<#---
Macro to build chart. Need work with [jqplot](http://www.jqplot.com) and javascript in qad-ui.js.

@namespace chart
@author Leo Liao, 2012/05/22, created
-->

<#---
Plot a line chart.

Chart data is fetched by AJAX. There are two ways to define AJAX query, `ajaxForm` or `ajaxUrl`+`ajaxParam`.
If both options are set, `ajaxForm` take override.

Chart legends are controlled by parameters legendXxx.

`legendPlacement` defines legend placement relative to chart
- `"insideGrid"` places legend inside the grid area of the plot.
- `"outsideGrid"` places the legend outside the grid but inside the plot container, shrinking the grid to accomodate the legend.
- `"inside"` synonym for "insideGrid",
- `"outside"` places the legend ouside the grid area, but does not shrink the grid which can cause the legend to overflow the plot container.

@param id {string} chart id
@param title {string} chart title
@param ajaxUrl {string} URL to fetch chart data
@param ajaxParam {String} query string for `ajaxURL`
@param ajaxForm {string} a form submitted to fetch chart data. This is prefered way to define ajax query.
@param legendShow {boolean} `true` to show legend
@param legendPosition {string} legend position, one value of `"nw"`,`"n"`,`"ne"`,`"e"`,`"se"`,`"s"`,`"sw"`,`"w"`
@param legendPlacement {string} legend placement relative to the chart
@param xAxisInterval {string} (NOT WORK NOW!) possible value of `"1 day"`, `"x days"`, `"1 week"`, `"x weeks"`, `"1 month"`, `"x months"`. Blank value will auto scale x-axis.
@param xAxisFormat {string} format of x-axis label, combination of `"%Y|%y"`(year),`"%m"`(month),`"%d"`(day),`"%H"`(hour),`"%M"`(minute),`"%S"`(second)
@param markerSize {integer} marker is a shape (circle,square) marked on a data point. This parameter defines marker size(diameter or circle, length of edge of square, etc.)
@param markerShow {boolean} `false`(default) to hide marker
@param allowZooming {boolean} `false`(default) to disable zoom the chat by mouse selection

@param size (DEPRECATED!) use markerSize
@param show (DEPRECATED!) use markerShow
-->
<#macro lineChart id title ajaxUrl="" ajaxParam="" ajaxForm=""
legendShow=false legendPosition="e" legendPlacement="outsideGrid"
xAxisInterval="" xAxisFormat="%m-%d" xAxisShowGridline=false yAxisShowGridline=false maxIsNow=false
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
                    show: true,
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
        kui.plotChart("${id}", chartOptions, "line");
    });
</script>
</#macro>
<#---
Plot a bar chart.

@param rotateAxisLabel Possible value of "x"
@param barWidth string, bar width in pixel
@param legendShow refer to line chart
@param legendPosition refer to line chart
@param legendPlacement refert to line chart
@param barDirection string, "vertical,horizontal"
@param barWidth integer, width of bar
@param xAxisTickAngle integer, angle of text measured clockwise from x axis.
@param xAxisTickSize string, CSS spec for font size of x axis tick.
@param showPointLabel boolean, true|false(default), if show value label of points

@param direction (DEPRECATED!) use barDirection
@param angle (DEPRECATED!) use xAxisTickAngle
@param fontSize (DEPRECATED!) use xAxisTickSize
@param show (DEPRECATED!) use showPointLabel
-->
<#macro barChart id title ajaxUrl="" ajaxParam="" ajaxForm=""
legendShow=false legendPosition="e" legendPlacement="outsideGrid"
rotateAxisLabel="" xAxisTickAngle=0 xAxisTickSize="10px" angle="-30" fontSize="10px"
xAxisShowGridline=false yAxisShowGridline=false
markerShow=false markerSize=9
showPointLabel=false show="false"
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
        kui.plotChart("${id}", chartOptions, "bar");
    });
</script>
</#macro>
<#---
Plot a pie chart.

@param id {string} chart id
@param title {string} chart title
@param legendShow refer to line chart
@param legendPosition refer to line chart
@param legendPlacement refert to line chart
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
                chartAjaxForm: "${ajaxForm}"
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
        kui.plotChart("${id}", chartOptions, "pie");
    });
</script>
</#macro>

<#---
Create a div as chart container
@internal
-->
<#macro _createChartContainer id title>
<div id="${id}_wrapper">
    <div id="${id}" data-title="${title}" <#--data-plot-->>
        <div id="${id}_target"></div>
    </div>
</div>
</#macro>

<#---
Prepare javascript for legend
@internal
-->
<#macro _prepareLegendJs legendShow legendPosition legendPlacement>
legend: {
placement: "${legendPlacement}",
show: ${legendShow?string},
location: '${legendPosition}'
},
</#macro>