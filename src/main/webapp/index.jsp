<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login");
    }else{
        response.sendRedirect("home.action");
    }
%>