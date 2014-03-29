<#--
********************************************************************************
@desc system audit log
@author Leo Liao, 2012/07/13, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#assign pageId="audit-log"/>
<#assign tableId="audit-log-table"/>
<@ui.page id=pageId title="看板使用日志">
<div id="${pageId}-qdiv" class="accordion">
    <h3>精确查询</h3>
    <form id="${pageId}-qform" action="${base}/query/json/table" method="post" class="form-inline" onsubmit="refreshDataTable('${pageId}');return false;">
        <input type="hidden" name="qid" value="admin.ADM_APP_LOG_LIST"/>
        <input type="text" name="sparams['username']" value="${(Request.sparams['loginName'])!""}"
               placeholder="用户" title="用户"/>
        <input type="text" name="sparams['action_name']"
               value="${(Request.sparams['action_name'])!""}" placeholder="操作" title="操作"/>
        <input type="text" name="sparams['host']" value="${(Request.sparams['host'])!""}"
               placeholder="来访主机" title="来访主机"/>
        <input type="text" name="sparams['log_level']" value="${(Request.sparams['log_level'])!""}"
               placeholder="日志级别" title="日志级别"/>
        <button type="submit" class="btn">刷新</button>
    </form>
</div>
<script type="text/javascript">
    setTableColumns("${tableId}", [
        { "mData": "username", "sTitle": "用户"},
        { "mData": "action_name", "sTitle": "操作" },
        { "mData": "action_param", "sTitle": "操作参数" },
        { "mData": "log_level", "sTitle": "级别" },
        { "mData": "timestamp", "sTitle": "时间" },
        { "mData": "session_id", "sTitle": "Session" },
        { "mData": "host", "sTitle": "来访地址" }
    ]);
</script>
    <@ajaxTable tableId="${tableId}" ajaxForm="#${pageId}-qform" serverSide=true toolbarElement="#${pageId}-qdiv"/>
</@ui.page>