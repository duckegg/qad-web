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
<#--<div class="navbar navbar-default" id="user-breadcrumb">-->
        <#--&lt;#&ndash;<a class="navbar-brand"&ndash;&gt;-->
           <#--&lt;#&ndash;href="${base}/user/index">系统安全</a>&ndash;&gt;-->
        <#--<ul class="nav navbar-nav">-->
            <#--<li class="<#if level=='user'>active</#if>"><a-->
                    <#--href="${base}/user/list">用户</a></li>-->
            <#--<li class="<#if level=='role'>active</#if>"><a-->
                    <#--href="${base}/admin/people/role/list">角色</a></li>-->

            <#--&lt;#&ndash;<li class="<#if level=='domain'>active</#if>"><a&ndash;&gt;-->
                    <#--&lt;#&ndash;href="${base}/admin/config/citype/list">CI类型定义</a>&ndash;&gt;-->
            <#--&lt;#&ndash;</li>&ndash;&gt;-->
            <#--<li class="<#if level=='perm'>active</#if>"><a-->
                    <#--href="${base}/admin/people/permission/list">权限定义</a>-->
            <#--</li>-->
            <#--<li class="<#if level=='permcode'>active</#if>"><a href="${base}/admin/people/permission/codes">权限代码</a>-->
            <#--</li>-->
            <#--<li class="<#if level=='matrix'>active</#if>"><a href="${base}/user/matrix">权限矩阵</a>-->
            <#--</li>-->
        <#--</ul>-->
<#--</div>-->
</#macro>