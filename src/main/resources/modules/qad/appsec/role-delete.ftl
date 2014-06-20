<#--
********************************************************************************
@desc pre delete a role
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="role-delete" data-title="删除确认">
    <form action="${base}/admin/people/role/delete_do" class="form-horizontal"
          data-ajax-form data-kui-target="#role-delete" method="POST">
        <input type="hidden" name="id" value="${role.id}"/>
        <div class="alert alert-danger">
            <p>删除角色不会删除该角色所拥有的用户，但可能会对用户的权限造成影响。</p>
            确认删除角色 <strong>${role.name}</strong> 么？
        </div>
    <@ui.buttonGroup>
        <button type="submit" class="btn btn-danger"><i class="fa fa-times"></i> 确认删除
        </button>
        <button type="reset" class="btn btn-default"><i class="fa fa-check"></i> 取消</button>
    </@ui.buttonGroup>
    </form>
</div>
