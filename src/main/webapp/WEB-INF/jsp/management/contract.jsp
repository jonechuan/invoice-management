﻿<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/tag.jsp"%>
<html> 
<head>
<title>合同查询</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<%@ include file="/WEB-INF/jsp/base/common_css.jsp"%>
<%@ include file="/WEB-INF/jsp/base/common_js.jsp"%>

<script type="text/javascript">

$(function() {
	initGrid();
	
	var start = {
			  elem: '#start',
			  format: 'YYYY/MM/DD',
			  min: '2001-06-16', //设定最小日期为当前日期
			  max: '2099-06-16', //最大日期
			  istime: false,
			  istoday: false,
			  choose: function(datas){
				  end.min = datas; //开始日选好后，重置结束日的最小日期
				  end.start = datas //将结束日的初始值设定为开始日
			  }
			};
	var end = {
			  elem: '#end',
			  format: 'YYYY/MM/DD',
			  min: '2001-06-16',
			  max: '2099-06-16',
			  istime: false,
			  istoday: false,
			  choose: function(datas){
				  start.max = datas; //结束日选好后，重置开始日的最大日期
			  }
			};
			laydate(start);
			laydate(end);
});

var addContract = function (){
	var sendUrl = "${baseurl}/management/contract/toadd";
	createmodalwindow("添加合同", 800, 300, sendUrl);
	/* var ajaxOption = new AjaxOption();
			ajaxOption._initPostRequest(true,sendUrl,"json","html");
			_ajaxPostRequest(ajaxOption, '', ypxximport_callback); */
};

var addinvoice = function (serialno){
	var sendUrl = "${baseurl}/management/invoice/toadd?serialno="+ serialno;
	createmodalwindow("添加发票", 800, 400, sendUrl);
	/* var ajaxOption = new AjaxOption();
			ajaxOption._initPostRequest(true,sendUrl,"json","html");
			_ajaxPostRequest(ajaxOption, '', ypxximport_callback); */
};

var addcheck = function (serialno){
	var sendUrl = "${baseurl}/management/check/toadd?serialno="+ serialno;
	createmodalwindow("添加支票", 800, 400, sendUrl);
	/* var ajaxOption = new AjaxOption();
			ajaxOption._initPostRequest(true,sendUrl,"json","html");
			_ajaxPostRequest(ajaxOption, '', ypxximport_callback); */
};


var contractexport = function(){
	//jquerySubByFId('contractQueryForm', contractexport_callback, null, "json");
	$("#contractQueryForm").submit();
};

var contractdelList = function(){
	_confirm('您确定要执行删除操作吗?',null,
	  function(){
		var ids = [];
		var rows = $('#contractlist').datagrid('getSelections');
		for(var i=0;i<rows.length;i++){
			ids.push(rows[i].id);
		}
		if(ids.length>0){
			$("#contractdelid").val(ids.join(','));
			//alert($("#contractdelid").val());
			jquerySubByFId('contractdelForm', contractdel_callback, null, "json");
		}else{
			alert_warn("请选择要删除的项目");
		}
		
	  }
	)
	
};
var contractdel = function(id){
	_confirm('您确定要执行删除操作吗?',null,
			function(){
				$("#contractdelid").val(id);
				jquerySubByFId('contractdelForm', contractdel_callback, null, "json");
			}
	)
};
function contractdel_callback(data) {
	//var result = getCallbackData(data);
	_alert(data);
	contractQuery();
}
var contractedit = function (id){
	//alert(id);
	var sendUrl = "${baseurl}/management/contract/toupdate?serialNo="+id;
	
	createmodalwindow("合同信息修改", 900, 500, sendUrl);
	/* 
	var ajaxOption = new AjaxOption();
			ajaxOption._initPostRequest(true,sendUrl,"json","html");
			_ajaxPostRequest(ajaxOption, '', contractedit_callback);  */
};

//显示合同详情
var showcontract = function(serialNo){
	
	var sendUrl = '${baseurl}/management/contract/detail/' + serialNo;
	
	createmodalwindow("合同详情", 1155, 540, sendUrl);
}

