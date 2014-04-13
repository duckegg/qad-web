<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/12, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="udp-view-${id}"/>
<@ui.page id=pageId title=thisEntity.title>
    <#include "/"+fmTemplateName/>
</@ui.page>
