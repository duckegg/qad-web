<#--
********************************************************************************
@desc Page to view.
@author Leo Liao, 2012/06/12, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "post-helper.ftl" parse=true/>
<#assign pageId="jpost-view-${jpost.id}"/>
<@ui.page id=pageId class="media" title="查看${postType}">
    <#assign _canUpdate=permissionResolver.allow("perm_"+postType+"_update")/>
    <@viewOnePost jpost=jpost isThread=true containerId=pageId/>
    <#if jpost.isReplyEnabled()>
        <@shiro.user>
        <div class="js-jpost-reply" style="display: none">
            <#if permissionResolver.allow("perm_"+postType+"_update_status")>
                <@postStatusSwitcher jpost/>
            </#if>
            <form action="${base}/jpost/${postType}/reply_do" id="jpost-view-form"
                  class="form-vertical"
                  method="post" data-ajax-form data-kui-target="#${pageId}">
                <fieldset>
                    <input type="hidden" name="reply.parentId" value="${jpost.id}"/>
                    <@ui.textarea name="reply.content" required=true></@ui.textarea>
                </fieldset>

                <@ui.buttonGroup>
                    <@ui.button type="submit" class="btn-primary" name="subact" value="[reply]" label="回复"/>
                    <@ui.button type="reset" class="btn btn-default" label="取消"/>
                </@ui.buttonGroup>
            </form>
        </div>
        </@shiro.user>
    </#if>
    <#if (jpost.replies?size > 0) >
    <div class="media">
        <h3>回复</h3>

        <div id="jpost-replies" class="media-list" style="padding-left:60px">
            <#list jpost.replies as reply>
                <div id="reply-${reply.id}">
                    <@viewOnePost jpost=reply isThread=false showReply=true containerId="${pageId}"/>
                </div>
                <hr>
            </#list>
        </div>
    </div>
    </#if>
</@ui.page>