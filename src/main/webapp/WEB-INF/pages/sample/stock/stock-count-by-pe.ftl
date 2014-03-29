<#--
********************************************************************************
@desc 
@author Leo Liao, 3/27/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="stock-count-by-pe"/>
<@ui.page id=pageId title="股票PE统计">
    <#assign chartId="${pageId}-chart"/>
<form id="${chartId}-qform" action="${base}/query/json/jqplot" method="post"
      onsubmit="replotChart('${chartId}');return false;"
      class="hidden">
    <input type="hidden" name="qid" value="sample.STOCK_GROUP_BY_PE"/>
    <@ui.textfield name='chartOptions.xField'value="pe_range"/>
    <@ui.textfield name='chartOptions.yField' value="stock_count"/>
    <@ui.textfield name='chartOptions.seriesField' value="{PE}"/>
</form>
    <@pieChart id=chartId title="PE统计" ajaxForm="#${chartId}-qform" legendPosition="n"/>
</@ui.page>
