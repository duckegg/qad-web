/*******************************************************************************
 *
 * JavaScript for UI. It may be extended by app.ui.desktop and app.ui.mobile.
 *
 * @author Leo Liao, 2012/05, created
 * @author Leo Liao, 2012/11/25, add UiKit
 *
 ******************************************************************************/

//==============================================================================
//                                 UI KIT
//==============================================================================
function UiKit() {
    this.type = "";
    this.getUiType = function () {
        return this.type;
    };
    this.initPage = function (pageSelector) {
        if (qadUtil.isBlank(pageSelector)) {
            logger.error("Argument 'pageSelector' cannot be empty for function initPage()");
            return;
        }
        var $page = $(pageSelector);
        if ($page.length == 0) {
            logger.error("UiKit.initPage: Cannot find page by selector " + pageSelector);
            return;
        }
        this.uiBuildCollapsibleForm($page);
        this.uiBuildCollapsible($page);
        this.uiBuildPortlet($page);
        this.uiLoadPanelContent($page);
        this.uiBuildDateTimeRange($page);
        $('select.select2', $page).select2();
        $('.action-tabs:visible', $page).kuiActionTabs();
        $('.nav[data-ajax],.nav[data-ajax-nav]', $page).kuiAjaxNav();
        $('.nav-list-tree', $page).kuiListTree();
    };

    this.uiLoadPanelContent = function (selector) {
        $('.panel[data-kui-content-url]:not(.portlet)', selector).each(function () {
            var $this = $(this);
            var url = $this.data('kui-content-url');
            if (qadUtil.isNotBlank(url) && isValidAjaxUrl(url)) {
                $('.panel-body', $this).load(url);
            }
        });
    };
    this.uiBuildCollapsibleForm = function (selector) {
        $('.kui-collapsible-form fieldset', selector).collapsibleForm();
    };
    this.uiBuildSidebar = function (selector) {
        return $(selector).each(function () {
            var $navTree = $(this);
            if ($navTree.not('ul'))
                $navTree = $navTree.find('ul.nav-list-tree');

            sbHighlightMatch();
            sbRegisterEvents();
            var sidebarOpen = qadPref.loadPreference("sidebarOpen", true);
            sbToggleSidebar(sidebarOpen);

            function sbToggleSidebar(toOpen) {
                $(".sidebar-search").toggleClass("open", toOpen);
                $(".page-container").toggleClass("sidebar-closed", !toOpen);
            }

            function sbRegisterEvents() {
                // handle sidebar show/hide
                $('.sidebar-toggler').on('click.kui', function (e) {
                    var toOpen = $(".page-container").hasClass("sidebar-closed");
                    qadPref.savePreference("sidebarOpen", toOpen);
                    sbToggleSidebar(toOpen);
                    e.preventDefault();
                });
            }

            function sbHighlightMatch() {
                var matched = null;
                $('li a', $navTree).each(function (index) {
                    var key = $(this).data("menu-key");
                    if (qadUtil.isBlank(key))
                        key = $(this).attr("href");
                    var loc = decodeURIComponent(document.location.href);
                    if (loc.indexOf(key) > 0) {
                        if (matched == null) {
                            matched = $(this);
                        } else if (key.length > matched.attr("href").length) {
                            matched = $(this); // Longest match
                        }
                    }
                });
                if (matched != null) {
                    $navTree.kuiListTree("activateItem", matched.closest("li"));
                }
            }
        });
    };
    this.uiBuildCollapsible = function (selector) {
        var $container = $('[data-role="collapsible"],.accordion', $(selector))
            .addClass('dropdown dropdown-form');
        var $toggler = $container.children('h3')
            .addClass('dropdown-toggle').attr('data-toggle', "dropdown")
            .attr('tabindex', '0').attr('accesskey', 'v');
        var $content = $toggler.next().addClass('dropdown-menu').attr('role', 'menu');
        // Fix input element click problem in dropdown
        $content.on('click.kui', 'label,select,input,span', function (e) {
            e.stopPropagation();
        });
    };
    this.uiBuildDateTimeRange = function (selector) {
        var $datepicker = $("input.daterange", selector);
        if ($datepicker.length > 0)
            $datepicker.daterangepicker({dateFormat: 'yy-mm-dd'});

        var $start = $('input.datetimepicker.start:not(readonly)', selector);
        var $end = $('input.datetimepicker.end:not([readonly])', selector);
        if ($start.length == 0)
            return;
        if ($end.length == 0)
            return;

        $start.datetimepicker({
            onClose: function (dateText, inst) {
                if ($end.val() != '') {
                    var testStartDate = $start.datetimepicker('getDate');
                    var testEndDate = $end.datetimepicker('getDate');
                    if (testStartDate > testEndDate)
                        $end.datetimepicker('setDate', testStartDate);
                }
                else {
                    $end.val(dateText);
                }
            },
            onSelect: function (selectedDateTime) {
                $end.datetimepicker('option', 'minDate', $start.datetimepicker('getDate'));
            }
        });
        $end.datetimepicker({
            onClose: function (dateText, inst) {
                if ($start.val() != '') {
                    var testStartDate = $start.datetimepicker('getDate');
                    var testEndDate = $end.datetimepicker('getDate');
                    if (testStartDate > testEndDate)
                        $start.datetimepicker('setDate', testEndDate);
                }
                else {
                    $start.val(dateText);
                }
            },
            onSelect: function (selectedDateTime) {
                $start.datetimepicker('option', 'maxDate', $end.datetimepicker('getDate'));
            }
        });
    };
    this.uiBuildPortlet = function (key) {
        alert("Need be implemented by subclass");
    };
}

