<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="sysparam-update"/>
<@ui.page id=pageId title="修改系统参数" class="webform">
<form action="${base}/admin/config/${moduleName}/settings/update_do" method="POST" class="form-vertical"
      data-ajax-form data-kui-target="#${pageId}">
    <@s.hidden name="sysParam.name"/>
    <@ui.text label="参数名">${sysParam.name!''}</@ui.text>
    <@ui.textarea label="参数值" name="sysParam.value"/>
    <@ui.textarea label="说明" name="sysParam.description"/>
    <@ui.buttonGroup>
        <@ui.button class="btn-primary"><i class="fa fa-ok"></i> 保存</@ui.button>
        <@ui.button type="reset"><i class="fa fa-remove"></i> 取消</@ui.button>
    </@ui.buttonGroup>
</form>
</@ui.page>
