<#--
********************************************************************************
@desc Permission code definition
@author Leo Liao, 2013/04/02, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "people-helper.ftl" parse=true/>
<@ui.page id="permission-codes" title="权限代码">
    <@userNavbar level="permcode"/>
    <@ui.alert level="info">
    权限代码在shiro/permcode.properties中定义，这里只是展示。
    </@ui.alert>
<table class="table table-bordered table-striped">
    <thead>
    <tr>
        <th>权限代码</th>
        <th>权限定义表达式</th>
    </tr>
    </thead>
    <tbody>
        <#list permCodes?keys as code>
        <tr>
            <td><code>${code}</code></td>
            <td><code>${permCodes[code]}</code></td>
        </tr>
        </#list>
    </tbody>
</table>
</@ui.page>