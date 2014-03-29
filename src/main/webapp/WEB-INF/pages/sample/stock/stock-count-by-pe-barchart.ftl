<#--
********************************************************************************
@desc 
@author Leo Liao, 3/26/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="quote-barchart"/>
<@ui.page id=pageId title="Bar Chart">
    <#assign chartId="${pageId}-chart"/>
<form id="${chartId}-qform" action="${base}/query/json/jqplot" method="post"
      onsubmit="replotChart('${chartId}');return false;"
      class="hidden">
    <input type="hidden" name="qid" value="sample.STOCK_GROUP_BY_PE"/>
    <@ui.textfield name='chartOptions.xField'value="pe_range"/>
    <@ui.textfield name='chartOptions.yField' value="stock_count"/>
    <@ui.textfield name='chartOptions.seriesField' value="{数量}"/>
</form>
    <@barChart id=chartId title="Stock PE Range" ajaxForm="#${chartId}-qform" legendShow=true yAxisShowGridline=true/>
</@ui.page>
