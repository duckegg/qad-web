/*******************************************************************************
 *
 * JavaScript for utility functions.
 *
 * @author Leo Liao, 2014/03, extracted from app-util.js
 *
 ******************************************************************************/
'use strict';

var qadServerContextPath = window.qadServerContextPath || '';

(function (window) {
    /**
     * If an object is null, undefined, or empty string ""
     * @param obj
     * @return {Boolean}
     */
    function isBlank(obj) {
        return (typeof obj === "undefined" || obj === null || obj === "");
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isNotBlank(obj) {
        return !isBlank(obj);
    }

    /**
     * From http://phpjs.org/functions/strip_tags/
     * @param input
     * @param allowed
     * @returns {XML}
     */
    function stripHtmlTags(input, allowed) {
        allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
        var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
            commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
        return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
            return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
        });
    }

    /**
     * Escape HTML characters. It converts "&" to "&amp;", "<" to "&lt;", ">" to "&gt;"
     * @param source
     * @return {*} "" if source is {@link isBlank}
     * @see {@link unescapeHTML}
     */
    function escapeHtml(source) {
        if (isBlank(source))
            return "";
        return (source + "").replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    /**
     * Unescape HTML characters. It converts "&amp;" to "&", "&lt;" to "<", "&gt;" to ">"
     * @param source
     * @return {*} "" if source is {@link isBlank}
     * @see {@link escapeHtml}
     */
    function unescapeHtml(source) {
        if (isBlank(source)) {
            return "";
        }
        return source.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
    }

    /**
     * Shorten text to a specified length
     * @param text
     * @param length
     * @param escapeHtml
     * @return {String}
     */
    function shortenText(text, length, escapeHtml) {
        var out = "";
        if (isNotBlank(text)) {
            if (text.length > length) {
                out = text.substring(0, length) + "......";
            } else {
                out = text;
            }
            if (escapeHtml === true) {
                out = escapeHtml(out).replace(/\n/g, '<br/>');
            }
        }
        return out;
    }

    /**
     * Here's a more flexible version, which allows you to create
     * reusable sort functions, and sort by any field
     * http://stackoverflow.com/questions/979256/how-to-sort-an-array-of-javascript-objects
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

    /**
     * Format a date with pattern
     * @param date
     * @param pattern default "yyyy-MM-dd HH:mm:ss"
     * @return {*}
     */
    function formatDateTime(date, pattern) {
        if (isBlank(date))
            return "";
        var type = jQuery.type(date);
        var dateObj;
        if (type === 'date')
            dateObj = date;
        else
            dateObj = Date.parse(date);
        var patternStr = pattern;
        if (isBlank(pattern)) {
            patternStr = "yyyy-MM-dd HH:mm:ss";
        }
        if ((dateObj !== null && !isNaN(dateObj))) {
            return dateObj.toString(patternStr);
        }
        return date;
    }

    window.klib = {
        pref: new QadPref(qadServerContextPath + "/my/pref.json"),
        stripHtmlTags: stripHtmlTags,
        escapeHtml: escapeHtml,
        unescapeHtml: unescapeHtml,
        isBlank: isBlank,
        isNotBlank: isNotBlank,
        sortBy: sortBy,
        shortenText: shortenText,
        formatDateTime: formatDateTime
    };

    /**
     * @param url Server URL to read(GET)/save(POST) preference
     * @constructor
     */
    function QadPref(url) {
        var USE_LOCAL_STORAGE = false;
        var LOCAL_PREF_KEY = "qad.pref";
        var serverUrl = null;
        var localPref = {};

        function saveServerPref(prefJson) {
            if (isBlank(serverUrl)) {
                logger.warn("saveServerPref: Server URL not set");
                return;
            }
            $.ajax({type: "post", url: serverUrl, data: {myPrefJson: prefJson}});
        }

        function loadQadPref() {
            if (isBlank(serverUrl)) {
                logger.info("loadQadPref:Server URL not set, use local storage");
                var json = localStorage.getItem(LOCAL_PREF_KEY);
                if (!isBlank(json)) {
                    try {
                        localPref = JSON.parse(json);
                    } catch (error) {
                        console.warn(error.message);
                    }
                }
            } else {
                // We use async!
                $.ajax({type: "get", url: serverUrl, async: false, success: function (xhr) {
                    localPref = xhr || {};
                }});
            }
        }

        /**
         * Save user preference.
         * @param key preference key
         * @param pref preference object
         */
        function savePreference(key, pref) {
            var obj = {};
            obj[key] = pref;
            $.extend(true, localPref, obj);
            var json = JSON.stringify(localPref);
            saveServerPref(json);
            if (USE_LOCAL_STORAGE)
                localStorage.setItem(LOCAL_PREF_KEY, json);
        }

        /**
         * Load user prederence
         * @param key preference key
         * @param defaultPref default preference
         * @return {Object} preference object
         */
        function loadPreference(key, defaultPref) {
            return localPref[key] || defaultPref;
        }

        this.initServer = function (url) {
            serverUrl = url;
            loadQadPref();
        };
        this.savePreference = savePreference;
        this.loadPreference = loadPreference;
        this.initServer(url);
    }
})(window, jQuery);