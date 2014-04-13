<#--
********************************************************************************
@desc tag list
@author Leo Liao, 2012/08/18, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<title>标签管理</title>
<#--====== Task Toolbar ======-->
<div class="btn-toolbar">
    <div class="btn-group">
        <a class="btn btn-default" data-dialog="#tagDialog" href="${base}/admin/content/tag/edit"><i class="fa fa-plus"></i> 新建标签</a>
    </div>
</div>
<@s.action name="tree-query" var="resTags" rethrowException=true flush=false ignoreContextParams=true>
    <@s.param name="qid">admin.ADM_TAG_TREE_LIST</@s.param>
    <@s.param name="levelColumns">tree_parent_id,tree_child_id</@s.param>
<#--<@s.param name="resultStatusKeys">not_used</@s.param>-->
<#--<@s.param name="resultColumn">not_used</@s.param>-->
</@s.action>
<div id="tagTree">
${resTags.treeHtml}
</div>
<div id="tagDialog" style="display: none"></div>
<script type="text/javascript">
    $(function () {
        $('#tagTree>ul').tree({
            expanded:'>li'
        });

        $('#tagTree ul li a').each(function (index, item) {
//            var status = ($(this).data('status'));
            var dataRow = ($(this).data('json'));
            var level = ($(this).data('level'));
            var href = "#", text, cssClass, title, id;
            if (level == 0) {
                id = dataRow.cells['category_id'].value;
            <#--if (typeof id !== "undefined") {-->
            <#--&lt;#&ndash;href = '${base}/admin/content/tagcat/edit?id=' + id;&ndash;&gt;-->
            <#--text = dataRow.cells['category_name'].value;-->
            <#--} else {-->
            <#--//                    href = "#";-->
            <#--text = "未分类";-->
            <#--}-->
                text = dataRow.cells['category_name'].value
                cssClass = "fa fa-tags";
                title = "标签类别";
            } else {
                id = dataRow.cells['tag_id'].value;
                if (typeof id === "undefined") {
                    $(this).remove();
                    return;
                } else {
                    href = '${base}/admin/content/tag/edit?id=' + id;
                    text = "<span>" + dataRow.cells['tag_name'].value + "</span>";
                    cssClass = "fa fa-tag";
                    title = "标签";
                }
            }
            this.href = href;
//            $(this).html('<i class="' + cssClass + '" title="' + title + '"></i>' + text);
            $(this).html(text);
            $(this).addClass(cssClass);
            $(this).attr("data-dialog", "#tagDialog");
        });
    });
</script>