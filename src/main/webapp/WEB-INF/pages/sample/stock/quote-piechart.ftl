<#--
********************************************************************************
@desc 
@author Leo Liao, 3/26/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="quote-piechart"/>
<@ui.page id=pageId title="Pie Chart">
<div class="row">
    <div class="col-md-6">
        <@ui.panel id="${pageId}-price-change"  contentUrl="${base}/report/sample/stock/stock-price-count" title="价格变化"></@ui.panel>
    </div>
    <div class="col-md-6">
        <@ui.panel id="${pageId}-pe"  contentUrl="${base}/report/sample/stock/stock-count-by-pe" title="市盈率"></@ui.panel>
    </div>
</div>
</@ui.page>
