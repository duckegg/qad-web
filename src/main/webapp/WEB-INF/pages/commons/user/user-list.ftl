<#--
********************************************************************************
@desc account management
@author Leo Liao, 2012/06/26, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#include "../appsec/people-helper.ftl" parse=true/>
<#assign tableId="sysUser"/>
<#--===== Report Title =====-->
<@ui.page id="user-list" title="用户">
    <@userNavbar level="user"/>
<div class="btn-toolbar" id="user-list-toobar">
    <#if permissionResolver.allow('perm_sysadm_user')>
        <div class="btn-group">
            <a class="btn btn-default" data-dialog data-dialog-aftersubmit="refreshDataTable('${tableId}')"
               href="${base}/user/create"><i class="fa fa-plus"></i> 新建用户</a>
        </div>
    </#if>
</div>
<#--====== Query Form ======-->
<div class="hidden">
    <h3>精确查询</h3>

    <div>
        <@s.form id="${tableId}QueryForm" action="tabledata" method="post" theme="bootstrap" cssClass="form-inline" onsubmit="refreshDataTable('${tableId}');return false;">
            <input type="hidden" name="qid" value="user.USR_SYS_USER_LIST"/>
            <@s.checkboxlist label="角色" name="roleIdsInUser" multiple="true" list="roles" listKey="id" listValue="name"/>
            <button type="submit" class="btn btn-default">刷新</button>
        </@s.form>
    </div>
</div>
<#--===== Table Setup =====-->
<script type="text/javascript">
    var columns_${tableId} = [
        { "mDataProp": "login_name", "sTitle": "登录名" },
        { "mDataProp": "full_name", "sTitle": "姓名" },
        { "mDataProp": "email", "sTitle": "Email" },
        { "mDataProp": "department", "sTitle": "部门" },
        { "mDataProp": "phone", "sTitle": "电话" },
        { "mDataProp": "created_at", "sTitle": "创建日期" },
        { mDataProp: "login_name", sTitle: "操作", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                var href = '${base}/user/update?id=' + o.aData['id'];
                return '<a class="btn btn-xs" data-dialog href="' + href + '" data-dialog-aftersubmit="refreshDataTable(\'${tableId}\')"><i class="fa fa-cog"></i></a>';
            }
        }
    ];
</script>
    <@ajaxTable tableId="${tableId}" ajaxForm="#${tableId}QueryForm" printable=false toolbarElement="#user-list-toobar"/>
</@ui.page>