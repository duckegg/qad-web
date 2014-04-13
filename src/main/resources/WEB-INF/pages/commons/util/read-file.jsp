<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="java.io.File" %>
<%--
********************************************************************************
@desc Display content of a file.
@author Leo Liao, 2012/06/04, created
********************************************************************************
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="file" scope="request" value="${file}"/>
<% File file = (File) request.getAttribute("file");%>
<title><%=file.getName()%></title>
<link type="text/css" rel="stylesheet" media="screen" href="${base}/media/bootstrap/css/bootstrap.css"/>
<div id="read-file">
<%
    if (!file.exists()) {
%>
<div class="alert alert-danger" style="margin:50px 20px">
    <p>文件<%=file.getPath()%>未找到，可能是由以下原因造成：</p>
    <ul class="listing listing-bullet">
        <li>streamlizer没有正确运行</li>
        <li>未正确的将BSAE的/opt/opsware/customer_dev/streamlizer目录映射到看板文件系统</li>
    </ul>
    请联系管理员。
</div>
<%
} else {
    String content = FileUtils.readFileToString(file);
%>
<pre>
<%=content%>
</pre>
<%
    }
%>
</div>
