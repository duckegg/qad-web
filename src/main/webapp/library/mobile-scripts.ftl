<#--
********************************************************************************
@desc Script includes mobile used JavaScripts and css
@author Leo Liao, 2012/11/23, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<link rel="shortcut icon" href="${base}/media/app/images/favicon.png"/>
<#--============================================================================
                                  CORE
=============================================================================-->
<#--======= jquery mobile  =======-->
<script type="text/javascript" src="${base}/media/jquery/jquery.min.js"></script>
<link rel="stylesheet" href="${base}/media/mobile/jquery.mobile-1.2.0.css"/>
<link rel="stylesheet" href="${base}/media/mobile/jquery.mobile.theme-1.2.0.css"/>
<script type="text/javascript" src="${base}/media/mobile/jquery.mobile-1.2.0.js"></script>


<#--======= jqplot =======-->
<!--[if lt IE 9]>
<script type="text/javascript" src="${base}/media/jqplot/excanvas.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${base}/media/jqplot/jquery.jqplot.custom.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/jqplot.dateAxisRenderer.custom.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.pieRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.categoryAxisRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.pointLabels.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.canvasTextRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.canvasAxisTickRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.cursor.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.highlighter.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.dragable.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.json2.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/jqplot.enhancedLegendRenderer.leo.js"></script>
<link rel="stylesheet" type="text/css" href="${base}/media/jqplot/jquery.jqplot.custom.css"/>

<#--============================================================================
                              APP OVERRIDES
=============================================================================-->
<link rel="stylesheet" href="${base}/media/app/css/mobile-site.css"/>
<script type="text/javascript" src="${base}/media/app/js/app-util.js"></script>
<#--<script type="text/javascript" src="${base}/media/app/app-events.js"></script>-->
<script type="text/javascript" src="${base}/media/app/js/app-ui.js"></script>
<script type="text/javascript" src="${base}/media/app/js/app-ui-mobile.js"></script>

<script type="text/javascript">
    $.ajaxSetup({
        headers:{"Device-Type":"mobile"}
    });
</script>