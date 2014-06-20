<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "../query-lib.ftl" parse=true/>
<#assign pageId="report-table-${userDefinedQuery.id!'unknown'}"/>
<#assign tableId="udr-table"/>
<@ui.page id=pageId title="Table Report">
    <div class="hidden">
        <form id="${tableId}QueryForm" action="${base}/udr/query/json/table" method="post"
              class="form-inline" onsubmit="kui.refreshDataTable('${tableId}');return false;">
            <input type="hidden" name="displayFormat" value="table"/>
            <input type="hidden" name="uid" value="${id!''}"/>
            <input type="hidden" name="queryDef.sql"
                   value="${(userDefinedQuery.queryDef.sql)!''}"/>
            <input type="hidden" name="queryDef.dbConn"
                   value="${(userDefinedQuery.queryDef.dbConn)!''}"/>
            <button type="submit" class="btn btn-default">刷新</button>
        </form>
    </div>
    <script type="text/javascript">
        (function () {
            var formatSetting =${userDefinedQuery.displayJson} || {table:{columns:[]}};
            var tableColumns = formatSetting['table']['columns'];
            var columns=[];
            for (var i = 0; i < tableColumns.length; i++) {
                columns.push({mData:tableColumns[i].field,sTitle:tableColumns[i].title});
            }
            kui.setTableColumns("${tableId}",columns);
        })();
    </script>
        <@ui.ajaxTable tableId="${tableId}" ajaxForm="#${tableId}QueryForm"/>
</@ui.page>
