<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/11, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="qdf-angular"/>
<#--<script type="text/javascript" src="${base}/media/angularjs/angular-route.min.js"></script>-->
<@ui.page id=pageId title="查询定义">
<div ng-view></div>
<script type="text/ng-template" id="index.html">
    <div class="form-group">
        <a href="#!/create" class="btn btn-info">新建查询</a>
    </div>
    <div class="list-group">
        <div class="list-group-item" ng-repeat="qdf in allQueryDef">
            <span class="label label-default pull-right"><i class="fa fa-folder-o"></i> {{qdf.namespace}}</span>
            <a href="#!/edit/{{qdf.id}}"><h3 class="list-group-item-heading">{{qdf.name}}</h3></a>

            <p class="list-group-item-text">{{qdf.description}}</p>
        </div>
    </div>
</script>
<script type="text/ng-template" id="edit.html">
    <div class="webform">
        <form ng-submit="actionSave()" kui-tabbable-form>
            <fieldset>
                <legend>关键信息</legend>
                <input type="hidden" name="queryDef.id" ng-model="queryDef.id"/>

                <@ui.labelControlGroup label="名称" helpText="通过目录和名称来定位一个查询，<code>目录.名称</code>必须唯一">
                    <div class="input-group">
                        <input type="text" name="queryDef.namespace" ng-model="queryDef.namespace" required="required"
                               class="form-control"/>
                        <span class="input-group-addon">.</span>
                        <input type="text" name="queryDef.name" ng-model="queryDef.name" required="required"
                               class="form-control"/>
                    </div>
                </@ui.labelControlGroup>
                <@ui.textfield label="数据库连接" name="queryDef.dbConn" isNgModel=true/>
                <button type="button" class="btn btn-info btn-sm pull-right" style="margin-top:-8px;"
                        ng-click="actionTestSql()">
                    测试SQL
                </button>
                <@ui.textarea label="SQL" name="queryDef.sql" isNgModel=true size="large" class="code"/>
            </fieldset>
            <fieldset>
                <legend>其它信息</legend>
                <@ui.textarea label="描述" name="queryDef.description" isNgModel=true/>
                <@ui.textfield label="模糊查询字段" name="queryDef.fuzzySearch" isNgModel=true helpText="仅服务器端查询需要，字段名称之间用英文逗号(,)分隔"/>
                <@ui.textfield label="可以为空的字段" name="queryDef.nullableParameters" isNgModel=true/>
            </fieldset>
            <@ui.buttonGroup>
                <button type="reset" class="btn btn-default" ng-click="actionCancel()">取消</button>
                <button type="submit" class="btn btn-primary">保存</button>
            </@ui.buttonGroup>
        </form>
    </div>
    <div class="well js-preview-zone"></div>
</script>
<script type="text/javascript">
    angular.module('qad.qdf', ['ngRoute', 'qad.angular'])
            .config(['$routeProvider', '$locationProvider', function ($routeProvider, $locationProvider) {
//                $locationProvider.html5Mode(false).hashPrefix('!');
                $routeProvider
                        .when('/index', {controller: 'ListCtrl', templateUrl: 'index.html'})
                        .when('/edit/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/create', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .otherwise({redirectTo: '/index'});
            }])
            .controller('ListCtrl', ['$scope', '$http', function ($scope, $http) {
                $scope.allQueryDef = [];
                $http.get('${base}/udr/qdf/list.json')
                        .success(function (data) {
                            $scope.allQueryDef = data.allQueryDef;
                        });
            }])
            .controller('EditCtrl', ['$scope', '$http', '$routeParams', '$route', '$location', function ($scope, $http, $routeParams, $route, $location) {
                //http://deansofer.com/posts/view/14/AngularJs-Tips-and-Tricks-UPDATED#routing
                $scope.$on('$routeChangeSuccess', function () {
                    var id = $routeParams.id;
                    $scope.isNew = id == null;
                    $scope.loadOne(id);
                });
                $scope.loadOne = function (id) {
                    $http.get(ktl.isBlank(id) ? '${base}/udr/qdf/create.json' : ('${base}/udr/qdf/update.json?id=' + id))
                            .success(function (data) {
                                $scope.queryDef = data.queryDef;
                            });
                };
                $scope.actionTestSql = function () {
                    var page = $('#${pageId}');
                    $('form', page).ajaxSubmit({
                        url: '${base}/udr/qdf/testsql',
                        target: $(".js-preview-zone", page)});
                };
                $scope.actionCancel = function () {
                    $location.path("/index");
                };
                $scope.actionSave = function () {
                    var isCreate = $scope.queryDef.id == null;
                    var url = isCreate ? '${base}/udr/qdf/create_do.json' : '${base}/udr/qdf/update_do.json';
                    $http.post(url, {"queryDef": $scope.queryDef})
                            .success(function (data) {
                                kui.showToast("success", "已保存", 3);
                                $scope.queryDef = data.queryDef;
                            }).error(function (data) {
                                kui.showToast("error", data.error, 15);
                            });
                };
            }]);
    //Manually bootstrap angularjs
    angular.element(document).ready(function () {
        angular.bootstrap('#${pageId}', ['qad.qdf']);
    });
</script>
</@ui.page>