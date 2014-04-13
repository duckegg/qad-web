<%--
Handle 401 authorization error.
@author Leo Liao, 2012/11/23, created
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <%@include file="basic-header.jsp" %>
    <title>401访问受限</title>
</head>
<body>
<div class="row page-error">
    <div class="col-md-5 code error-401">401</div>
    <div class="col-md-7 details">
        <h3>您访问的页面有权限限制</h3>

        <p id="error-message"><%=request.getAttribute("javax.servlet.error.message")%>
        </p>
    </div>
</div>
</body>
</html>