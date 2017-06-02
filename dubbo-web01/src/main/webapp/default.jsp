<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>MavenCommonWeb01</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="<%=this.getServletContext().getContextPath()%>/js/easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=this.getServletContext().getContextPath()%>/js/easyui/themes/icon.css">
	<script type="text/javascript" src="<%=this.getServletContext().getContextPath()%>/js/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="<%=this.getServletContext().getContextPath()%>/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=this.getServletContext().getContextPath()%>/js/easyui/loadmask.js"></script>
	<title>桌面:/default.jsp</title>
	<style type="text/css">
		#list li{
			font-size:14px;
			padding:2px;
		}
	</style>
	<script type="text/javascript">
		$(function() {
			//onloading();
			loadTree();
		});
	
		function loadTree() {
			$.ajax({
				url : "<%=this.getServletContext().getContextPath()%>/json/getTreeTabMenus",
				timout: 10000,
				complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
					if(status=='timeout'){//超时,status还有success,error等值的情况
						
				 		//ajaxTimeoutTest.abort();
				 		//alert("超时");
				 		removeload();
				 	}
				},
				success : function(data,textStatus,xhr) {
					
					if(data["rows"]&&data["rows"].length>0)
					{
						var subNodes = [];
						for(var i=0;i<data["rows"].length;i++)
						{
							var subMenuNodes = [];
							if(data["rows"][i]["menus"]&&data["rows"][i]["menus"].length>0)
							{
								for(var j=0;j<data["rows"][i]["menus"].length;j++)
								{
									subMenuNodes[j]={id:data["rows"][i]["menus"][j]["menuId"],text:data["rows"][i]["menus"][j]["menuName"]};
									subMenuNodes[j]["attributes"]={"clickable":true,"xtype":"menu","type":data["rows"][i]["menus"][j]["menuType"],"url":data["rows"][i]["menus"][j]["defaultUrl"]};
									
								}
							}
							subNodes[i]={id:data["rows"][i]["tabId"],text:data["rows"][i]["tabName"]};
							subNodes[i]["children"]=subMenuNodes;
							if(data["rows"][i]["tabType"]!=1)
							{	
								subNodes[i]["state"]="closed";
							}
							subNodes[i]["attributes"]={"xtype":"tab","type":data["rows"][i]["tabType"],"url":data["rows"][i]["defaultUrl"]};
							if(data["rows"][i]["tabType"]!=0)
							{
								subNodes[i]["attributes"]["clickable"]=true;
							}
							
						}
						$('#menuTree').tree({
							"data":subNodes
						});
	
						$("#btnShowLogin").linkbutton("disable");
						
						
						$("#menuTree").tree({
							'onClick':function(node){
								//$.messager.alert("消息", node.attributes.url, "信息");
								if(node.attributes.clickable)
									showContent(node.attributes.url,node.text);
							}
						});
						
						
					}
					else{
						//alert($("#btnLogin").attr("disable"));
						$("#btnLogout").linkbutton("disable");
					}
					removeload();
				}
			});
	
		}
	
		/*type=0:*/
		function showContent(url,title,type) {
			/**/
			if(title == "桌面")
			{
				if ($('#tt').tabs('exists', "我的桌面")){
					$('#tt').tabs('select', "我的桌面");
					return;
				}
			}
			if ($('#tt').tabs('exists', title)){
				$('#tt').tabs('select', title);
			} else {
				var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
				$('#tt').tabs('add',{
					title:title,
					content:content,
					closable:true
				});
			}
		}
		
		function login() {
			var username = $("#username").val();
			var password = $("#password").val();
			//alert(username+"|"+password);
			//$("#btnLogin").linkbutton("disable");
			onloading();
			//$("#loginw").window();
			$.ajax({
				type : "POST",
				dataType : "json",
				url : "<%=this.getServletConfig().getServletContext().getContextPath()%>/account/login",
				cache:false,
				data : {
					Method : "Login",
					"username":username,
					"password":password
				},
				success : function(data,status,xhr) {
					//alert(data["result"]);
					if(data && data["result"]=="1")
					{
						$('#loginw').window('close');
						refreshContent();
						setTimeout(function(){
							window.location.href = "<%=this.getServletConfig().getServletContext().getContextPath()%>/";
						}, 2000);
						
					}
					else
					{
						$.messager.alert("消息", data["message"], "信息");
					}
				},
				error : function() {
					$.messager.alert("消息", "错误！", "info");
				}
			});
		}
		
		function logout()
		{
			$.ajax({
				type : "POST",
				dataType : "json",
				url : "<%=this.getServletConfig().getServletContext().getContextPath()%>/account/logout",
				success:function(data,status,xhr)
				{
					if(data["result"]==1)
					{
						refreshContent();
						setTimeout(function(){
							window.location.href = "<%=this.getServletConfig().getServletContext().getContextPath()%>/";
						}, 2000);//2秒后刷新窗口
						$.messager.alert("消息", data["message"], "信息");
					}
				}
		
			});
		}
		
		function refreshContent()
		{
			
		}
		
		
	
	</script>
