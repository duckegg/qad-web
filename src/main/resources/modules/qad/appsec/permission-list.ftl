<#--
********************************************************************************
@desc permission management
@author Leo Liao, 2012/07/02, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign tableId="permList"/>
<@ui.page id="permission-list" title="权限定义">
<#--<@userNavbar level="perm"/>-->
    <@ui.alert level="warning">
    权限的定义影响到用户能使用的系统功能，修改权限的定义务必小心。在修改前请咨询系统架构师。
    </@ui.alert>
<#--====== Task Toolbar ======-->
<ul class="breadcrumb">
    <li class="btn-group">
        <a class="btn btn-default" data-dialog href="${base}/admin/people/permission/create"><i
                class="fa fa-plus"></i> 新建权限</a>
    </li>
    <li><a href="${base}/admin/people/permission/codes">权限代码</a>
    </li>
    <li><a href="${base}/admin/people/permission/matrix">权限矩阵</a>
    </li>
</ul>

<div class="btn-toolbar" id="permission-list-toolbar">

</div>
<div class="hidden">
    <h3>精确查询</h3>

    <div>
        <@s.form id="${tableId}-qform" action="/admin/people/permission/list" method="get" theme="simple" cssClass="form-inline" onsubmit="refreshDataTable('${tableId}');return false;">
            <input type="hidden" name="actionResult" value="json"/>
            <input type="hidden" name="loadUser" value="true"/>
            <button type="submit" class="btn btn-default">刷新</button>
        </@s.form>
    </div>
</div>
<#--===== Table Setup =====-->
<script type="text/javascript">
    var columns_${tableId} = [
        { "mDataProp": "domain", "sTitle": "类型" },
        { "mDataProp": "action", "sTitle": "操作" },
        { "mDataProp": "target", "sTitle": "对象" },
        { "mDataProp": "description", "sTitle": "说明" },
        { mDataProp: "id", sTitle: "操作", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                var href = '${base}/admin/people/permission/update?id=' + o.aData['id'];
                return '<a data-dialog href="' + href + '"><i class="fa fa-edit"></i></a>';
            }
        }
    ];
</script>
    <@ui.ajaxTable tableId="${tableId}" ajaxForm="#${tableId}-qform" toolbarElement="#permission-list-toolbar"/>
</@ui.page>