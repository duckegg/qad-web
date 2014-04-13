<#--
********************************************************************************
@desc Page to edit role.
@author Leo Liao, 2012/06/27, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/functions.ftl" parse=true/>
<#assign pageId="role-edit"/>
<@ui.page id=pageId title="编辑角色" class="webform">
<form id="role-edit-form" action="${base}/admin/people/role/${iif(role.id??,'update_do','create_do')}"
      class="form-horizontal" method="post"
      data-ajax-form data-kui-target="#role-edit">
    <div class="tabbable tabbable-custom">
        <ul class="nav nav-tabs">
            <li class="active"><a href="#role-edit-tab-1" data-toggle="tab">基本信息</a></li>
            <li><a href="#role-edit-tab-2" data-toggle="tab">权限</a></li>
            <li><a href="#role-edit-tab-3" data-toggle="tab">用户</a></li>
        </ul>
        </div>
    <div class="tab-content">
        <div id="role-edit-tab-1" class="tab-pane active">
            <@s.hidden name="role.id"/>
        <@s.textfield id="name" name="role.name" label="角色" class="required" title="请设置角色名" maxlength="60"/>
        <@s.textarea id="description" name="role.description" label="说明" title="请输入描述信息" cssStyle="height:5em"/>
            <@s.hidden name="role.visibility"/>
        </div>
        <div id="role-edit-tab-2" class="tab-pane">
            <@s.checkboxlist label="权限" name="rolePermissionIds" multiple="true" list="allPermissions" listKey="id" listValue="permkey" value="role.permissionIds" cssClass="checkbox-inline"/>
        </div>
        <div id="role-edit-tab-3" class="tab-pane">
            <@s.select label="用户" name="roleUserIds" multiple="true" list="allUsers" listKey="id" listValue="fullName" value="role.userIds" cssClass="select2"/>
        </div>
    </div>
    <@ui.buttonGroup>
        <#if role.id?? && !role.isPrivate()>
            <div style="float:left">
                <a href="${base}/admin/people/role/delete?id=${role.id}"
                   class="btn btn-danger js-delete-role" tabindex="-1"
                   data-ajax-link data-kui-target="#role-edit">
                    <i class="fa fa-times"></i> 删除角色</a>
            </div>
        </#if>
        <#if !role.isPrivate()>
            <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存</button>
            <button type="reset" class="btn btn-default">取消</button>
        <#else>
            <button type="reset" class="btn btn-default">这是个人角色，不能修改</button>
        </#if>

    </@ui.buttonGroup>
</form>
<script type="text/javascript">
    $(function () {
        var $page = $('#${pageId}');
        <#if role.isPrivate()>
            disableControls($page);
        </#if>
    });
</script>
</@ui.page>