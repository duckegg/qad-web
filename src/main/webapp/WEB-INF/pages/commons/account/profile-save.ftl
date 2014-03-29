<#--
********************************************************************************
@desc after save profile
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<div id="user-save">
    <div class="alert alert-success hero-unit">
        已更新用户信息 ${user.fullName} (${user.loginName})
        <ul>
            <li><a href="${base}/profile" data-ajax-link data-kui-target="#user-save">继续编辑</a></li>
            <li><a href="#" onclick="closeDialog('#user-save')">关闭</a></li>
        </ul>
    </div>
</div>
