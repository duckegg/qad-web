<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/WEB-INF/pages/commons/tag/tag-controls.ftl" parse=true/>
<#include "udr-lib.ftl" parse=true/>
<#assign pageId="udr-edit"/>
<#assign isCreate=!userDefinedReport.id??/>
<@ui.page id=pageId title=userDefinedReport.title!'未命名报告'>
<div class="webform">
    <div id="testTabs"></div>
    <form id="${pageId}-form" class="kui-tabbable-form"
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
            <button class="js-action-test-sql btn btn-info btn-sm pull-right"
                    style="margin-top:-8px;">测试SQL
            </button>
            <@ui.textarea name="userDefinedReport.queryDef.sql" label="SQL语句" required=true size="large">${(userDefinedReport.queryDef.sql)!''}</@ui.textarea>
        </fieldset>
        <fieldset>
            <legend>展现格式</legend>
            <@ui.ajaxNav target="#${pageId}-display" class="nav-pills">
                <#list UDR_FORMATS?keys as key>
                    <li class="<#if key_index==0>active</#if> js-format-tab-${key}">
                        <a href="#${pageId}-display-${key}"
                           data-toggle="tab">${UDR_FORMATS[key]}</a>
                    </li>
                </#list>
            </@ui.ajaxNav>
            <div class="tab-content" id="${pageId}-display">
                <#list UDR_FORMATS?keys as key>
                    <div id="${pageId}-display-${key}" class="tab-pane">
                        <div class="clearfix" style="margin-bottom:4px;">
                            <button class="js-action-preview btn btn-info pull-right"
                                    value="${key}">预览
                            </button>
                        </div>
                        <div class="js-display-format" data-display-format="${key}">
                        <#-- Dynamic format setting goes here -->
                        </div>
                    </div>
                </#list>
            </div>
            <input type="hidden" name="userDefinedReport.displayJson" class="form-control"
                   value=""/>
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
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="reset" class="btn btn-default">取消</button>
        </@ui.buttonGroup>
    </form>
