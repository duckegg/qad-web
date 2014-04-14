<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-3, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "../udr-lib.ftl" parse=true/>
<#assign FORMAT=displayFormat/>
<#assign pageId="report-${userDefinedReport.id!'unknown'}-${FORMAT!''}"/>
<#assign chartId="${pageId}-${FORMAT}"/>
<#assign formats=parseJson(userDefinedReport.displayJson)/>
<#assign format=formats[FORMAT]/>
<@ui.page id=pageId title=FORMAT>
<form id="${pageId}-qform" action="${base}/udr/json/chart" method="post"
      class="<#if !previewMode??>hidden</#if> form-inline"
      onsubmit="kui.replotChart('${chartId}');return false;">
    <#if previewMode??>
        <@ui.textfield name="queryDef.sql" value="${(userDefinedReport.queryDef.sql)!''}" isHidden=true/>
        <@ui.textfield name="queryDef.dbConn"
        value="${(userDefinedReport.queryDef.dbConn)!''}" isHidden=true/>
    <#else>
        <input type="hidden" name="id" value="${userDefinedReport.id!''}"/>
    </#if>
    <@ui.textfield name="displayFormat" value="${FORMAT}" isHidden=true/>
    <@ui.textfield name='chartOptions.xField'
    value="${format.xField}" isHidden=true/>
    <@ui.textfield name='chartOptions.yField'
    value="${format.yField}" isHidden=true/>
    <@ui.textfield name='chartOptions.seriesField'
    value="${(format.seriesField)!''}" isHidden=true/>
</form>
    <#if FORMAT=='barchart'>
        <@chart.barChart id="${chartId}" title="${userDefinedReport.title!''}" ajaxForm="#${pageId}-qform"/>
    <#elseif FORMAT=="linechart">
        <@chart.lineChart id="${chartId}" title="${userDefinedReport.title!''}" ajaxForm="#${pageId}-qform" xAxisFormat="${(format.xAxisFormat)!'%y-%m'}"
        markerShow=true markerSize=4 />
    <#elseif FORMAT=="piechart">
        <@chart.pieChart id="${chartId}" title="${userDefinedReport.title!''}" ajaxForm="#${pageId}-qform" />
    </#if>
</@ui.page>
