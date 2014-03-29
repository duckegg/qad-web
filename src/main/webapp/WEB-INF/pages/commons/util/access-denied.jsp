<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>无权访问</title>
</head>
<body>
<%--<%@ include file="/WEB-INF/pages/commons/util/env.jsp" %>--%>
<%--http://struts.apache.org/2.3.3/docs/exception-handling.html--%>
<h4><s:property value="exception.message" /></h4>
<%--<h4>Exception Details: <s:property value="exceptionStack" /></h4>--%>
</body>
</html>