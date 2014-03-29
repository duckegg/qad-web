<#-- 2012/05/03 -->
<#include "/library/taglibs.ftl" parse=true/>
<#include "_demo-navigation.ftl" parse=true/>
<@ui.page id="uidemo-index" title="UI Demo">
    <@demoNav id="horizontal-nav" style="horizontal" target="#js-content-pane"/>
<div id="js-content-pane" class="tab-content"></div>
</@ui.page>