/*******************************************************************************
 *
 * TODO: Move all functions out of qad to application specific files
 *
 ******************************************************************************/
//==============================================================================
// Functions: status and message
//==============================================================================


/**
 * @deprecated use kui.hideLoading()
 * @returns {*}
 */
function hideLoading() {
    return kui.hideLoading();
}

/**
 * @deprecated use kui.setFormSubmited
 */
function setFormSubmited(isSubmitted) {
    return kui.setFormSubmited(isSubmitted);
}

/**
 * @deprecated use kui
 */
function isFormSubmitted() {
    return kui.isFormSubmitted();
}


//==============================================================================
// Functions: strings
//==============================================================================

/**
 * @deprecated use ktl
 */
function toSparamsJsonString(object, properties) {
    return ktl.toSparamsJsonString(object, properties);
}


//==============================================================================
// Functions: URL
//==============================================================================

/**
 * @deprecated use ktl.isValidAjaxUrl
 */
function isValidAjaxUrl(url) {
    return ktl.isValidAjaxUrl(url);
}

/**
 * @deprecated use ktl
 */
function getUrlHash(url) {
    return ktl.getUrlHash(url);
}
/**
 * @deprecated use ktl
 */
function stripHtmlTags(input, allowed) {
    return ktl.stripHtmlTags(input, allowed);
}

/**
 * @deprecated use ktl.escapeHTML
 */
function escapeHTML(source) {
    return ktl.escapeHtml(source);
}

/**
 * @deprecated use ktl.unescapeHTML
 */
function unescapeHTML(source) {
    return ktl.unescapeHtml(source);
}

/**
 * @deprecated use ktl.shortenText
 */
function shortenText(text, length, escapeHtml) {
    return ktl.shortenText(text, length, escapeHtml);
}

/**
 * @deprecated use ktl.isBlank
 */
function isBlank(obj) {
    return ktl.isBlank(obj);
}
/**
 * @deprecated use ktl.isNotBlank
 */
function isNotBlank(obj) {
    return !ktl.isBlank(obj);
}
/**
 * @deprecated use ktl.formatDateTime
 */
function formatDateTime(date, pattern) {
    return ktl.formatDateTime(date, pattern);
}
/**
 * @deprecated use kui.showToast
 */
function _showProcessing(isShow) {
    if (isShow) {
        flashMessage("info", "正在处理", 0);
    }
    else {
        flashMessage();
    }
}
/**
 * @deprecated use kui.showToast
 */
function flashMessage(status, msg, autoCloseSeconds) {
    return kui.showToast(status, msg, autoCloseSeconds);
}
/**
 * @deprecated use {@link #flashMessage} instead
 */
function statusMessage(message, autoCloseSeconds) {
    flashMessage("info", message, autoCloseSeconds);
}
//==============================================================================
// Functions: AJAX
//==============================================================================

/**
 * @deprecated use kui
 */
function callAjax(options) {
    return kui.callAjax(options);
}

/**
 * @deprecated use kui
 */
function postAjax(options) {
    return kui.postAjax(options);
}

/**
 * @deprecated use kui
 */
function callPjax(url, successMessage) {
    return kui.callPjax(url, successMessage);
}



//==============================================================================
// Plugins
//==============================================================================

/**
 * jQuery alterClass plugin
 *
 * Remove element classes with wildcard matching. Optionally add classes:
 *   $( '#foo' ).alterClass( 'foo-* bar-*', 'foobar' )
 *
 * Copyright (c) 2011 Pete Boere (the-echoplex.net)
 * Free under terms of the MIT license: http://www.opensource.org/licenses/mit-license.php
 *
 */
