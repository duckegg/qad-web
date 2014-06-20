<#--
********************************************************************************
@desc Page to edit permission.
@author Leo Liao, 2012/07/02, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/library/ftl/lib-function.ftl" parse=true/>
<#assign pageId="permission-edit"/>
<@ui.page id=pageId  title="编辑权限" class="webform">
<form id="permission-edit-form" action="${base}/admin/people/permission/${iif(permission.id??,'update_do','create_do')}"
      class="form-horizontal" method="post"
      data-ajax-form data-kui-target="#permission-edit">
    <div class="alert alert-info">权限以<code>类型:操作:对象</code>的形式表现</div>
    <@s.hidden name="permission.id"/>
    <@ui.labelControlGroup label="类型">
        <@s.select key="permission.domain" cssClass="required select2" title="请设置类别" list='availableCiTypes' listKey="key" listValue="key" value="permission.domain" theme="simple"/>
        <a href="${base}/admin/config/citype/create" data-ajax-link data-kui-target="#permission-edit"
           title="新增对象类型" class="btn btn-default"><i class="fa fa-plus"></i></a>
    </@ui.labelControlGroup>
    <@s.select key="permission.action" label="操作" cssClass="required select2" title="请设置操作" list='availableActions' value="permission.action"/>
    <@ui.textfield name="permission.target" label="对象" class="required" title="请设置对象" maxlength="50"/>
    <@ui.textarea name="permission.description" label="说明" title="请输入描述信息"/>
    <div class="form-actions">
        <#if permission.id??>
            <div style="float:left">
                <a href="${base}/admin/people/permission/delete?id=${permission.id}"
                   class="btn btn-danger js-delete-perm" tabindex="-1"
                   data-ajax-link data-kui-target="#permission-edit"><i
                        class="fa fa-times"></i> 删除权限</a>
            </div>
        </#if>
        <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存</button>
        <button type="reset" class="btn btn-default">取消</button>
    </div>
</form>
</@ui.page>