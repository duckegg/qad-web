<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#include "../udr-lib.ftl" parse=true/>
<#assign pageId="table-report"/>
<#assign tableId="udr-table"/>
<#assign columns=toJson(userDefinedReport.display["table"])!''/>
<@ui.page id=pageId title="Table Report">
    <#if columns!=''>
    <div class="hidden">
        <form id="${tableId}QueryForm" action="${base}/udr/json/table" method="post"
              class="form-inline" onsubmit="refreshDataTable('${tableId}');return false;">
            <input type="hidden" name="displayFormat" value="table"/>
            <input type="hidden" name="uid" value="${id!''}"/>
            <input type="hidden" name="queryDef.sql"
                   value="${(userDefinedReport.queryDef.sql)!''}"/>
            <input type="hidden" name="queryDef.dbConn"
                   value="${(userDefinedReport.queryDef.dbConn)!''}"/>
            <button type="submit" class="btn btn-default">刷新</button>
        </form>
    </div>
    <table id="${tableId}"></table>
    <script type="text/javascript">
        setTableColumns("${tableId}",${columns});
    </script>
        <@ajaxTable tableId="${tableId}" ajaxForm="#${tableId}QueryForm"/>
    <#else>
    <div class="alert">Columns not defined</div>
    </#if>
</@ui.page>