/* function contractedit_callback(redata){
	$('#contractQuery_div').css("display","none");
	$("#contractedit_div").css("display","block");
	$("#contractedit_div").html(redata);
} */
function contractinfo(id){
var sendUrl = "${baseurl}/ypml/ypxx/view.action?id="+id;
	
	createmodalwindow("药品信息查看", 900, 500, sendUrl);
}
var ypxxadd = function (){
	//alert(id);
	var sendUrl = "${baseurl}/ypml/ypxx/edit.action";
	createmodalwindow("药品信息添加", 900, 500, sendUrl);
	/* var ajaxOption = new AjaxOption();
			ajaxOption._initPostRequest(true,sendUrl,"json","html");
			_ajaxPostRequest(ajaxOption, '', contractedit_callback);  */
};

var rsyncypxx = function(id){
	_confirm('您确定要执行同步操作吗?',null,
			function(){
				jquerySubByFId('rsyncForm', rsyncypxx_callback, null, "json");
			}
	)
};
function rsyncypxx_callback(data) {
	var result = getCallbackData(data);
	_alert(result);
}
//工具栏


var toolbar = [ {
	id : 'btnAddContract',
	text : '添加合同',
	iconCls : 'icon-add',
	handler : addContract
	},
	{
		id : 'export',
		text : '导出',
		iconCls : 'icon-redo',
		handler : contractexport
	}];

var frozenColumns;

var columns = [ [{
	field : 'id',
	title : '',
	checkbox:true,
	hidden:true
},{
	field : 'serialno',
	title : '标记',
	width : 60,
	formatter:function(value, row, index){
		var str = '<select name="'+ row.serialno +'" class="iffinish">';
		str += '<option value="1" ';
		if(row.finish ==1 ){
			str += ' selected ';
		}
		str += '>蓝</option>';
		str += '<option value="2" ';
		if(row.finish ==2 ){
			str += ' selected ';
		}
		str += '>红</option>';
		str += '<option value="3" ';
		if(row.finish ==3 ){
			str += ' selected ';
		}
		str += '>绿</option>';
		str += '<option value="0" ';
		if(row.finish ==0 ){
			str += ' selected ';
		}		
		str += '>白</option>';
		str += '</select>';
		return str;
	}
},{
	field : 'contractno',
	title : '合同号',
	width : 80,
	formatter:function(value, row, index){
		if(row.serialno){
		    return '<a href=javascript:showcontract(\''+row.serialno+'\')>'+value+'</a>'
		}
	}
},{
	field : 'consumer',
	title : '客户姓名',
	width : 80
},{
	field : 'createdatestr',
	title : '创建日期',
	width : 120
},{
	field : 'amount',
	title : '金额(元)',
	width : 100
},{
	field : 'company',
	title : '单位名称',
	width : 200
},{
	field : 'ifformal',
	title : '是否正式合同',
	width : 80,
	formatter:function(value, row, index){
		if(value ==1 ){
			return "是";
		}else if(value ==0){
			return "否";
		}else{
			return "--";
		}
	}
}
<c:if test="${activeUser.permission1 == 'admin'}">  
,{
	field : 'cinvoice',
	title : '普票',
	width : 100
},{
	field : 'sinvoice',
	title : '专票',
	width : 100
}
</c:if>
<c:if test="${activeUser.permission2 == 'admin'}"> 
,{
	field : 'check',
	title : '支票',
	width : 100
}
</c:if>
,{
	field : 'comment',
	title : '备注',
	width : 350
}
,{
	field : 'opt1',
	title : '修改',
	width : 60,
	formatter:function(value, row, index){
		if(row.serialno){
		return '<a href=javascript:contractedit(\''+row.serialno+'\')>修改</a>';
		}else{
			return "--";
		}
		
	}
},{
	field : 'opt2',
	title : '删除',
	width : 60,
	formatter:function(value, row, index){
		if(row.serialno){
				return '<a href=javascript:contractdel(\''+row.serialno+'\')>删除</a>';
			}else{
				return "--";
			}
	}
}
<c:if test="${activeUser.permission1 == 'admin'}">   
,{
	field : 'opt3',
	title : '添加发票',
	width : 60,
	formatter:function(value, row, index){
		if(row.serialno){
				return '<a href=javascript:addinvoice(\''+row.serialno+'\')>添加发票</a>';
			}else{
				return "--";
			}
	}
}
</c:if>
<c:if test="${activeUser.permission2 == 'admin'}">   
,{
	field : 'opt4',
	title : '添加支票',
	width : 60,
	formatter:function(value, row, index){
		if(row.serialno){
				return '<a href=javascript:addcheck(\''+row.serialno+'\')>添加支票</a>';
			}else{
				return "--";
			}
	}
}
</c:if>
]];

