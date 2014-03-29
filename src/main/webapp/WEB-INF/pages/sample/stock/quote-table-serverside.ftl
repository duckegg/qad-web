<#--
********************************************************************************
@desc Demo fuzzy search
@author Leo Liao, 14-3-12, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#assign pageId="quote-table-fuzzy"/>
<#assign tableId="quoteTableFuzzy"/>
<@ui.page id=pageId title="Server Side Query">
<div>
    本列表的排序、过滤、分页都是通过服务器端完成，每次排序、过滤、分页都会向服务器端提交一次请求。
    服务器端查询适用于大数据量的查询。
</div>
<div>
    <script type="text/javascript">
        var columns_${tableId} = [
            { "mDataProp": "low", "sTitle": "最低" },
            { "mDataProp": "high", "sTitle": "最高" },
            { "mDataProp": "open", "sTitle": "开盘" },
            { "mDataProp": "close", "sTitle": "收盘" },
            { "mDataProp": "volume", "sTitle": "成交量" },
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
    <@ajaxQueryAndTable tableId=tableId qid="sample.STOCK_QUOTE_FULL_LIST" printable=true printPid="sample/report/quote-table" serverSide=true></@ajaxQueryAndTable>
</div>
</@ui.page>
