<#--
********************************************************************************
@desc decorate only content for linked by external system, no sidebar, header, footer.
@author Leo Liao, 2012/07/04, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<!DOCTYPE html>
<html>
<head>
    <title>自动化看板 ${title}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<#include "/library/scripts.ftl" parse=true/>
    <script type="text/javascript">
        piwikTrackLink();
    </script>
${head}
</head>
<body class="outlink">
<div class="container">
    <div id="global-message-bar" style="display:none"></div>
<#--<div id="global-status-bar" style="display:none"></div>-->
    <table id="body">
        <tr>
            <td id="body-content" tabindex="0" accesskey="m">
                <h1 class="page-title">${title}</h1>
            <#include "body-content.ftl" parse=true/>
            </td>
        </tr>
    </table>
</div>
</body>
</html>