<#--
********************************************************************************
@desc account profile.
@author Leo Liao, 2012/07/02, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<@ui.page id="profile-edit" title="用户信息">
<div id="profile" class="webform">
    <@ui.strutsErrors/>
    <@s.form id="profile-edit-form" action="profile/save" cssClass="form-horizontal" theme="bootstrap" enctype="multipart/form-data" method="POST">
        <div class="tabbable tabbable-custom">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#profile-basic" data-toggle="tab">基本信息</a></li>
                <li><a href="#profile-perm" data-toggle="tab">我的权限</a></li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active row-fluid" id="profile-basic">
                    <div class="span2">
                        <div class="fileupload fileupload-new" data-provides="fileupload">
                            <div class="fileupload-preview thumbnail avatar">
                                <@func.userAvatar avatarFile=user.avatar!''/>
                            </div>
                            <div>
                                    <span class="btn btn-file"><span
                                            class="fileupload-new">修改头像</span>
                                        <span class="fileupload-exists">修改</span>
                                        <@s.file name="avatar" theme="simple"/>
                                    <#--<input type="file" name="avatar"/>-->
                                    </span>
                                <a href="#" class="btn fileupload-exists"
                                   data-dismiss="fileupload">移除</a>
                            </div>
                        </div>
                    </div>
                    <div class="span10">
                    <#-- TODO: Dangerous hidden field! -->
                        <input type="hidden" name="user.loginName" value="${user.loginName}"/>
                        <@ui.text label="登录名">${user.loginName}</@ui.text>
                        <@s.textfield name="user.fullName" label="全名" cssClass="required" title="请输入您的大名" maxlength="60" required="true"/>
                        <@s.radio name="user.authMode" label="认证方式" list=r"#{'LOCAL':'本地','AD':'Windows域'}" cssClass="radio inline" required="true"/>
                        <@s.textfield name="user.email" label="Email" title="请输入你的Email地址" maxlength="60" value="${user.email!''}"/>
                        <@s.textarea name="user.description" label="自我介绍" title="介绍一下自己呗" style="height:5em"/>
                        <#assign authModes={"LOCAL":"本地","AD":"Windows域"}/>
                        <div class="control-group">
                            <label class="control-label"></label>

                            <div class="controls">
                                <label class="checkbox inline"><input type="checkbox"
                                                                      id="js-change-password"/>修改密码</label>

                            </div>
                        </div>
                        <div>
                            <@s.password name="user.plainPassword" label="新密码"  title="请设置新的用户密码，留空保留原来的密码" maxlength="60"/>
            <@s.password name="repeatedPassword"label="重复密码" title="请重复用户密码" maxlength="60"/>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="profile-perm">
                    <fieldset>
                        <@ui.text label="我的角色">
                            <ul class="unstyled inline">
                                <#list user.roles as role>
                                    <li><span class="label">${role.name}</span></li>
                                </#list>
                            </ul>
                        </@ui.text>
                        <@ui.text label="我的权限">
                            <ul>
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
                <button type="reset" class="btn">取消</button>
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