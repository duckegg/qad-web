<#--
********************************************************************************
@desc 
@author Leo Liao, 14-2-28, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "/modules/qad/public/tag-controls.ftl" parse=true/>
<#include "udr-lib.ftl" parse=true/>
<#assign pageId="udr-edit"/>
<script type="text/javascript" src="${base}/media/angularjs/angular-route.min.js"></script>
<@ui.page id=pageId title="自定义报告">
<div class="webform" ng-controller="EditCtrl">
    <div id="testTabs"></div>
    <form id="${pageId}-form" method="post">
        <fieldset class="active">
            <legend>基本信息</legend>
            <input type="hidden" name="userDefinedReport.id" ng-model="userDefinedReport.id"/>
            <@ui.textfield name="userDefinedReport.title" label="标题" class="required" maxlength="100" required=true  dataAttribute='ng-model="userDefinedReport.title"'/>
            <@ui.textarea name="userDefinedReport.description" label="报表说明" class="required" dataAttribute='ng-model="userDefinedReport.description"'></@ui.textarea>
        <#--<@ui.textfield name="userDefinedReport.tagLabels" label="Tag"/>-->
        <@tagging id="udr-tags" tagCategory="report" controlName="userDefinedReport.tagLabels" label="Tag" selectedValues=[]/>
        </fieldset>
        <fieldset>
            <legend>数据来源</legend>
            <@ui.textfield name="userDefinedReport.queryDef.dbConn" label="数据库连接" class="required" dataAttribute='ng-model="userDefinedReport.queryDef.dbConn"'/>
            <button class="js-action-test-sql btn btn-info btn-sm pull-right"
                    style="margin-top:-8px;">测试SQL
            </button>
            <@ui.textarea name="userDefinedReport.queryDef.sql" label="SQL语句" required=true size="large" dataAttribute='ng-model="userDefinedReport.queryDef.sql"'></@ui.textarea>
        </fieldset>
        <fieldset>
            <legend>展现格式</legend>
            <@ui.ajaxNav target="#${pageId}-display" class="nav-pills">
                <#list UDR_FORMATS?keys as key>
                    <li class="<#if key_index==0>active</#if>">
                        <a href="#${pageId}-display-${key}"
                           data-toggle="tab">${UDR_FORMATS[key]}</a>
                    </li>
                </#list>
            </@ui.ajaxNav>
            <div class="tab-content" id="${pageId}-display">
                <#list UDR_FORMATS?keys as key>
                    <div id="${pageId}-display-${key}" class="tab-pane">
                        <div class="clearfix" style="margin-bottom:0.5em;">
                            <a class="js-action-preview btn btn-info pull-right"
                               data-value="${key}">预览
                            </a>
                        </div>
                        <div class="form-group js-display-format" data-display-format="${key}">
                            <@ui.textarea name="" class="form-control js-display-option" size="large" dataAttribute='ng-model="userDefinedReport.display.${key}"'></@ui.textarea>
                        </div>
                    </div>
                </#list>
            </div>
            <input type="hidden" name="userDefinedReport.displayJson"
                   ng-model="userDefinedReport.displayJson"/>
        </fieldset>
        <@ui.buttonGroup>
            <div class="pull-left" ng-if="userDefinedReport.id!=null">
                <a class="btn btn-default"
                   href="${base}/udr/copy?id={{userDefinedReport.id}}"
                   data-kui-dialog>复制
                </a>
                <a class="btn btn-danger"
                   href="${base}/udr/delete?id={{userDefinedReport.id}}"
                   data-kui-dialog>删除
                </a>
            </div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="reset" class="btn btn-default">取消</button>
        </@ui.buttonGroup>
    </form>
