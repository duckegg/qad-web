<#--
********************************************************************************
@desc 
@author Leo Liao, 13-12-12, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="multi-iframe"/>
<@ui.page id=pageId title="一个页面多个iframe">
    <#assign tabs={"baidu":"http://www.baidu.com","csdn":"http://www.csdn.com","163":"http://www.163.com","yahoo-not-allow-iframe":"http://www.yahoo.com","google-not-allow-iframe":"http://www.google.com"}/>
<div class="tabbable tabbable-custom">
    <@ui.ajaxNav target="#${pageId}-nav-target" class="nav-tabs">
        <#list tabs?keys as key>
            <li <#if key_index==0>class="active"</#if>>
                <a href="#${pageId}-${key}" title="${tabs[key]}">${key}</a>
            </li>
        </#list>
    </@ui.ajaxNav>
</div>
<div id="${pageId}-nav-target" class="tab-content">
    <#list tabs?keys as key>
        <div id="${pageId}-${key}" class="tab-pane">
            <h4>${tabs[key]}</h4>
            <iframe src="${tabs[key]}" width="100%"
                    height="400" style="border:0;"></iframe>
        </div>
    </#list>
</div>
</@ui.page>
