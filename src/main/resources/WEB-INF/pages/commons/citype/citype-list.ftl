<#--
********************************************************************************
@desc list page
@author Leo Liao, 2013/03/26, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#--<#include "../appsec/people-helper.ftl" parse=true/>-->
<#assign tableId="domainList"/>
<@ui.page id="citype-list" title="CI类型">
    <#--<@userNavbar level="domain"/>-->
<@ui.alert level="info" textOnly=true>
在这里定义系统中各类对象模型（CI）
</@ui.alert>
<div class="btn-toolbar" id="citype-list-toolbar">
    <div class="btn-group">
        <a class="btn btn-default" data-dialog data-dialog-aftersubmit="refreshDataTable('${tableId}')"
           href="${base}/admin/config/citype/create"><i class="fa fa-plus"></i> 新建CI类型</a>
        <a class="btn btn-default" data-dialog data-dialog-aftersubmit="refreshDataTable('${tableId}')"
           href="${base}/datex/imp?target=ciType&sourceFormat=tsv"><i class="fa fa-upload"></i> 导入CI类型</a>
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
    var columns_${tableId} = [
        { "mDataProp": "machine_name", "sTitle": "CI类型标识" },
        { "mDataProp": "name", "sTitle": "CI类型名称" },
//        { "mDataProp": "icon", "sTitle": "图标" },
//        { "mDataProp": "clazz", "sTitle": "Class"},
        { "mDataProp": "full_view_url", "sTitle": "Full View"},
        { "mDataProp": "search_enabled", "sTitle": "可否搜索"},
        { "mDataProp": "index_profile_name", "sTitle": "索引方案"},
//        { "mDataProp": "summary_view_url", "sTitle": "Summary View"},
//        { "mDataProp": "search_result_view_url", "sTitle": "Search Result View"},
        { mDataProp: "id", sTitle: "操作", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                var href = '${base}/admin/config/citype/update?id=' + o.aData['id'];
                return '<a href="' + href + '" data-dialog data-dialog-aftersubmit="refreshDataTable(\'${tableId}\')"><i class="fa fa-edit"></i></a>';
            }
        }
    ];
</script>
    <@ajaxTable tableId="${tableId}" ajaxForm="#${tableId}-qform" toolbarElement="#citype-list-toolbar"/>
</@ui.page>