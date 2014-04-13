<#--
********************************************************************************
@desc account profile.
@author Leo Liao, 2012/07/02, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<@ui.page id="profile-edit" title="用户信息">
<div id="profile" class="webform">
    <@ui.strutsErrors/>
    <@s.form id="profile-edit-form" action="user/profile/save" cssClass="form-horizontal" theme="bootstrap" enctype="multipart/form-data" method="POST">
        <div class="tabbable tabbable-custom">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#profile-basic" data-toggle="tab">基本信息</a></li>
                <li><a href="#profile-perm" data-toggle="tab">我的权限</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active row" id="profile-basic">
                    <div class="col-md-9">
                    <#-- TODO: Dangerous hidden field! -->
                        <input type="hidden" name="user.loginName" value="${user.loginName}"/>
                        <@ui.text label="登录名">${user.loginName}</@ui.text>
                        <@ui.textfield name="user.fullName" label="全名" class="required" title="请输入您的大名" maxlength="60" required=true/>
                        <@ui.labelControlGroup label="认证方式">
                            <@s.radio name="user.authMode" list=r"#{'LOCAL':'本地','AD':'Windows域'}" cssClass="radio-inline" required="true"/>
                        </@ui.labelControlGroup>
                        <@ui.textfield name="user.email" label="Email" title="请输入你的Email地址" maxlength="60"/>
                        <@ui.textarea name="user.description" label="自我介绍" title="介绍一下自己呗" style="height:5em"/>
                        <#assign authModes={"LOCAL":"本地","AD":"Windows域"}/>
                        <div class="form-group">
                            <label class="control-label"></label>

                            <div class="controls">
                                <label class="checkbox-inline"><input type="checkbox"
                                                                      id="js-change-password"/>修改密码</label>

                            </div>
                        </div>
                        <div>
                            <@ui.textfield name="user.plainPassword" label="新密码"  title="请设置新的用户密码，留空保留原来的密码" maxlength="60" isPassword=true/>
                            <@ui.textfield name="repeatedPassword"label="重复密码" title="请重复用户密码" maxlength="60" isPassword=true/>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="fileinput fileinput-new text-center" data-provides="fileinput">
                            <div class="fileinput-new thumbnail avatar">
                                <@func.userAvatar avatarFile=user.avatar!''/>
                            </div>
                            <div class="fileinput-preview fileinput-exists thumbnail avatar"></div>
                            <div>
                                    <span class="btn btn-default btn-file btn-xs"><span
                                            class="fileinput-new">修改头像</span>
                                        <span class="fileinput-exists">修改</span>
                                        <@s.file name="avatar" theme="simple"/>
                                    <#--<input type="file" name="avatar"/>-->
                                    </span>
                                <a href="#" class="btn btn-default fileinput-exists btn-xs"
                                   data-dismiss="fileinput">移除</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane" id="profile-perm">
                    <fieldset>
                        <@ui.text label="我的角色">
                            <ul class="list-unstyled list-inline">
                                <#list user.roles as role>
                                    <li><span class="label">${role.name}</span></li>
                                </#list>
                            </ul>
                        </@ui.text>
                        <@ui.text label="我的权限">
                            <ul class="list-unstyled">
                                <#list user.roles as role>
                                    <#list role.permissions as perm>
                                        <li>${perm.permkey}</li>
                                    </#list>
                                </#list>
                            </ul>
                        </@ui.text>
                    </fieldset>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存
                </button>
                <button type="reset" class="btn btn-default">取消</button>
            </div>
        </div>
    </@s.form>
</div>
<#--===== JS&UI Setup ======-->
<script type="text/javascript">
    $(function () {
        var $page = $('#profile');
        var $form = $('#profile-edit-form');

        function enablePassword(status) {
            if (status)
                $("input:password", $form).removeAttr("disabled");
            else
                $("input:password", $form).attr("disabled", "disabled");
        }

        $("#js-change-password").click(function () {
            enablePassword($(this).is(":checked"));
        });
        enablePassword($(this).is(":checked"));
        $form.kuiAjaxForm();
    });
</script>
</@ui.page>