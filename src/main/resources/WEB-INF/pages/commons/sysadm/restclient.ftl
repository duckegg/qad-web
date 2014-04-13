<#--
********************************************************************************
@desc a REST client
@author Leo Liao, 13-5-13, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>

<@ui.page id="restclient" title="REST Client" class="webform">
<form action="${base}/admin/devel/restclient" class="form-horizontal" data-ajax-form
      data-kui-target="#restclient" data-ajax-result="replace">
    <@s.textfield name="restServer" label="Server"/>
    <@s.textfield name="restPath" label="Path"/>
    <@s.textfield name="restMethod" label="Method"/>
    <@s.textarea name="restParameter" label="Parameter"/>
<#--<@s.select name="restMethod" list=["GET","PUT","POST","DELETE"]/>-->
    <@ui.buttonGroup>
        <button type="submit" class="btn btn-primary">Submit</button>
    </@ui.buttonGroup>
</form>
<div>
    <#if restResponse??>
        <pre>${restResponse}</pre>
    </#if>
</div>
</@ui.page>
