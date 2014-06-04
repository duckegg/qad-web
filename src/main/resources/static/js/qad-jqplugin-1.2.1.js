/**
 * jQuery plugins
 * @author Leo Liao, 2014/04/30, extracted from qad-ui.js
 */

(function ($) {
    var pluginName = 'kuiDialog',
        defaults = {
            dialogClass: "webform",
            modal: true,
//            minWidth: 600,
//            minHeight: 300,
//            maxHeight: 600,
            resizable: false
        };

    /**
     * Create dialog with jQuery UI.
     * @memberOf "$.fn"
     * @param options jQuery UI dialog options
     * @returns {*}
     */
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
        if (!ktl.isBlank(this.options.style)) {
            var $obj = $(this).closest('.ui-dialog');
            $obj.attr('style', $obj.attr('style') + ";" + this.options.style);
        }
//        $dialog.find(":input:visible").not("[readonly]").first().focus();
        $(":tabbable:first", $dialog).focus();
        kui.setFormSubmited(false);
    };
})(jQuery);

//==============================================================================
//                                TREE
//==============================================================================
(function ($) {
    var pluginName = 'kuiListTree',
        defaults = {};

    /**
     * Create tree style list with `ul` and `li`. The `ul` element need a `nav-list-tree` CSS class.
     * @memberOf "$.fn"
     * @param options
     * @param args
     * @returns {*}
     */
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
            var $liLevel1 = $li.parentsUntil('.nav-list-tree', 'li')/*.addClass("active")*/;
            $li.closest('.nav-list-tree').find('li').not($li)/*.not($liLevel1)*/.removeClass("active");

            var $parentArrow = $li.parents("ul").prev("a").children(".arrow");
            $parentArrow.addClass("open");
            $li.parents("ul").show();
            $li.parents("li").addClass("open");
        };
    }

    KuiListTree.prototype.init = function () {
        var $treeObj = $(this);
        var $treeElem = $(this.element);
        initData($treeElem);
        regEvents($treeElem);

        function initData(ul) {
            var arrow = '<span class="arrow"></span>';
            $('li', ul).each(function (index, obj) {
                var $li = $(this);
                if ($li.children("ul").length > 0) {
                    $li.children('a').append(arrow).next().hide(); // Initially collapse all top level group
                }
                if ($li.parentsUntil($treeElem, 'ul').length > 4)
                    logger.warn("List tree works best with up to 4 levels");
            });
        }

        function isElementInViewport(el) {
            //special bonus for those using jQuery
            if (el instanceof jQuery) {
                el = el[0];
            }

            var rect = el.getBoundingClientRect();

            return (
                rect.top >= 0 &&
                rect.left >= 0 &&
                rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && /*or $(window).height() */
                rect.right <= (window.innerWidth || document.documentElement.clientWidth) /*or $(window).width() */
                );
        }

        function regEvents(ul) {
            ul.on('click.kui', 'li > a', function (e) {
                var $a = $(this);
                var $li = $a.parent();
                var $ulSub = $a.next();
                if ($ulSub.length > 0) {
                    // Handle menu sub-group, close previous open sub-menu group
                    var $ulParent = $li.parent();
                    var $opened = $ulParent.children('li.open').removeClass('open');
                    $opened.children('a').children('.arrow').removeClass('open');
                    var toOpen = $ulSub.is(":hidden");
                    $opened.children('ul').not($ulSub).slideUp("fast", function () {
                        if (toOpen && !isElementInViewport($a)) {
                            // Make current sub-group visible in view port
                            var itemOffset = $a.offset();
                            var treeOffset = $treeElem.offset();
                            $('html, body').animate({
                                scrollTop: itemOffset.top - treeOffset.top
                            });
                        }
                    });
                    // Toggle current sub-menu group
                    $li.toggleClass("open", toOpen);
                    $a.children(".arrow").toggleClass('open', toOpen);
                    $ulSub.slideToggle();
                    e.preventDefault();
                    e.stopPropagation();
                } else {
                    // Handle menu item
                    if ($li.parentsUntil($treeElem, 'ul').length > 3) {
                        logger.warn("List tree best work with max 4 levels");
                    }
                    $treeObj.kuiListTree("activateItem", $li);
                    var itemLink = $a.attr('href');
                    if ($a.data('kui-toggle') === 'ajaxSubMenu' && ktl.isValidAjaxUrl(itemLink)) {
                        $.get(itemLink, function (data) {
                            $a.after(data);
                            $a.children('.arrow').addClass('open');
                        });
                    }
                }
            });
        }
    };
})(jQuery);


//==============================================================================
//                                FORM
//==============================================================================
/**
 * Make fieldset as tabs in a form
 */
$.fn.kuiTabForm = function () {
    var $form = $(this);
    var $container = $form;
    $container.prepend();
    var $tabContent = $('<div class="tab-content"></div>').prependTo($container);
    var $navTabs = $('<ul class="nav nav-tabs"></ul>').prependTo($container);
    var index = 0;
    var formId = $form.attr('id');
    $('fieldset', $form).each(function () {
        index++;
        var $fieldset = $(this);
        var $legend = $('legend', $fieldset);
        var tabId = formId + '-tab-' + index;
        $navTabs.append('<li><a href="#' + tabId + '" data-toggle="tab">' + $legend.html() + '</a></li>');
        $legend.remove();
        var $tabPane = $('<div id="' + tabId + '" class="tab-pane"></div>').appendTo($tabContent);
        $fieldset.appendTo($tabPane);
    });
    $('a:first', $navTabs).tab('show');
    return $form;
};

