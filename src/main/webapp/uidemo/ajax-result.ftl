<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-15, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>

<@ui.page id="ajax" title="Ajax">
This is message from server. <strong>${Parameters.inputMessage!''}</strong><br/>
Now is ${.now}
</@ui.page>
