<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-26, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="search-settings"/>
<@ui.page id=pageId title="搜索参数">
    <@ui.alert level="danger" textOnly=true>下面列出了系统中可配置参数，请咨询开发人员。</@ui.alert>
<table class="table table-bordered table-condensed">
    <thead>
    <tr>
        <th>参数名</th>
        <th>参数值</th>
        <th>说明</th>
    </tr>
    </thead>
    <tbody>
        <#list sysParams as sysParam>
        <tr>
            <td><a href="${base}/sysadm/sysparam/update?name=${sysParam.name}"
                   data-dialog>${sysParam.name}</a></td>
            <td>
                <pre style="max-height: 10em; overflow: auto">${sysParam.value!''}</pre>
            </td>
            <td>${sysParam.description!''}</td>
        </tr>
        </#list>
    </tbody>
</table>
</@ui.page>
