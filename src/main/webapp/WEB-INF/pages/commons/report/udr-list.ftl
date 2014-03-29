<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-2, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "udr-lib.ftl" parse=true/>
<#assign pageId="udr-list"/>
<@ui.page id=pageId title="用户定义报表">
<div class="form-group">
    <a href="${base}/udr/create" class="btn btn-info">新建</a>
</div>
<div class="list-group">
    <#list reportList as report>
        <div class="list-group-item">
            <h3 class="list-group-item-heading">${report.title}</h3>
            <#if report.createdUser??>
                <ul class="list-unstyled list-inline">
                    <li><a data-kui-dialog
                           href="${base}/user/view/${report.createdUser.id}">${(report.createdUser.fullName)!''}</a>
                    </li>
                    <li>${(report.createdAt)!''}</li>
                </ul>
            </#if>
            <#if report.tagLabels?has_content>
                <ul class="list-unstyled list-inline kui-tag-list">
                    <#list report.tagLabels as tag>
                        <li><a href="${base}/udr/tags/${tag}">${tag}</a></li>
                    </#list>
                </ul>
            </#if>

            <div class="btn-toolbar">
                <div class="btn-group btn-group-sm">
                    <#list UDR_FORMATS?keys as format>
                        <#if report.display[format]?? && report.display[format]!=''>
                            <a class="btn btn-default"
                               href="${base}/udr/view/${report.id}/${format}">${UDR_FORMATS[format]}</a>
                        </#if>
                    </#list>
                </div>
                <div class="btn-group btn-group-sm">
                    <a href="${base}/udr/update?id=${report.id}"
                       class="btn btn-default">编辑</a>
                    <a href="${base}/udr/copy?id=${report.id}" data-kui-dialog
                       class="btn btn-default">复制</a>
                    <a href="${base}/udr/delete?id=${report.id}" data-kui-dialog
                       class="btn btn-default">删除</a>
                </div>
            </div>
        </div>
    </#list>
</div>
</@ui.page>
