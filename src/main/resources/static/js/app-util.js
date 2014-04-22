/*******************************************************************************
 *
 * JavaScript for utility functions.
 *
 * @author Leo Liao, 2012/04, created
 *
 ******************************************************************************/

/**
 * Set if a form is submitted. It is generally used when the main page need do something link refresh
 * after a ajax form is submitted.
 * @param isSubmitted
 */
function setFormSubmited(isSubmitted) {
    AppRuntime.isFormSubmitted = isSubmitted;
}

/**
 * If a form is submitted.
 * @return {Boolean}
 */
function isFormSubmitted() {
    return AppRuntime.isFormSubmitted;
}


//==============================================================================
// Functions: strings
//==============================================================================

/**
 * @deprecated use klib
 */
function stripHtmlTags(input, allowed) {
    return klib.stripHtmlTags(input, allowed);
}

/**
 * @deprecated use klib
 */
function escapeHTML(source) {
    return klib.escapeHtml(source);
}

/**
 * @deprecated use klib
 */
function unescapeHTML(source) {
    return klib.unescapeHtml(source);
}

/**
 * @deprecated use klib
 */
function shortenText(text, length, escapeHtml) {
    return klib.shortenText(text, length, escapeHtml);
}
///**
// * Replace string. It handles null or undefined string.
// * @param source
// * @param searchValue
// * @param replaceValue
// * @return {*} "" if source is {@link isBlank}
// * @deprecated redundant
// */
//function replaceString(source, searchValue, replaceValue) {
//    if (isBlank(source)) {
//        return source;
//    }
//    return source.replace(searchValue, replaceValue);
//}


/**
 * Extract properties from an object and to sparams JSON string.
 * @param object contains properties
 * @param properties properties to be extracted
 * @return {String}
 */
function toSparamsJsonString(object, properties) {
    var map = new Object();
    for (var i = 0; i < properties.length; i++) {
        map["sparams['" + properties[i] + "']"] = object[properties[i]];
    }
    return  JSON.stringify(map);
}

/**
 * @deprecated use klib
 */
function isBlank(obj) {
    return klib.isBlank(obj);
}
/**
 * @deprecated use klib
 */
function isNotBlank(obj) {
    return !klib.isBlank(obj);
}
/**
 * @deprecated use klib
 */
function formatDateTime(date, pattern) {
    return klib.formatDateTime(date, pattern);
}


//==============================================================================
// Functions: URL
//==============================================================================

/**
 * URL with "#", "javascript:" are not qualified for AJAX
 * @param url
 * @return {Boolean} true for a valid AJAX url
 */
function isValidAjaxUrl(url) {
    return !(isBlank(url) || url.indexOf("#") == 0 || url.indexOf("javascript:") == 0 /*|| !isBlank($(this).attr("target"))*/)
}

/**
 * Get hash from a URL.
 * getUrlHash('#tab-1') == '#tab-1'
 * getUrlHash('/some-link') == null
 * getUrlHash('/some-link#target') == 'target'
 * getUrlHash('http://some.host/some-link#target') == 'target'
 * @param url a full url or partial url
 * @returns {null}
 */
function getUrlHash(url) {
    var hashPos = url.lastIndexOf('#');
    return hashPos < 0 ? null : url.substring(hashPos);
}

///**
// * @deprecated
// */
//function _toEmbedUrl(url) {
//    return _toLayoutUrl(url, "embed");
//}
//
///**
// * @param url
// * @param layout
// * @returns {XML}
// * @deprecated
// */
//function _toLayoutUrl(url, layout) {
//    var qstr = "decorator=" + layout + "&confirm=true";
//    var out;
//    if (url.indexOf(qstr) >= 0 || url.indexOf("javascript:") >= 0 || url.indexOf("#") == 0) {
//        out = url;
//    } else {
//        out = url + (url.indexOf("?") > 0 ? "&" : "?");
//        out = out + qstr
//    }
//    out = out.replace(/ /g, "%20");
//    return out;
//}

//==============================================================================
// Functions: status and message
//==============================================================================

/**
 * @deprecated use {@link flashMessage}
 */
function _showProcessing(isShow) {
    if (isShow) {
        flashMessage("info", "正在处理", 0);
    }
    else {
        flashMessage();
    }
}

