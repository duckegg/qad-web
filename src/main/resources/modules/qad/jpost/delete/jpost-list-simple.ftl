<#--
********************************************************************************
@desc Page to list jpost.
@author tom, 2012/07/12, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign tableId="jpost"/>
<div id="jpost-list" data-role="page">
    <a href="${base}/jpost/${postType}/list?style=fancy" class="btn btn-info">Fancy</a>
    <div class="accordion" id="${tableId}-query">
        <h3>精确查询</h3>

        <div>
        <@s.form id="${tableId}-query-form" action="tabledata" namespace="/" method="post" theme="bootstrap" cssClass="form-inline">
            <input type="hidden" name="qid" value="post.POST_THREAD_LIST"/>
            <input type="hidden" name="__PERM_RESTRICTS_JSON__"
                   value="{'perm_entity_id_field':'id','perm_domain':'jpost','perm_actions':'update,delete,execute'}"/>
            <button type="submit" class="btn">刷新</button>
        </@s.form>
        </div>
    </div>
<#--===== Table Setup =====-->
    <script type="text/javascript">
        var columns_${tableId} = [
            { "mDataProp": "id", "sTitle": "ID" },
            { "mDataProp": "title", "sTitle": "标题", bUseRendered: false,
                fnRender: function (o) {
                    return '<a data-dialog href="${base}/jpost/${postType}/view?id=' + o.aData['id'] + '">' + o.aData['title'] + '</a>';
                }},
            { "mDataProp": "created_by", "sTitle": "创建人" },
            { "mDataProp": "created_at", "sTitle": "创建时间" },
            { "mDataProp": "updated_by", "sTitle": "更新人" },
            { "mDataProp": "updated_at", "sTitle": "更新时间" },
            { "mDataProp": "can_update", "sTitle": "can_update" },
            { mDataProp: "id", sTitle: "操作", sClass: "",
                bUseRendered: false,
                fnRender: function (o) {
                    var id = o.aData['id'];
                    var html = "", href;
                    var status = o.aData['can_update'] ? "" : "disabled";
                    href = '${base}/jpost/${postType}/update?id=' + id;
                    html += '<a class="btn btn-mini" data-dialog="#${tableId}-dialog" href="' + href + '" data-dialog-aftersubmit="refreshDataTable(\'${tableId}\')" ' + status + '><i class="fa fa-cog"></i></a>';
                    return html;
                }
            }
        ];
    </script>
<@ui.ajaxTable tableId="${tableId}" ajaxForm="#${tableId}-query-form" printable=false/>
    <div id="${tableId}-dialog" style="display: none"></div>
    <script type="text/javascript">
        $(function () {
            $("#${tableId}-query").collapse();

            $('#${tableId}-query-form').submit(function () {
                refreshDataTable('${tableId}');
                return false;
            });
        });
    </script>
</div>
