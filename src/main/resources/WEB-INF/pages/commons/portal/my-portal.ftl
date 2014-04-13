<#--
********************************************************************************
@desc
@author Leo Liao, 2014/3/27, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign isLogin=false/>
<@shiro.user>
    <#assign isLogin=true/>
</@shiro.user>
<#if isLogin>
    <#include "my.ftl" parse=true/>
<#else>
    <#include "guest.ftl" parse=true/>
</#if>