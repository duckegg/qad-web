<#--
********************************************************************************
@desc Page to list jpost.
@author tom, 2012/07/12, created
@author Leo Liao, 2012/04/12, rewrite
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/library/ftl/lib-function.ftl" parse=true/>
<#include "post-helper.ftl" parse=true/>
<#assign pageId="jpost-list"/>
<@ui.page id=pageId title="系统公告">
    <#assign sortCss="fa-angle-up"/>
    <#if so.dir=="desc">
        <#assign sortCss="fa-angle-down"/>
    </#if>
<form id="jpost-qform" action="${base}/jpost/${postType}/list?style=fancy" method="get"
      style="display:none" class="form-inline" data-ajax-form data-kui-target="#${pageId}">
    <input type="text" name="so.size" value="${so.size}" title="页数"/>
    <input type="text" name="so.page" value="${so.page}" title="每页数量"/>
    <input type="text" name="so.sort" value="${so.sort}" title="排列字段"/>
    <input type="text" name="so.dir" value="${so.dir}" title="排列顺序"/>
    <input type="text" name="so.tags" value="${so.tags}" title="标签"/>
    <button type="submit" class="btn btn-default">刷新</button>
</form>
<#--<div class="row">-->
<#--<div class="col-md-10">-->
<form action="${base}/jpost/${postType}/delete" id="jpost-list-batch-form" method="post"
      data-ajax-form data-kui-target="#jpost-list"
      data-dialog data-dialog-aftersubmit="refreshPageList()">
    <div class="panel panel-default">
        <div class="panel-heading clearfix">
            <div class="btn-group btn-group-sm pull-right">
                <a class="btn btn-default" data-kui-sort-by="updatedAt"
                   href="${base}/jpost/${postType}/list?style=fancy&so.page=${so.page}&so.size=${so.size}&so.sort=updatedAt&so.dir=${iif(so.dir=='asc','desc','asc')}&so.tags=${so.tags}">
                    <i class="fa"></i> 按日期</a>
                <a class="btn btn-default" data-kui-sort-by="updatedBy"
                   href="${base}/jpost/${postType}/list?style=fancy&so.page=${so.page}&so.size=${so.size}&so.sort=updatedBy&so.dir=${iif(so.dir=='asc','desc','asc')}&so.tags=${so.tags}">
                    <i class="fa"></i> 按作者</a>
            </div>
            <div class="btn-group btn-group-sm">
                <a class="btn btn-default" href="${base}/jpost/${postType}/create"
                   data-dialog data-dialog-aftersubmit="refreshPageList()">
                    <i class="fa fa-plus"></i> 新建</a>
                <button type="submit" id="toolbarDelete" class="btn btn-default">
                    <i class=" fa fa-times"></i> 删除
                </button>
            </div>
        </div>
        <div class="panel-body">
            <ul class="list-group">
                <#list jposts as jpost>
                    <li class="list-group-item" id="jpost-${jpost.id}">
                        <@viewOnePost jpost=jpost type="summary" containerId="jpost-${jpost.id}"/>
                    </li>
                </#list>
            </ul>
        </div>
        <div class="panel-footer small clearfix">
            <div class="pull-right">共${so.totalRecords}条</div>
            <@ui.pagination size=so.size records=so.totalRecords current=so.page link="${base}/jpost/${postType}/list?style=fancy&so.page=[page]&so.size=${so.size}&so.sort=${so.sort}&so.dir=${so.dir}&so.tags=${so.tags}"/>
        </div>
    </div>
</form>
<#--</div>-->
<#--<div class="col-md-2">-->
<#--<ul class="list-unstyled list-inline tags">-->
<#--<li>-->
<#--<a class="label label-tag"-->
<#--href="${base}/jpost/${postType}/list?style=fancy&so.page=${so.page}&so.size=${so.size}&so.sort=${so.sort}&so.dir=${so.dir}">-->
<#--<i class="fa fa-tags"></i> 所有</a>-->
<#--</li>-->
<#--<#list tagFilters as tag>-->
<#--<li>-->
<#--<a class="label label-tag"-->
<#--href="${base}/jpost/${postType}/list?style=fancy&so.page=1&so.size=${so.size}&so.sort=${so.sort}&so.dir=${so.dir}&so.tags=${tag.categoryDomain}:${tag.label}">-->
<#--<i class="fa fa-tag"></i> ${tag.label}</a>-->
<#--</li>-->
<#--</#list>-->
<#--</ul>-->
<#--</div>-->
<#--</div>-->
<script type="text/javascript">
    function refreshPageList() {
        $('#jpost-qform').trigger('submit');
    }

    $(function () {
        var $page = $('#${pageId}');
        var $form = $('#jpost-list-batch-form');
        $form.on('click', ':checkbox', function () {
            if ($(':checked', $form).length == 0) {
                $('#toolbarDelete').attr('disabled', 'disabled').hide();
            } else {
                $('#toolbarDelete').removeAttr('disabled').show();
            }
        });
        $('[data-kui-sort-by="${so.sort}"] .fa', $page).addClass("${sortCss}");

        $('.btn-toolbar',$page).on('click', ':checkbox', function () {
            $(this).closest('.list-group-item').toggleClass('kui-with-selected');
        });
    });
</script>
</@ui.page>