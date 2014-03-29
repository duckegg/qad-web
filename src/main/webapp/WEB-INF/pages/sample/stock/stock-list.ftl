<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-27, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#assign pageId="stock-list"/>
<#assign tableId="stockList"/>
<@ui.page id=pageId title="Quote List">
<div class="hidden">
    <h3>精确查询</h3>

    <div>
        <@s.form id="${tableId}QueryForm" action="tabledata" namespace="/" method="post" cssClass="form-inline" onsubmit="refreshDataTable('${tableId}');return false;">
            <input type="hidden" name="qid" value="sample.STOCK_QUOTE_LIST"/>
            <button type="submit" class="btn btn-default">刷新</button>
        </@s.form>
    </div>
</div>
<#--===== Table Setup =====-->
<script type="text/javascript">
    var columns_${tableId} = [
        { "mDataProp": "low", "sTitle": "最低" },
        { "mDataProp": "high", "sTitle": "最高" },
        { "mDataProp": "open", "sTitle": "开盘" },
        { "mDataProp": "close", "sTitle": "收盘" },
        { "mDataProp": "symbol", "sTitle": "代码" },
        { "mDataProp": "date", "sTitle": "日期" },
        { mDataProp: "symbol", sTitle: "操作", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                var href = '${base}/user/update?id=' + o.aData['id'];
                return '<a class="btn btn-xs" data-dialog href="' + href + '" data-dialog-aftersubmit="refreshDataTable(\'${tableId}\')"><i class="fa fa-cog"></i></a>';
            }
        }
    ];
</script>
    <@ajaxTable tableId="${tableId}" ajaxForm="#${tableId}QueryForm" printable=false toolbarElement="#user-list-toobar"/>

</@ui.page>