function hideLoading() {
    $('.loading:visible').remove();
}
function showLoading(style) {
    if (style === "bar") {
        return '<div class="loading bar"><i class="fa fa-spinner fa-spin"></i> 正在加载...</div>'
    } else {
        return '<div class="loading inline"><i class="fa fa-spinner fa-spin"></i> 正在加载...</div>';
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

///**
// * If processing status bar is visible
// * @see _showProcessing
// * @deprecated
// */
//function isProcessing() {
////    return $('#global-status-bar').is(":visible");
//}

//==============================================================================
// Functions: AJAX
//==============================================================================

/**
 * Call ajax. It shows processing message before calling.
 * @param options $.ajax options
 */
function callAjax(options) {
//    _showProcessing(true);
    var obj = $.ajax(options);
//    _showProcessing(false);
    return obj;
}

/**
 * Call ajax with POST.
 * @param options
 */
function postAjax(options) {
    options.type = "post";
    callAjax(options);
}

/**
 * Call pjax. It shows processing message before calling.
 * @param url
 * @param successMessage flash message when success
 */
function callPjax(url, successMessage) {
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
    kui.showToast("success", successMessage, 3);
}

var logger = {
    alertOn: ["error"],
    debug: function (msg, locator) {
        console.debug(msg, locator);
    },
    warn: function (msg) {
        this.log("WARN: " + msg);
    },
    info: function (msg) {
        this.log("INFO: " + msg);
    },
    error: function (msg) {
        this.log("ERROR: " + msg);
        if (this.alertOn.indexOf("error") >= 0)
            alert(msg);
    },
    log: function (msg, locator) {
        if (window.console && window.console.log) {
            if (isBlank(locator))
                locator = arguments.callee.caller.name;
            if (isNotBlank(locator))
                window.console.log("........." + locator + ".........");
            window.console.log(msg);
        }
        else if (window.opera && window.opera.postError) {
            window.opera.postError(msg);
        }
    }
};

//TODO: move out !
function showProgressbar(v) {
    var used = '';
    var defaultWidth = 40;
    var defaultHeight = 15.28;
    var colorWidth = defaultWidth * v;
    var color = '';
    if (v <= 0.15) {
        color = 'red';
    } else if (v > 0.15 && v <= 0.3) {
        color = 'orange';
    } else {
        color = 'green';
    }
    used = '<span><div title="剩余' + v * 100 + '%" style="float:left;border:1px solid #BEBEBE;border-radius: 2px; width:' + defaultWidth + 'px; height:' + defaultHeight + 'px">' +
        '<div style="background:' + color + '; width:' + colorWidth + 'px; height:' + (defaultHeight - 2) + 'px; position:relative; top:1px; left:1px;"></div></div>' + Math.round(v * 100) + '%</span>';

    return used;
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

///**
// * Save user preference.
// * @param key preference key
// * @param pref preference object
// * @deprecated use klib.pref.savePreference()
// */
//function savePreference(key, pref) {
//    return klib.pref.savePreference(key, pref);
//}
//
///**
// * @deprecated use klib.pref.loadPreference()
// */
//function loadPreference(key, defaultPref) {
//    return klib.pref.loadPreference(key, defaultPref);
//}

//==============================================================================
// Functions: List
//==============================================================================
/**
 * @deprecated use klib
 */
function sortBy(field, reverse, primer) {
    var key = function (x) {
        return primer ? primer(x[field]) : x[field]
    };
    return function (a, b) {
        var A = key(a), B = key(b);
        return ((A < B) ? -1 :
            (A > B) ? +1 : 0) * [-1, 1][+!!reverse];
    }
}


function disableControls(container) {
    $('form .form-actions', container).each(function () {
        $(this).hide();
    });
    $('input', container).each(function () {
        $(this).attr('readonly', 'true');
    });
    $('select,input:checkbox,a,textarea,button', container).each(function () {
        $(this).attr('disabled', 'disabled');
    });
}

function piwikTrackLink(url) {
    try {
        window._paq = window._paq || [];

        var u = AppConst.piwikServer;
        var baseUrl = (u + 'piwik.php');
        var siteId = 1;

        if (isNotBlank(url)) {
            if (isBlank(window.Piwik)) {
                logger.warn("Piwik is not defined. Possible incorrect piwik server '" + AppConst.piwikServer + "'");
            } else {
                var tracker = window.Piwik.getTracker(baseUrl, siteId);
                tracker.trackPageView(url);
            }
        } else {
            window._paq.push(['trackPageView']);
            window._paq.push(['enableLinkTracking']);
            window._paq.push(['setTrackerUrl', baseUrl]);
            window._paq.push(['setSiteId', siteId]);
            if ($('#piwik-script').length == 0) {
                var d = document, g = d.createElement('script'), s = d.getElementsByTagName('script')[0];
                g.type = 'text/javascript';
                g.defer = true;
                g.async = true;
                g.src = u + 'piwik.js';
                g.id = "piwik-script";
                s.parentNode.insertBefore(g, s);
            }
        }
    } catch (err) {
        logger.error(err.message);
    }
}
(function (window) {

})();
