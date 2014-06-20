/**
 *
 * JavaScript for utility functions.
 *
 * @author Leo Liao, 2014/03, extracted from app-util.js
 *
 */

/**
 * Server context path need be initialized if your application is not deployed under web root "/".
 * For example, your web application is accessed from http://127.0.0.1/qad-app.
 * The context path is `qad-app`
 * @global
 * @type {string}
 */
var qadServerContextPath = window.qadServerContextPath || '';
/**
 * Define HTTPS port.
 * To support HTTPS login, add `<script type="text/javascript">window.qadHttpsPort=8443;</script>`
 * before `<#include "/modules/qad/public/qad-js.ftl"/>`. Here `8443` shall be changed to HTTPS port.
 * @type {number}
 */
var qadHttpsPort = window.qadHttpsPort || -1;

(function (window) {
    "use strict";

    /**
     * A wrapper for console log. Some ideas borrowed from http://benalman.com/code/projects/javascript-debug/examples/debug/.
     * Exposed as `logger`
     * @private
     * @memberof "logger"
     * @returns {{error: *, warn: *, info: *, debug: *, log: *}}
     * @constructor
     */
    function Logger() {
        var alertOn = ["error"];
        var logMethods = [ 'error', 'warn', 'info', 'debug', 'log' ];
        var that = {};
        for (var i = logMethods.length; i >= 0; i--) {
            (function () {
                var level = logMethods[i];

                that[level] = function () {
                    var console = window.console;
                    if (console && console[level]) {
                        console[ level ].apply(window.console, arguments);
                    }
                    if (alertOn.indexOf(level) >= 0) {
                        window.alert([].join.call(arguments, "\n"));
                    }
                };
            })();
        }
        // We return an object with explicit properties instead of just returning `that`.
        // Because this enable syntax checking and auto completion with IDE (IntelliJ IDEA)
        return {
            error: that.error,
            warn: that.warn,
            info: that.info,
            debug: that.debug,
            log: that.log
        };
    }

    /**
     * A global Logger instance.
     * @global
     * @type {Logger}
     */
    window.logger = new Logger();
})(window);

(function (window, logger) {
    "use strict";

    /**
     * Utilities exposed as `ktl`
     * @private
     * @memberof "ktl"
     * @constructor
     */
    function QadTools() {
        var that = this;
        var markdownOptions = null;

        //======================================================================
        // String
        //======================================================================
        /**
         * If an object is null, undefined, or empty string ""
         * @param obj
         * @return {Boolean}
         */
        this.isBlank = function (obj) {
            return (typeof obj === "undefined" || obj === null || obj === "");
        };

        /**
         * @param obj
         * @returns {boolean}
         */
        this.isNotBlank = function (obj) {
            return !that.isBlank(obj);
        };

        /**
         * Convert markdown text to to HTML via [marked.js](https://github.com/chjj/marked).
         * It supports gfm (Github Flavored Markdown)
         * @param text string in markdown
         */
        this.markdownToHtml = function (text) {
            if (typeof marked === "undefined") {
                logger.warn("Markdown library marked.js not found");
                return text;
            }
            if (markdownOptions === null) {
                var renderer = new marked.Renderer();
                renderer.table = function (header, body) {
                    return '<table class="table table-bordered table-condensed">\n' +
                        '<thead>\n' + header + "</thead>\n<tbody>\n" + body + '</tbody>\n' + '</table>\n';
                };
                markdownOptions = {
                    gfm: true,
                    pedantic: false,
                    sanitize: false,
                    tables: true,
                    smartLists: false,
                    breaks: false,
                    renderer: renderer
                };
            }
            try {
                return marked(text, markdownOptions);
            } catch (error) {
                logger.warn(error.message);
                return text;
            }
        };

        /**
         * From http://phpjs.org/functions/strip_tags/
         * @param input
         * @param allowed
         * @returns {XML}
         */
        this.stripHtmlTags = function (input, allowed) {
            allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
            var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
                commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
            return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
                return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
            });
        };

        /**
         * Escape HTML characters. It converts `&` to `&amp;`, `<` to `&lt;`, `>` to `&gt;`
         * @param source
         * @return {*} "" if source is {@link isBlank}
         * @see {@link unescapeHTML}
         */
        this.escapeHtml = function (source) {
            if (that.isBlank(source)) {
                return "";
            }
            return (source + "").replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
        };

        /**
         * Unescape HTML characters. It converts "&amp;" to "&", "&lt;" to "<", "&gt;" to ">"
         * @param source
         * @return {*} "" if source is {@link isBlank}
         * @see {@link escapeHtml}
         */
        this.unescapeHtml = function (source) {
            if (that.isBlank(source)) {
                return "";
            }
            return source.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
        };

        /**
         * Shorten text to a specified length
         * @param text
         * @param length
         * @param escapeHtml
         * @return {String}
         */
        this.shortenText = function (text, length, escapeHtml) {
            var out = "";
            if (that.isNotBlank(text)) {
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
        };

        //======================================================================
        // URL
        //======================================================================

        /**
         * URL with "#", "javascript:" are not qualified for AJAX
         * @param url
         * @return {Boolean} `true` for a valid AJAX url
         */
        this.isValidAjaxUrl = function (url) {
            return !(that.isBlank(url) || url.indexOf("#") === 0 || url.indexOf("javascript:") === 0 /*|| !isBlank($(this).attr("target"))*/)
        };
        /**
         * Get hash from a URL.
         * getUrlHash('#tab-1') == '#tab-1'
         * getUrlHash('/some-link') == null
         * getUrlHash('/some-link#target') == 'target'
         * getUrlHash('http://some.host/some-link#target') == 'target'
         * @param url a full url or partial url
         * @returns {null}
         */
        this.getUrlHash = function (url) {
            var hashPos = url.lastIndexOf('#');
            return hashPos < 0 ? null : url.substring(hashPos);
        };

        /**
         * Extract properties from an object and to sparams JSON string.
         * @param object contains properties
         * @param properties properties to be extracted
         * @return {String}
         */
        this.toSparamsJsonString = function (object, properties) {
            var map = {};
            for (var i = 0; i < properties.length; i++) {
                map["sparams['" + properties[i] + "']"] = object[properties[i]];
            }
            return  JSON.stringify(map);
        };

        //======================================================================
        // STATISTICS
        //======================================================================
        this.trackLink = function (url) {
            logger.warn("Function trackLink need implemented by application");
        };

        /**
         * Here's a more flexible version, which allows you to create
         * reusable sort functions, and sort by any field
         * http://stackoverflow.com/questions/979256/how-to-sort-an-array-of-javascript-objects
         */
        this.sortBy = function (field, reverse, primer) {
            var key = function (x) {
                return primer ? primer(x[field]) : x[field];
            };
            return function (a, b) {
                var A = key(a), B = key(b);
                return ((A < B) ? -1 :
                    (A > B) ? +1 : 0) * [-1, 1][+!!reverse];
            };
        };

        /**
         * Format a date with pattern
         * @param date
         * @param pattern default "yyyy-MM-dd HH:mm:ss"
         * @return {*}
         */
        this.formatDateTime = function (date, pattern) {
            if (that.isBlank(date)) {
                return "";
            }
            var type = jQuery.type(date);
            var dateObj;
            if (type === 'date') {
                dateObj = date;
            } else {
                dateObj = Date.parse(date);
            }
            var patternStr = pattern;
            if (that.isBlank(pattern)) {
                patternStr = "yyyy-MM-dd HH:mm:ss";
            }
            if ((dateObj !== null && !isNaN(dateObj))) {
                return dateObj.toString(patternStr);
            }
            return date;
        };
    }

    /**
     * As global exposed accessor for {@link QadTools}
     * @global
     * @type {QadTools}
     */
    window.ktl = new QadTools();

    /**
     * @deprecated use window.ktl
     * @type {QadTools}
     */
    window.klib = window.ktl;
})(window, logger);

