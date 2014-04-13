<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-3, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udr-copy"/>
<@ui.page id=pageId title="复制">
<form action="${base}/udr/copy_do" method="post" data-kui-ajax-form data-kui-target="#${pageId}">
    <input type="hidden" name="id" value="${id}"/>
    <@ui.textfield label="标题" name="title" value="${userDefinedReport.title}"/>
    <@ui.buttonGroup>
        <button type="reset" class="btn btn-default">取消</button>
        <button type="submit" class="btn btn-primary">复制</button>
    </@ui.buttonGroup>
</form>
</@ui.page>