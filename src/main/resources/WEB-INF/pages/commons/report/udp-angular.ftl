<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/11, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="qdf-angular"/>
<#--<script type="text/javascript" src="${base}/media/angularjs/angular-route.min.js"></script>-->
<@ui.page id=pageId title="页面定义">

<div ng-view></div>
<script type="text/ng-template" id="index.html">
    <a href="#!/create" class="btn btn-default">新建页面</a>
    <div class="list-group">
        <div class="list-group-item" ng-repeat="udp in allEntity">
            <a href="${base}/udr/page/view?id={{udp.id}}"><h3 class="list-group-item-heading">{{udp.title}}</h3></a>

            <p class="list-group-item-text"><a href="${base}/user/view/{{udp.trace.createdUser.id}}" data-kui-dialog>{{udp.trace.createdUser.fullName}}</a> {{udp.trace.createdAt}}</p>
            <div class="btn-toolbar kui-hover-toolbar">
                <div class="btn-group btn-group-sm">
                    <a href="#!/update/{{udp.id}}" class="btn btn-default">编辑</a>
                    <a href="#!/delete/{{udp.id}}" data-kui-dialog class="btn btn-default">删除</a>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/ng-template" id="edit.html">
    <div class="webform">
        <form ng-submit="actionSave()" kui-tabbable-form>
            <input type="hidden" name="thisEntity.id" ng-model="thisEntity.id"/>

            <@ui.textfield label="Title" name="thisEntity.title" isNgModel=true/>
            <#--<button type="button" class="btn btn-info btn-sm pull-right" style="margin-top:-8px;"-->
                    <#--ng-click="actionTestSql()">-->
                <#--测试SQL-->
            <#--</button>-->
            <@ui.textarea id="js-code-mirror" label="Content" name="thisEntity.content" isNgModel=true size="large"/>
            <@ui.buttonGroup>
                <button type="reset" class="btn btn-default" ng-click="actionCancel()">取消</button>
                <button type="submit" class="btn btn-primary">保存</button>
            </@ui.buttonGroup>
        </form>
    </div>
    <div class="well js-preview-zone"></div>
</script>
<script type="text/javascript">
    angular.module('qad.udp', ['ngRoute', 'qad.angular'])
            .config(['$routeProvider', function ($routeProvider) {
                $routeProvider
                        .when('/index', {controller: 'ListCtrl', templateUrl: 'index.html'})
                        .when('/delete/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/update/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/create', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .otherwise({redirectTo: '/index'});
            }])
            .controller('ListCtrl', ['$scope', '$http', function ($scope, $http) {
                $scope.allEntity = [];
                $http.get('${base}/udr/page/list.json')
                        .success(function (data) {
                            $scope.allEntity = data.allEntity;
                        });
            }])
            .controller('EditCtrl', ['$scope', '$http', '$routeParams', '$route', '$location', function ($scope, $http, $routeParams, $route, $location) {
                // http://deansofer.com/posts/view/14/AngularJs-Tips-and-Tricks-UPDATED#routing
                $scope.$on('$routeChangeSuccess', function () {
                    var id = $routeParams.id;
                    $scope.isNew = id == null;
                    $scope.loadOne(id);
                });
                $scope.loadOne = function (id) {
                    $http.get('${base}/udr/page/update.json?id=' + id)
                            .success(function (data) {
                                $scope.thisEntity = data.thisEntity;
                            });
                };
//                CodeMirror.fromTextArea(document.getElementById("js-code-mirror"),{lineNumbers: true,
//                    mode: "htmlmixed"});
                $scope.actionTestSql = function () {
                    var page = $('#${pageId}');
                    $('form', page).ajaxSubmit({
                        url: '${base}/udr/page/testsql',
                        target: $(".js-preview-zone", page)});
                };
                $scope.actionCancel = function () {
                    $location.path("/index");
                };
                $scope.actionSave = function () {
                    var isCreate = $scope.thisEntity.id == null;
                    var url = isCreate ? '${base}/udr/page/create_do.json' : '${base}/udr/page/update_do.json';
                    $http.post(url, {"thisEntity": $scope.thisEntity})
                            .success(function (data) {
                                kui.showToast("success", "已保存", 3);
                                $scope.thisEntity = data.thisEntity;
                            }).error(function (data) {
                                kui.showToast("error", data.error, 15);
                            });
                };
            }]);
    // Manually bootstrap angularjs
    angular.element(document).ready(function () {
        angular.bootstrap('#${pageId}', ['qad.udp']);
    });
</script>
</@ui.page>