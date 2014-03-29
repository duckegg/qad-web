<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/WEB-INF/pages/commons/tag/tag-helper.ftl" parse=true/>
<#include "udr-lib.ftl" parse=true/>
<#assign pageId="udr-edit"/>
<#assign isCreate=!userDefinedReport.id??/>
<@ui.page id=pageId title="自定义报告">
<div class="webform">
    <div id="testTabs"></div>
    <form id="${pageId}-form"
          action="${base}/udr/<#if isCreate>create_do<#else>update_do</#if>" method="post"
          method="post"
          data-kui-collapsible-form-options
          data-kui-ajax-form
          data-kui-ajax-form-serialize="fnValidateDisplayFormat()"
          data-kui-target="#${pageId}-ajax-result">
        <fieldset class="active">
            <legend>基本信息</legend>
            <input type="hidden" name="userDefinedReport.id" value="${userDefinedReport.id!''}"/>
            <@ui.textfield name="userDefinedReport.title" label="标题" class="required" maxlength="100" required=true  value="${userDefinedReport.title!''}"/>
            <@ui.textarea name="userDefinedReport.description" label="报表说明" class="required">${userDefinedReport.description!''}</@ui.textarea>
        <#--<@ui.textfield name="userDefinedReport.tagLabels" label="Tag"/>-->
            <@tagging id="udr-tags" tagCategory="report" controlName="userDefinedReport.tagLabels" label="Tag" selectedValues=userDefinedReport.tagLabels/>
        </fieldset>
        <fieldset>
            <legend>数据来源</legend>
            <@ui.textfield name="userDefinedReport.queryDef.dbConn" label="数据库连接" class="required" value="${(userDefinedReport.queryDef.dbConn)!''}"/>
            <@ui.textarea name="userDefinedReport.queryDef.sql" label="SQL语句" required=true size="large">${(userDefinedReport.queryDef.sql)!''}</@ui.textarea>
        </fieldset>
        <fieldset>
            <legend>展现格式</legend>
            <@ui.ajaxNav target="#${pageId}-display" class="nav-pills">
                <#list UDR_FORMATS?keys as key>
                    <li class="<#if key_index==0>active</#if>">
                        <a href="#${pageId}-display-${key}"
                           data-toggle="tabe">${UDR_FORMATS[key]}</a>
                    </li>
                </#list>
            </@ui.ajaxNav>
            <div class="tab-content" id="${pageId}-display">
                <#list UDR_FORMATS?keys as key>
                    <div id="${pageId}-display-${key}" class="tab-pane">
                        <div class="form-group">
                            <div class="clearfix" style="margin-bottom:0.5em;">
                                <a class="js-action-preview btn btn-info pull-right"
                                   data-value="${key}">预览
                                </a>
                            </div>
                            <@ui.textarea name="" class="form-control js-display-option" size="large"
                            dataAttribute='data-display-format="${key}"'>${toJson((userDefinedReport.display[key])!null,true)!''}</@ui.textarea>
                        </div>
                    </div>
                </#list>
            </div>
            <input type="hidden" name="userDefinedReport.displayJson" value=""/>
        </fieldset>
        <@ui.buttonGroup>
            <#if !isCreate>
                <div class="pull-left">
                    <a class="btn btn-default"
                       href="${base}/udr/copy?id=${userDefinedReport.id}"
                       data-kui-dialog>复制
                    </a>
                    <a class="btn btn-danger"
                       href="${base}/udr/delete?id=${userDefinedReport.id}"
                       data-kui-dialog>删除
                    </a>
                </div>
            </#if>
            <button type="submit" class="btn btn-primary" value="save">保存</button>
        </@ui.buttonGroup>
    </form>
</div>
<div id="${pageId}-ajax-result">
<#--<div class="loading inline"><i class="fa fa-spinner fa-spin"></i> 正在加载...</div>-->
</div>
<div id="${pageId}-preview"></div>
<script type="text/javascript">
    $(function () {
        var $form = $('[data-kui-ajax-form]');
        $form.on('click', '.js-action-preview', function (e) {
            var format = $(this).data("value");
            $form.ajaxSubmit({
                beforeSerialize: fnValidateDisplayFormat,
                url: "${base}/udr/preview?displayFormat=" + format,
                target: "#${pageId}-preview"
            });
            e.preventDefault();
        });
        formFieldSetToTab('#${pageId}-form');
        function formFieldSetToTab(formSelector) {
            var $form = $(formSelector);
            var $container = $form;
            $container.prepend();
            var $tabContent = $('<div class="tab-content"></div>').prependTo($container);
            var $navTabs = $('<ul class="nav nav-tabs"></ul>').prependTo($container);
            var index = 0;
            var formId = $form.attr('id');
            $('fieldset', $form).each(function () {
                index++;
                var $fieldset = $(this);
                var $legend = $('legend', $fieldset);
                var tabId = formId + '-tab-' + index;
                $navTabs.append('<li><a href="#' + tabId + '" data-toggle="tab">' + $legend.html() + '</a></li>');
                $legend.remove();
                var $tabPane = $('<div id="' + tabId + '" class="tab-pane"></div>').appendTo($tabContent);
                $fieldset.appendTo($tabPane);
            });
            $('a:first', $navTabs).tab('show');
        }
    });
    function fnValidateDisplayFormat() {
        var $form = $("#${pageId}-form");
        var obj = {};
        var result = true;
        $.each($('.js-display-option', $form), function () {
            var $this = $(this);
            var fmt = $this.data("display-format");
            var value = $this.val();
            try {
                obj[fmt] = isBlank(value) ? null : JSON.parse(value);
            } catch (error) {
                alert("你输入的内容不是有效的JSON格式：" + error.message);
                console.error(error.message);
                $this.focus();
                result = false;
                return false;
            }
            return true;
        });
        if (result) {
            var json = JSON.stringify(obj);
            $('[name="userDefinedReport.displayJson"]', $form).val(json);
        }
        return result;
    }
</script>
</@ui.page>
