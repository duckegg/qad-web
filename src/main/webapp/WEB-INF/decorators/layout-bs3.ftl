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
<#include "/library/scripts-bs3.ftl" parse=true/>
    <script type="text/javascript">
        piwikTrackLink();
    </script>
${head}
</head>
<body class="page-wrapper" data-pjax>
<div class="page-header navbar navbar-inverse">
<#include "navbar.ftl"/>
</div>
<div class="page-container row-fluid">
    <div class="page-sidebar nav-collapse collapse tabs-top" data-pjax>
    <#include "sidebar.ftl" parse=true/>
    </div>
    <div class="page-content container-fluid">
        <div class="row-fluid">
            <div id="body-content">
                <h1 class="page-title">${title}</h1>
            <#include "body-content.ftl" parse=true/>
            </div>
        </div>
    </div>
</div>
<div class="page-footer"><#include "footer.ftl"/></div>
<div id="global-message-bar" style="display:none"></div>
<div id="global-dialog" style="display:none"></div>
</body>
</html>