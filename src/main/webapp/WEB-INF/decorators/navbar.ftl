<#--
********************************************************************************
@desc top nav bar
@author Leo Liao, 2012/04, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign userStatus=""/>
<#assign userFullName="Unknown User"/>
<#assign userAvatarFile=""/>
<#if Session??>
    <#if Session.user??>
        <#assign userStatus=Session.user.status!''/>
        <#assign userFullName=Session.user.fullName/>
        <#assign userAvatarFile=Session.user.avatar!''/>
    </#if>
</#if>
<div class="navbar-inner">
    <div class="container-fluid">
        <a class="btn-navbar" data-toggle="collapse" data-target=".page-sidebar">
            <span class="fa fa-bar"></span>
            <span class="fa fa-bar"></span>
            <span class="fa fa-bar"></span>
        </a>

        <a href="${base}/home" class="brand">
            <img src="${base}/media/app/images/logo-head.png" title="Home"/>
        </a>
        <ul class="nav pull-right">
        <@shiro.hasPermission name="sysadm:*:*">
            <form action="${base}/search" class="navbar-search form-search" method="get" data-pjax>
                <input type="text" name="query" placeholder="输入/进入搜索"
                          style="height: 15px"
                          title="全文搜索处于初步测试阶段，只能搜索有限的类型，快捷键为/"
                          tabindex="1" accesskey="/">
            </form>
        </@shiro.hasPermission>
            <li><a href="${base}/itil/itil-index"><i class="fa fa-credit-card"></i> ITIL</a></li>
        <#if isDebugMode>
            <li class="in-develop">
                <a href="#"><i class="fa fa-envelope"></i> 消息 <span
                        class="badge badge-warning">20</span> </a>
            </li>
        </#if>
        <@shiro.user>
            <li><a href="${base}/database/permission/right-managerment">
                <i class="fa fa-flask"></i>
                审计</a></li>
        <li>
        </@shiro.user>
            <li><a href="${base}/rs6000/duty-schedule"><i
                    class="fa fa-calendar"></i>
                值班表</a></li>
            <li class="in-develop">
                <a href="${base}/shortcuts" data-dialog accesskey="h"><i
                        class="fa fa-keyboard-o"></i>
                    快捷键</a></li>
            <li class="dropdown">
            <@shiro.guest>
                <a href="${base}/login" data-pjax-disabled><i
                        class="fa fa-user"></i> 请登录</a>
            </@shiro.guest>
            <@shiro.user>
                <a class="dropdown-toggle" data-toggle="dropdown" rel="popover">
                    <@func.userAvatar avatarFile=userAvatarFile cssClass="avatar small"/>
                ${userFullName}<b class="caret"></b></a>
            </@shiro.user>
                <ul class="dropdown-menu">
                    <li>
                    <#if (userStatus!"")=="UNREG">
                        <a class="text-error"><i class="fa fa-user"></i> 未注册用户，请联系管理员</a>
                    <#else><a id="jsNavbarUser" href="${base}/profile"><i
                            class="fa fa-user"></i> 修改资料</a>
                    </#if></li>

                    <li class="divider"></li>
                    <li><a href="${base}/logout" data-pjax-disabled><i
                            class="fa fa-sign-out"></i> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>
<style type="text/css">
    .navbar .kui-search-input {
        padding-right: 24px;
        background: #ddd url('${base}/media/app/images/search-icon.png') no-repeat right center;
    }

    .navbar .kui-search-input:focus {
        background-color: #fff;
    }
</style>
<script type="text/javascript">
    $(function () {
        $('.kui-search-input').on('focus', function () {
            var $this = $(this);
            $this.select();
            //http://stackoverflow.com/questions/5797539/jquery-select-all-text-from-a-textarea
            // Work around Chrome's little problem
            $this.onmouseup = function () {
                // Prevent further mouseup intervention
                $this.onmouseup = null;
                return false;
            };
        });
    });
</script>
