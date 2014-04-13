<#--
********************************************************************************
@desc Page to edit user.
@author Leo Liao, 2012/06/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/library/ftl/functions.ftl" parse=true/>
<#assign isNew = !user.id??/>
<#assign pageId="user-edit"/>
<@ui.page id=pageId title="编辑用户" class="webform">
<form id="user-edit-form" action="${base}/user/${iif(isNew,'create_do','update_do')}"
      method="post" class="form-horizontal"
      data-ajax-form data-kui-target="#user-edit">
    <input type="hidden" name="id" value="${user.id!''}"/>
    <input type="hidden" name="user.id" value="${user.id!''}"/>

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
        <div class="tab-content">
            <div id="user-info-basic" class="tab-pane active">
            <#--<div class="col-md-2">-->
            <#--</div>-->
            <#--<div class="col-md-10">-->
                <fieldset>
                    <@ui.textfield name="user.loginName" label="登录名" value="${user.loginName!''}" class="required" title="请设置用户名" maxlength="20" readonly=!isNew required=true />
                    <@ui.textfield name="user.fullName" label="全名" class="required" title="请输入用户全名" maxlength="20" required=true/>
                    <@ui.textfield name="user.saUsername" label="SA用户名" class="required" title="请输入SA用户名" maxlength="20" required=true/>
                    <@ui.textfield name="user.secretAccessKey" label="WS SAK" title="Secret Access Key for Webservice"/>
                    <@s.radio name="user.authMode" label="认证方式" list=r"#{'LOCAL':'本地','AD':'Windows域'}" cssClass="radio-inline" required="true"/>
                    <#if isNew>
                        <@ui.textfield isPassword=true name="user.plainPassword" label="密码"  class="required" title="请设置用户密码" maxlength="60" required=true/>
                        <@ui.textfield isPassword=true name="repeatedPassword" label="重复密码"  class="required" title="请重复用户密码" maxlength="60" required=true/>
                    <#else>
                        <div class="form-group">
                            <label class="control-label"></label>

                            <div class="controls">
                                <label class="checkbox-inline"><input type="checkbox"
                                                                      id="js-change-password"/>修改密码</label>
                            </div>
                        </div>
                        <div>
                            <@ui.textfield isPassword=true name="user.plainPassword" label="新密码"  title="请设置新的用户密码，留空保留原来的密码" maxlength="60"/>
                            <@ui.textfield isPassword=true name="repeatedPassword" label="重复密码" title="请重复用户密码" maxlength="60"/>
                        </div>
                    </#if>
                </fieldset>
            <#--</div>-->
            </div>
            <div class="tab-pane" id="user-info-other">
                <fieldset>
                    <@ui.textfield name="user.email" label="Email" title="请输入用户Email" maxlength="60" value="${user.email!''}"/>
                    <@ui.textfield name="user.department" label="部门" title="请输入部门" maxlength="40" value="${user.department!''}"/>
                    <@ui.textfield name="user.phone" label="电话" title="请输入电话号码" maxlength="40" value="${user.phone!''}"/>
                    <@ui.textarea name="user.description" label="说明" title="请输入描述信息" style="height:5em"/>
                </fieldset>
            </div>
            <div class="tab-pane" id="user-info-perm">
                <fieldset>
                    <@s.action name="admin/people/role/list" rethrowException=true executeResult=false var="roleListAction"/>
                    <@s.checkboxlist label="角色" name="roleIdsInUser" multiple="true" list="%{#roleListAction.roles}" listKey="id" listValue="name" value="user.roleIds" cssClass="checkbox-inline"/>
                </fieldset>
            </div>
            <@buttonGroup>
                <#if user.id??>
                    <div style="float:left">
                        <a href="${base}/user/delete?id=${user.id}"
                           class="btn btn-danger js-delete-user" tabindex="-1"
                           data-ajax-link data-kui-target="#user-edit">
                            <i class="fa fa-times"></i> 删除用户</a>
                    </div>
                </#if>
                <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存
                </button>
                <button type="reset" class="btn btn-default">取消</button>
            </@buttonGroup>
        </div>
    </div>
</form>
<#--===== JS&UI Setup ======-->
<script type="text/javascript">
    $(function () {
        var $form = $('#user-edit-form');
        var $authMode = $("input[name='user.authMode']", $form);

        function enablePassword(status) {
            var $password = $("input:password", $form);
            if (status)
                $password.removeAttr("disabled");
            else
                $password.attr("disabled", "disabled");
        }
        <#if !isNew>
            $("#js-change-password").click(function () {
                enablePassword($(this).is(":checked"));
            });
        </#if>
        enablePassword($("input[name='user.authMode']:checked", $form).val() === 'LOCAL');

        $authMode.click(function () {
            enablePassword($(this).val() === 'LOCAL');
        });
    });
</script>
</@ui.page>