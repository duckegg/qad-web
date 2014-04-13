<#--
********************************************************************************
@desc Page to view user.
@author Leo Liao, 2014/03/17, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/library/ftl/functions.ftl" parse=true/>
<#assign isNew = !user.id??/>
<#assign pageId="user-view"/>
<@ui.page id=pageId title="查看用户" class="webform">
<div class="tabbable tabbable-custom">
    <ul class="nav nav-tabs">
        <li class="active"><a href="#user-info-basic" data-toggle="tab">基本信息</a></li>
        <li><a href="#user-info-other" data-toggle="tab">联系信息</a></li>
        <li><a href="#user-info-perm" data-toggle="tab">权限</a></li>
        <#if user.createdAt??>
            <li class="pull-right">
                <a class="muted initialism ">创建于${user.createdAt}</a>
            </li>
        </#if>
    </ul>
    <div class="tab-content form-horizontal">
        <div id="user-info-basic" class="tab-pane active">
            <div class="col-md-3 thumbnail">
                <@func.userAvatar avatarFile=user.avatar!''/>
            </div>
            <div class="col-md-9">
                <@ui.labelControlGroup label="登录名">${user.loginName}</@ui.labelControlGroup>
                    <@ui.labelControlGroup label="全名">${user.fullName}</@ui.labelControlGroup>
                    <@ui.labelControlGroup label="SA用户名">${user.saUsername!''}</@ui.labelControlGroup>
                    <@ui.labelControlGroup label="认证方式">${{'LOCAL':'本地','AD':'Windows域'}[user.authMode]}</@ui.labelControlGroup>
            </div>
        </div>
        <div class="tab-pane" id="user-info-other">
            <@ui.labelControlGroup label="Email">${user.email!''}</@ui.labelControlGroup>
            <@ui.labelControlGroup label="部门">${user.department!''}</@ui.labelControlGroup>
            <@ui.labelControlGroup label="电话">${user.phone!''}</@ui.labelControlGroup>
            <@ui.labelControlGroup label="说明">${user.description!''}</@ui.labelControlGroup>
        </div>
        <div class="tab-pane" id="user-info-perm">
            <#list user.roleIds as roleId>
               ${roleId}
            </#list>
        </div>
    </div>
</div>
</@ui.page>