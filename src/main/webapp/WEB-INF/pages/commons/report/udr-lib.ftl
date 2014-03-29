<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-2, created
********************************************************************************
-->
<#assign UDR_FORMATS={"table":"表格","linechart":"折线图","barchart":"直方图","piechart":"饼图"}/>
<#assign toJson="hpps.qad.base.freemarker.ToJsonMethod"?new()/>
<#macro chartDataQueryForm>
<form id="${pageId}-qform" action="${base}/udr/data" method="post"
      class="<#if !previewMode??>hidden</#if>"
      onsubmit="replotChart('${chartId}');return false;">
    <#if previewMode??>
        <input type="text" name="queryDef.sql" value="${(userDefinedReport.queryDef.sql)!''}"/>
        <input type="text" name="queryDef.dbConn"
               value="${(userDefinedReport.queryDef.dbConn)!''}"/>
    <#else>
        <input type="hidden" name="id" value="${userDefinedReport.id!''}"/>
    </#if>
    <input type="text" name="displayFormat" value="${FORMAT}"/>
    <input type="text" name='chartOptions.xField'
           value="${userDefinedReport.display[FORMAT].xField}"/>
    <input type="text" name='chartOptions.yField'
           value="${userDefinedReport.display[FORMAT].yField}"/>
    <input type="text" name='chartOptions.seriesField'
           value="${(userDefinedReport.display[FORMAT].seriesField)!''}"/>
</form>
</#macro>