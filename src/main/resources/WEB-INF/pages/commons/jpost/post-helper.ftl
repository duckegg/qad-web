<#--
********************************************************************************
@desc Helper functions
@author Leo Liao, 2013/04/30, created
********************************************************************************
-->
<#include "/library/functions.ftl" parse=true/>
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
<#--<a href="${base}/jpost/${postType}/view?id=${jpost.id}"-->
<#--class="kui-click-target"-->
<#--data-kui-dialog data-kui-dialog-title="&nbsp;"-->
<#--data-kui-dialog-aftersubmit="refreshPageList()"-->
<#--data-kui-dialog-resizable="true"-->
<#--data-kui-dialog-modal="false"></a>-->
    <a class="pull-left" href="#">
        <#assign avatarFile = ''/>
        <#if jpost.createdUser??><#assign avatarFile=jpost.createdUser.avatar!''/></#if>
        <@userAvatar avatarFile=avatarFile cssClass="avatar middle"/>
    </a>

    <div class="media-body">
        <div class="media-heading">
            <#if isThread>
                <#if jpost.status?? >
                    <span class="js-jpost-${jpost.id}-status label label-default kui-label-${jpost.status} pull-right">${jpost.status}</span>
                </#if>
                <h3>
                    <#if type=="summary">
                        <a href="${base}/jpost/${postType}/view?id=${jpost.id}"
                           data-kui-dialog data-kui-dialog-title="&nbsp;"
                           data-kui-dialog-aftersubmit="refreshPageList()"
                           data-kui-dialog-resizable="true"
                           data-kui-dialog-modal="false">
                            <span id="blt${jpost.id}">${(jpost.title!'')?html}</span></a>
                    <#else>
                    ${jpost.title!""}
                    </#if>
                </h3>
            </#if>
            <@_postMetaInfo jpost=jpost type=type pageId=containerId/>
        </div>
        <#if type=="summary">
            <div class="btn-toolbar kui-hover-toolbar" style="display: none">
                <div class="btn-group" adata-toggle="buttons">
                    <label class="btn btn-default">
                        <input type="checkbox" name="id" value="${jpost.id}"
                               <#if !_canDelete>disabled="disabled"</#if>/></label>
                    <a class="btn btn-default"
                       href="${base}/jpost/${postType}/update?id=${jpost.id}"
                       title="<#if !_canUpdate>无权</#if>修改"
                       <#if !_canUpdate>disabled="disabled"</#if>
                       data-kui-dialog
                       data-kui-dialog-aftersubmit="refreshPageList()">
                        <i class="fa fa-pencil"></i>
                    </a>
                    <a class="btn btn-default"
                       href="${base}/jpost/${postType}/delete?id=${jpost.id}"
                       title="<#if !_canDelete>无权</#if>删除"
                       <#if !_canDelete>disabled="disabled"</#if>
                       data-kui-dialog
                       data-kui-dialog-aftersubmit="refreshPageList()">
                        <i class="fa fa-trash-o"></i>
                    </a>
                </div>
            </div>
        </#if>
        <p>${cleanHtml(jpost.content!"")}</p>
    </div>
    <div class="row js-media-tag-and-action">
        <div class="<#if type!="summary">col-md-6<#else>col-md-12</#if>">
            <#if (jpost.tagLabels?size > 0)>
                <ul class="list-unstyled list-inline kui-tag-list">
                    <li>
                        <#list jpost.tagLabels as tagLabel>
                            <a href="javascript:;">${tagLabel}</a>
                        </#list>
                    </li>
                </ul>
            </#if>
        </div>
        <#if type!="summary">
            <div class="col-md-6 text-right">
                <div class="btn-group btn-group-xs">
                    <a href="${base}/jpost/${postType}/update?id=${jpost.id}"
                       class="btn btn-default"
                       <#if !_canUpdate>disabled="disabled" title="没有编辑权限"</#if>
                       data-ajax-link data-kui-target="#${pageId}">
                        <i class="fa fa-edit"></i> 编辑</a>
                    <#if jpost.isThread()>
                        <a onclick="$('.js-jpost-reply','#${pageId}').toggle()"
                           class="btn btn-default"
                            <#if !jpost.isReplyEnabled()>
                           title="作者关闭了回复功能"
                            <#else>
                           <@shiro.guest>title="登录后才可以回复"</@shiro.guest>
                            </#if>><i
                                class="fa fa-share"></i> 回复</a>
                    </#if>
                </div>
            </div>
        </#if>
    </div>
</div>
</#macro>

<#macro _postMetaInfo jpost type pageId>
<div>
    <ul class="list-unstyled list-inline">
        <li>
            #${jpost.id} <#if jpost.createdUser??><a data-kui-dialog
                                        href="${base}/user/view/${jpost.createdUser.id}">${jpost.createdUser.fullName!""}</a></#if>
        ${jpost.createdAt!""}
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