//==============================================================================
//                                 CHART
//==============================================================================

/**
 * Get a plot object
 * @param chartId
 * @return {*}
 * @private
 */
function _getPlot(chartId) {
    return AppRuntime.jqPlots[chartId];
}

/**
 * Calculate color
 * http://www.sitepoint.com/javascript-generate-lighter-darker-color/
 * @param hex
 * @param lum
 * @return {String}
 * @private
 */
function _colorLuminance(hex, lum) {
    // validate hex string
    hex = String(hex).replace(/[^0-9a-f]/gi, '');
    if (hex.length < 6) {
        hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }
    lum = lum || 0;
    // convert to decimal and change luminosity
    var rgb = "#", c, i;
    for (i = 0; i < 3; i++) {
        c = parseInt(hex.substr(i * 2, 2), 16);
        c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
        rgb += ("00" + c).substr(c.length);
    }
    return rgb;
}


/**
 * Replot a chart
 * @param chartId
 */
function replotChart(chartId) {
    var plot = _getPlot(chartId);
    //TODO: quick and dirt to replot
    plotChart(chartId, plot._chartOptions, plot._chartType);
}


/**
 * Plot chart. Used with FreeMarker macro pieChart, lineChart and barChart.
 * @param chartId div id of the chart
 * @param chartOptions jqPlot options with custom kuiExtraChartOptions
 * @param chartType "bar", "line", "pie"
 */
