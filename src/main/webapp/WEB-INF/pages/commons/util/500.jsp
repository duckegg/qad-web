<%@ page import="com.opensymphony.xwork2.ActionContext" %>
<%@ page import="com.opensymphony.xwork2.util.ValueStack" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%--
This page to handle both Struts2 and JSP exception mechanism
Exception is not normal operation error and is not supposed to be resolved by end user.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isErrorPage="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
    request.setAttribute("base", request.getContextPath());
    String exSource = "";
    String message = "";
    if (exception == null) {
        if (request.getAttribute("javax.servlet.error.status_code") != null) {
            // Try to locate exception message from standard JavaEE container
            exSource = request.getAttribute("javax.servlet.error.status_code").toString();
            message = message + request.getAttribute("javax.servlet.error.message");
        } else {
            exSource = "S2";
            // Try to locate exception object from Struts ExceptionHandlerAction
            ActionContext context = ActionContext.getContext();
            System.out.println(context);
            Object thr = null;
            if (context != null) {
                ValueStack valueStack = context.getValueStack();
                if (valueStack != null) {
                    thr = valueStack.findValue("exception");
                }
            }
            // Try some luck to locate exception from request attribute
            if (thr == null) {
                thr = request.getAttribute("exception");
            }
            if (thr != null) {
                exception = (Throwable) thr;
                message = exception.getMessage();
            }
        }
    } else {
        exSource = "JSP";
        message = exception.getMessage();
    }
%>
<html>
<head>
    <%@include file="basic-header.jsp" %>
    <title>看板错误500</title>
</head>
<body>
<div class="container-fluid">
    <div class="row page-error">
        <div class="col-md-5 code error-500">500</div>
        <div class="col-md-7 details">
            <h3>
                错误信息
            </h3>

            <pre id="error-message"><%=StringEscapeUtils.escapeHtml4(message)%>
            </pre>
        </div>
    </div>
    <%--<div class="row">--%>
    <%--<div class="col-md-5"></div>--%>
    <%--<div class="col-md-7">--%>
    <%--<button type="button" class="btn btn-default" onclick="$('#js-error-detail').toggle();">错误详细信息--%>
    <%--</button>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div id="js-error-detail" style="display: none; padding:1em;">--%>
    <%--<h3>诊断信息[<%=exSource%>]</h3>--%>

    <%--<div style="height:40em;overflow:auto;background-color: white">--%>
    <%--&lt;%&ndash;<%@ include file="/WEB-INF/pages/commons/util/env.jsp" %>&ndash;%&gt;--%>
    <%--</div>--%>
    <%--</div>--%>
</div>
</body>
</html>