<#--
********************************************************************************
@desc Freemarker macro to build chart. Some logic is placed in app-ui.js
@author Leo Liao, 2012/05/22, created
********************************************************************************
-->
<#--
================================================================================
Build date type line chart.
The data from two possible sources in priority: ajaxForm > ajaxUrl+ajaxParam
@param xAxisInterval string, possible value of `"1 day", "x days", "1 week", "x weeks", "1 month", "x months"`.
                     Blank value will auto scale x-axis. NOT WORK NOW!
@param xAxisFormat string, combination of `"%Y|%y"(year),"%m"(month),"%d"(day),"%H"(hour),"%M"(minute),"%S"(second)`
@param legendShow boolean, `true|false(default)`
@param legendPosition string, `nw,n,ne,e,se,s,sw,w`
@param legendPlacement string,
  - "insideGrid" places legend inside the grid area of the plot.
  - "outsideGrid" places the legend outside the grid but inside the plot container, shrinking the grid to accomodate the legend.
  - "inside" synonym for "insideGrid",
  - "outside" places the legend ouside the grid area, but does not shrink the grid which can cause the legend to overflow the plot container.
@param markerSize integer, size of the marker (diameter or circle, length of edge of square, etc.)
@param markerShow boolean, `true|false(default)`, to show marker
@param allowZooming boolean, `true|false(default)`
@param size(DEPRECATED) use markerSize
@param show(DEPRECATED) use markerShow
================================================================================
-->
<#macro lineChart id title ajaxUrl="" ajaxParam="" ajaxForm=""
xAxisInterval="" xAxisFormat="%m-%d" xAxisShowGridline=false yAxisShowGridline=false maxIsNow=false
legendShow=false legendPosition="e" legendPlacement="outsideGrid"
markerShow=false markerSize=9 show="false" size=4
allowZooming=false>
    <#assign aDateTime = .now>
    <#assign  aDate = aDateTime?date>
    <@_createChartContainer id=id title=title/>
<script type="text/javascript">
    $(function () {
        var chartOptions = {
            kuiExtraChartOptions: {
                showSeriesInTooltip: true,
                chartAjaxUrl: "${ajaxUrl}",
                chartAjaxParam: "${ajaxParam}",
                chartAjaxForm: "${ajaxForm}"
            },
            seriesDefaults: {
                renderer: $.jqplot.LineRenderer,
                markerOptions: {
                    style: 'filledCircle',
                    kuiFillColor: '#fff',
                    lineWidth: 2, //LEO: lineWidth<1 will omit, Leo modified jquery.jqplot.leo.js
                    size:${markerSize},
                    show:${markerShow?string}
                }
            },
            <@_prepareLegendJs legendShow=legendShow legendPlacement=legendPlacement legendPosition=legendPosition/>
            <#if allowZooming>
                cursor: {
                    show: false,
                    zoom: true
                },
            </#if>
            axes: {
                xaxis: {
                    tickOptions: { showGridline: ${xAxisShowGridline?string}, formatString: "${xAxisFormat}" },
                    renderer: $.jqplot.DateAxisRenderer
                    <#if maxIsNow>, max: "${aDate?iso_utc}"</#if>
                },
                yaxis: {
                    tickOptions: { showGridline: ${yAxisShowGridline?string}}
                }
            }
        };
        plotChart("${id}", chartOptions, "line");
    });
</script>
</#macro>
<#--
================================================================================
Build bar chart.
@param rotateAxisLabel Possible value of "x"
@param barWidth string, bar width in pixel
@param legendShow boolean, true|false(default)
@param legendPosition string, "nw,n,ne,e,se,s,sw,w"
@param legendPlacement string,
  - "insideGrid" places legend inside the grid area of the plot.
  - "outsideGrid" places the legend outside the grid but inside the plot container, shrinking the grid to accomodate the legend.
  - "inside" synonym for "insideGrid",
  - "outside" places the legend ouside the grid area, but does not shrink the grid which can cause the legend to overflow the plot container.
