<#--
********************************************************************************
@desc default sitemesh decorator file
@author Leo Liao, 2012/05/03, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<!DOCTYPE html>
<html>
<head>
    <title>看板 ${title}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
<#include "/library/scripts-qadweb.ftl" parse=true/>
    <script type="text/javascript">
        piwikTrackLink();
    </script>
${head}
</head>
<body data-pjax class="page-fixed-header">
<div class="page-wrapper">
    <div class="page-header navbar navbar-inverse navbar-fixed-top">
    <#include "navbar-qadweb.ftl"/>
    </div>
    <div class="page-container">
        <nav id="page-sidebar-left" class="page-sidebar page-sidebar-left">
        <#include "sidebar-qadweb.ftl" parse=true/>
        </nav>
        <div id="body-content" class="page-content container-fluid">
            <h1 class="page-title">${title}</h1>
        <#include "body-content.ftl" parse=true/>
        </div>
    </div>
    <div class="page-footer"><#include "footer-qadweb.ftl"/></div>
</div>
</body>
</html>