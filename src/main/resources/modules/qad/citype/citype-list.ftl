<#--
********************************************************************************
@desc list page
@author Leo Liao, 2013/03/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#--<#include "../appsec/people-helper.ftl" parse=true/>-->
<#assign pageId="citype-list"/>
<#assign tableId="${pageId}-table"/>
<@ui.page id="citype-list" title="CI类型">
<#--<@userNavbar level="domain"/>-->
    <@ui.alert level="info" textOnly=true>
    在这里定义系统中各类对象模型（CI）
    </@ui.alert>
<div class="btn-toolbar" id="citype-list-toolbar">
    <div class="btn-group">
        <a class="btn btn-default" data-dialog data-dialog-aftersubmit="kui.refreshDataTable('${tableId}');"
           href="${base}/admin/config/citype/create"><i class="fa fa-plus"></i> 新建CI类型</a>
        <a class="btn btn-default" data-dialog data-dialog-aftersubmit="kui.refreshDataTable('${tableId}');"
           href="${base}/datex/imp?target=ciType&sourceFormat=tsv"><i class="fa fa-upload"></i> 导入CI类型</a>
        <button class="btn btn-default" onclick='$("#${pageId}-form").submit();return false;'>删除</button>
    </div>
</div>
<div class="hidden">
    <h3>精确查询</h3>

    <div>
        <@s.form id="${tableId}-qform" action="tabledata" namespace="/" method="post" theme="bootstrap" cssClass="form-inline">
            <input type="hidden" name="qid" value="sys.SYS_DOMAIN_LIST"/>
        </@s.form>
    </div>
</div>
<script type="text/javascript">
    kui.setTableColumns('${tableId}', [
        { "mData": "id", "sTitle": "ID", bUseRendered: false,
            fnRender: function (o) {
                return '<input type="checkbox" name="ids" value="' + o.aData['id'] + '"/>';
            } },
        { "mData": "machine_name", "sTitle": "CI类型标识" },
        { "mData": "name", "sTitle": "CI类型名称" },
        { "mData": "full_view_url", "sTitle": "Full View"},
        { "mData": "search_enabled", "sTitle": "可否搜索"},
        { "mData": "index_profile_name", "sTitle": "索引方案"},
        { mData: "id", sTitle: "操作", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                var href = '${base}/admin/config/citype/update?id=' + o.aData['id'];
                return '<a class="btn btn-xs btn-default" href="' + href + '" data-kui-dialog data-dialog-aftersubmit="refreshDataTable(\'${tableId}\')"><i class="fa fa-pencil"></i></a>';
            }
        }
    ]);
</script>
<form action="${base}/admin/config/citype/delete" method="post" id="${pageId}-form"
      data-kui-ajax-form
      data-kui-dialog
      data-kui-dialog-aftersubmit="refreshDataTable(\'${tableId}\')">
    <@ui.ajaxTable tableId=tableId ajaxForm="#${tableId}-qform" toolbarElement="#citype-list-toolbar"/>
</form>
</@ui.page>