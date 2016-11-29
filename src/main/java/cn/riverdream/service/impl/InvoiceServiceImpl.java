package cn.riverdream.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.riverdream.mapper.TbInvoiceMapper;
import cn.riverdream.model.InvoiceVo;
import cn.riverdream.pojo.TbInvoice;
import cn.riverdream.pojo.TbInvoiceExample;
import cn.riverdream.pojo.TbUser;
import cn.riverdream.pojo.TbInvoiceExample.Criteria;
import cn.riverdream.service.InvoiceService;
import cn.riverdream.utils.DataGridResultInfo;

@Service
public class InvoiceServiceImpl implements InvoiceService {

	@Autowired
	private TbInvoiceMapper invoiceMapper;

	@Override
	public DataGridResultInfo find(Integer type, InvoiceVo vo) {

		String contractno = vo.getContractno();
		String consumer = vo.getConsumer();
		String invoiceno = vo.getInvoiceno();
		Date start = vo.getStart();
		Date end = vo.getEnd();
		int page = vo.getPage();
		int rows = vo.getRows();

		TbInvoiceExample example = new TbInvoiceExample();
		Criteria criteria = example.createCriteria();
		criteria.andInvoicetypeEqualTo(type);
		criteria.andStatusNotEqualTo(3);

		if (StringUtils.isNotBlank(contractno)) {
			criteria.andContractnoEqualTo(contractno);
		}
		if (StringUtils.isNotBlank(invoiceno)) {
			criteria.andInvoicenoEqualTo(invoiceno);
		}
		if (StringUtils.isNotBlank(consumer)) {
			criteria.andConsumerLike("%" + consumer + "%");
		}
		if (start != null) {
			criteria.andCreatedateGreaterThanOrEqualTo(start);
		}
		if (end != null) {
			criteria.andCreatedateLessThanOrEqualTo(end);
		}
		PageHelper.startPage(page, rows);
		List<TbInvoice> list = invoiceMapper.selectByExample(example);

		// 取分页信息
		PageInfo<TbInvoice> pageInfo = new PageInfo<>(list);
		long total = pageInfo.getTotal();
		DataGridResultInfo result = new DataGridResultInfo();

		// 身份
		Subject subject = SecurityUtils.getSubject();
		TbUser activeUser = (TbUser) subject.getPrincipal();
		// if ("admin".equalsIgnoreCase(activeUser.getPermission1())) {
		// 合计
		BigDecimal zf = new BigDecimal(0);// 作废
		BigDecimal zc = new BigDecimal(0);// 正常
		List<TbInvoice> listsum = invoiceMapper.selectByExample(example);
		for (TbInvoice ti : listsum) {
			BigDecimal bd = new BigDecimal(ti.getAmount());
			bd = bd.abs();
			Integer status = ti.getStatus();
			if (0 == status) {// 正常
				zc = zc.add(bd);
			} else if (1 == status) {// 作废
				zf = zf.add(bd);
			} else if (2 == status) {// 退票
				zc = zc.subtract(bd);
			}
		}
		List<Map<String, String>> sum = new ArrayList<>();
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("zuofei", zf.setScale(2, BigDecimal.ROUND_HALF_UP).toString());
		map.put("amount", zc.setScale(2, BigDecimal.ROUND_HALF_UP).toString());
		map.put("contractno", "合计");
		sum.add(map);

		result.setFooter(sum);
		// }
		result.setTotal(total);
		result.setRows(list);
		return result;
	}

	@Override
	public Integer save(TbInvoice invoice) {
		invoice.setCreatedate(new Date());
		invoice.setWorkdate(new Date());
		invoiceMapper.insert(invoice);
		return invoice.getSerialno();
	}

	@Override
	public void delete(InvoiceVo vo) {
		Integer serialno = vo.getSerialno();
		TbInvoiceExample example = new TbInvoiceExample();
		Criteria criteria = example.createCriteria();
		criteria.andSerialnoEqualTo(serialno);
		TbInvoice invoice = new TbInvoice();
		invoice.setStatus(3);
		invoice.setSerialno(serialno);
		invoiceMapper.updateByPrimaryKeySelective(invoice);
	}

	@Override
	public TbInvoice findBySerialNo(Integer serialNo) {
		TbInvoiceExample example = new TbInvoiceExample();
		Criteria criteria = example.createCriteria();
		criteria.andSerialnoEqualTo(serialNo);
		criteria.andStatusNotEqualTo(3);
		List<TbInvoice> list = invoiceMapper.selectByExample(example);
		TbInvoice invoice = new TbInvoice();
		if (list != null && list.size() > 0) {
			invoice = list.get(0);
		}
		return invoice;
	}

	@Override
	public void update(InvoiceVo invoicevo) {
		Integer serialNo = invoicevo.getInvoice().getSerialno();
		TbInvoiceExample example = new TbInvoiceExample();
		Criteria criteria = example.createCriteria();
		criteria.andSerialnoEqualTo(serialNo);
		invoiceMapper.updateByExampleSelective(invoicevo.getInvoice(), example);
	}

}