function plotChart(chartId, chartOptions, chartType) {
    var kuiOptions = chartOptions.kuiExtraChartOptions;
    var chartArgument = {_chartOptions: chartOptions, _chartType: chartType};
    var $chartDiv = $('#' + chartId);
    var chartTitle = $("#" + chartId).data('title');
    var DISPLAY_TOOLBAR = true;
    var prefKey = "chart_" + chartId;
    var pref = qadPref.loadPreference(prefKey, {});

    //------------------------------------------
    // Default options for all kinds of charts
    //------------------------------------------
    var DEFAULT_OPTIONS = {
        title: chartTitle,
        legend: {
            show: false,
            renderer: $.jqplot.EnhancedLegendRenderer,
            rendererOptions: {
                numberRows: null
            },
            location: 'nw',
            showSwatch: true,
//            border: "1",
            seriesToggle: 'fast'
        },
        grid: {
            borderWidth: 0,
            shadow: false,
            background: 'rgba(0,0,0,0)'
        },
        highlighter: {
            //LEO: undocumented property to customize tooltip, please refer to source code of jqplot.highlighter.js
            tooltipContentEditor: jqplotTooltip,
            show: true,
            tooltipFadeSpeed: "fast"
        },
        cursor: {
            show: false
        },
        seriesDefaults: {
            shadow: false, // show shadow or not.
            markerOptions: {
                show: false,
                shadow: false
            },
            rendererOptions: {
                animation: {
//                    show: true
                }
            }
        },
        axes: {
            xaxis: {
                tickOptions: {
                    showGridline: false
                }
            },
            yaxis: {
                tickOptions: {
                    showGridline: false
                }
            }
        }
    };

    // Local variable allOptions is assigned to hold all plot options
    var allOptions = chartOptions;

    //------------------------------------------
    /*--- Highlight color ---*/
    //------------------------------------------
    function assignHighlightColors(chartType) {
        if (chartType === "pie") {
            var highlightColors = [];
            for (var index in AppRuntime.charting.colorScheme) {
                var color = AppRuntime.charting.colorScheme[index];
                highlightColors[index] = _colorLuminance(color, 0.15);
            }

            if (typeof allOptions.seriesDefaults !== "undefined") {
                if (typeof allOptions.seriesDefaults.rendererOptions !== "undefined") {
                    allOptions.seriesDefaults.rendererOptions.highlightColors = highlightColors;
                }
            }
        }
    }

    assignHighlightColors(chartType);

    //------------------------------------------
    /*--- Fetch plot data ---*/
    //------------------------------------------
    var plotData = fetchPlotData(chartOptions);
    if (plotData == null)
        return;

    //------------------------------------------
    // Wrap chart div
    //------------------------------------------
    var wrapperId = chartId + "_wrapper";
    var targetId = chartId + '_target';
    var $targetDiv = $('#' + targetId).empty().css("height", "100%");
    // Make them full height
    $('#' + wrapperId).css("height", "100%").addClass('chart-wrapper')
        .on({mouseenter: function () {
//            $(this).find('.chart-controls').show();
        }, mouseleave: function () {
//            $(this).find('.chart-controls').hide();
        }});
    $('#' + chartId).css("height", "100%");

    //------------------------------------------
    // Check error or empty data
    //------------------------------------------
    var isEmptyChart = false;
    var emptyChartMessage = "";
    if (isNotBlank(plotData.error)) {
        isEmptyChart = true;
        emptyChartMessage = plotData.error;
        // If no data returned, display no data
        $targetDiv.addClass("jqplot-target").append(
                '<div class="jqplot-title">' + chartTitle + '</div><div style="text-align: center;padding-top:1em;">' + emptyChartMessage + '</div>');
        AppRuntime.jqPlots[chartId] = $.extend(true, {isError: true}, chartArgument);
        return;
    }

    // Combine chart options with priority: plotData (server data) > allOptions (custom options) > DEFAULT_OPTIONS
    allOptions = $.extend(true, {}, DEFAULT_OPTIONS, allOptions, plotData);
    allOptions.legend.rendererOptions.numberRows = allOptions.legend.location == "s" || allOptions.legend.location == "n" ? 1 : null;
//    console.log("plotChart.allOptions", allOptions);

    //------------------------------------------
    // Create plot and save it in global variable
    //------------------------------------------
    //*******************************************
    var thePlot = $.jqplot(targetId, plotData.data, allOptions);
    AppRuntime.jqPlots[chartId] = $.extend(true, thePlot, chartArgument);
    //*******************************************


    // Save original dimensions
    if (qadUtil.isBlank($targetDiv.data("old-height")))
        $targetDiv.data("old-height", $targetDiv.height());
    if (qadUtil.isBlank($targetDiv.data("old-width")))
        $targetDiv.data("old-width", $targetDiv.width());

    //------------------------------------------
    // Determine Chart Type
    //------------------------------------------
    var isPieChart = false, isBarChart = false, isLineChart = false;
    var renderer = AppRuntime.jqPlots[chartId].series[0].renderer;
    if (renderer._hiBandGridData === undefined) {
        isPieChart = true;
    } else if (renderer.smooth === undefined) {
        isBarChart = true;
    } else {
        isLineChart = true;
    }

    //------------------------------------------
    // Activate theme
    //------------------------------------------
    var chartTheme = {seriesStyles: {seriesColors: AppRuntime.charting.colorScheme}};
    if (chartTheme != null) {
        AppRuntime.jqPlots[chartId].themeEngine.newTheme('myStyle', chartTheme);
        // TODO AND NOTE
        // if not use plot.activateTheme, piechart chartTheme can not be applied
        // if use plot.activateTheme, barchart x-axis label can not be displayed
        if (isPieChart)
            AppRuntime.jqPlots[chartId].activateTheme('myStyle');
    }

    /**
     * Shorten legend labels, apply CSS styles.
     */
    function formatChartLegend($chartDiv, allOptions) {
//        $chartDiv.find('td.jqplot-table-legend-label').each(function () {
//            var text = $(this).text();
//            $(this).html('<a href="javascript:void(0);" title="' + text + '">' + $(this).text() + '</a>');
//        });
        var $legendTable = $('table.jqplot-table-legend', $chartDiv);
        if ($legendTable.length > 0) {
            if (!allOptions.legend.show) {
                $legendTable.hide();
            }
            var location = allOptions.legend.location;
            if (location == "n" || location == "s") {
                $legendTable.addClass("kui-chart-legend-horizontal");
            }
        }

    }

    formatChartLegend($chartDiv, allOptions);
    //------------------------------------------
    // Post plot: create action toolbar
    //------------------------------------------
    if (DISPLAY_TOOLBAR) {
        createToolbar(chartId);
    }

    //
    /**
     * Now bind function to the highlight event to show the tooltip and highlight the row in the legend.
     */
    function processHighlight() {
        var highlight = 'highlight';
        var legendTds = $targetDiv.find('table.jqplot-table-legend td');
        if (isBarChart || isPieChart) {
            $targetDiv.bind('jqplotDataHighlight',
                function (ev, seriesIndex, pointIndex, data, radius) {
                    // Pie chart has only one single series
                    legendTds.removeClass(highlight).eq(isPieChart ? pointIndex * 2 + 1 : seriesIndex * 2 + 1).addClass(highlight);
                });
            //Bind a function to the unhighlight event to clean up after highlighting.
            $targetDiv.bind('jqplotDataUnhighlight',
                function (ev, seriesIndex, pointIndex, data) {
                    legendTds.removeClass(highlight);
                });
        }
        else if (isLineChart) {
            // Event jqplotDataHighlight does not work for line chart, use jqplotDataMouseOver instead
            $targetDiv.bind('jqplotDataMouseOver',
                function (ev, seriesIndex, pointIndex, data, radius) {
                    legendTds.removeClass(highlight).eq(seriesIndex * 2 + 1).addClass(highlight);
                });
        }
    }

    processHighlight();

    /**
     * Create chart toolbar
     * @param chartId
     * @private
     */
    function createToolbar(chartId) {

        var controlsId = chartId + "_controls";
        var $chartDiv = $('#' + chartId);

        var $controlsDiv = $('#' + controlsId);
        if ($controlsDiv.length > 0) {
            $controlsDiv.detach().empty();
        }
        var legendList = "";

        // Iterate series
        $.each(AppRuntime.jqPlots[chartId].legend._series, function (index, series) {
            // Load user preference
            var isShow = true;
            if (isNotBlank(pref[series.label])) {
                isShow = pref[series.label].show;
                if (isNotBlank(isShow) && !isShow) {
                    series.toggleDisplay({data: {series: series}});
                }
            }
            legendList += '<li><a class="js-toggle-series jqplot-legend-label jqplot-seriesToggle ' + (!isShow ? "jqplot-series-hidden" : "") + '" href="#" data-series-index="' + index + '">' +
                '<span class="label" style="width:1em;display:inline-block;background:' + series.color + ';margin-right:5px">&nbsp;</span>' + series.label + '</a></li>';
        });

        if (uiKit.getUiType() === "desktop") {
            $chartDiv.prepend
//            $('.jqplot-title',$targetDiv).append
            ('<div id="' + controlsId + '" class="chart-controls" style="sdisplay:none">' +
                '<div class="btn-group">' +
                '<a class="btn btn-link dropdown-toggle" data-toggle="dropdown" href="#">' +
                '<i class="text-muted fa fa-bars"></i></a>' +
                '<ul class="dropdown-menu dropdown-menu-right">' +
                '<li><a class="js-chart-legend" href="#">显示图标</a></li>' +
                '<li><a class="js-chart-image" href="#">保存图片</a></li>' +
                '<li><a class="js-chart-refresh" href="#"><i class="icomoon-refresh"></i> 刷新</a></li>' +
                '<li><a class="js-chart-enlarge" href="#"><i class="icomoon-zoom-in"></i> 放大</a></li>' +
                '<li class="divider"></li>' + legendList +
                '</ul>' +
                '</div></div>');
            $('.dropdown-toggle').dropdown();
        }

        //------------------------------------------
        // Event: toggle legend
        // Use off() to remove possible registered event during refresh
        //------------------------------------------
        $chartDiv.off('click.kui', '.js-toggle-series').on('click.kui', '.js-toggle-series', function (e) {
            var series = AppRuntime.jqPlots[chartId].legend._series[$(this).data('series-index')];
            series.toggleDisplay({data: {series: series}});

            var isHidden = series.canvas._elem.hasClass('jqplot-series-hidden');
            if (isHidden) {
                $(this).addClass('jqplot-series-hidden');
            }
            else {
                $(this).removeClass('jqplot-series-hidden');
            }
            // Update preference
            pref[series.label] = {show: !isHidden};
            qadPref.savePreference(prefKey, pref);

            e.preventDefault();
            return false; // Prevent dropdown menu from closing
        });

        //------------------------------------------
        // Event: toggle legend
        //------------------------------------------
        $chartDiv.on('click.kui', '.js-chart-legend', function (e) {
            $(this).data("show", $(this).data("show") !== true);
            var show = $(this).data("show");
            var plot = _getPlot(chartId);
            plot.legend.show = show;
            plot.replot();
            // NOTE: replot does not work for Pie chart. Use following toggle() as workaround for pie chart.
            $chartDiv.find('table.jqplot-table-legend').toggle(show);
            e.preventDefault();
            return false;
        });

        //------------------------------------------
        // Event: save image
        //------------------------------------------
        $chartDiv.off('click.kui', '.js-chart-image').on('click.kui', '.js-chart-image', {chart: $targetDiv}, function (e) {
            var imgelem = e.data.chart.jqplotToImageElem();
            var $imgDialog = $('<div></div>').css('display', "none");
            $imgDialog.html("<img src='" + imgelem.src + "'/>").appendTo($('body'));
            $imgDialog.kuiDialog({title: "点右键保存图片", modal: true, width: "auto", height: "auto", position: "center",
                close: function (event, ui) {
                    $imgDialog.remove();
                }
            });
            e.preventDefault();
            return false;
        });

        //------------------------------------------
        // Event: enlarge
        //------------------------------------------
        $chartDiv.off('click.kui', '.js-chart-enlarge').on('click.kui', '.js-chart-enlarge', function (e) {
            var $chartDialog = $('<div></div>');
            $('body').append($chartDialog);

            // Move chart to dialog
            $chartDiv.detach().prependTo($chartDialog);

            $chartDialog.addClass("resizable-container");
            $chartDialog.kuiDialog({resizable: true, position: "center",
                width: 800, height: 500,
                modal: false,
                dialogClass: "",
                close: function () {
                    $chartDialog.remove();
                },
                resizeStop: function (event, ui) {
                    resizeChart(chartId);
                    replotChart(chartId);
                },
                afterMaximize: function (event, ui) {
                    resizeChart(chartId);
                    replotChart(chartId);
                },
                afterUnmaximize: function (event, ui) {
                    resizeChart(chartId);
                    replotChart(chartId);
                },
                beforeClose: function (event, ui) {
                    // Put chart back
                    $chartDiv.detach().prependTo($('#' + wrapperId));
                    $targetDiv.height($targetDiv.data('old-height')).width($targetDiv.data('old-width'));
                    replotChart(chartId);
                    $chartDialog.removeClass("resizable-container");
                }
            });
            resizeChart(chartId);
            replotChart(chartId);
            //LEO@2012/11/14: do not return false, otherwise the dropdown menu will not close after clicking
            e.preventDefault();
        });

        //------------------------------------------
        // Event: refresh
        //------------------------------------------
        $chartDiv.off('click.kui', '.js-chart-refresh').on('click.kui', '.js-chart-refresh', function (e) {
            replotChart(chartId);
            e.preventDefault();
        });

//        $chartDiv.find('table.jqplot-table-legend').hide();
//    $('table.jqplot-table-legend', $chartDiv).appendTo($('#' + controlsId));
    }

    /**
     * Fetch plot data from AJAX
     * @param options contains KUI enhanced options kuiExtraChartOptions
     * @return {*} null if program error
     */
    function fetchPlotData(options) {
        var kuiOptions = options.kuiExtraChartOptions;
        // Prepare AJAX arguments
        var ajaxUrl = kuiOptions.chartAjaxUrl;
        var ajaxParam = kuiOptions.chartAjaxParam;
        var ajaxForm = kuiOptions.chartAjaxForm;

        if (qadUtil.isBlank(ajaxUrl) && qadUtil.isBlank(ajaxForm)) {
            alert("Program Error. Parameter 'ajaxUrl' or 'ajaxForm' must be specified");
            return null;
        }
        if (!qadUtil.isBlank(ajaxForm)) {
            if ($(ajaxForm).length == 0) {
                alert("Program Error: Cannot find form element '" + ajaxForm + "'");
                return null;
            }
            ajaxUrl = $(ajaxForm).attr("action");
            ajaxParam = $(ajaxForm).serialize();
        }

        // Call AJAX and process data
        var jsonData = null;
        callAjax({
            url: ajaxUrl, type: "POST", data: ajaxParam, dataType: "json",
            async: false, /* Have to use synchronous here, else the function will return before the data is fetched */
            success: function (xhr) {
                jsonData = xhr;
            }
        });

        /**
         * Process return json data.
         * TODO: rename plotData to plot in Java accordingly?
         * @param jsonData
         * <pre>
         * - plotData: Array of object, each object is a series legend and its data
         *     - dataPoints: Array of 2-D array (x value, y value)
         *     - legendLabel: String
         * </pre>
         * JSON format: {"plotData":[{"dataPoints":[[x1,y1],[x2,y2],...,[xn,yn]],"legendLabel":"series1_legend"},...,{"dataPoints":...,"legendLabel:...}]}
         * @return plotData
         */
        function processJson(jsonData) {
            var plotData = {series: [], data: [], error: ""};

            if (qadUtil.isBlank(jsonData) || qadUtil.isBlank(jsonData['plotData']) || jsonData['plotData'].length == 0) {
                plotData.error = "没有数据";
                return plotData;
            }

            var chartSeries = [];
            var chartData = [];
//        var theme = {seriesStyles:{seriesColors:AppRuntime.charting.colorScheme}};
            var seriesColors = AppRuntime.charting.colorScheme;

            // Iterate all series
            $.each(jsonData['plotData'], function (i, item) {
                if (chartType === "pie") {
                    i = 0; // Pie chart has only one series
                }
                // For on series (legend + data)
                chartData[i] = item['dataPoints'];
                var color = null;
                if (!qadUtil.isBlank(seriesColors)) {
                    color = seriesColors[i % (seriesColors.length)];
                }
                if (isNotBlank(color)) {
                    chartSeries.push({label: item['legendLabel'], color: color});
                } else {
                    chartSeries.push({label: item['legendLabel']});
                }
                if (chartData[i].length == 0) {
                    plotData.error = "没有数据点";
                }
            });
            plotData.series = chartSeries;
            plotData.data = chartData;
            return plotData;
        }

        return processJson(jsonData);
    }

    /**
     * Resize a chart to its parent <code>.resizable-container</code> element
     * @param chartId
     */
    function resizeChart(chartId) {
        var $targetDiv = $('#' + chartId + "_target");
        var $container = $targetDiv.closest('.resizable-container');
        var margin = 20;
        if ($container.length > 0 && $container.height() > margin) {
            $targetDiv.height($container.height() - margin);
            $targetDiv.width($container.width() - margin);
        }
    }

    /**
     * Customize tooltip
     * @param str default tooltip
     * @param seriesIndex
     * @param pointIndex
     * @param plot
     * @return {String}
     * @private
     */
    function jqplotTooltip(str, seriesIndex, pointIndex, plot) {
//        console.debug('chartOptions.kuiShowSeriesInTooltip',chartOptions.kuiShowSeriesInTooltip);
        if (kuiOptions.showSeriesInTooltip)
            return "<strong>" + plot.series[seriesIndex]["label"] + "</strong> " + str;//plot.data[seriesIndex][pointIndex];
        return str;
    }
}


