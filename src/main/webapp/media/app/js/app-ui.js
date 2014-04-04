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
    /**
     * Initialize UI elements in a page.
     * @param pageSelector jquery page selector
     */
    this.initPage = function (pageSelector) {
        if (k$.isBlank(pageSelector)) {
            logger.error("Argument 'pageSelector' cannot be empty for function initPage()");
            return;
        }
        var $page = $(pageSelector);
        if ($page.length == 0) {
            logger.error("UiKit.initPage: Cannot find page by selector " + pageSelector);
            return;
        }
//        this.uiBuildCollapsibleForm($page);
        this.uiBuildCollapsible($page);
//        this.uiBuildPortlet($page);
        this.uiLoadPanelContent($page);
        this.uiBuildDateTimeRange($page);
        function initHoverToolbar($page) {
            $('.kui-toolbar-container', $page).on({mouseenter: function () {
                $(this).find('.kui-hover-toolbar').show();
            }, mouseleave: function () {
                $(this).find('.kui-hover-toolbar').hide();
            }});
        }

        initHoverToolbar($page);
        $('select.select2', $page).select2();
        $('.action-tabs:visible', $page).kuiActionTabs();
        $('.nav[data-ajax],.nav[data-ajax-nav]', $page).kuiAjaxNav();
        $('.nav-list-tree', $page).kuiListTree();
    };

    this.uiLoadPanelContent = function (selector) {
        $('.panel[data-kui-content-url]:not(.portlet)', selector).each(function () {
            var $this = $(this);
            var url = $this.data('kui-content-url');
            if (k$.isNotBlank(url) && isValidAjaxUrl(url)) {
                $('.panel-body', $this).load(url);
            }
        });
    };