(function (window, ktl, logger) {
    "use strict";
    var localStorage = window.localStorage;

    /**
     * User preference. Exposed as `kup`
     * @param url Server URL to read(GET)/save(POST) preference
     * @private
     * @memberof "kup"
     * @constructor
     */
    function QadUserPreference(url) {
        var USE_LOCAL_STORAGE = false;
        var LOCAL_PREF_KEY = "qad.pref";
        var serverUrl = url;
        var localPref = {};

        function saveServerPref(prefJson) {
            if (ktl.isBlank(serverUrl)) {
                logger.warn("saveServerPref: Server URL not set");
                return;
            }
            $.ajax({type: "post", url: serverUrl, data: {myPrefJson: prefJson}});
        }

        /**
         * Load preference from local storage
         */
        function loadFromLocalStorage() {
            var json = localStorage.getItem(LOCAL_PREF_KEY);
            if (!ktl.isBlank(json)) {
                try {
                    localPref = JSON.parse(json);
                } catch (error) {
                    logger.warn(error.message);
                }
            }
        }

        /**
         * Load preference from server
         */
        function loadFromRemoteServer() {
            // We use sync!
            $.ajax({type: "get", url: serverUrl, async: false, success: function (xhr) {
                localPref = xhr || {};
            }});
        }

        function loadQadPref() {
            if (ktl.isBlank(serverUrl)) {
                logger.warn("loadQadPref:Server URL not set, use local storage");
                loadFromLocalStorage();
            } else {
                loadFromRemoteServer();
            }
        }

        /**
         * Save user preference.
         * @param key preference key
         * @param pref preference object corresponding to the key
         * @param forceLocal {boolean} `true` to force use in local storage
         */
        this.savePreference = function (key, pref, forceLocal) {
            var obj = {};
            obj[key] = pref;
            // NOTE: deep copy cannot overwrite non-empty array with empty array.
            localPref = $.extend(false, localPref, obj);
            var json = JSON.stringify(localPref);
            saveServerPref(json);
            if (USE_LOCAL_STORAGE || forceLocal === true) {
                localStorage.setItem(LOCAL_PREF_KEY, json);
            }
        };

        /**
         * Load user prederence
         * @param key preference key
         * @param defaultPref default preference
         * @param forceLocal {boolean} `true` to force use in local storage
         * @return {Object} preference object
         */
        this.loadPreference = function (key, defaultPref, forceLocal) {
            var pref = localPref[key];
            if (ktl.isBlank(pref) && forceLocal === true) {
                loadFromLocalStorage();
                pref = localPref[key];
            }
            return ktl.isBlank(pref) ? defaultPref : pref;
        };

        loadQadPref();
    }

    /**
     * @global
     * @type {QadUserPreference}
     */
    window.kup = new QadUserPreference(qadServerContextPath + "/my/pref.json");

    /**
     * @deprecated for compatibility with old app code. Use window.kup
     * @type {QadUserPreference}
     */
    window.klib.pref = window.kup;
})(window, ktl, logger);