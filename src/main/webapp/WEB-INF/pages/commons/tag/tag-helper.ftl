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
<#--<#include "/library/taglibs.ftl" parse=true/>-->
<#--
@desc A auto-complete tagging control
@param tagCategory: category of tag
@param controlName: HTML control name
@param id: HTML control ID
@param selectedValue: a sequence of string, or comma separated string
-->
<#macro tagging tagCategory controlName selectedValues id label="" style="width:100%" class="">
    <#assign valueSequence=[]/>
    <#if selectedValues?is_sequence>
        <#assign valueSequence=selectedValues/>
    <#else>
        <#assign valueSequence=selectedValues?split(",")/>
    </#if>
    <#assign valueString=valueSequence?join(",")/>
    <@s.action name="utils/tag/controls" namespace="/" var="tagAction" executeResult=false rethrowException=true ignoreContextParams=true>
        <@s.param name="category" value="%{'${tagCategory}'}"/>
    </@s.action>
    <#assign _freeInput=false/>
    <#if tagAction.ciType??><#assign _freeInput=tagAction.ciType.isTagEditable()/></#if>
<div class="form-group" id="${id}">
    <label class="control-label"><#if label!="">${label}:</#if></label>
    <#if !_freeInput>
        <a href="#${id}-help" data-kui-dialog="#${id}-help"><i class="fa fa-info"></i></a>

        <div id="${id}-help" style="display: none">
            这类标签不能自由编辑，如果找不到你所需要的标签，请联系管理员添加。
        </div>
    </#if>

    <div class="controls">
        <#if _freeInput>
            <input type="text" value="${valueString}"
                   placeholder="请选择或输入标签"
                   class="${class} js-select2-control" style="${style}"/>

            <div class="js-select2-submit">
                <#list valueSequence as value>
                    <input type="hidden" name="${controlName}" value="${value}"/>
                </#list>
            </div>
        <#else>
            <select name="${controlName}" class="${class} js-select2-control" style="${style}"
                    data-placeholder="选择标签"
                    multiple="multiple">
                <#list tagAction.tags as tag>
                    <option value="${tag.label}"
                            <#if valueSequence?seq_contains(tag.label)>selected="selected"</#if>>${tag.label}</option>
                </#list>
            </select>
        </#if>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        var $control = $('.js-select2-control', '#${id}');
        <#if _freeInput>
            $control.select2({
                <#assign allTags=""/>
                <#list tagAction.tags as tag>
                    <#assign allTags=allTags+'"'+tag.label+'"'/>
                    <#if tag_has_next>
                        <#assign allTags = allTags+","/>
                    </#if>
                </#list>
                tags: [${allTags}],
                maximumInputLength: 10,
                tokenSeparators: [",", " "]
            });
            var $submit = $('.js-select2-submit', '#${id}');
            var resetSubmit = function (e) {
                $submit.empty();
                var values = e.val;
                for (var i = 0; i < values.length; i++) {
                    $submit.append('<input type="hidden" name="${controlName}" value="' + values[i] + '"/>');
                }
            };
            $control.on("change", resetSubmit);
        <#else>
            $control.select2();
        </#if>
    });
</script>
</#macro>

<#macro listCustomer controlName selectedValues="" label="" style="" class="">
    <#assign _currentCustomer=customer!''/>
    <@s.action name="customer/list" namespace="/" var="custListAction" executeResult=false rethrowException=true ignoreContextParams=true>
    </@s.action>
    <#assign values=selectedValues?eval/>
<div class="form-group">
    <label class="control-label"><#if label!="">${label}:</#if></label>

    <div class="controls">
        <#if style=="select">
            <select name="${controlName}" multiple="multiple" <#if class!="">class="${class}"</#if>>
                <#list custListAction.customers as cust>
                    <option value="${cust.keyword}"
                            <#if values?seq_contains(cust.keyword)>selected="selected"</#if>>${cust.name}</option>
                </#list>
            </select>
        <#else>
            <#list custListAction.customers as cust>
                <label class="checkbox-inline"><input type="checkbox" name="${controlName}"
                                                      value="${cust.keyword}"
                                                      <#if values?seq_contains(cust.keyword) || cust.keyword==_currentCustomer>checked="checked"</#if>
                                                      <#if cust.keyword==_currentCustomer>style="display:none"</#if>/>
                    <#if cust.keyword==_currentCustomer>
                        <strong>${cust.name}</strong><#else>${cust.name}</#if>
                </label>
            </#list>
        </#if>
    </div>
</div>
</#macro>