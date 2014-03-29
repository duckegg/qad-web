
//==============================================================================
// SORTING
// http://www.datatables.net/plug-ins/sorting
//==============================================================================

/*
 jQuery.fn.dataTableExt.oSort['alt-string-asc'] = function (a, b) {
 var x = a.match(/alt="(.*?)"/)[1].toLowerCase();
 var y = b.match(/alt="(.*?)"/)[1].toLowerCase();
 return ((x < y) ? -1 : ((x > y) ? 1 : 0));
 };

 jQuery.fn.dataTableExt.oSort['alt-string-desc'] = function (a, b) {
 var x = a.match(/alt="(.*?)"/)[1].toLowerCase();
 var y = b.match(/alt="(.*?)"/)[1].toLowerCase();
 return ((x < y) ? 1 : ((x > y) ? -1 : 0));
 };

 jQuery.fn.dataTableExt.oSort['title-string-asc'] = function (a, b) {
 var x = a.match(/title="(.*?)"/)[1].toLowerCase();
 var y = b.match(/title="(.*?)"/)[1].toLowerCase();
 return ((x < y) ? -1 : ((x > y) ? 1 : 0));
 };

 jQuery.fn.dataTableExt.oSort['title-string-desc'] = function (a, b) {
 var x = a.match(/title="(.*?)"/)[1].toLowerCase();
 var y = b.match(/title="(.*?)"/)[1].toLowerCase();
 return ((x < y) ? 1 : ((x > y) ? -1 : 0));
 };
 */
jQuery.extend(jQuery.fn.dataTableExt.oSort, {
    "date-uk-pre": function (a) {
        var ukDatea = a.split('/');
        return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
    },

    "date-uk-asc": function (a, b) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },

    "date-uk-desc": function (a, b) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
});

jQuery.extend(jQuery.fn.dataTableExt.oSort, {
    "ip-address-pre": function (a) {
        var m = a.split("."), x = "";

        for (var i = 0; i < m.length; i++) {
            var item = m[i];
            if (item.length == 1) {
                x += "00" + item;
            } else if (item.length == 2) {
                x += "0" + item;
            } else {
                x += item;
            }
        }

        return x;
    },

    "ip-address-asc": function (a, b) {
        return ((a < b) ? -1 : ((a > b) ? 1 : 0));
    },

    "ip-address-desc": function (a, b) {
        return ((a < b) ? 1 : ((a > b) ? -1 : 0));
    }
});

$.fn.dataTableExt.afnSortData['dom-checkbox'] = function (oSettings, iColumn) {
    var aData = [];
    $('td:eq(' + iColumn + ') input', oSettings.oApi._fnGetTrNodes(oSettings)).each(function () {
        aData.push(this.checked == true ? "1" : "0");
    });
    return aData;
};

$.fn.dataTableExt.afnSortData['dom-select'] = function (oSettings, iColumn) {
    var aData = [];
    $('td:eq(' + iColumn + ') select', oSettings.oApi._fnGetTrNodes(oSettings)).each(function () {
        aData.push($(this).val());
    });
    return aData;
};

//==============================================================================
// RELOAD
//==============================================================================
//http://datatables.net/plug-ins/api
$.fn.dataTableExt.oApi.fnReloadAjax = function (oSettings, sNewSource, fnCallback, bStandingRedraw) {
    if (typeof sNewSource != 'undefined' && sNewSource != null) {
        oSettings.sAjaxSource = sNewSource;
    }
    this.oApi._fnProcessingDisplay(oSettings, true);
    var that = this;
    var iStart = oSettings._iDisplayStart;
    var aData = [];

    this.oApi._fnServerParams(oSettings, aData);

    oSettings.fnServerData(oSettings.sAjaxSource, aData, function (json) {
        /* Clear the old information from the table */
        that.oApi._fnClearTable(oSettings);

        /* Got the data - add it to the table */
        var aData = (oSettings.sAjaxDataProp !== "") ?
            that.oApi._fnGetObjectDataFn(oSettings.sAjaxDataProp)(json) : json;

        for (var i = 0; i < aData.length; i++) {
            that.oApi._fnAddData(oSettings, aData[i]);
        }

        oSettings.aiDisplay = oSettings.aiDisplayMaster.slice();
        that.fnDraw();

        if (typeof bStandingRedraw != 'undefined' && bStandingRedraw === true) {
            oSettings._iDisplayStart = iStart;
            that.fnDraw(false);
        }

        that.oApi._fnProcessingDisplay(oSettings, false);

        /* Callback user function - for event handlers etc */
        if (typeof fnCallback == 'function' && fnCallback != null) {
            fnCallback(oSettings);
        }
    }, oSettings);
};


//==============================================================================
// FILTER DELAY
//==============================================================================

jQuery.fn.dataTableExt.oApi.fnSetFilteringDelay = function (oSettings, iDelay) {
    var _that = this;
    this.each(function (i) {
        $.fn.dataTableExt.iApiIndex = i;
        iDelay = (iDelay && (/^[0-9]+$/.test(iDelay))) ? iDelay : 250;

        var $this = this, oTimerId;
        var anControl = $('input', _that.fnSettings().aanFeatures.f);

        anControl.unbind('keyup').bind('keyup', function (event) {
            window.clearTimeout(oTimerId);

            if (event.keyCode == '13') {
                // cr, we filter immedately
                $.fn.dataTableExt.iApiIndex = i;
                _that.fnFilter(anControl.val());
            } else {
                // not cr, set new timer
                oTimerId = window.setTimeout(function () {
                    $.fn.dataTableExt.iApiIndex = i;
                    _that.fnFilter(anControl.val());
                }, iDelay);
            }

        });

        return this;
    });
    return this;
};

//==============================================================================
// Set the classes that TableTools uses to something suitable for Bootstrap
//==============================================================================
$.extend(true, $.fn.DataTable.TableTools.classes, {
    "container": "btn-group",
    "buttons": {
        "normal": "btn  btn-default btn-xs",
        "disabled": "btn btn-default btn-xs disabled"
    },
    "collection": {
        "container": "DTTT_dropdown dropdown-menu",
        "buttons": {
            "normal": "",
            "disabled": "disabled"
        }
    }
});

// Have the collection use a bootstrap compatible dropdown
$.extend(true, $.fn.DataTable.TableTools.DEFAULTS.oTags, {
    "collection": {
        "container": "ul",
        "button": "li",
        "liner": "a"
    }
});