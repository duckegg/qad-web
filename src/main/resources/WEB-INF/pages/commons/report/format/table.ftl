<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#include "../udr-lib.ftl" parse=true/>
<#assign pageId="report-table-${userDefinedReport.id!'unknown'}"/>
<#assign tableId="udr-table"/>
<@ui.page id=pageId title="Table Report">
    <div class="hidden">
        <form id="${tableId}QueryForm" action="${base}/udr/json/table" method="post"
              class="form-inline" onsubmit="kui.refreshDataTable('${tableId}');return false;">
            <input type="hidden" name="displayFormat" value="table"/>
            <input type="hidden" name="uid" value="${id!''}"/>
            <input type="hidden" name="queryDef.sql"
                   value="${(userDefinedReport.queryDef.sql)!''}"/>
            <input type="hidden" name="queryDef.dbConn"
                   value="${(userDefinedReport.queryDef.dbConn)!''}"/>
            <button type="submit" class="btn btn-default">刷新</button>
        </form>
    </div>
    <script type="text/javascript">
        (function () {
            var formatSetting =${userDefinedReport.displayJson} || {table:{columns:[]}};
            var tableColumns = formatSetting['table']['columns'];
            var columns=[];
            for (var i = 0; i < tableColumns.length; i++) {
                columns.push({mData:tableColumns[i].field,sTitle:tableColumns[i].title});
            }
            kui.setTableColumns("${tableId}",columns);
        })();
    </script>
        <@ajaxTable tableId="${tableId}" ajaxForm="#${tableId}QueryForm"/>
</@ui.page>
