<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-7, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="quote-chart"/>
<#assign chartId="quoteChart"/>
<@ui.page id=pageId title="Quote Chart">

<div>
    <#assign chartId="${pageId}-achart"/>
    <form id="${chartId}-qform" action="${base}/query/json/jqplot" method="post"
          onsubmit="replotChart('${chartId}');return false;"
          class="hidden">
        <input type="hidden" name="qid" value="sample.STOCK_QUOTE_LIST"/>
        <@ui.textfield name="jsonFormat" value="linechart"/>
        <@ui.textfield name='chartOptions.xField'value="date"/>
        <@ui.textfield name='chartOptions.yField' value="close"/>
        <@ui.textfield name='chartOptions.seriesField' value="symbol"/>
    </form>
    <@lineChart id=chartId title="Stock" ajaxForm="#${chartId}-qform"/>
</div>
</@ui.page>