//==============================================================================
//                                DATATABLES
//==============================================================================
function refreshDataTable(tableId) {
    try {
        AppRuntime.oTables[tableId].fnReloadAjax();
    } catch (err) {
        alert(err);
    }
}
/**
 * Update a cell in DataTable
 *
 * @param tableId
 * @param cellSelector cell to be updated
 * @param dataField field/column to be updated in fnGetData()
 * @param newValue
 * @deprecated too messy
 */
function dtUpdateCell(tableId, cellSelector, dataField, newValue) {
    var selectedCell = AppRuntime.oTableParams[tableId].selectedCell;
    $(selectedCell).siblings(cellSelector).html(escapeHTML(newValue));
    var table = AppRuntime.oTables[tableId];
    var pos = table.fnGetPosition(selectedCell);
    table.fnGetData(pos[0])[dataField] = newValue;
}

//==============================================================================
//                            DIALOG AND FORM
//==============================================================================

(function ($) {
    var pluginName = 'kuiDialog',
        defaults = {
            dialogClass: "webform",
            modal: true,
            minWidth: 600,
//            minHeight: 300,
//            maxHeight: 600,
            resizable: false
        };

    $.fn.kuiDialog = function (options) {
        // Dialog can be created multiple times
        return this.each(function () {
            new KuiDialog(this, options);
        });
    };

    // The actual plugin constructor
    function KuiDialog(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this.init();
    }

    KuiDialog.prototype.init = function () {
        var $dialog = $(this.element);
        $dialog.dialog(this.options);
        $dialog.closest('.ui-dialog-content');
        // Custom style options
        if (!qadUtil.isBlank(this.options.style)) {
            var $obj = $(this).closest('.ui-dialog');
            $obj.attr('style', $obj.attr('style') + ";" + this.options.style);
        }
//        $dialog.find(":input:visible").not("[readonly]").first().focus();
        $(":tabbable:first", $dialog).focus();
        setFormSubmited(false);
    };
})(jQuery);

