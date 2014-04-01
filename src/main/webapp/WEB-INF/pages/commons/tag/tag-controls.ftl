<#--
********************************************************************************
@desc tag list control

*****ATTENTION_BY_LEO*****
Calling multiple s.action in the same context, the parameters in previous action will propagate to next action.
For example, if calling listCustomer from drill-edit, the {function} parameter is edit(in drill), not list (in customer)
We have to set ignoreContextParams=true to avoid it.

@author Leo Liao, 2012/08/18, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#--
================================================================================
@desc Build tagging control with select2
@param allowInput boolean, true(default) - user can input tag, false - user can only select
================================================================================
-->
<#macro tagging tagCategory controlName selectedValues id label="" style="width:400px" class="" allowInput=true>
    <@s.action name="utils/tag/controls" namespace="/" var="tagAction" executeResult=false rethrowException=true ignoreContextParams=true>
        <@s.param name="category" value="%{'${tagCategory}'}"/>
    </@s.action>
<#--<#assign allowInput=false/>-->
<#--<#if tagAction.ciType??><#assign _editable=tagAction.ciType.isTagEditable()/></#if>-->
<div class="form-group">
    <label class="control-label"><#if label!="">${label}:</#if></label>

    <div class="controls">
        <#if allowInput>
            <#assign allTags=""/>
            <#list tagAction.tags as tag>
                <#assign allTags=allTags+'"'+tag.label+'"'/>
                <#if tag_has_next>
                    <#assign allTags = allTags+","/>
                </#if>
            </#list>
            <#assign allTags="["+allTags+"]"/>
            <input type="text" id="${id}" name="${controlName}" value="${selectedValues}"
                   placeholder="请选择或输入标签"
                   class="${class}" style="${style}"/>
        <#else>
            <#assign _seqValues=selectedValues?split(",")/>
            <select id="${id}" name="${controlName}" value="${selectedValues}" class="${class}"
                    style="${style}" multiple="multiple" placeholder="请选择标签">
                <#list tagAction.tags as tag>
                    <option value="${tag.label}"
                            <#if _seqValues?seq_contains(tag.label)>selected="selected"</#if>>${tag.label}</option>
                </#list>
            </select> <a href="#${id}-help" data-dialog="#${id}-help"><i class="fa fa-info"></i></a>

            <div id="${id}-help" style="display: none">
                这类标签不能自由编辑，如果找不到你所需要的标签，请联系管理员添加。
            </div>
        </#if>
    </div>
</div>
<script type="text/javascript">
    $('#${id}').select2({
        <#if allowInput>
            tags: ${allTags},
            maximumInputLength: 10,
            tokenSeparators: [",", " "]
        </#if>
    });
</script>
</#macro>
<#--
================================================================================
@desc Build a customer selection list.
================================================================================
-->
<#macro listCustomer controlName selectedValues="" label="" style="" class="">
    <#assign _currentCustomer=customer!''/>
    <@s.action name="customer/list" namespace="/" var="custListAction" executeResult=false rethrowException=true ignoreContextParams=true>
    </@s.action>
    <#if selectedValues?is_sequence>
        <#assign sequenceValues=selectedValues/>
    <#else>
        <#assign sequenceValues=selectedValues?eval/>
    </#if>
<div class="form-group">
    <label class="control-label"><#if label!="">${label}:</#if></label>

    <div class="controls">
        <#if style=="select">
            <select name="${controlName}" multiple="multiple" <#if class!="">class="${class}"</#if>>
                <#list custListAction.customers as cust>
                    <option value="${cust.keyword}"
                            <#if sequenceValues?seq_contains(cust.keyword)>selected="selected"</#if>>${cust.name}</option>
                </#list>
            </select>
        <#else>
            <#list custListAction.customers as cust>
                <label class="checkbox-inline"><input type="checkbox" name="${controlName}"
                                                      value="${cust.keyword}"
                                                      <#if sequenceValues?seq_contains(cust.keyword) || cust.keyword==_currentCustomer>checked="checked"</#if>
                                                      <#if cust.keyword==_currentCustomer>style="display:none"</#if>/>
                    <#if cust.keyword==_currentCustomer>
                        <strong>${cust.name}</strong><#else>${cust.name}</#if>
                </label>
            </#list>
        </#if>
    </div>
</div>
</#macro>