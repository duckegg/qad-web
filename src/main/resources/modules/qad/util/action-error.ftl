<#--
********************************************************************************
@desc User friendly action error message prompt
@author Leo Liao, 2013/03, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div class="alert alert-warning">
<@s.if test="hasActionErrors()">
    <#list action.errorMessages as msg >
        <p>${msg}</p>
    </#list>
</@s.if>
</div>
