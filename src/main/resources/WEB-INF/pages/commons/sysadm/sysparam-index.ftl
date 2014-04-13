<#--
********************************************************************************
@desc 
@author Leo Liao, 13-12-8, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="sysparam-index"/>
<@ui.page id=pageId title="系统参数">
<div class="tabbable tabbable-custom">
    <@ui.ajaxNav target="#${pageId}-nav-target" class="nav-tabs">
        <li class="active"><a href="${base}/admin/config/citype/list" data-toggle="tab">CI类型</a></li>
        <li><a href="${base}/sysadm/sysparam/list" data-toggle="tab">搜索参数</a></li>
    </@ui.ajaxNav>
</div>
<div id="${pageId}-nav-target" class="tab-content">
</div>
</@ui.page>