</head>
<body class="easyui-layout">
	<div data-options="region:'north',border:false"
		style="height: 80px; background: #B3DFDA; padding: 10px">
		<span style="font-size: 18px; font-weight: bold;">CommonWeb项目</span>:用于演示Java
		Web开发相关的示例;
		
		<div style="margin:20px 0;">
			<a id="btnShowLogin" href="javascript:void(0)" class="easyui-linkbutton" style="padding-left:10px;padding-right:10px;" onclick="$('#loginw').window('open')">登&#8195;录</a>
			<a id="btnLogout" href="javascript:void(0)" class="easyui-linkbutton" style="padding-left:10px;padding-right:10px;" onclick="logout()">登&#8195;出</a>
		</div>

	</div>
	<div data-options="region:'west',split:true,title:'West'"
		style="width: 200px; padding: 10px;">
		<ul id="menuTree" class="easyui-tree">
			<li><span>用户功能菜单</span>
				<!--  -->
				<ul>
					<li data-options="state:'closed'"><span>系统管理</span>
						<ul>
							<li><a href="javascript:showContent('ui/sysadmin/user/list','用户管理')"><span>用户管理</span></a></li>
							<li><a href="javascript:showContent('ui/sysadmin/role/list','角色管理')"><span>角色管理</span></a></li>
							<li><a href="javascript:showContent('ui/sysadmin/menu/list','菜单管理')"><span>菜单管理</span></a></li>
							<li><a href="javascript:showContent('ui/sysadmin/tab/list','标签管理')"><span>标签管理</span></a></li>	
							<li><a href="javascript:showContent('ui/sysadmin/company/list','公司管理')" ><span>公司管理</span></a></li>	
							<li><a href="javascript:showContent('ui/sysadmin/company/list','组织机构管理')"><span>组织机构管理</span></a></li>
							<li><a href="javascript:showContent('ui/sysadmin/company/list','数据权限管理')"><span>数据权限管理</span></a></li>	
							
						</ul>
					</li>
					<li><span>Program Files</span>
						<ul>
							<li>Intel</li>
							<li>Java</li>
							<li>Microsoft Office</li>
							<li>Games</li>
						</ul></li>
					<li>index.html</li>
					<li>about.html</li>
					<li>welcome.html</li>
				</ul>
			</li>
		</ul>

	</div>
	<div
		data-options="region:'east',split:true,collapsed:true,title:'East'"
		style="width: 100px; padding: 10px;">
		east region
	</div>
	<!--  
	<div data-options="region:'south',split:true,collapsed:true"
		style="height: 50px; background: #A9FACD; padding: 10px;">
		
		south
		region
		
	</div>-->
	<!-- 
	<div data-options="region:'center',title:'Center'"></div>
 	-->
		<div id="tt" data-options="region:'center'" class="easyui-tabs" style="width: 99%; height: 99%;">
			<div title="我的桌面" style="padding: 10px;">
				<ul id="list">
					<li><a href="json/getTreeTabMenus" target="_blank">json/getTreeTabMenus:获取当前用户的树菜单</a></li>
					<li><a href="json/getUserTabs" target="_blank">json/getUserTabs:获取当前用户的标签项</a></li>
					<li><a href="json/getUserMenus" target="_blank">json/getUserMenus:获取当前用户的菜单项</a></li>
					<li><a href="local/jsondata/list/user" target="_blank">local/jsondata/list/user</a></li>
					<li><a href="local/jsondata/querylist?propertyName=username&propertyValue=fangming&objectType=user" target="_blank">local/jsondata/querylist?propertyName=username&propertyValue=fangming&objectType=user</a></li>
					<li><a href="local/jsondata/querylist?propertyName=status&propertyValue=0&objectType=user" target="_blank">local/jsondata/querylist?propertyName=status&propertyValue=0&objectType=user</a></li>
					
					<li><a href="local/jsondata/get/user/2" target="_blank">local/jsondata/get/user/1</a></li>
					<li><a href="local/jsondata/list/company" target="_blank">local/jsondata/list/company</a></li>
					<li><a href="local/jsondata/get/company/2" target="_blank">local/jsondata/get/company/2</a></li>
					<li><a href="local/jsondata/list/department" target="_blank">local/jsondata/list/department</a></li>
					<li><a href="local/jsondata/get/department/2" target="_blank">local/jsondata/get/department/2</a></li>
					<li><a href="local/jsondata/list/config" target="_blank">local/jsondata/list/config</a></li>
					<li><a href="local/jsondata/get/config/2" target="_blank">local/jsondata/get/config/2</a></li>
					
					<li><a href="sequence/getOne?keyName=sys.euser" target="_blank">sequence/getOne?keyName=sys.euser</a></li>
					<li><a href="sequence/getOne?keyName=test" target="_blank">sequence/getOne?keyName=test</a></li>
					<li><a href="sequence/getOne?keyName=default" target="_blank">sequence/getOne?keyName=default</a></li>
					<li><a href="sequence/getOne/5?keyName=test" target="_blank">sequence/getOne/5?keyName=test</a></li>
					<li><a href="sequence/getOne/5?keyName=default" target="_blank">sequence/getOne/5?keyName=default</a></li>
					<li><a href="sequence/getMultiple/4?keyName=test" target="_blank">sequence/getMultiple/4?keyName=test></li>
					<li><a href="sequence/getMultiple/4?keyName=default" target="_blank">sequence/getMultiple/4?keyName=default</a></li>
					
					<li><a href="local/rest/test?key=default" target="_blank">local/rest/test?key=default</a></li>
					<li><a href="local/rest/getClassLoaderInfo?key=default" target="_blank">local/rest/getClassLoaderInfo?key=default</a></li>
				</ul>
			</div>
			<div title="我的通知" data-options="closable:true" style="padding: 10px;">
				Second Tab
			</div>
			<div title="即时消息" data-options="closable:true" iconCls="icon-reload"
				style="padding: 10px;">Third Tab</div>
		

	</div>
	
	<div id="loginw" class="easyui-window" title="登录" data-options="modal:true,closed:true,iconCls:'icon-save'" style="width:350px;height:200px;padding:10px;">
		<form id="form1">
			<table cellpadding="5" style="width:100%;">
				<tr>
					<td style="width:60px;text-align:right;font-size:16px;">用户名:</td>
					<td><input id="username" name="username" class="easyui-validatebox textbox" style="height:28px;width:180px;font-size:16px;padding-left:2px;"
						data-options="missingMessage:'请输入用户名,长度为6-26！',required:true,validType:'length[6,26]'"></td>
				</tr>
				<tr>
					<td style="width:60px;text-align:right;font-size:16px;">密&#8195;码:</td>
					<td><input id="password" name="password" type="password" class="easyui-validatebox textbox" style="height:28px;width:180px;font-size:16px;"
						data-options="missingMessage:'请输入密码,长度为6-26！',required:true,validType:'length[6,26]'"></td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:center;height:40px;padding-top:10px;">
						<a id="btnLogin" href="#" class="easyui-linkbutton" style="padding:5px 15px 5px 10px;font-size:16px;" icon="icon-ok" onclick="login()">登&#8195;录</a>
						<a href="#" class="easyui-linkbutton" style="padding:5px 15px 5px 10px;font-size:16px;margin-left:20px;" icon="icon-cancel" onclick="$('#loginw').window('close')">取&#8195;消</a>
					</td>
				</tr>
			</table>		
		</form>
	</div>
</body>
</html>