//==============================================================================
//                                TREE
//==============================================================================
(function ($) {
    var pluginName = 'kuiListTree',
        defaults = {};

    $.fn.kuiListTree = function (options, args) {
//        console.debug("kuiListTree", "constructor called");
        return this.each(function () {
            var data = $.data(this, 'plugin_' + pluginName);
            if (!data)
                $.data(this, 'plugin_' + pluginName, (data = new KuiListTree(this, options)));
            if (typeof options === 'string') data[options](args);
        });
    };

    // The actual plugin constructor
    function KuiListTree(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this.init();
        this.activateItem = function ($li) {
            $li.addClass('active');
            var $liLevel1 = $li.parentsUntil('.nav-list-tree', 'li');
            $liLevel1.addClass("active");
            $li.closest('.nav-list-tree').find('li').not($li).not($liLevel1).removeClass("active");

            var $parentArrow = $li.parents("ul").prev("a").children(".arrow");
            $parentArrow.addClass("open");
            $li.parents("ul").show();
            $li.parents("li").addClass("open");
        };
    }

    KuiListTree.prototype.init = function () {
        var $self = $(this);
        var selector = $(this.element);
        initData(selector);
        regEvents(selector);

        function initData(ul) {
//            console.debug("kuiListTree", "initData");
            var arrow = '<span class="arrow"></span>';
            $('li', ul).each(function (index, obj) {
                var $li = $(this);
                if ($li.children("ul").length > 0) {
                    $li.children('a').append(arrow).next().hide(); // Initially collapse all top level group
                }
                if ($li.parentsUntil($self, 'ul').length > 4)
                    logger.warn("List tree works best with up to 4 levels");
            });
        }

        function regEvents(ul) {
            ul.on('click.kui', 'li > a', function (e) {
//                logger.debug("kuiListTree.onClick: begin");
                var $a = $(this);
                var $li = $a.parent();
                var $ulSub = $a.next();
                if ($ulSub.length > 0) {
                    // Handle menu group, close previous open sub-menu group
                    var $ulParent = $li.parent();
                    var $opened = $ulParent.children('li.open').removeClass('open');
                    $opened.children('a').children('.arrow').removeClass('open');

                    $opened.children('ul').not($ulSub).slideUp();

                    // Toggle current sub-menu group
                    var toOpen = $ulSub.is(":hidden");
                    $li.toggleClass("open", toOpen);
                    $a.children(".arrow").toggleClass('open', toOpen);
//                    alert("pause");
                    $ulSub.slideToggle();
                    e.preventDefault();
                    e.stopPropagation();
                } else {
                    if ($li.parentsUntil($self, 'ul').length > 3)
                        logger.warn("List tree best work with max 4 levels");
                    $self.kuiListTree("activateItem", $li);
                    var itemLink = $a.attr('href');
                    if ($a.data('kui-toggle') === 'ajaxSubMenu' && isValidAjaxUrl(itemLink)) {
                        $.get(itemLink, function (data) {
                            $a.after(data);
                            $a.children('.arrow').addClass('open');
                        });
//                        e.preventDefault();
//                        e.stopPropagation();
                    }
                }
            });
        }
    };
})(jQuery);
/**
 * Close a jQuery UI dialog where the element resides
 * @param element
 */
