<#--
********************************************************************************
@desc Page to import CI type.
@author Leo Liao, 2013/12/6, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/library/ftl/lib-function.ftl" parse=true/>
<#assign pageId="datex-imp"/>
<@ui.page id=pageId class="webform" title="导入CI类型">
    <@ui.strutsErrors/>
<form id="${pageId}-form"
      action="${base}/datex/imp_do" enctype="multipart/form-data"
      class="form-vertical" method="post" data-confirm="确认导入吗？" data-form-validate="true"
      data-ajax-form data-kui-target="#${pageId}">

    <#assign uploadOptions={'file':'上传文件','string':'直接粘贴内容'}/>
    <input type="hidden" name="importSource" value="${importSource!''}"
           id="${pageId}-import-source">

    <@ui.labelControlGroup label="导入方式">
        <@ui.ajaxNav target="#${pageId}-nav-target" class="nav-pills">
            <#list uploadOptions?keys as key>
                <li<#if (importSource!'string')==key> class="active"</#if>><a
                        href="#${pageId}-upload-${key}" data-toggle="tab"
                        onclick="$('#${pageId}-import-source').val('${key}');">${uploadOptions[key]}</a>
                </li>
            </#list>
        </@ui.ajaxNav>
    </@ui.labelControlGroup>
    <div class="tab-content" id="${pageId}-nav-target">
        <div id="${pageId}-upload-file" class="tab-pane well">
            <@s.file name="sourceFile" theme="simple" cssClass="required"/>
            <div class="help-block">请选择要导入的文件，如果文件内容包含中文，必须是UTF-8格式。</div>
        </div>
        <div id="${pageId}-upload-string" class="tab-pane well">
            <@ui.textarea name="sourceString" placeholder="请直接将要导入的内容填写在这里" class="required"
                      style="width:100%;"/>
        </div>
    </div>
    <#assign formatOptions={'csv':'字段用逗号分隔，内容用引号包围 <strong>从Excel保存的CSV为此格式</strong>','tsv':'字段用Tab分隔，内容无引号 <strong>从Excel直接复制为此格式</strong>'}/>
    <@ui.labelControlGroup label="内容格式">
        <#list formatOptions?keys as key>
            <label class="radio">
                <input type="radio" name="sourceFormat" value="${key}"
                       <#if (sourceFormat!'')==key>checked="checked"</#if>>${formatOptions[key]}
            </label>
        </#list>
    </@ui.labelControlGroup>
    <div class="form-actions">
        <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 开始导入</button>
        <button type="reset" class="btn btn-default">取消</button>
    </div>
</form>
</@ui.page>