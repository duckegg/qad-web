<#--
********************************************************************************
@desc page to edit jpost
@author Leo Liao, 2012/05/06, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/functions.ftl" parse=true/>
<#include "post-helper.ftl" parse=true/>
<#include "/WEB-INF/pages/commons/tag/tag-helper.ftl" parse=true/>
<#assign pageId="jpost-edit"/>
<@ui.page id=pageId class="webform">
<form id="jpost-edit-form" method="post"
      action="${base}/jpost/${postType}/${iif(jpost.id??,'update_do','create_do')}"
      data-ajax-form data-kui-target="#jpost-edit">
    <fieldset>
        <input type="hidden" name="subact" value="[save_all]"/>
        <input type="hidden" name="id" value="${jpost.id!""}"/>
        <input type="hidden" name="jpost.id" value="${jpost.id!""}"/>
        <input type="hidden" name="jpost.parentId" value="${jpost.parentId!""}"/>
        <#if jpost.isThread()>
        <@s.textfield id="title" name="jpost.title" label="标题" cssClass="required" title="请输入标题" maxlength="100" required="true"/>
        </#if>
        <@s.textarea id="content" name="jpost.content" label="正文" cssClass="required" title="请输入详细内容" style="height:15em" maxlength="1024" required="true"/>
        <@ui.labelControlGroup>
            <#if jpost.postType.isReplyEnabled() && jpost.isThread()>
                <label class="checkbox-inline">
                    <input type="checkbox" name="jpost.enableReply" value="1"
                           <#if jpost.isReplyEnabled()>checked="checked"</#if>/>允许回复</label>
            <#else>
            </#if>
        </@ui.labelControlGroup>
        <#assign tagLabelString=colToString(jpost.tagLabels)/>
        <#--<@tagging id="jpost-edit-tagging" label="标签" tagCategory="${postType}" controlName="jpost.tagLabelString" selectedValues="${tagLabelString}"/>-->
        <#if jpost.isThread()>
            <@s.select label="状态" name="jpost.status" list="jpost.postType.allowedStatuses" value="jpost.status" cssClass="select2"
            cssStyle="width:6em;"/>
        </#if>
    </fieldset>

    <@ui.buttonGroup>
        <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 提交</button>
        <button type="reset" class="btn btn-default">取消</button>
    </@ui.buttonGroup>
</form>
</@ui.page>