function closeDialog(element) {
    var dialog;
    dialog = $(element).parents('.ui-dialog-content:first');
    if (dialog.length > 0) {
        dialog.dialog("close");
    } else {
        if (window.history.length > 1) {
            window.history.go(-1);
        } else {
            location.href = "/home";
        }
    }
}


//==============================================================================
//                                FORM
//==============================================================================
/**
 * Initiate AJAX form with validation
 * @param settings
 */
$.fn.kuiAjaxForm = function (settings) {
    var $form = $(this);
    $form.validate({ignore: ""}); // Default ignore :hidden, but we need validate hidden fields in inactive tabs
    var ajaxFormOpts = {
        beforeSubmit: function (event, ui) {
//            logger.debug("kuiAjaxForm:beforeSubmit");
            return  $(ui).valid(); //jquery validate plugin
        },
        success: function (xhr) {
            setFormSubmited(true);
            $form.resetForm();
            $form.parents("div.webform:first").parent().first().html(xhr);
        }
    };
    $.extend(true, ajaxFormOpts, settings);
    $form.ajaxForm(ajaxFormOpts);
    $form.on("click.kui", ":reset", function () {
        closeDialog($(this));
    });
    return $form;
};

//==============================================================================
//                                TAB AND LIST
//==============================================================================
/**
 * Generate action button like tabs.
 * @author Leo
 */
$.fn.kuiActionTabs = function (option) {
//    logger.debug('kuiActionTabs:begin');
    return this.each(function (idx, el) {
        var $this = $(this);
        var $ul = $this.is('ul') ? $this : $this.children('ul');
        var $div = $ul.parent();
//        logger.debug($div);
//        $ul.addClass('nav nav-pills').kuiAjaxNav({target: $div.siblings('.tab-content')});
        if ($ul.hasClass('listing-scrollable')) {
            $ul.carouFredSel({
                circular: false,
                infinite: false,
//                width:400,
//                height:70,
                prev: $('.carousel-control.left:first', $div),
                next: $('.carousel-control.right:first', $div),
                pagination: $(".pager:first", $div),
                auto: false
            }, {wrapper: {element: 'div', classname: 'carousel-wrapper'}});
        }
        // Smart list
        var smartList = $('.js-smart-list', $div);
        if (smartList.length > 0) {
            var fields = smartList.find('[data-sort]');
            var names = [];
            $.each(fields, function (i, o) {
                names[i] = $(o).data('sort');
            });
            new List($div.attr('id'),
                {valueNames: names});
        }
    });
};

