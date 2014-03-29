<#--
********************************************************************************
@desc Page to edit tag.
@author Leo Liao, 2012/08/18, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/ui-builder.ftl" parse=true/>
<title><#if tag.id??>修改<#else>新建</#if>标签</title>
<div id="tag-edit" class="webform">
<@s.form id="editTagForm" action="/admin/content/tag/save?actionResult=defaultResult" cssClass="form-horizontal" theme="bootstrap">
    <fieldset>
        <legend>标签信息</legend>
        <@s.hidden name="tag.id"/>
        <@s.textfield name="tag.label" label="名称" cssClass="required" title="请设置标签名称" maxlength="60"/>
        <@labelControlGroup label="分类">
        <div class="form-group">
            <@s.select label="分类" key="tag.categoryDomain" list="categories" cssStyle="width:16em" theme="simple"/>
        </@labelControlGroup>
    </fieldset>
    <div class="form-actions">
        <#if tag.id??>
            <div style="float:left">
                <a href="${base}/admin/content/tag/delete?id=${tag.id}&actionResult=defaultResult"
                   class="btn btn-danger jsActionDelTag" tabindex="-1"><i
                        class="fa fa-times"></i>
                    删除标签</a>
            </div>
        </#if>
        <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存</button>
        <button type="reset" class="btn btn-default">取消</button>
    </div>
</@s.form>
</div>
<script type="text/javascript">
    $(function () {
    <#-- Select -->
        var $select = $('#editTagForm :input[name="tag.categoryId"]');
    <#-- Edit Form -->
        var $formObj = $('#editTagForm');
        $formObj.kuiAjaxForm();
    <#-- Delete -->
        $('.jsActionDelTag').click(function (o) {
            var conf = confirm("删除标签请务必小心！\n" +
                    "标签删除后，系统中被该标签限制的内容将 *无法* 访问。请事先与熟悉系统标签设置的开发人员联系。\n" +
                    "你还坚持要删除该标签吗？");
            if (conf == true) {
                setFormSubmited(true);
                $(this).parents("div.webform:first").parent().first().load(this.href);
            }
            return false;
        });
    });
</script>