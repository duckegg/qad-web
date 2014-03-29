<#--
********************************************************************************
@desc 
@author Leo Liao, 3/20/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="quote-linechart"/>
<@ui.page id=pageId title="Line Chart">
<div>
    <#assign chartId="${pageId}-chart"/>
    <form id="${chartId}-qform" action="${base}/query/json/jqplot" method="post"
          onsubmit="replotChart('${chartId}');return false;"
          class="hidden">
        <input type="hidden" name="qid" value="sample.STOCK_QUOTE_WEEKLY"/>
        <@ui.textfield name='chartOptions.xField'value="date"/>
        <@ui.textfield name='chartOptions.yField' value="close"/>
        <@ui.textfield name='chartOptions.seriesField' value="symbol"/>
    </form>
    <@lineChart id="${pageId}-line" title="Weekly Price" ajaxForm="#${chartId}-qform"
    xAxisFormat="%Y-%m" yAxisShowGridline=true
    legendShow=true legendPosition="n"
    markerShow=true markerSize=9/>
    <@barChart id="${chartId}-bar" title="Many Bars Demo" ajaxForm="#${chartId}-qform"
    barWidth=1 rotateAxisLabel="x" xAxisTickAngle=-90
    legendShow=true legendPosition="e"
    markerShow=true markerSize=9/>
</div>
</@ui.page>
