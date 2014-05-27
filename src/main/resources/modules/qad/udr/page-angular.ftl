<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/11, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="page-angular"/>
<@ui.page id=pageId title="自定义页面">

<div ng-view></div>
<script type="text/ng-template" id="list.html">
    <div class="row">
        <div class="col-md-6">
            <pagination class="pagination-sm" total-items="so.totalRecords" page="so.page" items-per-page="so.size"
                        on-select-page="actionChangePage(page)"
                        boundary-links="false" previous-text="&lsaquo;" next-text="&rsaquo;" first-text="&laquo;"
                        last-text="&raquo;"></pagination>
        </div>
        <div class="col-md-6">
            <div class="pull-right">
                <button ng-click="actionCreate()" class="btn btn-info btn-sm js-action-create-page"
                        ng-disabled="!isUserLoggedIn">
                    <i class="fa fa-plus"></i> 新建页面
                </button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default btn-sm" ng-click="actionSort(so.sort)"><i class="fa"
                                                                                                           ng-class="so.dir=='desc'?'fa-angle-down':'fa-angle-up'"></i>
                        {{sortFields[so.sort]}}
                    </button>
                    <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu pull-right" role="menu">
                        <li><a href="javascript:;" ng-click="actionSort('trace.updatedAt')">
                            <i class="fa"
                               ng-class="so.sort=='trace.updatedAt'?(so.dir=='desc'?'fa-angle-down':'fa-angle-up'):''"></i>
                            {{sortFields['trace.updatedAt']}}</a></li>
                        <li><a href="javascript:;" ng-click="actionSort('trace.createdBy')">
                            <i class="fa"
                               ng-class="so.sort=='trace.createdBy'?(so.dir=='desc'?'fa-angle-down':'fa-angle-up'):''"></i>
                            {{sortFields['trace.createdBy']}}</a></li>
                        <li><a href="javascript:;" ng-click="actionSort('title')">
                            <i class="fa"
                               ng-class="so.sort=='title'?(so.dir=='desc'?'fa-angle-down':'fa-angle-up'):''"></i>
                            {{sortFields['title']}}</a></li>
                    </ul>
                </div>
                <button class="btn btn-default btn-sm" ng-click="showMoreFilter=!showMoreFilter"
                        title="{{showMoreFilter?'收起':'展开更多筛选'}}"><i class="fa"
                                                                    ng-class="showMoreFilter?'fa-chevron-up':'fa-chevron-down'"></i>
                </button>
            </div>
        </div>
    </div>
    <div class="well well-sm" ng-show="showMoreFilter">
        <form ng-submit="actionFilter()" class="form-horizontal">
            <div class="input-group input-group-sm form-group">
                <input type="text" class="form-control" ng-model="so.likes.title">

                <div class="input-group-btn">
                    <button class="btn btn-default" ng-click="actionFilter()"><i class="fa fa-search"></i>
                    </button>
                </div>
            </div>
        </form>
        <ul class="list-unstyled list-inline">
            <li class="text-muted">Tags <a href="javascript:;" ng-click="showTagSearchText=!showTagSearchText"><i
                    class="fa" ng-class="showTagSearchText?'fa-angle-up':'fa-angle-down'"></i></a></li>
            <li ng-repeat="tag in allTags | filter:tagSearchText ">
                <a href="javascript:;" ng-click="actionFilterTag(tag.label)" class="label kui-label-tag"
                   ng-class="tag.isSelected?'selected':''">{{tag.label}}</a>
            </li>
        </ul>
        <div ng-show="showTagSearchText" style="width:12em"><input type="text" ng-model="tagSearchText"
                                                                   class="form-control input-sm" placeholder="查找标签"/>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="list-group">
                <div class="list-group-item kui-toolbar-container" ng-repeat="udp in allEntity">
                    <div class="media">
                        <div class="media-body">
                            <h3 class="media-heading"><a
                                    href="${base}/udr/page/view?id={{udp.id}}">{{udp.title}}</a>
                            </h3>

                            <p><a href="${base}/user/view/{{udp.trace.createdBy}}"
                                                               data-kui-dialog>{{udp.trace.createdUser.fullName}}</a>
                                {{udp.trace.updatedAt}}</p>
                        </div>
                        <div class="js-media-tag-and-action">
                        <ul class="list-inline kui-tag-list" ng-show="udp.tagLabels.length>0">
                            <li><i class="fa fa-tag"></i></li>
                            <li ng-repeat="tag in udp.tagLabels">
                                <a href="#!/tags/{{tag}}" class="label kui-label-tag">
                                    {{tag}}
                                </a>
                            </li>
                        </ul>
                        <div class="btn-toolbar kui-hover-toolbar" kui-hover-toolbar>
                            <div class="btn-group btn-group-sm">
                                <a href="#!/update/{{udp.id}}" class="btn btn-default" ng-disabled="!udp.allowEdit"><i
                                        class="fa fa-pencil"></i> 编辑</a>
                                <a href="javascript:;" ng-click="actionDelete(udp)" class="btn btn-default"
                                   ng-disabled="!udp.allowEdit"><i
                                        class="fa fa-trash-o"></i> 删除</a>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>
