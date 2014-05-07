/**
 * The jQuery plugin namespace.
 * @external "$.fn"
 * @see {@link http://docs.jquery.com/Plugins/Authoring The jQuery Plugin Guide}
 */

/**
 * Need jQuery.
 * JavaScript for UI. It may be extended by app.ui.desktop and app.ui.mobile.
 * @param key {string} UI type like `desktop`, `mobile`.
 * @constructor
 * @author Leo Liao, 2012/05, created
 * @author Leo Liao, 2012/11/25, add UiKit
 */
function QadUi(key) {
    "use strict";
    var COLOR_SCHEME_ANDROID = ['#33B5E5', '#AA66CC', '#99CC00', '#FFBB33', '#FF4444'];
    var COLOR_SCHEME_ANDROID_DARK = ['#0099CC', '#9933CC', '#669900', '#FF8800', '#CC0000'];
    var COLOR_SCHEME_HP2007 = ['#007FC5', '#00A145', '#56378A', '#FFDD00', '#F39900', '#E31C19'];
    var COLOR_SCHEME_EXCEL = ['#FFC000', '#92D050', '#00B0F0', '#7030A0', '#808080', '#F79646' ];
    var chartColorScheme = COLOR_SCHEME_ANDROID;

    var that = this;
    var isFormSubmitted = false;
    /**
     * Stores DataTable definitions
     * @type {{}}
     */
    var cachedDataTableParams = {};
    /**
     * Stores created jqplots
     * @type {{}}
     */
    var cachedPlots = {};
    /**
     * Stores created DataTable object
     * @type {{}}
     */
    var cachedDataTables = {};

    function getUiType() {
        return key;
    }

    //==========================================================================
    // AJAX
    //==========================================================================
    $.ajaxSetup({
        headers: {"Device-Type": key}
    });

    /**
     * Call ajax. It shows processing message before calling.
     * @param options $.ajax options
     */
    this.callAjax = function (options) {
//    _showProcessing(true);
        var obj = $.ajax(options);
//    _showProcessing(false);
        return obj;
    };

    /**
     * Call ajax with POST.
     * @param options
     */
    this.postAjax = function (options) {
        options.type = "post";
        callAjax(options);
    };

    /**
     * Call pjax. It shows processing message before calling.
     * @param url
     * @param successMessage flash message when success
     */
    this.callPjax = function (url, successMessage) {
        var BODY_CONTENT = "#body-content";
        var options = {
            url: url,
            container: BODY_CONTENT,
            type: "GET"
        };
        //TODO: make it hock to pjax event, similar code duplicated in app-events.js
        // Clean up dialog since ui-dialog is direct child of body element, Pjax only refresh BODY_CONTENT
        $('body>div.ui-dialog *').remove();
        $.pjax(options);
        that.showToast("success", successMessage, 3);
    };

    //==========================================================================
    // DATATABLES
    //==========================================================================

    /**
     * Init columns settings for a table
     * @param tableId {string} ID of table
     * @param columns {*} DataTable
     */
    this.setTableColumns = function (tableId, columns) {
        cachedDataTableParams[tableId] = {columns: columns};
    };

    /**
     * Retrieve column settings for a table
     * Fall back to old style `columns_${tableId}`
     * @param tableId
     * @returns {*}
     */
    this.getTableColumns = function (tableId) {
        if (cachedDataTableParams[tableId]) {
            return cachedDataTableParams[tableId].columns || window['columns_' + tableId];
        }
        return window['columns_' + tableId];
    };

    /**
     * Refresh a data table
     * @param tableId ID of the table
     */
    this.refreshDataTable = function (tableId) {
        var table = that.getDataTable(tableId);
        if (ktl.isNotBlank(table)) {
            try {
                table.fnReloadAjax();
            } catch (err) {
                logger.error(err.message);
            }
        } else {
            logger.warn("Cannot find table %s", tableId);
        }
    };

    /**
     * Get a created data table object
     * @param tableId
     * @returns {*}
     */
    this.getDataTable = function (tableId) {
        return cachedDataTables[tableId];
    };

    /**
     * Set a created data table object
     * @param tableId
     * @param dataTable
     */
    this.setDataTable = function (tableId, dataTable) {
        cachedDataTables[tableId] = dataTable;
    };

    //==========================================================================
    // STATUS & MESSAGE
    //==========================================================================

    /**
     * Create and show a piece of alert message to indicate brief operation result.
     * @param status string value of `success`, `info`, `warn` or `error`
     * @param msg string or array of string. Message(s) to show. An empty/blank message will clear it
     * @param autoCloseSeconds integer, the message will close automatically after specified timeout seconds.
     * Default value is 3 seconds. 0 or negatives will not auto close the message.
     * @return {*|jQuery|HTMLElement} jQuery element of the created message
     */
    this.showToast = function (status, msg, autoCloseSeconds) {
        var FLASH_MSG_CLASS = 'flash-message';
        if (ktl.isBlank(msg)) {
            $('.' + FLASH_MSG_CLASS).remove();
            return null;
        }
        // Message list
        var messages = $.isArray(msg) ? msg : [msg];
        var msgHtml = '<ul class="list-unstyled">';
        for (var i = 0; i < messages.length; i++) {
            msgHtml += '<li>' + messages[i] + '</li>';
        }
        msgHtml += '</ul>';
        var cssMap = {"success": "alert-success", "info": "alert-info", "warn": "alert-warning", "error": "alert-danger"};
        var html = '<div class="' + FLASH_MSG_CLASS + ' alert ' + cssMap[status] + ' word-wrap">';
        html += ' <a class="close" data-dismiss="alert"><i class="fa fa-times"></i></a> ';
        // Auto close control
        var timeoutMap = {"warn": 10, "error": 20};
        autoCloseSeconds = ktl.isBlank(autoCloseSeconds) ? timeoutMap[status] || 3 : autoCloseSeconds;
        if (autoCloseSeconds > 0) {
            html += '<span class="close counter">' + autoCloseSeconds + '</span><a class="kui-flash-pin close" href="javascript:void(0);" title="固定消息"><i class="fa fa-unlock-alt"></i></span></a> ';
        }
        html += msgHtml + '</div>';
        var $msgAlert = $(html);

        /**
         * A container to hold all message stacks. Used to position the messages.
         * @returns {*|jQuery|HTMLElement}
         */
        function getMessageContainer() {
            var FLASH_MSG_CONTAINTER_CLASS = 'flash-message-container';
            var $container = $('.' + FLASH_MSG_CONTAINTER_CLASS);
            if ($container.length == 0) {
                $container = $('<div class="' + FLASH_MSG_CONTAINTER_CLASS + '"></div>').prependTo("body");
            }
            return $container;
        }

        var $container = getMessageContainer();
        $msgAlert.fadeIn("fast").prependTo($container).uniqueId();
        if (autoCloseSeconds > 0) {
            var elapsed = autoCloseSeconds;
            var timer = setInterval(function () {
                if (elapsed <= 0) {
                    $msgAlert.fadeOut(function () {
                        $msgAlert.remove();
                    });
                    clearInterval(timer);
                }
                $('.counter', $msgAlert).html("" + elapsed);
                elapsed--;
            }, 1000);
            $msgAlert.on('click', 'a.kui-flash-pin', function () {
                clearInterval(timer);
                $("i", this).alterClass("fa-*", "fa-lock");
            });
        }
        return $msgAlert;
    };

    this.showLoading = function (style) {
        if (style === "bar") {
            return '<div class="loading bar"><i class="fa fa-spinner fa-spin"></i> 正在加载...</div>';
        } else {
            return '<div class="loading inline"><i class="fa fa-spinner fa-spin"></i> 正在加载...</div>';
        }
    };
    this.hideLoading = function () {
        $('.loading:visible').remove();
    };

    //==========================================================================
    // INIT UI ELEMENTS
    //==========================================================================
    /**
     * Initialize UI elements in a page.
     * @param pageSelector {*|jQuery|HTMLElement} jquery page selector
     */
    this.initPage = function (pageSelector) {
        if (ktl.isBlank(pageSelector)) {
            logger.error("Argument 'pageSelector' cannot be empty for function initPage()");
            return;
        }
        var $page = $(pageSelector);
        if ($page.length === 0) {
            logger.error("UiKit.initPage: Cannot find page by selector " + pageSelector);
            return;
        }
        uiBuildCollapsible($page);
        uiLoadPanelContent($page);
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
        $('.kui-tabbable-form', $page).kuiTabForm();
    };

    function uiLoadPanelContent(selector) {
        $('.panel[data-kui-content-url]:not(.portlet)', selector).each(function () {
            var $this = $(this);
            var url = $this.data('kui-content-url');
            if (ktl.isNotBlank(url) && isValidAjaxUrl(url)) {
                $('.panel-body', $this).load(url);
            }
        });
    }

//    this.uiBuildCollapsibleForm = function (selector) {
//        $('.kui-collapsible-form fieldset', selector).collapsibleForm();
//    };
    this.uiBuildSidebar = function (selector) {
        var useMmenu = ($(selector).data('kui-usemmenu') === true);
        $(selector).kuiSidebar({useMmenu: useMmenu});
    };
    function uiBuildCollapsible(selector) {
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
    }

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

    //==========================================================================
    // FORM & DIALOG
    //==========================================================================
    /**
     * Close the closest dialog where the element resides
     * @param element a jQuery selector
     */
    this.closeDialog = function (element) {
        var dialog = $(element).closest('.ui-dialog-content');
        if (dialog.length > 0) {
            dialog.dialog("close");
        }
        /*else {
         if (window.history.length > 1) {
         window.history.go(-1);
         } else {
         location.href = "/home";
         }
         }*/
    };

    /**
     * Set if a form is submitted. It is generally used when the main page need do something link refresh
     * after a ajax form is submitted.
     * @param isSubmitted
     */
    this.setFormSubmited = function (isSubmitted) {
        isFormSubmitted = isSubmitted;
    };

    /**
     * If a form is submitted.
     * @return {Boolean}
     */
    this.isFormSubmitted = function () {
        return isFormSubmitted;
    };

    this.disableControls=function(container) {
        $('form .form-actions', container).each(function () {
            $(this).hide();
        });
        $('input', container).each(function () {
            $(this).attr('readonly', 'true');
        });
        $('select,input:checkbox,a,textarea,button', container).each(function () {
            $(this).attr('disabled', 'disabled');
        });
    };

    //==========================================================================
    // CHART
    //==========================================================================

    /**
     * Set color scheme for chart
     * @param colors array of colors
     */
    this.setChartColors = function (colors) {
        chartColorScheme = colors;
    };

    /**
     * Replot a chart
     * @param chartId ID of the chart
     */
    this.replotChart = function (chartId) {
        var plot = _getPlot(chartId);
        //TODO: quick and dirt to replot
        this.plotChart(chartId, plot._chartOptions, plot._chartType);
    };

    /**
     * Plot chart. Used with FreeMarker macro pieChart, lineChart and barChart.
     * @param chartId div id of the chart
     * @param chartOptions jqPlot options with custom kuiExtraChartOptions
     * @param chartType value of `bar`, `line` or `pie`
     */
    this.plotChart = function (chartId, chartOptions, chartType) {
        var kuiOptions = chartOptions.kuiExtraChartOptions;
        var chartArgument = {_chartOptions: chartOptions, _chartType: chartType};
        var $chartDiv = $('#' + chartId);
        var chartTitle = $("#" + chartId).data('title');
        var DISPLAY_TOOLBAR = true;
        var prefKey = "chart_" + chartId;
        var pref = kup.loadPreference(prefKey, {});

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
                for (var index in chartColorScheme) {
                    var color = chartColorScheme[index];
                    highlightColors[index] = calcColorLuminance(color, 0.15);
                }

                if (typeof allOptions.seriesDefaults !== "undefined") {
                    if (typeof allOptions.seriesDefaults.rendererOptions !== "undefined") {
                        allOptions.seriesDefaults.rendererOptions.highlightColors = highlightColors;
                    }
                }
            }
        }

        /**
         * Calculate color
         * http://www.sitepoint.com/javascript-generate-lighter-darker-color/
         * @param hex
         * @param lum
         * @return {String}
         * @private
         */
        function calcColorLuminance(hex, lum) {
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
            cachedPlots[chartId] = $.extend(true, {isError: true}, chartArgument);
            return;
        }

        // Combine chart options with priority: plotData (server data) > allOptions (custom options) > DEFAULT_OPTIONS
        allOptions = $.extend(true, {}, DEFAULT_OPTIONS, allOptions, plotData);
        allOptions.legend.rendererOptions.numberRows = allOptions.legend.location == "s" || allOptions.legend.location == "n" ? 1 : null;

        //------------------------------------------
        // Create plot and save it in global variable
        //------------------------------------------
        //*******************************************
        var thePlot = $.jqplot(targetId, plotData.data, allOptions);
        cachedPlots[chartId] = $.extend(true, thePlot, chartArgument);
        //*******************************************


        // Save original dimensions
        if (ktl.isBlank($targetDiv.data("old-height")))
            $targetDiv.data("old-height", $targetDiv.height());
        if (ktl.isBlank($targetDiv.data("old-width")))
            $targetDiv.data("old-width", $targetDiv.width());

        //------------------------------------------
        // Determine Chart Type
        //------------------------------------------
        var isPieChart = false, isBarChart = false, isLineChart = false;
        var renderer = cachedPlots[chartId].series[0].renderer;
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
        var chartTheme = {seriesStyles: {seriesColors: chartColorScheme}};
        if (chartTheme != null) {
            cachedPlots[chartId].themeEngine.newTheme('myStyle', chartTheme);
            // TODO AND NOTE
            // if not use plot.activateTheme, piechart chartTheme can not be applied
            // if use plot.activateTheme, barchart x-axis label can not be displayed
            if (isPieChart)
                cachedPlots[chartId].activateTheme('myStyle');
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
         * Get a plot object
         * @param chartId
         * @return {*}
         * @private
         */
        function _getPlot(chartId) {
            return cachedPlots[chartId];
        }

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
            $.each(cachedPlots[chartId].legend._series, function (index, series) {
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

            if (getUiType() === "desktop") {
                $chartDiv.prepend
//            $('.jqplot-title',$targetDiv).append
                ('<div id="' + controlsId + '" class="chart-controls" style="sdisplay:none">' +
                    '<div class="btn-group">' +
                    '<a class="btn btn-link dropdown-toggle" data-toggle="dropdown" href="#">' +
                    '<i class="text-muted fa fa-bars"></i></a>' +
                    '<ul class="dropdown-menu dropdown-menu-right">' +
                    '<li><a class="js-chart-legend" href="#">显示图标</a></li>' +
                    '<li><a class="js-chart-image" href="#">保存图片</a></li>' +
                    '<li><a class="js-chart-refresh" href="#">刷新</a></li>' +
                    '<li><a class="js-chart-enlarge" href="#">放大</a></li>' +
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
                var series = cachedPlots[chartId].legend._series[$(this).data('series-index')];
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
                kup.savePreference(prefKey, pref);

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
                        that.replotChart(chartId);
                    },
                    afterMaximize: function (event, ui) {
                        resizeChart(chartId);
                        that.replotChart(chartId);
                    },
                    afterUnmaximize: function (event, ui) {
                        resizeChart(chartId);
                        that.replotChart(chartId);
                    },
                    beforeClose: function (event, ui) {
                        // Put chart back
                        $chartDiv.detach().prependTo($('#' + wrapperId));
                        $targetDiv.height($targetDiv.data('old-height')).width($targetDiv.data('old-width'));
                        that.replotChart(chartId);
                        $chartDialog.removeClass("resizable-container");
                    }
                });
                resizeChart(chartId);
                that.replotChart(chartId);
                //LEO@2012/11/14: do not return false, otherwise the dropdown menu will not close after clicking
                e.preventDefault();
            });

            //------------------------------------------
            // Event: refresh
            //------------------------------------------
            $chartDiv.off('click.kui', '.js-chart-refresh').on('click.kui', '.js-chart-refresh', function (e) {
                that.replotChart(chartId);
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

            if (ktl.isBlank(ajaxUrl) && ktl.isBlank(ajaxForm)) {
                alert("Program Error. Parameter 'ajaxUrl' or 'ajaxForm' must be specified");
                return null;
            }
            if (!ktl.isBlank(ajaxForm)) {
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
             * <pre>
             * - plotData: Array of object, each object is a series legend and its data
             *     - dataPoints: Array of 2-D array (x value, y value)
             *     - legendLabel: String
             * </pre>
             * JSON format: {"plotData":[{"dataPoints":[[x1,y1],[x2,y2],...,[xn,yn]],"legendLabel":"series1_legend"},...,{"dataPoints":...,"legendLabel:...}]}
             * @param jsonData
             * @return plotData
             */
            function processJson(jsonData) {
                var plotData = {series: [], data: [], error: ""};

                if (ktl.isBlank(jsonData) || ktl.isBlank(jsonData['plotData']) || jsonData['plotData'].length == 0) {
                    plotData.error = "没有数据";
                    return plotData;
                }

                var chartSeries = [];
                var chartData = [];
//        var theme = {seriesStyles:{seriesColors:chartColorScheme}};
                var seriesColors = chartColorScheme;

                // Iterate all series
                $.each(jsonData['plotData'], function (i, item) {
                    if (chartType === "pie") {
                        i = 0; // Pie chart has only one series
                    }
                    // For on series (legend + data)
                    chartData[i] = item['dataPoints'];
                    var color = null;
                    if (!ktl.isBlank(seriesColors)) {
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

var UiKit = QadUi;

$(function () {
    kui.uiBuildSidebar('#page-sidebar-left');
});