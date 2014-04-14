<#--
********************************************************************************
@desc Edit user result
@author Leo Liao, 2012/06/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="user-save">
    <div class="alert alert-success hero-unit">
        已更新用户信息 ${user.fullName} (${user.loginName})
        <ul>
            <li><a href="${base}/user/update?id=${user.id}" data-ajax-link data-kui-target="#user-save">继续编辑</a></li>
            <li><a href="#" onclick="closeDialog('#user-save')">关闭</a></li>
        </ul>
    </div>
</div>
