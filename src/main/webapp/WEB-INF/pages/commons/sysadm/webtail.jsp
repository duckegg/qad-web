<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="hpps.qad.core.BaseMod" %>
<%@ page import="hpps.qad.utils.webtail.LogFile" %>
<%@ page import="hpps.qad.utils.webtail.Tail" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.io.File" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
    String strLineSep = System.getProperty("line.separator");
    if (strLineSep != null) {
        if (strLineSep.equals("\r\n")) {
            strLineSep = "\n";
        }
    }
    String strFileSep = System.getProperty("file.separator");
    String strDirName = "logs";


    String strCtxParam = BaseMod.getConfig().getLogDir();
    if (strCtxParam != null) {
        if (!strCtxParam.equals("")) {
            strDirName = strCtxParam;
        }
    }


    File dir = new File(strDirName);
    java.io.FilenameFilter filter = new java.io.FilenameFilter() {
        public boolean accept(File dir, String name) {
            return name.endsWith(".log");
        }
    };
    String[] logFiles = dir.list(filter);
    java.util.Arrays.sort(logFiles);
    int iLines = 50;
    String strReqLines = request.getParameter("lines");
    if (strReqLines != null) {
        iLines = Integer.parseInt(strReqLines);
    }

    String gotoBottom = request.getParameter("gotoBottom") != null ? "checked" : "";
    String autoWrap = request.getParameter("autoWrap") != null ? "checked" : "";


    String refreshSecs = request.getParameter("seconds");
    if (refreshSecs == null) {
        refreshSecs = "60";
    }

    String logFilename = request.getParameter("log");
    if (logFilename == null && logFiles.length >= 1) {
        logFilename = logFiles[0];
    }

    File f = new File(strDirName + strFileSep + logFilename);
    LogFile logFile = new LogFile(f);
    Tail t = new Tail(logFile);
    String logContent = "";
    try {
        logContent = t.tailLog(iLines);
    } catch (Exception e1) {
    }

    boolean isEmbed = StringUtils.equals(request.getParameter("decorator"), "embed");
%>
<% if (isEmbed) {%>
<%=logContent%>
<% return;
}%>
<title>Tail Log</title>

<body>
<div>
    <s:form id="logQform" action="webtail" namespace="/sysadm" method="post" name="taillog"
            theme="simple" cssClass="form-inline">
        <select name="log">
            <%
                for (String strLogFile : logFiles) {
                    if (strLogFile.equals(logFilename)) {
            %>
            <option selected><%=strLogFile %>
            </option>
            <%} else {%>
            <option><%=strLogFile %>
            </option>
            <%
                    }
                }
            %>
        </select>
        <label>行数: <input type="text" name="lines" value="<%=iLines %>"/></label>
        <label><input type="checkbox" class="checkbox" id="gotoBottom" name="gotoBottom"
                      value="true" <%=gotoBottom %>/>自动滚动</label>
        <label><input type="checkbox" class="checkbox" id="autoWrap" name="autoWrap"
                      value="true" <%=autoWrap %>/>自动换行</label>
        <button type="submit" class="btn">刷新</button>
        <label>自动刷新（秒）:<input type="text" id="seconds" name="seconds"
                              value="<%=refreshSecs %>"/></label>
    </s:form>
</div>
<pre id="logContent" style="overflow:scroll;height:500px;white-space:pre;"><%=logContent %></pre>
<script type="text/javascript">
    function toBottom() {
        var bChecked = document.getElementById('gotoBottom').checked;
        var divBlock = document.getElementById('logContent'); //the block content is appended to
        if (bChecked)
            divBlock.scrollTop = divBlock.scrollHeight; ///scroll to bottom
    }

    $(function () {
        toBottom();
        var sec = document.getElementById('seconds').value;
        var timer = window.setInterval("refreshPage();", sec * 1000);
        var refreshCounter = 0;
        var MAX_REFRESH_COUNT = 20;
        <%-- Refresh table --%>
        $('#logQform').submit(function () {
            $('#logQform').ajaxSubmit({
                data: {decorator: "embed", confirm: "true"},
                success: function (xhr) {
                    $('#logContent').html(xhr);
                    toBottom();
                }
            });
            return false;
        });
        $('#autoWrap').click(function () {
            $('#logContent').css("white-space", $(this).attr("checked") == "checked" ? "pre-wrap" : "pre");
        });
        $('#logQform input, #logQform select').change(function () {
            refreshPage();
        });

        function refreshPage() {
            $('#logQform').trigger("submit");
            refreshCounter++;
            //LEOLIAO@20120821: disable infinite refresh, which may cause file system error
            if (refreshCounter > MAX_REFRESH_COUNT) {
                clearInterval(timer);
            }
        }
    });
</script>
</body>