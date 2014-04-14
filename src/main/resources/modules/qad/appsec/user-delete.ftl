<#--
********************************************************************************
@desc pre delete a user
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="user-delete" data-title="删除确认">
    <title>删除确认</title>
    <form action="${base}/user/delete_do" class="form-horizontal"
          data-ajax-form data-kui-target="#user-delete" method="POST">
        <input type="hidden" name="id" value="${user.id}"/>

        <div class="alert alert-danger">确认删除用户 <strong>${user.fullName}</strong> 么？</div>
    <@buttonGroup>
        <button type="submit" class="btn btn-danger"><i class="fa fa-times"></i> 确认删除
        </button>
        <button type="reset" class="btn"><i class="fa fa-check"></i> 取消</button>
    </@buttonGroup>
    </form>
</div>
