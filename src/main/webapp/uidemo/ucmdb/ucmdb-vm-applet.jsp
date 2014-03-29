<%@ page import="hpps.qad.base.config.AppConfig" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="ucmdb"%>
<html>

<%
    AppConfig appConfig = AppConfig.getInstance();
    Map<String,String> ucmdbInfo = appConfig.getUcmdbInfo();
    String protocol = ucmdbInfo.get("protocol");
    String ip = ucmdbInfo.get("ip");
    String port = ucmdbInfo.get("port");
    String appletUrl = protocol+"://"+ip+":"+port;
    String ucmdbid=request.getParameter("ucmdbid");
    String viewName = request.getParameter("viewName");
    String href = "viewName="+viewName+"&interfaceVersion=9.0.0&params=[GID=" + ucmdbid + "]";
%>

<body bgcolor=cyan>
<h3>以下是调用Tag文件的效果: ucmdbid = <%=ucmdbid%>
</h3>


<ucmdb:ucmdb_applet
        serverConnectionString="<%=appletUrl%>"
        serverType="UCMDB"
        directLinkParameters="<%=href%>"
        userName="guest"
        userPassword="guest"
        customerId="1"
        encoded="false"
        printDebugLogs="true"
        userErrorMessage="Applet not loaded"
        navigation="false"
        clearSessionCookies="false"
        command="ShowViewTopologySA"/>

</body>
</html>