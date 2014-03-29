<#--
********************************************************************************
@desc Decorator file for mobile view
@author Leo Liao, 2012/11/23, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<!DOCTYPE html>
<html>
<head>
    <title>自动化看板 ${title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
<#include "/library/mobile-scripts.ftl" parse=true/>
${head}
</head>
<body>
<div data-role="page">
    <div data-role="header">
        <h1>看板Mobile</h1>
        <a href="${base}/m" data-icon="home" data-iconpos="notext" data-direction="reverse">Home</a>
    <#--<a href="#" data-icon="search" data-iconpos="notext" data-rel="dialog" data-transition="fade">Search</a>-->
        <a href="${base}/d" data-icon="grid" data-ajax-link="false">桌面版本</a>
    </div>
    <div data-role="content" class="content">
    <#include "body-content.ftl" parse=true/>
    </div>
</div>
</body>
</html>