/**
 * Extends jQuery UI tabs.
 * It will change tab URL to embed mode.
 * @param settings jQuery UI tabs settings
 * @deprecated
 */
$.fn.myTabs = function (settings) {
    var allSettings = {};
    if (settings != null)
        $.extend(true, allSettings, settings);
    return $(this).kuiTabs(allSettings);
};

/**
 * @deprecated
 * @param settings
 * @returns {*|jQuery|HTMLElement}
 */
$.fn.myTabsWithActionTabs = function (settings) {
    var allSettings = {cache: true, selected: -1};
    if (settings != null)
        $.extend(true, allSettings, settings);
    var $div = $(this);
    $div.find('.action-tabs').kuiActionTabs(allSettings);
    $div.myTabs();
    return $div;
};

//==============================================================================
//                               TREE
//==============================================================================
$.fn.myTree = function (settings) {
    return $(this).tree(settings);
};

//==============================================================================
//                               CALENDAR
//==============================================================================
$.fn.myCalendar = function (settings) {
    var allSettings = {
        defaultView: 'month',
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'year,month,agendaWeek,agendaDay'
        },
        // time formats
        titleFormat: {
            month: 'yyyy年MM月',
            week: "yyyy年MM月dd日{' - '[yyyy年][ MM月]dd日}",
            day: 'yyyy年MM月dd日,dddd'
        },
        columnFormat: {
            month: 'ddd',
            week: 'ddd MM/dd',
            day: 'dddd MM/dd'
        },
        timeFormat: { // for event elements
            '': 'h(:mm)t' // default
        },
        // locale
        monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        monthNamesShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        dayNames: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
        dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
        buttonText: {
            prev: '&lsaquo;', // <
            next: '&rsaquo;', // >
            prevYear: '&laquo;',  // <<
            nextYear: '&raquo;',  // >>
            today: '今天',
            month: '月',
            week: '周',
            day: '天'
        },
        eventDragStart: function (event, jsEvent, ui, view) {
            if (!event.editable)
                return false;
        }
    };
    $.extend(true, allSettings, settings);
    var $div = $(this);
    $div.fullCalendar(allSettings);
    return $div;
};

/**
 * Extend jQuery UI dialog to support minimize and maximize
 * @see https://github.com/fieryprophet/jQuery-UI-Dialog-MinMax
 */
