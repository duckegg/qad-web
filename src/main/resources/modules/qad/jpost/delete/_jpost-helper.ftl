<#--
********************************************************************************
@desc Helper functions
@author Leo Liao, 2013/04/30, created
********************************************************************************
-->
<#include "/library/ftl/lib-function.ftl" parse=true/>
<#assign postStatusCss={"wip":"warning","open":"important","closed":"inverse"}/>
<#function postCss status>
    <#if status?? >
        <#return postStatusCss[status?lower_case]!''>
    </#if>
</#function>

<#macro viewOnePost jpost containerId isThread=true type="detail" showReply=false>
<div class="media kui-toolbar-container">
    <#assign _canUpdate=permissionResolver.allow("perm_"+postType+"_update","${jpost.id}","${jpost.id}")/>
    <#assign _canDelete=permissionResolver.allow("perm_"+postType+"_delete","${jpost.id}","${jpost.id}")/>
    <a class="pull-left" href="#">
        <#assign avatarFile = ''/>
        <#if jpost.createdUser??><#assign avatarFile=jpost.createdUser.avatar!''/></#if>
        <@userAvatar avatarFile=avatarFile cssClass="avatar middle"/>
    </a>

    <div class="media-body">
        <div class="media-heading">
            <#if isThread>
                <h3>
                    <#if type=="summary">
                        <a href="${base}/jpost/${postType}/view?id=${jpost.id}"
                           data-dialog data-dialog-title="&nbsp;"
                           data-dialog-aftersubmit="refreshPageList()"
                           data-dialog-resizable="true"
                           data-dialog-modal="false">
                            <span id="blt${jpost.id}">${(jpost.title!'')?html}</span></a>
                    <#else>
                    ${jpost.title!""}
                    </#if>
                </h3>
            </#if>
            <@_postMetaInfo jpost=jpost type=type pageId=containerId/>
        </div>
        <#if type=="summary">
            <div class="btn-toolbar" style="display:none">
                <input type="checkbox" name="id" class="checkbox"
                       <#if !_canDelete>disabled="disabled"</#if>
                       value="${jpost.id}"/>
                <a href="${base}/jpost/${postType}/update?id=${jpost.id}"
                   title="<#if !_canUpdate>无权</#if>修改"
                   <#if !_canUpdate>disabled="disabled"</#if>
                   data-dialog
                   data-dialog-aftersubmit="refreshPageList()">
                    <i class="fa fa-edit"></i>
                </a>
                <a href="${base}/jpost/${postType}/delete?id=${jpost.id}"
                   title="<#if !_canDelete>无权</#if>删除"
                   <#if !_canDelete>disabled="disabled"</#if>
                   data-dialog
                   data-dialog-aftersubmit="refreshPageList()">
                    <i class="fa fa-remove"></i>
                </a>
            </div>
        </#if>
        <p>${cleanHtml(jpost.content!"")}</p>
    </div>
</div>
</#macro>

<#macro _postMetaInfo jpost type pageId>
<div class="metadata row-fluid">
    <ul class="unstyled inline pull-left">
        <li>
            <#if jpost.createdUser??><a href="#">${jpost.createdUser.fullName!""}</a></#if>
        ${jpost.createdAt?date!""}
        </li>
        <#if type!="summary">
            <li>
                <a href="${base}/jpost/${postType}/update?id=${jpost.id}" class=""
                   <#if !_canUpdate>disabled="disabled" title="没有编辑权限"</#if>
                   data-ajax-link data-kui-target="#${pageId}">
                    <i class="fa fa-edit"></i> 编辑</a>
                <#if jpost.isThread()>
                    <a onclick="$('.js-jpost-reply','#${pageId}').toggle()"
                        <#if !jpost.isReplyEnabled()>
                       class="disabled" title="作者关闭了回复功能"
                        <#else>
                       <@shiro.guest>class="disabled" title="登录后才可以回复"</@shiro.guest>
                        </#if>><i
                            class="fa fa-share"></i> 回复</a>
                </#if>
            </li>
        </#if>
    </ul>
    <ul class="unstyled inline tags pull-right">
        <li>
            <#if (jpost.tagLabels?size > 0)>
                <#list jpost.tagLabels as tagLabel>
                    <span class="label label-tag"><i class="fa fa-tag"></i> ${tagLabel}</span>
                </#list>
            </#if>
            <#if jpost.isThread() && jpost.status?? >
                <span class="js-jpost-${jpost.id}-status"><span
                        class="label label-${postCss(jpost.status)}">${jpost.status}</span></span>
            </#if>
        </li>
    </ul>
</div>
</#macro>

<#--
 @param jpost an existing jpost instance
-->
<#macro postStatusSwitcher jpost>
    <#if (jpost.postType.allowedStatuses?size >0 ) >
        <#assign formId="jpost-${jpost.id}-status-changer" />
    <form action="${base}/jpost/${postType}/execute" method="POST" class="form-inline"
          id="${formId}"
          data-ajax-form data-kui-target=".js-jpost-${jpost.id}-status">
        <@s.hidden name="id" value="${jpost.id}"/>
        <@s.select name="jpost.status" list="jpost.postType.allowedStatuses" value="jpost.status" cssClass="select2" cssStyle="width:6em;" onchange="$('#${formId}').trigger('submit');"/>
    </form>
    </#if>
</#macro>