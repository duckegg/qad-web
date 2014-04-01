<#--
********************************************************************************
@desc Page to list jpost.
@author tom, 2012/07/12, created
@author Leo Liao, 2012/04/12, rewrite
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/functions.ftl" parse=true/>
<#include "_jpost-helper.ftl" parse=true/>
<#assign pageId="jpost-list"/>
<@ui.page id=pageId>
<form id="jpost-qform" action="${base}/jpost/${postType}/list?style=fancy" method="get"
      style="display:none" class="form-inline" data-ajax-form data-kui-target="#${pageId}">
    <input type="text" name="so.size" value="${so.size}" title="页数"/>
    <input type="text" name="so.page" value="${so.page}" title="每页数量"/>
    <input type="text" name="so.sort" value="${so.sort}" title="排列字段"/>
    <input type="text" name="so.dir" value="${so.dir}" title="排列顺序"/>
    <input type="text" name="so.tags" value="${so.tags}" title="标签"/>
    <button type="submit" class="btn">刷新</button>
</form>
<div class="row-fluid">
    <div class="span10">
        <form action="${base}/jpost/${postType}/delete" id="jpost-list-batch-form" method="post"
              data-ajax-form data-kui-target="#jpost-list"
              data-dialog data-dialog-aftersubmit="refreshPageList()">
            <div class="mybox">
                <div class="mybox-header">
                    <div class="btn-toolbar pull-left">
                        <#if permissionResolver.allow("perm_"+postType+"_create")>
                            <a class="btn" href="${base}/jpost/${postType}/create"
                               data-dialog data-dialog-aftersubmit="refreshPageList()">
                                <i class="fa fa-plus"></i> 新建</a>
                        </#if>
                        <button type="submit" id="toolbarDelete" class="btn"
                                disabled="disabled" style="display: none"><i
                                class=" fa fa-times"></i> 删除
                        </button>
                    </div>
                    <ul class="unstyled inline sorts pull-right">
                        <li data-sort="updatedAt">
                            <a href="${base}/jpost/${postType}/list?style=fancy&so.page=${so.page}&so.size=${so.size}&so.sort=updatedAt&so.dir=${iif(so.dir=='asc','desc','asc')}&so.tags=${so.tags}">按日期</a>
                        </li>
                        <li data-sort="updatedBy">
                            <a href="${base}/jpost/${postType}/list?style=fancy&so.page=${so.page}&so.size=${so.size}&so.sort=updatedBy&so.dir=${iif(so.dir=='asc','desc','asc')}&so.tags=${so.tags}">按作者</a>
                        </li>
                    </ul>
                </div>
                <div class="mybox-content">
                    <@ui.pagination size=so.size records=so.totalRecords current=so.page link="${base}/jpost/${postType}/list?style=fancy&so.page=[page]&so.size=${so.size}&so.sort=${so.sort}&so.dir=${so.dir}&so.tags=${so.tags}"/>
                    <ul class="listing-vertical listing-bordered">
                        <#list jposts as jpost>
                            <li class="with-padding" id="jpost-${jpost.id}">
                                <@viewOnePost jpost=jpost type="summary" containerId="jpost-${jpost.id}"/>
                            </li>
                        </#list>
                    </ul>
                </div>
                <div class="mybox-footer">共${so.totalRecords}条</div>
            </div>
        </form>
    </div>
    <div class="span2">
        <ul class="unstyled inline tags">
            <li>
                <a class="label label-tag"
                   href="${base}/jpost/${postType}/list?style=fancy&so.page=${so.page}&so.size=${so.size}&so.sort=${so.sort}&so.dir=${so.dir}">
                    <i class="fa fa-tags"></i> 所有</a>
            </li>
            <#list tagFilters as tag>
                <li>
                    <a class="label label-tag"
                       href="${base}/jpost/${postType}/list?style=fancy&so.page=1&so.size=${so.size}&so.sort=${so.sort}&so.dir=${so.dir}&so.tags=${tag.categoryDomain}:${tag.label}">
                        <i class="fa fa-tag"></i> ${tag.label}</a>
                </li>
            </#list>
        </ul>
    </div>
</div>
<script type="text/javascript">
    function refreshPageList() {
        $('#jpost-qform').trigger('submit');
    }

    $(function () {
        var $form = $('#jpost-list-batch-form');
        $form.on('click', ':checkbox', function () {
            if ($(':checked', $form).length == 0) {
                $('#toolbarDelete').attr('disabled', 'disabled').hide();
            } else {
                $('#toolbarDelete').removeAttr('disabled').show();
            }
        });
        $('ul.sorts li[data-sort="${so.sort}"]').toggleClass("${so.dir}", true);

        $('.toolbar-inline').on('click', ':checkbox', function () {
            $(this).closest('.media').toggleClass('selected');
        });
    <#-- Inline toobar -->
        $('.kui-toolbar-container').on({mouseenter: function () {
            $(this).find('.toolbar-inline').show();
        }, mouseleave: function () {
            $(this).find('.toolbar-inline').hide();
        }});
    });
</script>
</@ui.page>