/**
 * Global variables.
 * @author Leo Liao, 2013-11-27, created
 */

//==============================================================================
// Global variables and accessors
//==============================================================================
var AppRuntime = {
    charting: {},
    oTables: {},
    oTableParams: {},
    isFormSubmitted: false,
    jqPlots: {},
    empty: function () {
        for (var p in AppRuntime) {
            if (typeof AppRuntime[p] === 'object') {
                AppRuntime[p] = {};
            }
        }
    }
};
<!-- Init global variables -->
//TODO: refactor AppRuntime to a class object
AppRuntime.charting = {
    //http://colorbrewer2.org/
    COLOR_SCHEME_ANDROID: ['#33B5E5', '#AA66CC', '#99CC00', '#FFBB33', '#FF4444'],
    COLOR_SCHEME_ANDROID_DARK: ['#0099CC', '#9933CC', '#669900', '#FF8800', '#CC0000'],
    COLOR_SCHEME_HP2007: ['#007FC5', '#00A145', '#56378A', '#FFDD00', '#F39900', '#E31C19'],
    COLOR_SCHEME_EXCEL: ['#FFC000', '#92D050', '#00B0F0', '#7030A0', '#808080', '#F79646' ]
};
AppRuntime.charting.colorScheme = AppRuntime.charting.COLOR_SCHEME_ANDROID;


/**
 * Init columns settings for a table
 * @param tableId
 * @param columns
 */
function setTableColumns(tableId, columns) {
    AppRuntime.oTableParams[tableId] = {columns: columns};
}

/**
 * Retrieve column settings for a table
 * Fall back to old style `columns_${tableId}`
 * @param tableId
 * @returns {*}
 */
function getTableColumns(tableId) {
    if (AppRuntime.oTableParams[tableId])
        return AppRuntime.oTableParams[tableId].columns || window['columns_' + tableId];
    return window['columns_' + tableId];
}

var AppConst = {
    piwikServer: (("https:" == document.location.protocol) ? "https" : "http") + "://" + document.location.hostname + ":" + document.location.port + "/piwik//"
};
$(function () {
    $.ajaxSetup({
        headers: {"Device-Type": "desktop"}
    });
});