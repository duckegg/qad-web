<#--
********************************************************************************
@desc Role management
@author Leo Liao, 2012/06/27, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#include "people-helper.ftl" parse=true/>
<#assign tableId="userRole"/>
<#--===== Report Title =====-->
<@ui.page id="role-list" title="角色">
<div id="role-list">
    <@userNavbar level="role"/>
<#--====== Task Toolbar ======-->
    <div class="btn-toolbar pull-left">
        <div class="btn-group">
            <a class="btn btn-default"
               data-dialog <#--data-dialog-aftersubmit="refreshDataTable('${tableId}')"-->
               href="${base}/admin/people/role/create"><i
                    class="fa fa-plus"></i> 新建角色</a>
        </div>
    </div>
    <table id="${tableId}" class="table">
        <thead>
        <tr>
            <th>角色名称</th>
            <th>说明</th>
            <th>用户</th>
        </tr>
        </thead>
        <tbody>
            <#list roles as role>
            <tr>
                <td><a href="${base}/admin/people/role/update?id=${role.id}" data-dialog>${role.name}</a></td>
                <td>${role.description!''}</td>
                <td>
                    <ul>
                        <#list role.users as user>
                            <li>
                                <a href="${base}/user/update?id=${user.id}"
                                   data-dialog>${user.fullName} (${user.loginName!''})</a>
                            </li>
                        </#list>
                    </ul>
                </td>
            </tr>
            </#list>
        </tbody>
    </table>
    <@staticTable tableId="${tableId}" printable=false/>
</div>
</@ui.page>