</div>
<div id="${pageId}-ajax-result">
<#--<div class="loading inline"><i class="fa fa-spinner fa-spin"></i> 正在加载...</div>-->
</div>
<div id="${pageId}-preview"></div>
<script type="text/javascript">
    var displayFormats = {};
    $(function () {
        var $page = $('#${pageId}');
        var $form = $("#${pageId}-form");

        function ReportFormat(type, container) {
            var $container = $(container);
            this.buildControl = function () {
                var html = '';
                html += '<textarea>' + type + '</textarea>';
                $container.append(html);
            };
            this.toJson = function () {
                return JSON.parse($('textarea', $container).val());
            };
            this.validate = function () {
            };
        }

        $('.js-display-format', $form).each(function () {
            var format = $(this).data('display-format');
            var reportFormat = new ReportFormat(format, $(this));
            reportFormat.buildControl();
            displayFormats[format] = reportFormat;
        });


        $form.on('click', '.js-action-preview', function (e) {
            var format = $(this).data("value");
            $form.ajaxSubmit({
                beforeSerialize: fnValidateDisplayFormat,
                url: "${base}/udr/preview?displayFormat=" + format,
                target: "#${pageId}-preview"
            });
            e.preventDefault();
        }).on('click', '.js-action-test-sql', function (e) {
            console.debug("etst-sql");
            $form.ajaxSubmit({
                url: "${base}/udr/testsql",
                target: "#${pageId}-preview"
            });
            e.preventDefault();
        });
    <#--formFieldSetToTab('#${pageId}-form');-->

        /**
         * Make fieldset as tabs in a form
         */
        $.fn.tabForm = function () {
            var $form = $(this);
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
            return $form;
        };
        $('#${pageId}-form').tabForm();
    });
    function fnValidateDisplayFormat1() {
        var $form = $("#${pageId}-form");
        var obj = {};
        var result = true;
        $.each($('.js-display-option', $form), function () {
            var $this = $(this);
            var fmt = $this.closest('.js-display-format').data("display-format");
            var value = $this.val();
            try {
                obj[fmt] = klib.isBlank(value) ? null : JSON.parse(value);
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
    function fnValidateDisplayFormat() {
        var $form = $("#${pageId}-form");
        var obj = {};
        var result = true;
        $.each($('.js-display-option', $form), function () {
            var $this = $(this);
            var fmt = $this.closest('.js-display-format').data("display-format");
            var value = $this.val();
            try {
                obj[fmt] = klib.isBlank(value) ? null : JSON.parse(value);
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
<script type="text/javascript">
    angular.module('qad.udr', ['ngRoute'])
            .config(['$routeProvider','$locationProvider', function ($routeProvider,$locationProvider) {
                $locationProvider.html5Mode(false).hashPrefix('!');
                $routeProvider
                        .when('/index', {controller: 'EditCtrl'})
                        .when('/update/:id', {controller: 'EditCtrl'})
                        .when('/create', {controller: 'EditCtrl'});
            }])
            .controller('EditCtrl', ['$scope', '$http', '$routeParams', '$route', '$location', function ($scope, $http, $routeParams, $route, $location) {
                //http://deansofer.com/posts/view/14/AngularJs-Tips-and-Tricks-UPDATED#routing
                $scope.$on('$routeChangeSuccess', function(){
                    var id = $routeParams.id;
                    $scope.isNew = id == null;
                    $scope.loadUdr(id);
                });
                $scope.loadUdr = function (id) {
                    $http.get('${base}/udr/update.json?id=' + id)
                            .success(function (data) {
                                console.debug(data);
                                $scope.userDefinedReport = data.userDefinedReport;
                            });
                };
                $scope.actionSave = function () {
                    var action = $scope.activeProfile.id == null ? "create" : "update";
                    var url = $scope.isNew ? '${base}/udr/create_do.json' : '${base}/udr/update_do.json';
                    $http.post(url, {"userDefinedReport": $scope.userDefinedReport})
                            .success(function (data) {
                                $scope.actionList();
                                kui.showToast("success", (action == "create" ? "新建" : "更新") + data.userDefinedReport.title, 3)
                            }).error(function (data) {
                                kui.showToast("error", data.error, 15);
                            });
                };
            }]);
    //Manually bootstrap angularjs
    angular.element(document).ready(function () {
        angular.bootstrap('#${pageId}', ['qad.udr']);
    });
</script>
</@ui.page>
