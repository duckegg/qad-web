<#-- 2012/05/03 -->
<#include "/library/taglibs.ftl" parse=true/>
<@ui.page id="tab" title="Tabs Demo">
<#--<@ui.actionTabs id="statsTabs" smartList=true scrollable=true>-->
<#--<#list 1..50 as i>-->
<#--<@ui.stats title="Title${i}" count="${i}" link="${base}/uidemo/chart?token=${i}"></@ui.stats>-->
<#--</#list>-->
<#--</@ui.actionTabs>-->
<div class="tabbable tabbable-custom">
    <@ui.ajaxNav target="#js-tab-content" class="nav-tabs">
        <#list 1..3 as m>
            <li <#if m==1>class="active"</#if>><a href="#statsTabs${m}">Tab${m}</a></li>
        </#list>
    </@ui.ajaxNav>
    <div class="tab-content" id="js-tab-content">
        <#list 1..3 as m>
            <#assign scrollable=m!=2/>
            <div id="statsTabs${m}" class="tab-pane">
                <div class="alert alert-info">scrollable=${scrollable?string}</div>
                <@ui.actionTabs id="statsTabs${m}" smartList=true scrollable=scrollable>
                    <#list 1..50 as i>
                        <@ui.stats title="LongLongLongLongTitle${m}-${i}" count="${i}" link="${base}/uidemo/chart?token=${m}-${i}" badge="100${i}"></@ui.stats>
                    </#list>
                </@ui.actionTabs>
            </div>
        </#list>
    </div>
</div>
</@ui.page>