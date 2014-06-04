<#--
********************************************************************************
@desc inline login box
@author Leo Liao, 2014/5/29, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="login-inline"/>
<@ui.page id=pageId title="Login" showStrutsInfo=false>
<style type="text/css">
    /* This will be fixed in bootstrap 3.2.0*/
    .has-feedback label.sr-only ~ .form-control-feedback {
        top: 0;
        color: #888;
    }

</style>
<form action="${base}/login-inline" method="post" data-kui-ajax-form data-kui-target="#${pageId}"
      class="page-login-box">
    <div class="form-group">
        <span class="form-control-static">请输入Windows域帐户登录</span>
    </div>

    <div class="form-group has-feedback">
        <label class="control-label sr-only">用户名</label>
        <input type="text" id="username" name="username"
               class="required form-control"
               placeholder="用户名"/>
        <span class="form-control-feedback"><i class="fa fa-user"></i></span>
    </div>
    <div class="form-group has-feedback">
        <label class="control-label sr-only">密码</label>
        <input type="password" id="password" name="password"
               class="required form-control"
               placeholder="密码"/>
    <#--<span class="input-group-addon"><i class="fa fa-keyboard-o"></i></span>-->
        <span class="form-control-feedback"><i class="fa fa-keyboard-o"></i></span>
    </div>
    <div>
        <@ui.strutsErrors/>
    </div>

    <div class="form-group">
        <button type="submit" class="btn btn-primary btn-block"
        <#--style="font-weight: bold"-->
                data-loading-text="正在登录...">
            登录
        </button>
    <#--<button class="btn btn-default col-xs-offset-1 col-xs-3"-->
    <#--name="guest" value="true">-->
    <#--直接访问-->
    <#--</button>-->
    </div>
</form>
</@ui.page>