<script type="text/ng-template" id="edit.html">
    <div class="row">
        <div class="col-md-7">
            <form ng-submit="actionSave()" id="${pageId}-edit-form">
                <input type="hidden" name="thisEntity.id" ng-model="thisEntity.id"/>

                <@ui.textfield label="Title" name="thisEntity.title" isNgModel=true/>
                <@ui.textarea id="js-code-mirror" label="Content" name="thisEntity.content" isNgModel=true size="large" class="code"/>
                <@ui.labelControlGroup label="Tag">
                    <input type="hidden" ui-select2="select2Options" ng-model="thisEntity.tagLabels" style="width:100%">
                </@ui.labelControlGroup>
                <@ui.buttonGroup>
                    <button type="reset" class="btn btn-default" ng-click="actionCancel()">取消</button>
                    <button type="submit" class="btn btn-primary js-action-save-edit">保存</button>
                </@ui.buttonGroup>
            </form>
        </div>
        <div class="col-md-5" id="${pageId}-help">
            <a href="${base}/help/qad/dev-guide">开发指南</a>
        </div>
    </div>
    <#--<div class="well js-preview-zone" ng-show="showPreview"></div>-->
</script>
<script type="text/javascript">
(function (angular) {
    var prefKey = "udp";
    var propsToSave = ['sort', 'dir', 'tagLabels', 'likes'];
    var defaultSo = {sort: 'trace.updatedAt', dir: 'desc', likes: {}, tagLabels: []};

    function loadSearchOption() {
        var pref = kup.loadPreference(prefKey, {so: defaultSo});
        var res = {};
        angular.forEach(propsToSave, function (prop) {
            res[prop] = pref.so[prop];
        });
        res = $.extend(false, res, {page: 1, size: 10, tagCategory: "UserDefinedPage"});
        return res;
    }

    function saveSearchOption(searchOption) {
        var so = {};
        angular.forEach(propsToSave, function (prop) {
            so[prop] = searchOption[prop];
        });
//            console.debug("saveSo", so);
        kup.savePreference(prefKey, {so: so});
    }

    angular.module('qad.udp', ['ngRoute', 'qad.angular', 'ui.bootstrap', 'ui.select2'])
            .config(['$routeProvider', function Config($routeProvider) {
                $routeProvider
                        .when('/index', {controller: 'ListCtrl', templateUrl: 'list.html'})
                        .when('/tags/:tags', {controller: 'ListCtrl', templateUrl: 'list.html'})
                        .when('/delete/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/update/:id', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .when('/create', {controller: 'EditCtrl', templateUrl: 'edit.html'})
                        .otherwise({redirectTo: '/index'});
            }])
            .service('tagService', ['$http', function ($http) {
                this.loadTags = function (tagCategory) {
                    $http.get('${base}/utils/tag/controls.json?category=' + tagCategory)
                            .success(function (data) {
                            });
                }

            }])
            .controller('ListCtrl', ['$rootScope', '$scope', '$http', '$location', '$routeParams',
                function ListCtrl($rootScope, $scope, $http, $location, $routeParams) {
                        <@shiro.user>$rootScope.isUserLoggedIn = true;</@shiro.user>
                    $scope.allEntity = [];
                    $scope.so = loadSearchOption();
//                    alert($scope.so.tagLabels.length);
//                    console.debug($scope.so.tagLabels.length);

                    $scope.showMoreFilter = ktl.isNotBlank($scope.so.likes.title) || $scope.so.tagLabels.length > 0;
//                    console.debug("showMoreFilter",$scope.showMoreFilter,$scope.so.tagLabels);
                    $scope.sortFields = {'trace.updatedAt': '修改时间', 'trace.createdBy': '作者', 'title': '标题'};
                    $scope.actionCreate = function () {
                        $location.path("/create");
                    };
                    $scope.$on('$routeChangeSuccess', function () {
                        var tags = $routeParams.tags;
                        if (ktl.isNotBlank(tags)) {
                            var array = tags.split(",");
                            $scope.so.tagLabels = _.remove(array, function (t) {
                                return t != "";
                            });
//                                console.debug("array",$scope.so.tagLabels);
                        }
                    });
                    $scope.actionChangePage = function (page) {
                        $scope.so.page = page;
                        saveSearchOption($scope.so);
                        fetchData();
                    };
                    $scope.actionFilterTag = function (tagLabel) {
                        var index = $scope.so.tagLabels.indexOf(tagLabel);
                        if (index >= 0) {
                            $scope.so.tagLabels.splice(index, 1);
                        } else {
                            $scope.so.tagLabels.push(tagLabel);
                        }
                        var tagStr = $scope.so.tagLabels.join(",");
                        saveSearchOption($scope.so);
                        $location.path("/tags/" + tagStr);
//                        $scope.so.tags = $scope.so.tagLabels.join(",");
//                        $scope.so.tagCategor="report";
//                        fetchData();
                    };
                    $scope.actionSort = function (sort) {
                        $scope.so.sort = sort;
                        $scope.so.dir = $scope.so.dir == "asc" ? "desc" : "asc";
                        saveSearchOption($scope.so);
                        fetchData();
                    };
                    $scope.actionFilter = function () {
//                        console.debug("filter");
//                        if (ktl.isBlank($scope.so.likes.title)) {
//                            $scope.so.likes = {};
//                        } else {
//                            $scope.so.likes.title = $scope.filterTitle;
//                        }
                        saveSearchOption($scope.so);
                        fetchData();
                    };

                    function markSelectedTags() {
                        angular.forEach($scope.allTags, function (tag, index) {
                            tag.isSelected = $scope.so.tagLabels.indexOf(tag.label) >= 0;
                        });
                    }

                    $http.get('${base}/utils/tag/controls.json?category=UserDefinedPage').success(function (data) {
                        $scope.allTags = data.tags;
                        markSelectedTags();
                    });

                    function fetchData() {
                        $http.post('${base}/udr/page/list.json', {so: $scope.so})
                                .success(function (data) {
                                    var allEntity = data.allEntity;
                                    angular.forEach(allEntity, function (value, index) {
                                        value.allowEdit = (value.trace.createdBy ==${(Session.user.id)!-100});
                                        <@shiro.hasPermission name="udr-page:admin">
                                            value.allowEdit = true;
                                        </@shiro.hasPermission>
                                    });
                                    $scope.allEntity.splice(0, $scope.allEntity.length);
                                    for (var i = 0; i < allEntity.length; i++) {
                                        $scope.allEntity.push(allEntity[i]);
                                    }
                                    $scope.so = data.so;
                                    markSelectedTags();
                                });
                    }

                    $scope.actionDelete = function (udp) {
                        if (confirm("确定要删除吗?")) {
                            $http.post('${base}/udr/page/delete_do.json?id=' + udp.id).success(function () {
                                kui.showToast('success', '已删除' + udp.title);
                                fetchData();
                            });//.error(function(data){logger.debug(data)});
                        }
                    };
                    fetchData();
                }])
            .controller('EditCtrl', ['$scope', '$http', '$routeParams', '$route', '$location',
                function EditCtrl($scope, $http, $routeParams, $route, $location) {
                    /**
                     * Setup options for select2 for auto completion of tag list
                     * @param tagCategory tag category
                     * @returns {{createSearchChoice: createSearchChoice, ajax: {url: string, dataType: string, quietMillis: number, cache: boolean, data: data, results: results}, multiple: boolean, simple_tags: boolean, tokenSeparators: string[]}}
                     */
                    function setupSelect2Options(tagCategory) {
                        return {
                            createSearchChoice: function (term) {
                                return {
                                    id: term,
                                    text: term
                                };
                            },
                            ajax: {
                                url: '${base}/utils/tag/controls.json',
                                dataType: "json",
                                quietMillis: 300,
                                cache: true,
                                data: function (term, page) {
                                    return {category: tagCategory};
                                },
                                results: function (data, pageNo) {
                                    var tagLabels = [];
                                    angular.forEach(data.tags, function (tag) {
                                        tagLabels.push({id: tag.label, text: tag.label});
                                    });
                                    return {results: tagLabels, more: false};
                                }
                            },
                            'multiple': true,
                            'simple_tags': true,
                            'tokenSeparators': [",", " "]};
                    }

                    $scope.select2Options = setupSelect2Options("UserDefinedPage");
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
})(angular);
</script>
</@ui.page>