/**
 * Initiate AJAX form with validation
 * @param settings options of $fn.ajaxForm plugin
 */
$.fn.kuiAjaxForm = function (settings) {
    var $form = $(this);
    $form.validate({ignore: ""}); // Default ignore :hidden, but we need validate hidden fields in inactive tabs
    var ajaxFormOpts = {
        beforeSubmit: function (event, ui) {
            return  $(ui).valid(); //jquery validate plugin
        },
        success: function (xhr) {
            kui.setFormSubmited(true);
            $form.resetForm();
            $form.parents("div.webform:first").parent().first().html(xhr);
        }
    };
    $.extend(true, ajaxFormOpts, settings);
    $form.ajaxForm(ajaxFormOpts);
    $form.on("click.kui", ":reset", function () {
        kui.closeDialog($(this));
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
 * https://github.com/fieryprophet/jQuery-UI-Dialog-MinMax
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
        $('<a href="javascript:;" class="ui-dialog-titlebar-xclose pull-right" role="button"><span class="ui-icon ui-icon-closethick">close</span></a>')
            .appendTo(this.uiDialogTitlebar).click(function (e) {
                self.close();
            });
        if (!options.modal && options.maximize)
            $('<a href="javascript:;" class="ui-dialog-titlebar-maximize pull-right" role="button"><span class="ui-icon ui-icon-plusthick">maximize</span></a>')
                .appendTo(this.uiDialogTitlebar).click(function (e) {
                    self.maximize(e);
                });
        if (!options.modal && options.minimize)
            $('<a href="javascript:;" class="ui-dialog-titlebar-minimize pull-right" role="button"><span class="ui-icon ui-icon-minusthick">minimize</span></a>')
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

    /**
     * Create bootstrap nav with ajax capability
     * @memberOf "$.fn"
     * @param options
     * @returns {*}
     */
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
                $tabPane = $(ktl.getUrlHash(tabLink));
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
        minimized: false,
        locked: false
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
        if (ktl.isBlank(this.portletId)) {
            logger.error("KuiPortlet: Portlet need 'id' attribute to store configuration data");
            return;
        }
        if (ktl.isBlank(containerId)) {
            var container = $(element).closest('.portlet-container');
            if (container.length == 0 || ktl.isBlank(container.attr('id'))) {
                logger.error('KuiPortlet: Cannot find portlet container "#' + containerId +
                    '". You need provide "containerId" or enclose portlets within ".portlet-container" element');
                return;
            } else {
                containerId = container.attr('id');
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
            kup.savePreference(PREF_CONFIG_KEY, obj);
        };
        this.init();
    }

    var CSS_MINIMIZED_CLASS = "minimized";
    var CSS_THEME_CLASS_PREFIX = "panel-";

    /*
     * Place initialization logic in init().
     * You already have access to the DOM element and the options via the instance,
     * e.g. this.element and this.options
     */
    KuiPortlet.prototype.init = function () {
        var that = this;
        var minIcon = 'fa-angle-down';
        var maxIcon = 'fa-angle-up';
        var lockIcon = 'fa-lock';
        var unlockIcon = 'fa-unlock';
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
                    '<button class="btn btn-default js-action-lock"><i class="fa ' + (that.portletConfig.locked ? lockIcon : unlockIcon) + '"></i></button>' +
                    ' <button class="btn btn-default js-action-size"><i class="fa ' + (that.portletConfig.minimized ? minIcon : maxIcon) + '"></i></button> ');
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
                    $icon.toggleClass(minIcon).toggleClass(maxIcon);
                    $portlet.toggleClass(CSS_MINIMIZED_CLASS);
                    var isMinimized = $portlet.hasClass(CSS_MINIMIZED_CLASS);
                    if (isMinimized) {
                        $portlet.data("old-height", $portlet.height()).css('height', 'auto');
                    } else {
                        $portlet.css('height', $portlet.data('old-height'));
                    }
                    that.saveConfig("minimized", isMinimized);
                })
                .on('click.kui', '.js-action-lock', function () {
                    var isLocked = that.portletConfig.locked = !that.portletConfig.locked;
                    $portlet.toggleClass('not-resizable').toggleClass('not-moveable');
                    $('.fa', $(this)).alterClass("fa-*", isLocked ? lockIcon : unlockIcon);
                    that.saveConfig("locked", isLocked);
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
     * @description Generate portlet widgets. It need work with bootstrap3 panel.
     *
     * - .portlet-container: containers to hold portlets, such as columns
     * - .portlet.panel: a portlet contains header and content.
     * - .panel-heading: portlet header, default is draggable
     * - .panel-body: portlet content, support <code>data-kui-content-url</code> to auto load AJAX
     *
     * It persists user preference as a JSON string in <code>localStorage</code>.
     *
     * JSON setting
     *
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
     * Portlet class:
     *
     * - not-resizable:
     * - not-moveable:
     * - not-editable:
     *
     * ````
     * <div class="portlet panel not-resizable not-moveable not-editable" data-kui-content-url="/ajax/some-link-to-content">
     *     <div class="panel-heading"><h3 class="panel-title">portlet-title</h3></div>
     *     <div class="panel-body">static or ajax content loaded by data-kui-content-url</div>
     * </div>
     * ````
     * @memberOf "$.fn"
     * @param options object of "containerId":string, default use closest `.portlet-container`
     * @returns {*}
     * @author Leo Liao, 2012/11/17
     */
    $.fn.kuiPortlet = function (options, args) {
        return this.each(function () {
            var data = $.data(this, 'plugin_' + portletPluginName);
            if (!data)
                $.data(this, 'plugin_' + portletPluginName, (data = new KuiPortlet(this, options)));
            if (typeof options === 'string') data[options](args);
        });
    };

    // The actual plugin constructor
    function KuiPortal(element, options) {
        this.element = element;
        this.options = $.extend({}, portalPluginDefaults, options);
        this.init();
    }

    function loadContainerConfig(containerId) {
        var pref = kup.loadPreference(PREF_CONFIG_KEY, {});
        return pref[containerId] || DEFAULT_CONTAINER_CONFIG;
    }

    function saveContainerConfig(containerId, containerPref) {
        var obj = {};
        obj[containerId] = containerPref;
        kup.savePreference(PREF_CONFIG_KEY, obj);
    }

    KuiPortal.prototype.init = function () {
        var $container = $(this.element);
        var containerId = $container.attr('id');
        if (ktl.isBlank(containerId)) {
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
                if (ktl.isNotBlank(item)) {
                    $container.append($('#' + item));
                }
            });
        }
    };


    /**
     * Create portal
     * @memberOf "$.fn"
     * @param options
     * @returns {*}
     */
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
            useMmenu: true,
            showMinIcon: false
        };

    /**
     * Create sidebar.
     * @memberOf "$.fn"
     * @param options {{useMmenu:boolean, showMinIcon:boolean}}
     * @returns {*}
     */
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
        var self = this;
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
            highlightMatch();
            function highlightMatch() {
                var matched = null;
                $('li a', $this).each(function (index) {
                    var key = $(this).data("kui-menu-key");
                    if (ktl.isBlank(key))
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
                    (matched.closest('li').addClass('mm-selected')).parentsUntil($this, 'li').addClass('mm-opened');
                }
            }
        }

        /**
         * Build home made sidebar, metronic style
         * @param ul jquery selector of menu `ul` element
         */
        function buildHomeMadeSidebar(ul) {
            var $navTree = $(ul);
            if ($navTree.not('ul')) {
                $navTree = $('ul', ul).first();
                if ($navTree.length == 0) {
                    logger.error("buildHomeMadeSidebar: Need list 'ul' element to build sidebar menu");
                    return;
                }
            }
            var $body = $("body");
            var showCollapsedIcon = self.options.showMinIcon;
            var SIDEBAR_MIN_CLASS = showCollapsedIcon ? "kui-sidebar-collapsed" : "kui-sidebar-closed";
            var SIDEBAR_MAX_CLASS = "kui-sidebar-opened";
            $navTree.addClass('nav nav-list-tree dark').kuiListTree();

            highlightMatch();
            registerEvents();
            var toOpen = kup.loadPreference("sidebarOpen", true, true);
            toggleSidebar(toOpen);

            function toggleSidebar(toOpen) {
                $(".sidebar-search").toggleClass("open", toOpen);
                $body.toggleClass(SIDEBAR_MIN_CLASS, !toOpen).toggleClass(SIDEBAR_MAX_CLASS, toOpen);
            }

            function isSidebarClosed() {
                return $body.hasClass(SIDEBAR_MIN_CLASS);
            }

            function registerEvents() {
                // handle sidebar show/hide
                $('.sidebar-toggler').on('click.kui', function (e) {
                    var toOpen = $body.hasClass(SIDEBAR_MIN_CLASS);
                    toggleSidebar(toOpen);
                    kup.savePreference("sidebarOpen", toOpen, true);
                    e.preventDefault();
                });
                $(document).on('pjax:complete', function () {
                    highlightMatch();
                });
            }

            /**
             * Highlight matched menu item based on current URL.
             * It compare menu item attribute of `data-kui-menu-key` or `href` with `document.location.href`.
             * The menu item with the longest match will be highlighted.
             */
            function highlightMatch() {
                var matched = null;
                $('li a', $navTree).each(function (index) {
                    var $this = $(this);
                    var key = $this.data("kui-menu-key");
                    if (ktl.isBlank(key)) {
                        key = $this.attr("href");
                    }
                    var loc = decodeURIComponent(document.location.href);
                    if (loc.indexOf(key) > 0) {
                        if (matched == null) {
                            matched = $this;
                        } else if (key.length > matched.attr("href").length) {
                            matched = $this; // Longest match
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