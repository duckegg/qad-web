<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/11, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="page-angular"/>
<#--<script type="text/javascript" src="${base}/media/angularjs/angular-route.min.js"></script>-->
<@ui.page id=pageId title="页面定义">

<div ng-view></div>
<script type="text/ng-template" id="index.html">
    <div class="form-group">
        <button ng-click="actionCreate()" class="btn btn-info js-action-create-page" ng-disabled="!isUserLoggedIn">新建页面</button>
    </div>
    <pagination class="pagination-sm" total-items="so.totalRecords" page="so.page" items-per-page="so.size"
                on-select-page="actionChangePage(page)"
                boundary-links="false" previous-text="&lsaquo;" next-text="&rsaquo;" first-text="&laquo;"
                last-text="&raquo;"></pagination>
    <div class="list-group">
        <div class="list-group-item kui-toolbar-container" ng-repeat="page in allEntity">
            <h3 class="list-group-item-heading"><a href="${base}/udr/page/view?id={{page.id}}">{{page.title}}</a></h3>

            <p class="list-group-item-text"><a href="${base}/user/view/{{page.trace.createdBy}}" data-kui-dialog>{{page.trace.createdUser.fullName}}</a>
                {{page.trace.createdAt}}</p>

            <div class="btn-toolbar kui-hover-toolbar" kui-hover-toolbar>
                <div class="btn-group btn-group-sm">
                    <a href="#!/update/{{page.id}}" class="btn btn-default" ng-disabled="!page.isOwner"><i
                            class="fa fa-pencil"></i> 编辑</a>
                    <a href="javascript:;" ng-click="actionDelete(page)" class="btn btn-default"
                       ng-disabled="!page.isOwner"><i
                            class="fa fa-trash-o"></i> 删除</a>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/ng-template" id="edit.html">
    <div class="row">
        <div class="col-md-7">
            <form ng-submit="actionSave()" kui-tabbable-form id="${pageId}-edit-form">
                <input type="hidden" name="thisEntity.id" ng-model="thisEntity.id"/>

                <@ui.textfield label="Title" name="thisEntity.title" isNgModel=true/>
            <#--<button type="button" class="btn btn-info btn-sm pull-right" style="margin-top:-8px;"-->
            <#--ng-click="actionTestSql()">-->
            <#--测试SQL-->
            <#--</button>-->
                <@ui.textarea id="js-code-mirror" label="Content" name="thisEntity.content" isNgModel=true size="large" class="code"/>
                <@ui.buttonGroup>
                    <button type="reset" class="btn btn-default" ng-click="actionCancel()">取消</button>
                    <button type="submit" class="btn btn-primary js-action-save-edit">保存</button>
                </@ui.buttonGroup>
            </form>
        </div>
        <div class="col-md-5">
            <a href="${base}/help/qad/udr">帮助</a>
        </div>
    </div>
    <#--<div class="well js-preview-zone" ng-show="showPreview"></div>-->
</script>
<script type="text/javascript">
    angular.module('qad.udp', ['ngRoute', 'qad.angular', 'ui.bootstrap'])
            .config(['$routeProvider', function ($routeProvider) {
                $routeProvider
                        .when('/index', {controller: 'ListCtrl', templateUrl: 'index.html'})
                        .when('/delete/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/update/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/create', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .otherwise({redirectTo: '/index'});
            }])
            .controller('ListCtrl', ['$rootScope', '$scope', '$http', '$location', function ($rootScope, $scope, $http, $location) {
                    <@shiro.user>$rootScope.isUserLoggedIn = true;</@shiro.user>
                $scope.allEntity = [];
                logger.debug("listctrl");
                $scope.actionCreate = function () {
                    $location.path("/create");
                };
                $scope.actionChangePage = function (page) {
                    $scope.so.page = page;
                    $http.post('${base}/udr/page/list.json', {so: $scope.so})
                            .success(function (data) {
                                var allEntity = data.allEntity;
                                angular.forEach(allEntity, function (value, index) {
                                    value.isOwner = (value.trace.createdBy ==${(Session.user.id)!-100});
                                    <@shiro.hasPermission name="udr-page:admin">
                                    value.isOwner = true;
                                    </@shiro.hasPermission>
                                });
                                $scope.allEntity.splice(0,$scope.allEntity.length);
                                for (var i=0;i<allEntity.length;i++){
                                    $scope.allEntity.push(allEntity[i]);
                                }
                                $scope.so = data.so;
                            });
                };
                $scope.actionDelete = function (udp) {
                    if (confirm("确定要删除吗?")) {
                        $http.post('${base}/udr/page/delete_do.json?id=' + udp.id).success(function () {
                            kui.showToast('success', '已删除' + udp.title);
                            $scope.actionChangePage($scope.so.page);
                        });
                    }
                };
                $scope.so = {page: 1, size: 10};
                $scope.actionChangePage(1);

            }])
            .controller('EditCtrl', ['$scope', '$http', '$routeParams', '$route', '$location', function ($scope, $http, $routeParams, $route, $location) {
                // http://deansofer.com/posts/view/14/AngularJs-Tips-and-Tricks-UPDATED#routing
                $scope.$on('$routeChangeSuccess', function () {
                    var id = $routeParams.id;
                    $scope.isNew = id == null;
                    $scope.loadOne(id);
                });
                $scope.loadOne = function (id) {
                    $http.get(!id ? '${base}/udr/page/create.json' : '${base}/udr/page/update.json?id=' + id)
                            .success(function (data) {
                                $scope.thisEntity = data.thisEntity;
                            });
                };
                $scope.actionCancel = function () {
                    $location.path("/index");
                };
                $scope.actionSave = function () {
                    var isCreate = $scope.thisEntity.id == null;
                    var url = isCreate ? '${base}/udr/page/create_do.json' : '${base}/udr/page/update_do.json';
                    $http.post(url, {id: $scope.thisEntity.id, "thisEntity": $scope.thisEntity})
                            .success(function (data) {
                                kui.showToast("success", "已保存", 3);
                                $location.path('/index');
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