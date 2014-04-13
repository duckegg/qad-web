<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-3, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udr-delete"/>
<@ui.page id=pageId title="删除">
<form action="${base}/udr/delete_do" method="post" data-kui-ajax-form data-kui-target="#${pageId}">
    <input type="hidden" name="id" value="${id}"/>
    <div class="alert alert-danger">确定删除 ${userDefinedReport.title} 吗？</div>
    <@ui.buttonGroup>
        <button type="reset" class="btn btn-default">取消</button>
        <button type="submit" class="btn btn-danger">删除</button>
    </@ui.buttonGroup>
</form>
</@ui.page>