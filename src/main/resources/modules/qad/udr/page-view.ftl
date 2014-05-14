<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/12, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udp-view-${id}"/>
<@ui.page id=pageId title=thisEntity.title>
<#--
Pjax will cause this problem!

Error: $rootScope:infdig
Infinite $digest Loop
10 $digest() iterations reached. Aborting!
Watchers fired in the last 5 iterations: [["fn: function (){var a=d.url(),b=h.$$replace;m&&a==h.absUrl()||(m++,c.$evalAsync(function(){c.$b
Description
This error occurs when the application's model becomes unstable and each $digest cycle triggers a state change and subsequent $digest cycle. Angular detects this situation and prevents an infinite loop from causing the browser to become unresponsive.

For example, the situation can occur by setting up a watch on a path and subsequently updating the same path when the value changes.

$scope.$watch('foo', function() {
  $scope.foo = $scope.foo + 1;
});
One common mistake is binding to a function which generates a new array every time it is called. For example:

<div ng-repeat="user in getUsers()">{{ user.name }}</div>

...

$scope.getUsers = function() {
  return [ { name: 'Hank' }, { name: 'Francisco' } ];
};
Since getUsers() returns a new array, Angular determines that the model is different on each $digest cycle, resulting in the error. The solution is to return the same array object if the elements have not changed:

var users = [ { name: 'Hank' }, { name: 'Francisco' } ];

$scope.getUsers = function() {
  return users;
});
The maximum number of allowed iterations of the $digest cycle is controlled via TTL setting which can be configured via $rootScopeProvider.
-->
<a href="${base}/udr/page#!/update/${id}" class="btn btn-default" data-pjax-disabled>Edit</a>
    <#include "/"+fmTemplateName/>
</@ui.page>
