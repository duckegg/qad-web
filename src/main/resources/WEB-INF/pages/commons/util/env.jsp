<%@ page import="com.opensymphony.xwork2.ActionContext" %>
<%@ page import="com.opensymphony.xwork2.util.ValueStack" %>
<%@ page import="hpps.qad.base.config.AppInitializer" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<style type="text/css">
    .infoStack table td {
        word-wrap: break-word;
    }

    .infoStack table {
        min-width: 600px;
        max-width: 100%;
        table-layout: fixed;
    }

    .infoStack table caption {
        font-size: 1.25em;
        font-weight: bold;
        text-align: left;
    }
</style>
<div class="infoStack">
<p class="text-info">系统已运行：<%=System.currentTimeMillis() - AppInitializer.getAppStartupTime()%>
</p>
<table class="table table-striped table-bordered table-condensed">
    <caption>Request</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>getRequestURL()</td>
        <td><%=StringEscapeUtils.escapeHtml(request.getRequestURL() + "")%>
        </td>
    </tr>
    <tr>
        <td>getContextPath()</td>
        <td><%=StringEscapeUtils.escapeHtml(request.getContextPath())%>
        </td>
    </tr>
    <tr>
        <td>getRequestURI()</td>
        <td><%=StringEscapeUtils.escapeHtml(request.getRequestURI())%>
        </td>
    </tr>
    <tr>
        <td>getQueryString()</td>
        <td><%=StringEscapeUtils.escapeHtml(request.getQueryString())%>
        </td>
    </tr>
    <tr>
        <td>getMethod()</td>
        <td><%=StringEscapeUtils.escapeHtml(request.getMethod())%>
        </td>
    </tr>
    </tbody>
</table>


<table class="table table-striped table-bordered table-condensed">
    <caption>Request Header</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <%
        Enumeration em = request.getHeaderNames();
        while (em.hasMoreElements()) {
            String name = (String) em.nextElement();
    %>
    <tr>
        <td><%=StringEscapeUtils.escapeHtml(name)%>
        </td>
        <td style="word-wrap: break-word;"><%=StringEscapeUtils.escapeHtml(request.getHeader(name))%>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<table class="table table-striped table-bordered table-condensed">
    <caption>Request Parameters</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <%
        em = request.getParameterNames();
        while (em.hasMoreElements()) {
            String name = (String) em.nextElement();
            String[] values = request.getParameterValues(name);
    %>
    <tr>
        <td><%=StringEscapeUtils.escapeHtml(name)%>
        </td>
        <td>[<%=StringEscapeUtils.escapeHtml(StringUtils.join(values, ","))%>]
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<table class="table table-striped table-bordered table-condensed">
    <caption>Request Attributes</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <%
        em = request.getAttributeNames();
        while (em.hasMoreElements()) {
            String name = (String) em.nextElement();
            Object value = request.getAttribute(name);
    %>
    <tr>
        <td><%=StringEscapeUtils.escapeHtml(name)%>
        </td>
        <td><%=StringEscapeUtils.escapeHtml(value + "")%>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<table class="table table-striped table-bordered table-condensed">
    <caption>Session Attributes</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <%
        em = session.getAttributeNames();
        while (em.hasMoreElements()) {
            String name = (String) em.nextElement();
            Object value = session.getAttribute(name);
    %>
    <tr>
        <td><%=StringEscapeUtils.escapeHtml(name)%>
        </td>
        <td><%=StringEscapeUtils.escapeHtml(value + "")%>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<table class="table table-striped table-bordered table-condensed">
    <caption>ActionContext ValueStack</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <%
        ActionContext actionContext = null;

        actionContext = ActionContext.getContext();
        if (actionContext != null) {
            ValueStack ovs = null;
            try {
                actionContext.getValueStack();
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (ovs != null) {
                Map context = ovs.getContext();
                if (context != null) {
                    for (Object name : context.keySet()) {

    %>
    <tr>
        <td><%=StringEscapeUtils.escapeHtml(name + "")%>
        </td>
        <td><%=StringEscapeUtils.escapeHtml(context.get(name) + "")%>
        </td>
    </tr>
    <%
                    }
                }
            }
        }
    %>
    </tbody>
</table>
<table class="table table-striped table-bordered table-condensed">
    <caption>ActionContext Parameters</caption>
    <thead>
    <tr>
        <th>Param</th>
        <th>Value</th>
    </tr>
    </thead>
    <tbody>
    <%
        if (actionContext != null) {
            Map params = actionContext.getParameters();
            for (Object name : params.keySet()) {
                Object paramValue = params.get(name);
                String valueOutput = "";
                if (paramValue instanceof String) {
                    valueOutput = (String) paramValue;
                } else if (paramValue instanceof String[]) {
                    valueOutput = StringUtils.join((String[]) paramValue, ",");
                }
    %>
    <tr>
        <td><%=StringEscapeUtils.escapeHtml(name + "")%>
        </td>
        <td>[<%=StringEscapeUtils.escapeHtml(valueOutput)%>]
        </td>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>
</div>
END
