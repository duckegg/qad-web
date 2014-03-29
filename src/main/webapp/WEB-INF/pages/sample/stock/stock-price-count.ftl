<#--
********************************************************************************
@desc 
@author Leo Liao, 3/26/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="stock-price-count"/>
<@ui.page id=pageId title="Price Change">
    <#assign chartId="${pageId}-chart"/>
<form id="${chartId}-qform" action="${base}/query/json/jqplot" method="post"
      onsubmit="replotChart('${chartId}');return false;"
      class="hidden">
    <input type="hidden" name="qid" value="sample.STOCK_QUOTE_UPDOWN_COUNT"/>
    <@ui.textfield name='chartOptions.xField'value="up_or_down"/>
    <@ui.textfield name='chartOptions.yField' value="amount"/>
    <@ui.textfield name='chartOptions.seriesField' value="symbol"/>
</form>
    <@pieChart id=chartId title="Price Change" ajaxForm="#${chartId}-qform"/>
</@ui.page>
