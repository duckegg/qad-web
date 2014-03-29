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
<div class="container-fluid">
    <a class="navbar-btn" data-toggle="collapse" data-target=".page-sidebar">
        <span class="fa fa-bar"></span>
        <span class="fa fa-bar"></span>
        <span class="fa fa-bar"></span>
    </a>
    <a href="javascript:void(0);" class="navbar-brand sidebar-toggler hidden-phone" title="切换侧栏"><i class="fa fa-bars"></i> </a>
    <a href="${base}/home" class="navbar-brand">
        <img src="${base}/media/app/images/logo-head.png" title="Home" alt="Home"/>
    </a>
    <ul class="nav navbar-nav navbar-right">
        <li>
            <form action="${base}/search" class="navbar-form" method="get" data-pjax>
                <div class="form-group">
                    <input type="text" name="query" placeholder="输入/进入搜索"
                           class="form-control" style="height:26px"
                           title="快捷键为/"
                           tabindex="1" accesskey="/">
                </div>
            </form>
        </li>
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
                    <a class="text-danger"><i class="fa fa-user"></i> 未注册用户，请联系管理员</a>
                <#else><a id="jsNavbarUser" href="${base}/user/profile"><i
                        class="fa fa-user"></i> 修改资料</a>
                </#if></li>

                <li class="divider"></li>
                <li><a href="${base}/logout" data-pjax-disabled><i
                        class="fa fa-sign-out"></i> 退出</a></li>
            </ul>
        </li>
    </ul>
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
