<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="ucmdb"%>
<html>

<%
    String ucmdbid=request.getParameter("ucmdbid");
//    String href = "viewName=template_os_fc_by_gid&interfaceVersion=9.0.0&params=[GID=" + ucmdbid + "]";
    String href = "viewName=template_os_vio_eth_by_gid&interfaceVersion=9.0.0&params=[GID=" + ucmdbid + "]";
%>

<body bgcolor=cyan>
<h3>以下是调用Tag文件的效果: ucmdbid = <%=ucmdbid%>
</h3>

<ucmdb:ucmdb_applet
        serverConnectionString="http://99.1.76.225:8080"
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
        command="ShowViewTopologySA"></ucmdb:ucmdb_applet>

<%--<ucmdb:ucmdb_applet--%>
        <%--serverConnectionString="http://10.1.248.243:8080"--%>
        <%--serverType="UCMDB"--%>
        <%--directLinkParameters="<%=href%>"--%>
        <%--userName="admin"--%>
        <%--userPassword="hpuCMDB#Jul2013"--%>
        <%--customerId="1"--%>
        <%--encoded="false"--%>
        <%--printDebugLogs="true"--%>
        <%--userErrorMessage="Applet not loaded"--%>
        <%--navigation="false"--%>
        <%--clearSessionCookies="false"--%>
        <%--command="ShowViewTopologySA"/>--%>

</body>
</html>