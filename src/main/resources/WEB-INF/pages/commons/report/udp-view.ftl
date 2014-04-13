<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/12, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udp-view-${id}"/>
<@ui.page id=pageId title=thisEntity.title>
    <#include "/"+fmTemplateName/>
</@ui.page>
