<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-3, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#include "../udr-lib.ftl" parse=true/>
<#assign pageId="format-barchart"/>
<#assign FORMAT=displayFormat/>
<#assign chartId="${pageId}-${FORMAT}"/>
<@ui.page id=pageId title=FORMAT>
<form id="${pageId}-qform" action="${base}/udr/json/chart" method="post"
      class="<#if !previewMode??>hidden</#if> form-inline"
      onsubmit="replotChart('${chartId}');return false;">
    <#if previewMode??>
        <@ui.textfield name="queryDef.sql" value="${(userDefinedReport.queryDef.sql)!''}"/>
        <@ui.textfield name="queryDef.dbConn"
        value="${(userDefinedReport.queryDef.dbConn)!''}"/>
    <#else>
        <input type="hidden" name="id" value="${userDefinedReport.id!''}"/>
    </#if>
    <@ui.textfield name="displayFormat" value="${FORMAT}"/>
    <@ui.textfield name='chartOptions.xField'
    value="${userDefinedReport.display[FORMAT].xField}"/>
    <@ui.textfield name='chartOptions.yField'
    value="${userDefinedReport.display[FORMAT].yField}"/>
    <@ui.textfield name='chartOptions.seriesField'
    value="${(userDefinedReport.display[FORMAT].seriesField)!''}"/>
</form>
    <#if FORMAT=='barchart'>
        <@barChart id="${chartId}" title="${userDefinedReport.title!''}" ajaxForm="#${pageId}-qform"/>
    <#elseif FORMAT=="linechart">
        <@lineChart id="${chartId}" title="${userDefinedReport.title!''}" ajaxForm="#${pageId}-qform" xAxisFormat="${(userDefinedReport.display[FORMAT].xAxisFormat)!'%y-%m'}"
        markerShow=true />
    <#elseif FORMAT=="piechart">
        <@pieChart id="${chartId}" title="${userDefinedReport.title!''}" ajaxForm="#${pageId}-qform" />
    </#if>
</@ui.page>