@param barDirection string, "vertical,horizontal"
@param barWidth integer, width of bar
@param xAxisTickAngle integer, angle of text measured clockwise from x axis.
@param xAxisTickSize string, CSS spec for font size of x axis tick.
@param showPointLabel boolean, true|false(default), if show value label of points
@param direction(DEPRECATED) use barDirection
@param angle(DEPRECATED) use xAxisTickAngle
@param fontSize(DEPRECATED) use xAxisTickSize
@param show(DEPRECATED) use showPointLabel
================================================================================
-->
<#macro barChart id title ajaxUrl="" ajaxParam="" ajaxForm=""
rotateAxisLabel="" xAxisTickAngle=0 xAxisTickSize="10px" angle="-30" fontSize="10px"
xAxisShowGridline=false yAxisShowGridline=false
markerShow=false markerSize=9
showPointLabel=false show="false"
legendShow=false legendPosition="e" legendPlacement="outsideGrid"
barWidth=25 barDirection="vertical" direction="vertical"
>
    <@_createChartContainer id=id title=title/>
<script type="text/javascript">
    $(function () {
        var chartOptions = {
            kuiExtraChartOptions: {
                showSeriesInTooltip: true,
                chartAjaxUrl: "${ajaxUrl}",
                chartAjaxParam: "${ajaxParam}",
                chartAjaxForm: "${ajaxForm}"
            },
            seriesDefaults: {
                rendererOptions: {
                    barDirection: "${barDirection}",
                    barWidth:${barWidth}
                },
                renderer: $.jqplot.BarRenderer,
                pointLabels: {
                    show: ${showPointLabel?string}
                }
            },
            <@_prepareLegendJs legendShow=legendShow legendPlacement=legendPlacement legendPosition=legendPosition/>
            axes: {
                xaxis: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: {
                        <#if xAxisTickAngle!=0>
                            fontSize: '${xAxisTickSize}',
                            angle:${xAxisTickAngle},
                        </#if>
                        showGridline: ${xAxisShowGridline?string}
                    },
                    renderer: $.jqplot.CategoryAxisRenderer
                },
                yaxis: {
                    tickOptions: { showGridline: ${yAxisShowGridline?string}}
                }
            }
        };
        plotChart("${id}", chartOptions, "bar");
    });
</script>
</#macro>
<#--
================================================================================
Build pie chart.
@param legendShow boolean, `true|false(default)`
@param legendPosition string, `nw,n,ne,e,se,s,sw,w`
@param legendPlacement string,
  - "insideGrid" places legend inside the grid area of the plot.
  - "outsideGrid" places the legend outside the grid but inside the plot container, shrinking the grid to accomodate the legend.
  - "inside" synonym for "insideGrid",
  - "outside" places the legend ouside the grid area, but does not shrink the grid which can cause the legend to overflow the plot container.
================================================================================
-->
<#macro pieChart id title ajaxUrl="" ajaxParam="" ajaxForm=""
legendShow=true legendPosition="e" legendPlacement="insideGrid">
    <@_createChartContainer id=id title=title/>
<script type="text/javascript">
    $(function () {
        var chartOptions = {
            kuiExtraChartOptions: {
                showSeriesInTooltip: true,
                chartAjaxUrl: "${ajaxUrl}",
                chartAjaxParam: "${ajaxParam}",
                chartAjaxForm: "${ajaxForm}",
            },
            <@_prepareLegendJs legendShow=legendShow legendPlacement=legendPlacement legendPosition=legendPosition/>
            seriesDefaults: {
                renderer: $.jqplot.PieRenderer,
                rendererOptions: {showDataLabels: true, sliceMargin: 2}
            },
            highlighter: {
                useAxesFormatters: false // Default is true. If true, pie chart tooltip will not work
            }
        };
        plotChart("${id}", chartOptions, "pie");
    });
</script>
</#macro>
<#-- Create a div as chart container -->
<#macro _createChartContainer id title>
<div id="${id}_wrapper">
    <div id="${id}" data-title="${title}" <#--data-plot-->>
        <div id="${id}_target"></div>
    </div>
</div>
</#macro>
<#macro _prepareLegendJs legendShow legendPosition legendPlacement>
legend: {
placement: "${legendPlacement}",
show: ${legendShow?string},
location: '${legendPosition}'
},
</#macro>