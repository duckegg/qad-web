<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-7, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#assign pageId="quote-table"/>
<#assign tableId="quoteTable"/>
<@ui.page id=pageId title="Client Side Query">
<div>
    <ul class="list-unstyled list-inline">
        <li>
            <a href="${base}/query/export/pdf?pid=sample/stock/quote-table&qid=sample.STOCK_QUOTE_LIST&outputDir=pdf&exportDest=file"
               class="btn btn-default"
               data-kui-dialog>后台保存为PDF</a>
        </li>
        <li>
            <a href="${base}/query/export/word?pid=sample/stock/quote-table&qid=sample.STOCK_QUOTE_LIST&outputDir=other&exportDest=file"
               class="btn btn-default"
               data-kui-dialog>后台保存为Word</a>
        </li>
        <li>
            <a href="${base}/report/sample/stock/quote-table-serverside"
               class="btn btn-default">采用服务器端查询</a>
        </li>
    </ul>
    <div>
        本列表通过SQL一次性将结果数据取出放在客户端，后续的分页、排序、查询等处理都在客户端通过Javascript完成。
        在数据量不大的时候（少于4000条），建议使用客户端处理。
    </div>
    <script type="text/javascript">
        setTableColumns('${tableId}', [
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
        ]);
    </script>
    <@ajaxQueryAndTable tableId=tableId qid="sample.STOCK_QUOTE_LIST" printable=true printPid="sample/stock/quote-table"></@ajaxQueryAndTable>
</div>
</@ui.page>
