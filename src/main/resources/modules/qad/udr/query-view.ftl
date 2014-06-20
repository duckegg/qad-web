<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udr-view"/>
<@ui.page id=pageId title="${userDefinedQuery.title}">
<#if displayFormat=='table'>
    <#include "format/table.ftl"/>
<#else>
    <#include "format/chart.ftl"/>
</#if>
</@ui.page>
