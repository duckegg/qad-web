<#--
********************************************************************************
@desc Search index profile. Experimental with AngularJs.
@author Leo Liao, 13-12-5, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#--<script type="text/javascript" src="${base}/media/angularjs/angular.min.js"></script>-->
<#assign pageId="index-profile"/>
<@ui.page id=pageId title="索引配置方案" class="webform">
<#--Note: You should not use the ng-app directive when manually bootstrapping your app.-->
<#--<div ng-app="indexProfile">-->
<div ng-controller="IndexProfileCtrl">
    <div class="">
        <div>
            <ul class="nav nav-pills">
                <li ng-repeat="p in indexProfiles" ng-class="{'active':activeProfile.name==p.name}">
                    <a href="javascript:;" ng-click="actionEdit(p)">{{p.id}}: {{ p.name }}</a>
                </li>
                <li class=" pull-right">
                    <button class="btn btn-default" ng-click="actionNew()"
                            style="margin-bottom:1em;"
                            ng-disabled="activeProfile.id==null"><i class="fa fa-plus"></i>
                    </button>
                </li>
            </ul>
        </div>
        <div>
            <form class="form-vertical" ng-submit="actionSave()">
                <div class="form-group">
                    <label class="control-label" for="indexProfileName">ID: <span>{{activeProfile.id}}</span></label>
                </div>
                <div class="form-group">
                    <label class="control-label" for="indexProfileName">名称: </label>

                    <div class="controls">
                        <input id="indexProfileName" type="text" name="activeProfile.name"
                               class="form-control"
                               ng-model="activeProfile.name"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label" for="indexProfileDefinition">定义: </label>

                    <div class="controls">
                        <textarea id="indexProfileDefinition" name="activeProfile.definition"
                                  class="form-control"
                                  style='height: 15em; font-family: "Courier New"'
                                  ng-model="activeProfile.definition"></textarea>

                        <div class="help-block">
                            可以使用参数，格式为<code>${r'${param_name}'}</code>。内置参数：<code>${r'${#key}'}</code>：CI类型
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label" for="indexProfileIndexerClass">索引维护Java类: </label>

                    <div class="controls">
                        <select id="indexProfileName" class="form-control"
                                name="activeProfile.indexerClass"
                                ng-options="class for class in indexerClasses"
                                ng-model="activeProfile.indexerClass">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label" for="indexDesc">增加描述字段 </label>

                    <div class="controls">
                        <textarea id="indexDesc" name="activeProfile.description"
                                  class="form-control"
                                  ng-model="activeProfile.description"></textarea>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-danger pull-left" ng-click="actionDelete()"
                            ng-show="activeProfile.id!=null">删除
                    </button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script type="text/javascript">
    angular.module('indexProfile', [])
            .controller('IndexProfileCtrl', function ($scope, $http) {
                $scope.actionErrors = [];
                $scope.actionMessages = [];
                $scope.actionList = function (refreshCurrent) {
                    $http.get('${base}/admin/config/search/profile/list.json')
                            .success(function (data) {
                                if (data.indexerErrors.length > 0)
                                    kui.showToast("warn", data.indexerErrors);
                                $scope.indexProfiles = data.indexProfiles;
                                if (refreshCurrent)
                                    $scope.activeProfile = data.indexProfile;
                                $scope.indexerClasses = data.indexerClasses;
                            }).error(function (data) {
                                kui.showToast("error", data.error);
                            });
                };
                $scope.actionSave = function () {
                    var action = $scope.activeProfile.id == null ? "create" : "update";
                    $http.post('${base}/admin/config/search/profile/' + action + '_do.json', {"indexProfile": $scope.activeProfile})
                            .success(function (data) {
                                $scope.actionList();
                                kui.showToast("success", (action == "create" ? "新建" : "更新") + data.indexProfile.name)
                            }).error(function (data) {
                                kui.showToast("error", data.error);
                            });
                };
                $scope.actionEdit = function (profile) {
                    $scope.activeProfile = angular.copy(profile);
                };
                $scope.actionNew = function () {
                    $scope.activeProfile = {"name": "未命名方案"};
                    $scope.indexProfiles.push($scope.activeProfile);
                };
                $scope.actionDelete = function () {
                    if (confirm("确认删除该配置方案吗")) {
                        $http.post('${base}/admin/config/search/profile/delete_do.json', {"id": [$scope.activeProfile.id]})
                                .success(function (data) {
                                    $scope.actionList();
                                }).error(function (data) {
                                    kui.showToast("error", data.error);
                                });
                    }
                };
                $scope.actionList();
            });
    //Manually bootstrap angularjs
    angular.element(document).ready(function () {
        angular.bootstrap('#${pageId}', ['indexProfile']);
    });
</script>
</@ui.page>