$.widget("ui.dialog", $.ui.dialog, {
    options: {
        minimize: true,
        maximize: true,
        cssRestore: 'ui-icon-arrowthick-2-ne-sw'
    },
    // Fix Select2 search broken inside jQuery UI 1.10.x modal Dialog
    // https://github.com/ivaynberg/select2/issues/1246
    _allowInteraction: function (e) {
        return !!$(e.target).closest('.ui-dialog, .ui-datepicker, .select2-drop').length;
    },
    // Support HTML as title which is removed from jui 1.9
    _title: function (title) {
        if (!this.options.title) {
            title.html("&#160;");
        }
        title.html(this.options.title);
    },
    _create: function () {
        this._super();
        this._createMinMaxButton();
    },
    _createMinMaxButton: function () {
        var self = this, options = self.options;
        self.uiDialogTitlebarClose.remove();
        $('<a href="#" class="ui-dialog-titlebar-xclose pull-right" role="button"><span class="ui-icon ui-icon-closethick">close</span></a>')
            .appendTo(this.uiDialogTitlebar).click(function (e) {
                self.close();
            });
        if (!options.modal && options.maximize)
            $('<a href="#" class="ui-dialog-titlebar-maximize pull-right" role="button"><span class="ui-icon ui-icon-plusthick">maximize</span></a>')
                .appendTo(this.uiDialogTitlebar).click(function (e) {
                    self.maximize(e);
                });
        if (!options.modal && options.minimize)
            $('<a href="#" class="ui-dialog-titlebar-minimize pull-right" role="button"><span class="ui-icon ui-icon-minusthick">minimize</span></a>')
                .appendTo(this.uiDialogTitlebar).click(function (e) {
                    self.minimize(e);
                });
    },
    minimize: function (event) {
        var self = this,
            ui = self.uiDialog;
        if (false === self._trigger('beforeMinimize', event)) {
            return;
        }
        if (!ui.data('is-minimized')) {
            if (self.options.minimize && typeof self.options.minimize !== "boolean" && $(self.options.minimize).length > 0) {
                self._min = $('<a>' + (ui.find('span.ui-dialog-title').html().replace(/&nbsp;/, '') || 'Untitled Dialog') + '</a>')
                    .attr('title', 'Click to restore dialog').addClass('ui-corner-all ui-button').click(function (event) {
                        self.unminimize(event);
                    });
                $(self.options.minimize).append(self._min);
                ui.data('is-minimized', true).hide();
            } else {
                if (ui.is(":data(resizable)")) {
                    ui.data('was-resizable', true).resizable('destroy');
                } else {
                    ui.data('was-resizable', false)
                }
                ui.data('minimized-height', ui.height());
                ui.find('.ui-dialog-content').hide();
                ui.find('.ui-dialog-titlebar-maximize').hide();
                ui.find('.ui-dialog-titlebar-minimize')
                    .find('span').removeClass('ui-icon-minusthick')
                    .addClass(this.options.cssRestore)
                    .click(function (event) {
                        self.unminimize(event);
                        return false;
                    });
                ui.data('is-minimized', true).height('auto');
            }
        }
        return self;
    },

    unminimize: function (event) {
        var self = this,
            ui = self.uiDialog;
        if (false === self._trigger('beforeUnminimize', event)) {
            return;
        }
        if (ui.data('is-minimized')) {
            if (self._min) {
                self._min.unbind().remove();
                self._min = false;
                ui.data('is-minimized', false).show();
                self.moveToTop();
            } else {
                ui.height(ui.data('minimized-height')).data('is-minimized', false).removeData('minimized-height').find('.ui-dialog-content').show();
                ui.find('.ui-dialog-titlebar-maximize').show();
                ui.find('.ui-dialog-titlebar-minimize').css('right', '3.3em').removeClass('ui-icon-arrowthickstop-1-s').addClass('ui-icon-minusthick')
                    .find('span').removeClass('ui-icon-arrowthickstop-1-s').addClass('ui-icon-minusthick').click(function (event) {
                        self.minimize(event);
                        return false;
                    });
                if (ui.data('was-resizable') == true) {
                    self._makeResizable(true);
                }
            }
        }
        return self;
    },

    maximize: function (event) {
        var self = this,
            ui = self.uiDialog;

        if (false === self._trigger('beforeMaximize', event)) {
            return;
        }
        if (!ui.data('is-maximized')) {
            if (ui.is(":data(draggable)")) {
                ui.data('was-draggable', true).draggable('destroy');
            } else {
                ui.data('was-draggable', false)
            }
            if (ui.is(":data(resizable)")) {
                ui.data('was-resizable', true).resizable('destroy');
            } else {
                ui.data('was-resizable', false)
            }
            ui.data('maximized-height', ui.height()).data('maximized-width', ui.width()).data('maximized-top', ui.css('top')).data('maximized-left', ui.css('left'))
                .data('is-maximized', true).height($(window).height() - 8).width($(window).width() + 9).css({"top": 0, "left": 0}).find('.ui-dialog-titlebar-minimize').hide();
            ui.find('.ui-dialog-titlebar-maximize')
                .find('span').removeClass('ui-icon-plusthick')
                .addClass(self.options.cssRestore)
                .off().on('click', function (event) {
                    self.unmaximize(event);
                    return false;
                });
            ui.find('.ui-dialog-titlebar').off().on('dblclick', function (event) {
                self.unmaximize(event);
                return false;
            });
        }
        $('.ui-dialog-content', ui).css('width', 'auto');
        //LEO@2012/11/14: trigger event
        self._trigger('afterMaximize', event);
        return self;
    },

    unmaximize: function (event) {
        var self = this,
            ui = self.uiDialog;

        if (false === self._trigger('beforeUnmaximize', event)) {
            return;
        }
        if (ui.data('is-maximized')) {
            //LEO@2012/11/14: .click(...) will cause accumulation of events ! Use off() and on()
            ui.height(ui.data('maximized-height')).width(ui.data('maximized-width')).css({"top": ui.data('maximized-top'), "left": ui.data('maximized-left')})
                .data('is-maximized', false).removeData('maximized-height').removeData('maximized-width').removeData('maximized-top').removeData('maximized-left').find('.ui-dialog-titlebar-minimize').show();
//            ui.find('.ui-dialog-titlebar-maximize').removeClass('ui-icon-arrowthick-1-sw').addClass('ui-icon-plusthick')
//                .find('span').removeClass('ui-icon-arrowthick-1-sw').addClass('ui-icon-plusthick').click(function(){
            ui.find('.ui-dialog-titlebar-maximize').removeClass('ui-icon-arrowthick-1-sw').addClass('ui-icon-plusthick')
                .find('span').removeClass('ui-icon-arrowthick-1-sw').addClass('ui-icon-plusthick').off().on('click', function (event) {
                    self.maximize(event);
                    return false;
                });
            ui.find('.ui-dialog-titlebar').off().on('dblclick', function (event) {
                self.maximize(event);
                return false;
            });
            if (ui.data('was-draggable') == true) {
                self._makeDraggable(true);
            }
            if (ui.data('was-resizable') == true) {
                self._makeResizable(true);
            }
        }
        //LEO@2012/11/14: trigger event
        self._trigger('afterUnmaximize', event);
        return self;
    }
});

//==============================================================================
//                               CALENDAR
//==============================================================================
jQuery.fn.collapsibleForm = function (options) {
    var defaults = {
        closed: false
    };
    settings = jQuery.extend({}, defaults, options);

    return this.each(function () {
        var obj = jQuery(this);
        obj.find("legend:first").addClass('collapsible').click(function () {
            if (obj.hasClass('collapsed'))
                obj.removeClass('collapsed').addClass('collapsible');

            jQuery(this).removeClass('collapsed');

            obj.children().not('legend').toggle(function () {
                if (jQuery(this).is(":visible"))
                    obj.find("legend:first").addClass('collapsible');
                else
                    obj.addClass('collapsed').find("legend").addClass('collapsed');
            });
        });
        if (settings.closed) {
            obj.addClass('collapsed').find("legend:first").addClass('collapsed');
            obj.children().not("legend:first").css('display', 'none');
        }
    });
};