(function ($) {
    "use strict";

    $.fn.alterClass = function (removals, additions) {

        var self = this;

        if (removals.indexOf('*') === -1) {
            // Use native jQuery methods if there is no wildcard matching
            self.removeClass(removals);
            return !additions ? self : self.addClass(additions);
        }

        var patt = new RegExp('\\s' +
            removals.
                replace(/\*/g, '[A-Za-z0-9-_]+').
                split(' ').
                join('\\s|\\s') +
            '\\s', 'g');

        self.each(function (i, it) {
            var cn = ' ' + it.className + ' ';
            while (patt.test(cn)) {
                cn = cn.replace(patt, ' ');
            }
            it.className = $.trim(cn);
        });

        return !additions ? self : self.addClass(additions);
    };

})(jQuery);


//==============================================================================
// Functions: List
//==============================================================================
/**
 * @deprecated use ktl.sortBy
 */
function sortBy(field, reverse, primer) {
    return ktl.sortBy(field, reverse, primer);
}

/**
 * @deprecated use kui
 * @param container
 */
function disableControls(container) {
    return kui.disableControls(container);
}


/**
 * @deprecated use kui.closeDialog
 */
function closeDialog(element) {
    return kui.closeDialog(element);
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
    logger.warn("Do not use dtUpdateCell, it is messy!");
//    var selectedCell = kao.oTableParams[tableId].selectedCell;
//    $(selectedCell).siblings(cellSelector).html(escapeHTML(newValue));
//    var table = kao.oTables[tableId];
//    var pos = table.fnGetPosition(selectedCell);
//    table.fnGetData(pos[0])[dataField] = newValue;
}

/**
 * @deprecated use kui.plotChart
 */
function plotChart(chartId, chartOptions, chartType) {
    return kui.plotChart(chartId, chartOptions, chartType);
}


/**
 * @deprecated use kui.refreshDataTable
 */
function refreshDataTable(tableId) {
    return kui.refreshDataTable(tableId)
}

/**
 * @deprecated use kui.replotChart
 */
function replotChart(chartId) {
    return kui.replotChart(chartId);
}

/**
 * @deprecated use kui#showLoading
 * @param style
 * @returns {string}
 */
function showLoading(style) {
    return kui.showLoading(style);
}
/**
 * Global variables.
 * @author Leo Liao, 2013-11-27, created
 */

/**
 * Application global object.
 */
function QadAppObject() {
    "use strict";
    //http://colorbrewer2.org/
    var COLOR_SCHEME_ANDROID = ['#33B5E5', '#AA66CC', '#99CC00', '#FFBB33', '#FF4444'];
    var COLOR_SCHEME_ANDROID_DARK = ['#0099CC', '#9933CC', '#669900', '#FF8800', '#CC0000'];
    var COLOR_SCHEME_HP2007 = ['#007FC5', '#00A145', '#56378A', '#FFDD00', '#F39900', '#E31C19'];
    var COLOR_SCHEME_EXCEL = ['#FFC000', '#92D050', '#00B0F0', '#7030A0', '#808080', '#F79646' ];
    var globals = {
        /**
         * @deprecated
         */
        charting: {
            colorScheme: COLOR_SCHEME_ANDROID
        },
        /**
         * @deprecated stored in QadUi
         */
        oTables: {},
        /**
         * @deprecated stored in QadUi
         */
        oTableParams: {},
        /**
         * @deprecated stored in QadUi
         */
        isFormSubmitted: false,
        /**
         * @deprecated stored in QadUi
         */
        jqPlots: {}
    };
    this.empty = function () {
        logger.warn("Not implemented");
//        for (var p in QadAppObject) {
//            if (typeof QadAppObject[p] === 'object') {
//                QadAppObject[p] = {};
//            }
//        }
    };
    return globals;
}
/**
 * @global
 * @type {QadAppObject}
 */
var kao = new QadAppObject();

/**
 * @deprecated for compatibility with old app code. Use QadAppObject
 */
var AppRuntime = kao;

/**
 * @deprecated use kui.getTableColumns
 */
function getTableColumns(tableId) {
    return kui.getTableColumns(tableId);
}

/**
 * @deprecated
 * @type {{piwikServer: string}}
 */
var AppConst = {
    piwikServer: ""
};