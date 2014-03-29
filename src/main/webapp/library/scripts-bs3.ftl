<#--
********************************************************************************
@desc Script includes commonly used JavaScripts and css
@author Leo Liao, 2012/05/03, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<link rel="shortcut icon" href="${base}/media/app/images/favicon.png"/>
<#--===========================      CORE       =============================-->
<script type="text/javascript" src="${base}/media/jquery/jquery-1.10.1.leo.js"></script>
<script type="text/javascript" src="${base}/media/jquery/jquery-migrate-1.2.1.leo.js"></script>
<script type="text/javascript" src="${base}/media/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="${base}/media/jquery/jquery.ba-bbq.js"></script>
<script type="text/javascript" src="${base}/media/jquery/jquery.pjax.js"></script>

<#--============================   UI  FRAMEWORK  ===========================-->
<script type="text/javascript" src="${base}/media/jquery/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${base}/media/jquery/jquery.ui.datepicker-zh-CN.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/jquery/themes/smoothness/jquery-ui-1.10.2.custom.css"/>
<#-- bootstrap -->
<link rel='stylesheet' type='text/css' href='${base}/media/bootstrap3/css/bootstrap.min.css'/>
<script type="text/javascript" src="${base}/media/bootstrap3/js/bootstrap.min.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/bs3-ext/css/jasny-bootstrap.css"/>
<script type="text/javascript" src="${base}/media/bs3-ext/js/jasny-bootstrap.min.js"></script>
<#--<script type="text/javascript" src="${base}/media/bootstrap/ext/jasny-bootstrap.min.js"></script>-->
<#-- fontawesome and icomoon -->
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/icomoon/style.css"/>
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/fontawesome/css/font-awesome.min.css"/>
<#--<link type="text/css" rel="stylesheet" media="all" href="${base}/media/fontawesome/css/font-awesome.min.css"/>-->
<#--========================   TABLE AND CHART   ============================-->
<#-- datatable -->
<script type="text/javascript" src="${base}/media/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="${base}/media/datatables/TableTools.min.js"></script>
<script type="text/javascript" src="${base}/media/datatables/ColVis.min.js"></script>
<script type="text/javascript" src="${base}/media/datatables/datatables.plugin.js"></script>
<script type="text/javascript" src="${base}/media/datatables/KeyTable.js"></script>
<script type="text/javascript" src="${base}/media/datatables/jquery.dataTables.grouping.js"></script>
<script type="text/javascript" src="${base}/media/datatables/ColReorderWithResize.js"></script>
<script type="text/javascript" src="${base}/media/datatables/jquery.dataTables.rowReordering.js"></script>
<#-- jqplot -->
<!--[if lt IE 9]>
<script type="text/javascript" src="${base}/media/jqplot/excanvas.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${base}/media/jqplot/jquery.jqplot.leo.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.dateAxisRenderer.js"></script>
<#--<script type="text/javascript" src="${base}/media/jqplot/jqplot.dateAxisRenderer.custom.js"></script>-->
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.pieRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.categoryAxisRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.pointLabels.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.canvasTextRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.canvasAxisTickRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.canvasAxisLabelRenderer.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.cursor.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.highlighter.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.dragable.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/plugins/jqplot.json2.min.js"></script>
<script type="text/javascript" src="${base}/media/jqplot/jqplot.enhancedLegendRenderer.leo.js"></script>
<link rel="stylesheet" type="text/css" href="${base}/media/jqplot/jquery.jqplot.custom.css"/>
<#--=========================== FORM ELEMENTS ===============================-->
<script type="text/javascript" src="${base}/media/form/jquery.form.js"></script>
<#--<script type="text/javascript" src="${base}/media/form/jquery.form.custom.js"></script>-->
<script type="text/javascript" src="${base}/media/form/jquery.validate.min.js"></script>
<#--=========================== Sheepit ===============================-->
<script type="text/javascript" src="${base}/media/sheepIt/jquery.sheepItPlugin-1.1.1.min.js"></script>
<#-- date -->
<script type="text/javascript" src="${base}/media/datepicker/date.js"></script>
<script type="text/javascript" src="${base}/media/datepicker/daterangepicker.jQuery.custom.js"></script>
<link rel="stylesheet" href="${base}/media/datepicker/ui.daterangepicker.css" type="text/css"/>
<script type="text/javascript" src="${base}/media/timepicker/jquery-ui-timepicker-addon.js"></script>
<script type="text/javascript" src="${base}/media/timepicker/jquery-ui-sliderAccess.js"></script>
<link type="text/css" href="${base}/media/timepicker/jquery-ui-timepicker-addon.css"/>

<#--=========================   LIST AND TREE ===============================-->
<script type="text/javascript" src="${base}/media/list/list.min.js"></script>
<script type="text/javascript" src="${base}/media/list/jquery.carouFredSel-5.6.2-packed.js"></script>
<script type="text/javascript" src="${base}/media/select/select2.min.js"></script>
<script type="text/javascript" src="${base}/media/select/select2_locale_zh-CN.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/select/select2.css"/>
<script type="text/javascript" src="${base}/media/tree/jquery.tree.custom.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/tree/css/jquery.tree.css"/>
<#-- Smart Wizard -->
<link type="text/css" href="${base}/media/step/smart_wizard.css" rel="stylesheet">
<script type="text/javascript" src="${base}/media/step/jquery.smartWizard-2.0.js"></script>
<#--==========================   CANLENDAR ==================================-->
<link rel='stylesheet' type='text/css' href='${base}/media/calendar/fullcalendar.css'/>
<link rel='stylesheet' type='text/css' href='${base}/media/calendar/fullcalendar.print.css' media="print"/>
<script type='text/javascript' src='${base}/media/calendar/fullcalendar.min.js'></script>
<#--==========================   EFFECTS  ===================================-->
<script type="text/javascript" src="${base}/media/jqModal/jqModal.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="${base}/media/jqModal/jqModal.css"/>
<#--==========================   UTILITIES   ================================-->
<script type="text/javascript" src="${base}/media/util/lodash.min.js"></script>
<script type="text/javascript" src="${base}/media/keyboard/jquery.scrollintoview.js"></script>
<script type="text/javascript" src="${base}/media/resize/jquery.ba-resize.js"></script>
<script type="text/javascript" src="${base}/media/util/jquery.sizes.js"></script>
<#--========================== APP OVERRIDES ================================-->
<link rel='stylesheet' type='text/css' href='${base}/media/app/css/basic.css'/>
<link rel='stylesheet' type='text/css' href='${base}/media/app/lib/kui.css'/>
<link rel='stylesheet' type='text/css' href='${base}/media/app/css/app.css'/>
<script type="text/javascript" src="${base}/media/app/js/qad-util.js"></script>
<script type="text/javascript" src="${base}/media/app/js/app-global.js"></script>
<script type="text/javascript" src="${base}/media/app/js/app-util.js"></script>
<script type="text/javascript" src="${base}/media/app/js/app-events.js"></script>
<script type="text/javascript" src="${base}/media/app/js/app-ui.js"></script>
<script type="text/javascript" src="${base}/media/app/js/app-ui-desktop.js"></script>

<#--============================================================================
                              INITIALIZATION
=============================================================================-->

<script type="text/javascript">
    $(function () {
        $.ajaxSetup({
            headers:{"Device-Type":"desktop"}
        });
    <#if Session??>
        <#if Session.debug??>
            $('.in-develop').show();
        </#if>
    </#if>
    });
</script>