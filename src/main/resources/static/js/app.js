/**
 * Application specific javascript
 * TODO: the file should be moved to app js folder
 */
var appSession = {
    isPiwikWarned: false
};

/**
 * Track link with piwik
 * @param url
 */
function piwikTrackLink(url) {
    "use strict";

    var piwikServer = (("https:" === document.location.protocol) ? "https" : "http") + "://" +
        document.location.hostname + ":" +
        document.location.port + "/piwik//";

    try {
        window._paq = window._paq || [];

        var u = piwikServer;
        var baseUrl = (u + 'piwik.php');
        var siteId = 1;

        if (ktl.isNotBlank(url)) {
            if (ktl.isBlank(window.Piwik)) {
                if (!appSession.isPiwikWarned) {
                    appSession.isPiwikWarned = true;
                    logger.warn("Piwik is not defined. Possible incorrect piwik server '" + piwikServer + "'");
                }
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

// Override ktl's trackLink
ktl.trackLink = piwikTrackLink;

// Following for compatibility with old app code
var uiKit = kui;
var loadPreference = kup.loadPreference;

/**
 * @param v
 * @returns {string}
 */
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