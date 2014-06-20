/**
 * Angular modules
 * @author Leo Liao, created 2014/4/11.
 */
(function (angular, $, kui) {
    'use strict';
    angular.module('qad.angular', [])
        .config(['$httpProvider', function ($httpProvider) {
            $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
            $httpProvider.responseInterceptors.push(['$rootScope', '$q', function ($rootScope, $q) {
                function success(response) {
                    return response;
                }

                function error(response) {
                    console.debug("response",response);
                    kui.showAjaxError(response);
                    // otherwise
                    return $q.reject(response);
                }

                return function (promise) {
                    return promise.then(success, error);
                };

            }]);
        }])
        .directive('kuiTabbableForm', function () {
            return {
                restrict: 'A',
                link: function (scope, element, attrs) {
                    return $(element).kuiTabForm();
                }
            };
        })
        .directive('kuiHoverToolbar', function () {
            return {
                restrict: 'A',
                link: function (scope, element, attrs) {
                    var $elem = $(element);
                    $elem.hide();
                    var $container = $elem.closest('.kui-toolbar-container');
                    if ($container.length > 0) {
                        $container.on({mouseenter: function () {
                            $(element).show();
                        }, mouseleave: function () {
                            $(element).hide();
                        }});
                    }
                }
            };
        })
        .config(['$routeProvider', '$locationProvider', function ($routeProvider, $locationProvider) {
            $locationProvider.html5Mode(false).hashPrefix('!');
        }]);
})(angular, jQuery, kui);