function initGrid(){
	$('#contractlist').datagrid({
		title : '合同列表',
		nowrap : true,
		striped : true,
		//collapsible : true,
		url : '${baseurl}/management/contract/search',
		//sortName : 'code',
		//sortOrder : 'desc',
		//remoteSort : false,
		idField : 'id',
		//frozenColumns : frozenColumns,
		fitColumns: true,
		showFooter:true,
		columns : columns,
		pagination : true,
		rownumbers : true,
		toolbar : toolbar,
		loadMsg:"",
		pageSize:30,
		pageList:[15,30,50,100],
		onClickRow : function(index, field, value) {
					$('#contractlist').datagrid('unselectRow', index);
				},
		rowStyler:function(index,row,css){
			if (row.finish == 1){
				return 'background-color:#6293BB;color:#fff;font-weight:bold;width:auto;';
			}else if(row.finish == 2){
				return 'background-color:#E21616;color:#fff;font-weight:bold;width:auto;';
			}else if(row.finish == 3){
				return 'background-color:#68c942;color:#fff;font-weight:bold;width:auto;';
			}else{
				return 'width:auto;';
			}
		},
		onLoadSuccess:function(data){      
			
			$(".iffinish").change(function(){
				$.post("${baseurl}/management/contract/changecl",
						{serialno:$(this).attr("name"),flag:$(this).val()},
						function(data){
							$('#contractlist').datagrid('reload');  
						},
						"json"
						);
			});
		}
		});

	}

	function contractQuery() {
 
		var formdata = $("#contractQueryForm").serializeJson();
		//alert(formdata);
		$('#contractlist').datagrid('unselectAll');
		$('#contractlist').datagrid('load', formdata);
	}

</script>
</HEAD>
<BODY>
<div id="contractQuery_div">
    <form id="contractQueryForm" name="contractQueryForm" action="${baseurl}/management/contract/excelDownload" method="post">
			<TABLE  class="table_search">
				<TBODY>
					<TR>
						
						<TD class="left">合同号：</td>
						<td><INPUT type="text"  name="contractno" /></TD>
						<TD class="left">客户名称：</TD>
						<td ><INPUT type="text" name="consumer" /></td>
						<TD class="left">单位名称：</TD>
						<td ><INPUT type="text" name="company" /></td>
						 <td class="left">日期：</td>
				  		<td>
				      		<input class="laydate-icon" id="start" name="start" style="width:150px; margin-right:10px;">
				      		至
				      		<input class="laydate-icon" id="end" name="end" style="width:150px;">
				 		 </td>
				 		 <td colspan=2  >
							<a id="btn" href="#" onclick="contractQuery()" class="easyui-linkbutton" iconCls='icon-search'>查询</a>
						</td>
					</TR>
				</TBODY>
			</TABLE>
	    </form>
		<TABLE border=0 cellSpacing=0 cellPadding=0 width="99%" align=center>
		<TBODY>
			<TR>
				<TD>
					<table id="contractlist"></table>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
</div>
<div id="ypxximport_div">

</div>
<div id="contractedit_div">

</div>
<form id="contractdelForm" name="contractdelForm" action="${baseurl}/management/contract/del" method="post">
<input type="hidden" id="contractdelid" name="serialno"/>
</form>
<form id="rsyncForm" name="rsyncForm" action="${baseurl}/ypml/ypxx/rsyncypxx.action" method="post">

</form>
</BODY>
</HTML>

