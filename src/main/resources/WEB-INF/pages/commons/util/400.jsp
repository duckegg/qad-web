<%--
Handle 400 bad client request.
@author Leo Liao, 2013/12/07, created
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <%@include file="basic-header.jsp" %>
    <title>400输入错误</title>
</head>
<body>
<div class="row page-error">
    <div class="col-md-5 code error-401">400</div>
    <div class="col-md-7 details">
        <h3>您的操作或输入参数不符合规定</h3>

        <p id="error-message"><%=request.getAttribute("javax.servlet.error.message")%>
        </p>
    </div>
</div>
</body>
</html>