</div>
<div id="${pageId}-ajax-result">
</div>
<div id="${pageId}-preview" class="well"></div>
<script type="text/javascript">
//    /**
//     * Make fieldset as tabs in a form
//     */
//    $.fn.tabForm = function () {
//        var $form = $(this);
//        var $container = $form;
//        $container.prepend();
//        var $tabContent = $('<div class="tab-content"></div>').prependTo($container);
//        var $navTabs = $('<ul class="nav nav-tabs"></ul>').prependTo($container);
//        var index = 0;
//        var formId = $form.attr('id');
//        $('fieldset', $form).each(function () {
//            index++;
//            var $fieldset = $(this);
//            var $legend = $('legend', $fieldset);
//            var tabId = formId + '-tab-' + index;
//            $navTabs.append('<li><a href="#' + tabId + '" data-toggle="tab">' + $legend.html() + '</a></li>');
//            $legend.remove();
//            var $tabPane = $('<div id="' + tabId + '" class="tab-pane"></div>').appendTo($tabContent);
//            $fieldset.appendTo($tabPane);
//        });
//        $('a:first', $navTabs).tab('show');
//        return $form;
//    };
</script>
<script type="text/javascript">
    $(function () {
        var formatSettings = ${userDefinedReport.displayJson!'{}'};
    <#--<#list UDR_FORMATS?keys as key>-->
    <#--formatSettings['${key}'] = userDefinedReport.displayJson;-->
    <#--</#list>-->
        var $page = $('#${pageId}');
        var $form = $('#${pageId}-form', $page);

        function textfieldHtml(label, name, value) {
            value = value || "";
            return '<div class="form-group"><label class="control-label">' + label + '</label><input type="text" class="form-control" data-control-name="' + name + '" value="' + value + '"/></div>';
        }

        function tableRowHtml(field, title) {
            return '<tr>' +
                    '<td><input type="text" class="form-control" data-control-name="field" value="' + (field || '') + '"/></td>' +
                    '<td><input type="text" class="form-control" data-control-name="title" value="' + (title || '') + '"/></td>' +
                    '<td><button type="button" class="btn btn-default btn-xs js-action-remove-table-column"><i class="fa fa-times"></i></button></td>' +
                    '</tr>';
        }

        function addTableEvent() {
            var $table = $('.js-table-columns', $page);
            $table.on('click', '.js-action-add-table-column', function () {
                var row = $(tableRowHtml("", ""));
                row.appendTo($('tbody', $table)).find('input:first').focus();
            }).on('click', '.js-action-remove-table-column', function () {
                $(this).closest('tr').remove();
            });
        }

        /**
         * @param format string, "table"|"linechart"|"barchart"|"piechart"
         * @param container jquery selector to enclose HTML controls of this format setting
         */
        function DisplayFormat(format, container) {
            var $container = $(container);
            this.format = format;
            function initHtmlControl() {
                var html = '';
                var settings = formatSettings[format] || {};
                if (!$.isEmptyObject(settings)) {
                    $('.js-format-tab-' + format + ' a').append(' <i class="fa fa-check-circle"></i>');
                }
                if ("table" == format) {
                    var columns = settings['columns'] || [
                        {}
                    ];
                    html += '<table class="table table-bordered table-condensed js-table-columns"><thead><tr>' +
                            '<th>数据库字段</th>' +
                            '<th>显示标题</th>' +
                            '<th><button type="button" class="btn btn-default btn-xs js-action-add-table-column"><i class="fa fa-plus"></i></button></th>' +
                            '</tr></thead><tbody>';
                    for (var i = 0; i < columns.length; i++) {
                        html += tableRowHtml(columns[i]['field'], columns[i]['title']);
                    }
                    html += '</tbody></table>';
                } else {
                    html+='<div class="form-horizontal">';
                    if ("linechart" == format || "barchart" == format) {
                        html += textfieldHtml('X轴字段', 'xField', settings["xField"])
                                + textfieldHtml('Y轴字段', 'yField', settings["yField"])
                                + textfieldHtml('序列字段', 'seriesField', settings["seriesField"]);
                    } else if ("piechart" == format) {
                        html += textfieldHtml('X轴字段', 'xField', settings["xField"])
                                + textfieldHtml('Y轴字段', 'yField', settings["yField"])
                                + textfieldHtml('序列字段', 'seriesField', settings["seriesField"]);
                    }
                    html+='</div>';
                }
                $container.append(html);
                if ("table" == format)
                    addTableEvent();
            }

            initHtmlControl();
            /**
             * Calculate the JSON object value of this format
             */
            this.calcJsonObject = function () {
                var obj = {};
                if ("table" == format) {
                    var $table = $('.js-table-columns', $container);
                    obj['columns'] = [];
                    $('tbody tr', $table).each(function (i, row) {
                        var o = {};
                        var isBlank = false;
                        $('[data-control-name]', row).each(function (j, cell) {
                            var $cell = $(cell);
                            var val = $cell.val();
                            isBlank = val == "";
                            o[$cell.data('control-name')] = val;
                        });
                        if (!isBlank)
                            obj['columns'].push(o);
                    });
                    return obj;
                } else if ("linechart" == format || "barchart" == format || "piechart" == format) {
                    var inputs = $('[data-control-name]', $container);
                    for (var i = 0; i < inputs.length; i++) {
                        var $item = $(inputs[i]);
                        var name = $item.data('control-name');
                        if (name) {
                            var value = $item.val();
                            if (value == "") {
                                console.warn('格式"' + format + '"缺少字段"' + name + '"');
                                return null;
                            }
                            obj[name] = value;
                        }
                    }
                    return obj;
                }
                return null;
            };
        }

        DisplayFormat.allFormats = [];
        DisplayFormat.getFormat = function (format) {
            for (var i = 0; i < DisplayFormat.allFormats.length; i++) {
                if (format == DisplayFormat.allFormats[i].format) {
                    return DisplayFormat.allFormats[i];
                }
            }
            return null;
        };
        DisplayFormat.addFormat = function (format) {
            DisplayFormat.allFormats.push(format);
        };
        DisplayFormat.iterate = function (fn) {
            for (var i = 0; i < DisplayFormat.allFormats.length; i++) {
                fn(DisplayFormat.allFormats[i]);
            }
        };
        /**
         * @returns string json represent of settings of all display format
         * @throw {"format":string,"message",string} if invalid format
         */
        DisplayFormat.allFormatsToJsonString = function () {
            var obj = {};
            var reportFormat;
            try {
                DisplayFormat.iterate(function (fmt) {
                    reportFormat = fmt;
                    obj[fmt.format] = fmt.calcJsonObject();
                })
            } catch (error) {
                throw {format: reportFormat.format, message: error.message};
            }
            return JSON.stringify(obj);
        };

        $('.js-display-format', $form).each(function () {
            var $this = $(this);
            var format = $this.data('display-format');
            DisplayFormat.addFormat(new DisplayFormat(format, $this));
        });


        $form.on('click', '.js-action-preview', function (e) {
            var format = $(this).val();
            if (DisplayFormat.getFormat(format).calcJsonObject() == null) {
                alert("not defined");
                return false;
            }
            $form.ajaxSubmit({
                beforeSerialize: fnValidateDisplayFormat,
                url: "${base}/udr/preview?displayFormat=" + format,
                target: "#${pageId}-preview"
            });
            e.preventDefault();
        }).on('click', '.js-action-test-sql', function (e) {
            $form.ajaxSubmit({
                url: "${base}/udr/testsql",
                target: "#${pageId}-preview"
            });
            e.preventDefault();
        });

        window.fnValidateDisplayFormat = function () {
            try {
                $('[name="userDefinedReport.displayJson"]', $form).val(DisplayFormat.allFormatsToJsonString());
            } catch (error) {
                $('.js-format-tab-' + error.format + ' a', $page).tab('show');
                kui.showToast("warn", "格式错误", 20);
                return false;
            }
            return true;
        };
    });
</script>
</@ui.page>