//    this.uiBuildCollapsibleForm = function (selector) {
//        $('.kui-collapsible-form fieldset', selector).collapsibleForm();
//    };
    this.uiBuildSidebar = function (selector) {
        $(selector).kuiSidebar();
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
    this.uiBuildPortlet = function (page) {
        $('.portlet-container:visible', page).addClass("clearfix").kuiPortal();
    };
    /**
     * Close a jQuery UI dialog where the element resides
     * @param element
     */
    this.closeDialog = function (element) {
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
    };
    /**
     * Replot a chart
     * @param chartId
     */
    this.replotChart = function (chartId) {
        var plot = _getPlot(chartId);
        //TODO: quick and dirt to replot
        uiKit.plotChart(chartId, plot._chartOptions, plot._chartType);
    };
    this.refreshDataTable = function (tableId) {
        try {
            AppRuntime.oTables[tableId].fnReloadAjax();
        } catch (err) {
            alert(err);
        }
    };
    /**
     * Plot chart. Used with FreeMarker macro pieChart, lineChart and barChart.
     * @param chartId div id of the chart
     * @param chartOptions jqPlot options with custom kuiExtraChartOptions
     * @param chartType "bar", "line", "pie"
     */
    this.plotChart = function (chartId, chartOptions, chartType) {
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
        if (k$.isBlank($targetDiv.data("old-height")))
            $targetDiv.data("old-height", $targetDiv.height());
        if (k$.isBlank($targetDiv.data("old-width")))
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
                        uiKit.replotChart(chartId);
                    },
                    afterMaximize: function (event, ui) {
                        resizeChart(chartId);
                        uiKit.replotChart(chartId);
                    },
                    afterUnmaximize: function (event, ui) {
                        resizeChart(chartId);
                        uiKit.replotChart(chartId);
                    },
                    beforeClose: function (event, ui) {
                        // Put chart back
                        $chartDiv.detach().prependTo($('#' + wrapperId));
                        $targetDiv.height($targetDiv.data('old-height')).width($targetDiv.data('old-width'));
                        uiKit.replotChart(chartId);
                        $chartDialog.removeClass("resizable-container");
                    }
                });
                resizeChart(chartId);
                uiKit.replotChart(chartId);
                //LEO@2012/11/14: do not return false, otherwise the dropdown menu will not close after clicking
                e.preventDefault();
            });

            //------------------------------------------
            // Event: refresh
            //------------------------------------------
            $chartDiv.off('click.kui', '.js-chart-refresh').on('click.kui', '.js-chart-refresh', function (e) {
                uiKit.replotChart(chartId);
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

            if (k$.isBlank(ajaxUrl) && k$.isBlank(ajaxForm)) {
                alert("Program Error. Parameter 'ajaxUrl' or 'ajaxForm' must be specified");
                return null;
            }
            if (!k$.isBlank(ajaxForm)) {
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

                if (k$.isBlank(jsonData) || k$.isBlank(jsonData['plotData']) || jsonData['plotData'].length == 0) {
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
                    if (!k$.isBlank(seriesColors)) {
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
            if (kuiOptions.showSeriesInTooltip)
                return "<strong>" + plot.series[seriesIndex]["label"] + "</strong> " + str;//plot.data[seriesIndex][pointIndex];
            return str;
        }
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
 * @deprecated use uiKit.replotChart
 */
function replotChart(chartId) {
    return uiKit.replotChart(chartId);
}


/**
 * @deprecated use uiKit.plotChart
 */
function plotChart(chartId, chartOptions, chartType) {
    return uiKit.plotChart(chartId, chartOptions, chartType);
}


/**
 * @deprecated use uiKit.refreshDataTable
 */
function refreshDataTable(tableId) {
    return uiKit.refreshDataTable(tableId)
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
// jQuery Plugins
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
        if (!k$.isBlank(this.options.style)) {
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
 * @deprecated use uiKit.closeDialog
 */
function closeDialog(element) {
    return uiKit.closeDialog(element);
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
    return this.each(function (idx, el) {
        var $this = $(this);
        var $ul = $this.is('ul') ? $this : $this.children('ul');
        var $div = $ul.parent();
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
 * @deprecated use KuiTabs
 */
$.fn.myTabs = function (settings) {
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
    return $div.kuiTabs(allSettings);
};

/**
 * @deprecated use KuiListTree
 */
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
//                               FORM
//==============================================================================
//jQuery.fn.collapsibleForm = function (options) {
//    var defaults = {
//        closed: false
//    };
//    settings = jQuery.extend({}, defaults, options);
//
//    return this.each(function () {
//        var obj = jQuery(this);
//        obj.find("legend:first").addClass('collapsible').click(function () {
//            if (obj.hasClass('collapsed'))
//                obj.removeClass('collapsed').addClass('collapsible');
//
//            jQuery(this).removeClass('collapsed');
//
//            obj.children().not('legend').toggle(function () {
//                if (jQuery(this).is(":visible"))
//                    obj.find("legend:first").addClass('collapsible');
//                else
//                    obj.addClass('collapsed').find("legend").addClass('collapsed');
//            });
//        });
//        if (settings.closed) {
//            obj.addClass('collapsed').find("legend:first").addClass('collapsed');
//            obj.children().not("legend:first").css('display', 'none');
//        }
//    });
//};

(function ($) {
    var pluginName = 'kuiAjaxNav',
        defaults = {};

    function KuiAjaxNav(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.init();
    }

    $.fn.kuiAjaxNav = function (options) {
        return this.each(function () {
            if (!$.data(this, 'plugin_' + pluginName)) {
                $.data(this, 'plugin_' + pluginName,
                    new KuiAjaxNav(this, options));
            }
        });
    };

    KuiAjaxNav.prototype.init = function () {
        var self = this;
        var $navUl = $(this.element);
        if (!$navUl.is('ul')) {
            logger.error("Element '" + $navUl.selector + "' should be 'ul', but it is '" + $navUl.tagName + "'");
            return;
        }

        $navUl.on('click.kui', 'li > a', function (e) {
            var $a = $(this);
            if ($a.data("kui-toggle") === "ajaxSubMenu")
                return true;
            //For bootstrap dropdown
            if ($a.data('toggle') === 'dropdown')
                return true;

            var container = self.options.target || $a.closest('[data-kui-target]').data('kui-target');
            var $tabContainer = $(container), $tabPane, tabLink = $a.attr('href');
            if (isValidAjaxUrl(tabLink)) {
                if ($tabContainer.length == 0) {
                    logger.error("Cannot find tab container '" + container + "'");
                    return false;
                } else {
                    $tabPane = $($a.data('kui-tab-pane'));
                    if ($tabPane.length == 0) {
                        $tabPane = $('<div class="tab-pane active"></div>').uniqueId().appendTo($tabContainer);
                        $a.attr('data-kui-tab-pane', '#' + $tabPane.attr('id'));
                    }
                    if (!$a.data('ajax-loaded')) {
                        $tabPane.html(showLoading("bar"));
                        $.get(tabLink, function (jqxhr) {
                            $tabPane.html(jqxhr);
                        });
                        $a.data('ajax-loaded', true);
                    }
                }
            } else {
                $tabPane = $(getUrlHash(tabLink));
            }
            $a.parent("li").addClass("active").siblings('.active').removeClass("active");
            $tabPane.addClass('active').siblings('.tab-pane.active').removeClass('active');
            var $actionTabs = $('.action-tabs', $tabPane).not('.action-tabs .action-tabs');
            if ($actionTabs.length > 0) {
                $actionTabs.kuiActionTabs();
            }
            return false;
        });
        $navUl.find('li.active:first a').trigger('click');
    };
})(jQuery);

(function ($) {
    var pluginName = 'kuiTabs',
        defaults = {};

    function KuiTabs(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.init();
    }

    $.fn.kuiTabs = function (options) {
        return this.each(function () {
            if (!$.data(this, 'plugin_' + pluginName)) {
                $.data(this, 'plugin_' + pluginName,
                    new KuiTabs(this, options));
            }
        });
    };

    KuiTabs.prototype.init = function () {
        var $wrapperDiv = $(this.element).addClass('tabbable-custom');
        // Format nav list
        var $tabNav = $wrapperDiv.children('ul');
        if ($tabNav.length == 0) {
            logger.error("Cannot find div.ul for element '" + $wrapperDiv.selector() + "'");
            return;
        }
        $tabNav.addClass('nav nav-tabs')
            .children('li').children('a').attr('data-toggle', 'tab').attr('data-pjax-disabled', 'disabled');
        if ($tabNav.children('li.active').length == 0) {
            //Default make first active
            $tabNav.children('li:first').addClass('active');
        }
        // Move jUI tab pane divs to a tab-content div
        var $tabContent = $tabNav.next('.tab-content');
        if ($tabContent.length == 0)
            $tabContent = $('<div class="tab-content"></div>').uniqueId()
                .append($tabNav.siblings('div').addClass('tab-pane'))
                .insertAfter($tabNav);
        // Make nav supports ajax
        $tabNav.kuiAjaxNav({target: $tabContent});
    };
})(jQuery);


(function ($) {
    // Create the defaults once
    var portalPluginName = 'kuiPortal',
        portalPluginDefaults = {
        };
    var portletPluginName = 'kuiPortlet',
        portletPluginDefaults = {
            containerId: null
        };
    var m_sContent = ".panel-body";
    var m_sHeader = ".panel-heading";
    var m_sFooter = ".panel-footer";
    var DEFAULT_PORTLET_CONFIG = {
        theme: 'default',
        style: '',
        minimized: false
    };
    var PREF_CONFIG_KEY = "portletConfig";
    var DEFAULT_CONTAINER_CONFIG = {orders: [], portlets: {}};

    // The actual plugin constructor
    function KuiPortlet(element, options) {
        var that = this;
        this.element = element;
        this.options = $.extend({}, portletPluginDefaults, options);
        this.portletId = $(element).attr('id');
        this.portletConfig = {};
        var containerId = this.options.containerId;
        if (k$.isBlank(this.portletId)) {
            logger.error("KuiPortlet: Portlet need 'id' attribute to store configuration data");
            return;
        }
        if (k$.isBlank(containerId)) {
            containerId = $(element).closest('.portlet-container').attr('id');
            if ($(containerId).length == 0) {
                logger.error('KuiPortlet: Cannot find portlet container "#' + containerId +
                    '". You need provide "containerId" or enclose portlets within ".portlet-container" element');
                return;
            }
        }
        this.containerId = containerId;
        // Load portlet preference
        var savedConfig = loadContainerConfig(this.containerId).portlets[this.portletId];
        $.extend(true, this.portletConfig, DEFAULT_PORTLET_CONFIG, savedConfig);
        /**
         * Calculate dimension of components
         */
        this.resize = function () {
            var $portlet = $(element);
            var all = $portlet.height();
            var $header = $(m_sHeader + ':visible', $portlet);
            var $footer = $(m_sFooter + ':visible', $portlet);
            var $content = $(m_sContent, $portlet);
            var hh = $header.length == 0 ? 0 : $header.outerHeight(true);
            var fh = $footer.length == 0 ? 0 : $footer.outerHeight(true);
            var ch = all - hh - fh;
            var padding = $content.padding();
            var margin = $content.margin();
            var border = $content.border();
            var pmb = padding.top + padding.bottom + margin.top + margin.bottom + border.top + border.bottom;
            $content.height(ch - pmb);
            $('.jqplot-target', $content).css("height", "100%").css("width", "100%");
        };
        this.saveConfig = function (key, value) {
            if (key == "*" && value == null)
                that.portletConfig = {};
            else
                that.portletConfig[key] = value;
            var obj = {};
            obj[that.containerId] = {portlets: {}};
            obj[that.containerId].portlets[that.portletId] = that.portletConfig;
            qadPref.savePreference(PREF_CONFIG_KEY, obj);
        };
        this.init();
    }

    var CSS_MINIMIZED_CLASS = "minimized";
    var CSS_THEME_CLASS_PREFIX = "panel-";

    /**
     * Place initialization logic in init().
     * You already have access to the DOM element and the options via the instance,
     * e.g. this.element and this.options
     */
    KuiPortlet.prototype.init = function () {
        var that = this;
        var $portlet = $(that.element);
        // Validate and generate layout component
        var $portletContent = $(m_sContent, $portlet);
        var $portletHeader = $(m_sHeader, $portlet);
        $portletHeader.disableSelection();
        createHeaderControls();
        initStyles();
        loadContent();
        createEditBox();
        initEventListener();
        that.loadContent = loadContent;

        function createHeaderControls() {
            var $headerBtnGroup = $('.btn-group.btn-group-xs', $portletHeader);
            if ($headerBtnGroup.length == 0) {
                $headerBtnGroup = $('<div class="btn-group btn-group-sm"></div>').appendTo($portletHeader);
            }
            $headerBtnGroup.hide();
            if (!$portlet.hasClass("not-editable")) {
                $headerBtnGroup.append('<button class="btn btn-default js-action-edit"><i class="fa fa-cog"></i></button>' +
                    ' <button class="btn btn-default js-action-size"><i class="fa ' + (that.portletConfig.minimized ? 'fa-plus' : 'fa-minus') + '"></i></button> ');
            }
            $portletHeader.on({mouseenter: function () {
                $headerBtnGroup.show();
            }, mouseleave: function () {
                $headerBtnGroup.hide();
            }});
            return $headerBtnGroup;
        }

        /**
         * Calculate title, theme, dimension and other styles
         */
        function initStyles() {
            $portlet.alterClass(CSS_THEME_CLASS_PREFIX + '*', CSS_THEME_CLASS_PREFIX + that.portletConfig.theme).attr("style", that.portletConfig.style);
            that.resize();
            if (that.portletConfig.minimized) {
                $portlet.addClass(CSS_MINIMIZED_CLASS).css("height", "auto");
            }
        }

        /**
         * Load AJAX content if `data-kui-content-url` specified
         */
        function loadContent() {
            // LEO@20140403: Do not use data('kui-content-url') since jquery data() is cached
            // It will not reflect dynamically changed attribute 'data-kui-content-url'
            // http://stackoverflow.com/questions/8414343/jquery-data-and-dynamically-changing-html5-custom-attributes
            var url = $portlet.attr('data-kui-content-url');
            if (isValidAjaxUrl(url)) {
                $portletContent.html(showLoading("inline"));//.load(url);
                $.ajax(url, {global: false,
                    success: function (xhr) {
                        $portletContent.html(xhr);
                    },
                    error: function (xhr) {
                        $portletContent.html('<div class="text-danger">' + xhr.statusText + '</div>');
                    }});
            }
        }

        function createEditBox() {
            var $editBox = $('.kui-portlet-edit-box', $portletHeader);
            $portletHeader
                .off('click.kui', '*')
                .on('click.kui', ".js-action-size", function () {
                    var $icon = $('.fa', $(this));
                    $icon.toggleClass("fa-minus").toggleClass("fa-plus");
                    $portlet.toggleClass(CSS_MINIMIZED_CLASS);
                    var isMinimized = $portlet.hasClass(CSS_MINIMIZED_CLASS);
                    if (isMinimized) {
                        $portlet.data("old-height", $portlet.height()).css('height', 'auto');
                    } else {
                        $portlet.css('height', $portlet.data('old-height'));
                    }
                    that.saveConfig("minimized", isMinimized);
                })
                .on('click.kui', ".js-action-edit", function () {
                    $portletHeader.toggleClass("open");
                    if ($editBox.length == 0) {
                        var themes = ['default', 'success', 'primary', 'info', 'warning', 'danger'];
                        var colorBtns = '';
                        $(themes).each(function (index, value) {
                            colorBtns += '<button class="btn btn-' + value + '" title="' + value + '" value="' + value + '">&nbsp;</button>';
                        });
                        var html = '<div class="form-horizontal">' +
//                            '<div class="form-group"><label class="control-label">标题:</label><input class="form-control" value="' + portletConfig.title + '"/></div>' +
                            '<div class="form-group"><label class="control-label">颜色:</label><div class="colors btn-group btn-group-sm">' + colorBtns + '</div></div>' +
//                            '<div class="text-right">' +
//                            '<button class="btn btn-default btn-sm js-action-save">保存</button> ' +
//                            '<button class="btn btn-default btn-sm js-action-reset">重置</button></div>' +
                            '</div>';
                        $editBox = $('<div class="kui-portlet-edit-box" style="display:none;"/>')
                            .append(html).insertAfter($portletHeader)
                            .on('click', '.colors button', function (e) {
                                $editBox.slideUp();
                                var t = $(this).val();
                                $portlet.alterClass(CSS_THEME_CLASS_PREFIX + '*', CSS_THEME_CLASS_PREFIX + t);
                                that.saveConfig("theme", t);
                                e.preventDefault();
                            })
                            .on('click', '.js-action-reset', function (e) {
                                $editBox.slideUp();
                                that.saveConfig("*", null);
                                e.preventDefault();
                            });
                    }
                    $editBox.slideToggle();
                    return false;
                });
        }

        function initEventListener() {
            // Resizable
            if (!$portlet.hasClass("not-resizable")) {
                $portlet.resizable({
                    stop: function (event, ui) {
                        that.resize();
                        that.saveConfig("style", $portlet.attr('style'));
                    }
                });
            }
            // Handle portlet inline links
            $portletContent.on('click.kui', 'a:[data-kui-inline-link]', function (e) {
                var href = this.href;
                if (isValidAjaxUrl(href)) {
                    callAjax({
                        url: href,
                        success: function (xhr) {
                            $portletContent.html(xhr);
                        }
                    });
                    e.preventDefault();
                    return false;
                }
            });
        }
    };

    /**
     * Portlet class:
     * - not-resizable:
     * - not-moveable:
     * - not-editable:
     * <div class="portlet panel not-resizable not-moveable not-editable" data-kui-content-url="/ajax/some-link-to-content">
     *     <div class="panel-heading"><h3 class="panel-title">portlet-title</h3></div>
     *     <div class="panel-body">static or ajax content loaded by data-kui-content-url</div>
     * </div>
     * @param options {"containerId":string} default use closest `.portlet-container`
     * @returns {*}
     */
    $.fn.kuiPortlet = function (options) {
        // A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
        return this.each(function () {
            var dataKey = 'plugin_' + portletPluginName;
            if (!$.data(this, dataKey)) {
                logger.debug("call $.fn.kuiPortlet");
                $.data(this, dataKey,
                    new KuiPortlet(this, options)
                );
            }
            if (typeof options == "string") {
                $.data(this, dataKey)[options]();
            }
        });
    };

    // The actual plugin constructor
    function KuiPortal(element, options) {
        this.element = element;
        this.options = $.extend({}, portalPluginDefaults, options);
        this.init();
    }

    function loadContainerConfig(containerId) {
        var pref = qadPref.loadPreference(PREF_CONFIG_KEY, {});
        return pref[containerId] || DEFAULT_CONTAINER_CONFIG;
    }

    function saveContainerConfig(containerId, containerPref) {
        var obj = {};
        obj[containerId] = containerPref;
        qadPref.savePreference(PREF_CONFIG_KEY, obj);
    }

    /**
     * Generate portlet widgets. It need work with bootstrap3 panel.
     * .portlet-container: containers to hold portlets, such as columns
     * .portlet.panel: a portlet contains header and content.
     * .panel-heading: portlet header, default is draggable
     * .panel-body: portlet content, support <code>data-kui-content-url</code> to auto load AJAX
     * It persists user preference as a JSON string in <code>localStorage</code>.
     * JSON setting
     * ````
     * {
     *   containerId(string):{
     *     "orders":[portletId(string)],
     *     "portlets":{
     *       portletId(string):{
     *         "title":string,
     *         "style":string,
     *         "theme":string
     *       }
     *     }
     *   }
     * }
     * ````
     * @author Leo Liao, 2012/11/17
     */
    KuiPortal.prototype.init = function () {
        var $container = $(this.element);
        var containerId = $container.attr('id');
        if (k$.isBlank(containerId)) {
            logger.error("KuiPortal:Need unique id to build portal");
            return false;
        }

        // Define selectors
        var m_sPortlet = ".panel.portlet";
        var sortableDisabledCss = "kui-init-disable-sort";

        // Load portlet preference,
        var containerPref = loadContainerConfig(containerId);

        // Sort portlets
        sortPortlets(containerPref);

        // Make element sortable
        $container.sortable({
            disabled: $container.hasClass(sortableDisabledCss),
            connectWith: $container, revert: 100, delay: 100, opacity: 0.8,
            cancel: ".panel-body,.kui-portlet-edit-box,.not-moveable",
            start: function (event, ui) {
                $container.addClass("kui-portal-in-sort");
            },
            stop: function (event, ui) {
                $container.removeClass("kui-portal-in-sort");
                $container.each(function (index, item) {
                    containerPref.orders = $(item).sortable('toArray');
                });
                saveContainerConfig(containerId, containerPref);
            }
        });

        // Customize each portlet
        $(m_sPortlet + ":visible", $container).kuiPortlet({containerId: containerId});

        /**
         * Sort portlets in container
         */
        function sortPortlets() {
            var portletIds = containerPref.orders || [];
            //For compatibility with old String data format
            if (typeof portletIds == "string") {
                portletIds = portletIds.split(",");
            }
            $.each(portletIds, function (index, item) {
                if (k$.isNotBlank(item)) {
                    $container.append($('#' + item));
                }
            });
        }
    };


    $.fn.kuiPortal = function (options) {
        return this.each(function () {
            if (!$.data(this, 'plugin_' + portalPluginName)) {
                $.data(this, 'plugin_' + portalPluginName,
                    new KuiPortal(this, options));
            }
        });
    }
})(jQuery);

(function ($) {
    var pluginName = 'kuiSidebar',
        defaults = {
            useMmenu: true
        };

    $.fn.kuiSidebar = function (options) {
        return this.each(function () {
            if (!$.data(this, 'plugin_' + pluginName)) {
                $.data(this, 'plugin_' + pluginName,
                    new KuiSidebar(this, options));
            }
        });
    };

    // The actual plugin constructor
    function KuiSidebar(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this.init();
    }

    KuiSidebar.prototype.init = function () {
        var $this = $(this.element);
        if (this.options.useMmenu) {
            buildMmenuSidebar($this)
        } else {
            buildHomeMadeSidebar($this);
        }
        function buildMmenuSidebar($sidebar) {
            var $body = $('body');
            $sidebar.mmenu({slidingSubmenus: false})
                .on("closed.mm", function () {
                    $body.addClass("kui-sidebar-closed");
                })
                .on("opened.mm", function () {
                    $body.removeClass("kui-sidebar-closed");
                });
            var toggleSidebar = function (e) {
                if ($sidebar.hasClass('mm-opened')) {
                    $sidebar.trigger('close.mm');
                } else {
                    $sidebar.trigger('open.mm');
                }
            };
            $('.sidebar-toggler').on('click', toggleSidebar);
            toggleSidebar();
        }

        function buildHomeMadeSidebar(selector) {
            var $navTree = $(selector);
            var $body = $("body");
            var SIDEBAR_CLOSED_CLASS = "kui-sidebar-closed";
            var SIDEBAR_OPEN_CLASS = "kui-sidebar-opened";
            if ($navTree.not('ul')) {
                $navTree = $('ul', selector).first();
                if ($navTree.length == 0) {
                    alert("buildHomeMadeSidebar: Need list 'ul' element to build sidebar menu");
                    return;
                }
                $navTree.addClass('nav nav-list-tree dark');
            }
            $navTree.kuiListTree();

            sbHighlightMatch();
            sbRegisterEvents();
            sbToggleSidebar(qadPref.loadPreference("sidebarOpen", true));

            function sbToggleSidebar(toOpen) {
                $(".sidebar-search").toggleClass("open", toOpen);
                $body.toggleClass(SIDEBAR_CLOSED_CLASS, !toOpen).toggleClass(SIDEBAR_OPEN_CLASS, toOpen);
            }

            function sbRegisterEvents() {
                // handle sidebar show/hide
                $('.sidebar-toggler').on('click.kui', function (e) {
                    var toOpen = $body.hasClass(SIDEBAR_CLOSED_CLASS);
                    qadPref.savePreference("sidebarOpen", toOpen);
                    sbToggleSidebar(toOpen);
                    e.preventDefault();
                });
            }

            function sbHighlightMatch() {
                var matched = null;
                $('li a', $navTree).each(function (index) {
                    var key = $(this).data("kui-menu-key");
                    if (k$.isBlank(key))
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
        }
    };
})(jQuery);

$(function () {
    uiKit.uiBuildSidebar('#page-sidebar-left');
});