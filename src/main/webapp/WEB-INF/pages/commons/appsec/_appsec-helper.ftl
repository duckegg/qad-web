<#--
********************************************************************************
@desc helpers for user,role,permission
@author Leo Liao, 2013/03/27, created
********************************************************************************
-->

<#--
================================================================================
Navigation breadcrumb
================================================================================
-->
<#macro userNavbar level="">
<div class="navbar" id="user-breadcrumb">
    <div class="navbar-inner">
        <a class="brand"
           href="${base}/user/index">系统安全</a>
        <ul class="nav">
            <li class="<#if level=='user'>active</#if>"><a
                    href="${base}/user/list">用户</a></li>
            <li class="<#if level=='role'>active</#if>"><a
                    href="${base}/role/list">角色</a></li>

            <#--<li class="<#if level=='domain'>active</#if>"><a-->
                    <#--href="${base}/citype/list">CI类型定义</a>-->
            <#--</li>-->
            <li class="<#if level=='perm'>active</#if>"><a
                    href="${base}/permission/list">权限定义</a>
            </li>
            <li class="<#if level=='permcode'>active</#if>"><a href="${base}/permission/codes">权限代码</a>
            </li>
            <li class="<#if level=='matrix'>active</#if>"><a href="${base}/user/matrix">权限矩阵</a>
            </li>
        </ul>
    </div>
</div>
</#macro>