<#--
********************************************************************************
@desc account management
@author Leo Liao, 2012/06/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl"/>
<div class="row">
    <div class="col-md-10">
    <#include "user-list.ftl" parse=true/>
    </div>
    <div class="col-md-2">
        <ul class="nav nav-list">
            <li class="nav-header">帮助</li>
            <li><a href="${base}/help/appsec">如何设置权限</a></li>
        </ul>
    </div>
</div>
