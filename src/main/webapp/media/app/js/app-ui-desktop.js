/*******************************************************************************
 *
 * Desktop UI adaptor.
 *
 * @author Leo Liao, 2012/11, created
 * @author Leo Liao, 2014/03/28, refactored
 *
 ******************************************************************************/
'use strict';

//==============================================================================
//                            DESKTOP UI KIT
//==============================================================================

function DesktopUiKit() {
    UiKit.call(this);
    this.type = "desktop";
    this.uiBuildPortlet = function (key) {
        $('.portlet-container').addClass("clearfix").kuiPortal();
    };
}

DesktopUiKit.prototype = new UiKit();
var uiKit = new DesktopUiKit();

//==============================================================================
// TABS AND NAVS
//==============================================================================

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
//        logger.debug("kuiAjaxNav:begin");
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
//            logger.debug("nav container=" + container);
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
    var LOCAL_STORAGE_KEY = "portletConfig";
    var DEFAULT_CONTAINER_CONFIG = {orders: [], portlets: {}};

    // The actual plugin constructor
    function KuiPortlet(element, options) {
        var that = this;
        this.element = element;
        this.options = $.extend({}, portletPluginDefaults, options);
        this.portletId = $(element).attr('id');
        this.portletConfig = {};
        this.containerId = this.options.containerId;
        if (qadUtil.isBlank(this.portletId)) {
            logger.error("KuiPortlet: Portlet need 'id' attribute to store configuration data");
            return;
        }
        if (qadUtil.isBlank(this.containerId)) {
            logger.error("KuiPortlet: Need specify containerId");
            return;
        }
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
            qadPref.savePreference(LOCAL_STORAGE_KEY, obj);
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
        var $portletHeader = $(m_sHeader, $portlet).disableSelection();
        createHeaderControls();
        initStyles();
        loadContent();
        createEditBox();
        initEventListener();

        function createHeaderControls() {
            var $headerBtnGroup = $('.btn-group.btn-group-sm', $portletHeader);
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
            var url = $portlet.data('kui-content-url');//||$portlet.data('url');
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
                            '<div class="text-right">' +
//                            '<button class="btn btn-default btn-sm js-action-save">保存</button> ' +
                            '<button class="btn btn-default btn-sm js-action-reset">重置</button></div>' +
                            '</div>';
                        $editBox = $('<div class="kui-portlet-edit-box" style="display:none;"/>')
                            .append(html).insertAfter($portletHeader)
                            .on('click', '.colors button', function (e) {
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
            // Handle links in portlet
            $portletContent.on('click.kui', 'a:not([data-dialog]):not([data-kui-target])', function (e) {
                var href = this.href;
                var $container = $(this).closest(".portlet-content");
                if (isValidAjaxUrl(href)) {
                    callAjax({
                        url: href,
                        success: function (xhr) {
                            $container.html(xhr);
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
     * @param options
     * @returns {*}
     */
    $.fn.kuiPortlet = function (options) {
        // A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
        return this.each(function () {
            if (!$.data(this, 'plugin_' + portletPluginName)) {
                $.data(this, 'plugin_' + portletPluginName,
                    new KuiPortlet(this, options));
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
        return qadPref.loadPreference(LOCAL_STORAGE_KEY, {})[containerId] || DEFAULT_CONTAINER_CONFIG;
    }

    function saveContainerConfig(containerId, containerPref) {
        var obj = {};
        obj[containerId] = containerPref;
        qadPref.savePreference(LOCAL_STORAGE_KEY, obj);
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
        if (qadUtil.isBlank(containerId)) {
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
                if (qadUtil.isNotBlank(item)) {
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