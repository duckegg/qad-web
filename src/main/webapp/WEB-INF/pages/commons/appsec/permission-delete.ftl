<#--
********************************************************************************
@desc pre delete a permission
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/ui-builder.ftl" parse=true/>
<div id="permission-delete" data-title="删除确认">
    <form action="${base}/admin/people/permission/delete_do" class="form-horizontal"
          data-ajax-form data-kui-target="#permission-delete" method="POST">
        <input type="hidden" name="id" value="${permission.id}"/>

        <div class="alert alert-danger">
            删除权限请务必小心！<br/>
            权限删除后，系统中被该权限限制的内容将 *无法* 访问。请事先与熟悉系统权限设置的开发人员联系。
            坚持要删除权限 <strong>${permission.permkey}</strong> 吗？
        </div>
    <@buttonGroup>
        <button type="submit" class="btn btn-danger"><i class="fa fa-times"></i> 确认删除
        </button>
        <button type="reset" class="btn btn-default"><i class="fa fa-check"></i> 取消</button>
    </@buttonGroup>
    </form>
</div>
