<%--
Handle 404 file not found
@author Leo Liao, 2012/11/23, created
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <%@include file="basic-header.jsp" %>
    <title>404地址错误</title>
</head>
<body>
<div class="row page-error">
    <div class="col-md-5 code error-404">404</div>
    <div class="col-md-7 details">
        <h3>找不到要访问的对象</h3>

        <p id="error-message"><%=request.getAttribute("javax.servlet.error.message")%>
        </p>
    </div>
</div>
</body>
</html>