/**
 * JavaScript for global events handling.
 * @author Leo Liao, 2012/11/13, extracted from app.util.js
 */
(function ($, ktl, kui, logger) {
    "use strict";

    $(function () {
        // Default body content
        var BODY_CONTENT = $('#body-content');

        onToggleDisplay();
        onAjaxError();
        onFormAjaxSubmit();
        onFormPjaxSubmit();
        onFormReset();
        onAjaxLink();
        onPjaxLink();
        onDialogLink();
        onShortAccesskey();
        initControls();

        function onToggleDisplay() {
            $(document).on('click', '[data-kui-toggle-display]', function () {
                var $this = $(this);
                var target = $this.data('kui-toggle-display');
                if (ktl.isBlank(target)) {
                    return;
                }
                var $target = $(target);
//                logger.debug("checked="+$this.is(':checked'));
//                logger.debug("selected="+$this.is(':selected'));
                if ($target.length > 0) {
                    $target.toggle($this.is(':checked'));
                }
            });
        }

        /**
         * Submit form with AJAX by tag annotation.
         * Example:
         * <form action="xxx" data-kui-ajax-form data-kui-target="#body-content"></form>
         * data-kui-ajax-form, data-ajax-form(deprecated) or data-ajax(deprecated): indicate this is an AJAX request
         * data-kui-ajax-form-serialize="functionName": a callback function for serialization
         * data-kui-validate or data-form-validate(deprecated)="true|false": validate the form before submit, default is "true"
         * data-kui-dialog or data-dialog(deprecated): mutual exclusion with data-kui-target, show response in dialog
         * data-kui-dialog-* or data-dialog-*(deprecated): all info in {@link _createSmartDialog()}
         * data-kui-target: show response in target, a jQuery selection string
         *                  (Mark)if want stay in this form after AJAX request,
         *                  set data-kui-target="#xxx" #xxx is a div which is a blank hidden div.
         * data-kui-target-replace or data-ajax-result(deprecated): "replace" or empty
         * data-flash-message-beforesend：flash message before send
         * data-flash-message-aftersend: flash message after send
         * data-confirm="some confirm message?": display confirm dialog before invoking
         */
        function onFormAjaxSubmit() {
            $(document).on('submit', 'form[data-ajax],form[data-ajax-form],form[data-kui-ajax-form]', function (event) {
                var $form = $(this);
                var $ajaxTarget;
                var isDialog = $form.data('kui-dialog') != null || $form.data('dialog') != null;
                //If data-kui-dialog specified, no need for data-kui-target
                if (!isDialog) {
                    $ajaxTarget = _findAjaxTarget($form);
                }
//                logger.debug($container);
                var fnSerialize = $form.data("kui-ajax-form-serialize");

                $(this).ajaxSubmit({
                    beforeSerialize: function () {
                        if (ktl.isNotBlank(fnSerialize)) {
                            try {
                                return eval(fnSerialize);
                            } catch (error) {
                                logger.error("Program Error in ajaxSubmit.beforeSerialize: " + error.message);
                                return false;
                            }
                        }
                        return true;
                    },
                    beforeSubmit: function () {
//                        _flashMessageBeforeSend($form);
                        var isValid = true;
                        var fnValidate = $form.data("kui-validate") || $form.data("form-validate");
                        if (ktl.isNotBlank(fnValidate)) {
                            isValid = _validateForm($form, ":hidden", fnValidate);
                        }
                        if (isValid) {
                            isValid = _checkConfirmation($form);
                        }
                        if (isValid && !isDialog) {
                            $ajaxTarget.append(kui.showLoading("inline"));
                        }
                        return  isValid;
                    },
                    success: function (xhr) {
                        kui.setFormSubmited(true);
                        kui.hideLoading();
//                        _flashMessageAfterSend($form);
                        if (isDialog) {
                            var $dialog = createSmartDialog($form, null, xhr).closest('.ui-dialog');
                            var title = $(xhr).data('title');
                            if ($dialog.length > 0 && ktl.isNotBlank(title)) {
                                $('.ui-dialog-title', $dialog).html(title);
                            }
                        }
                        else {
                            //LEO: use replaceWith instead of container.html(xhr)
                            if ($form.data('kui-target-replace') === 'replace' || $form.data('ajax-result') === 'replace')
                                $ajaxTarget.replaceWith(xhr);
                            else {
                                $ajaxTarget.html(xhr);
                            }

                        }
                    }
                });
                return false;
            });
        }

//        function onFormSubmit() {
//            $(document).on('click', 'form :submit', function (event) {
//                setFormSubmited(true);
//            });
//        }

//        /**
//         * Find error message from error page
//         * @private
//         * @param jqxhr
//         * @returns {*|jQuery}
//         * @deprecated
//         */
//        function _findErrorMessageFromErrorPage(jqxhr) {
//            return $("#error-message", $(jqxhr.responseText)).text();
//        }

        /**
         * @private
         * @param $item
         * @returns {*|HTMLElement}
         * @private
         */
        function _findPjaxTarget($item) {
            var $container = $($item.closest("[data-pjax]").data("pjax"));
            if ($container.length == 0) {
                // Use data-pjax-container element as container
                $container = $item.closest("[data-pjax-container]");
                if ($container.length == 0) {
                    $container = BODY_CONTENT;
                }
            }
            if ($container == BODY_CONTENT) {
                // clean up dialog
//                    $('body>div.ui-dialog.webform *').remove();
                $('body>div.ui-dialog *').remove();
            }
            return $container;
        }

        /**
         * Find ajax request target container by an item's attribute "data-kui-target".
         * @param $item
         * @returns {*}
         * @private
         */
        function _findAjaxTarget($item) {
            var elem = $item.data("kui-target");
            if (ktl.isBlank(elem)) {
                logger.error("No target specified for data-kui-target");
                return null;
            }
            if (elem === "none") {
                return null;
            }
            var container = $(elem);
            if (container.length === 0) {
                logger.error("Cannot find element by id '" + elem + "'");
                return null;
            }
            return container;
        }

        function _checkConfirmation($item) {
            var conf = $item.data("confirm");
            if (ktl.isBlank(conf)) {
                return true;
            }
            return confirm(conf);
        }

        /**
         * Validate a form for submission. By default it will ignore :hidden elements.
         * @param $form
         * @param ignores
         * @param fnExtraValidate
         * @returns {*}
         * @private
         */
        function _validateForm($form, ignores, fnExtraValidate) {
            ignores = ignores || ":hidden";
            $form.validate({ignore: ignores});
            var isValid = $form.valid();
            if (isValid) {
                //Run custom validate
                try {
                    isValid = eval(fnExtraValidate);
                } catch (error) {
                    logger.error(error);
                }
            }
            return isValid;
        }

        function onFormReset() {
            $(document).on('reset', '.ui-dialog form[data-kui-ajax-form],.ui-dialog form[data-ajax],.ui-dialog form[data-ajax-form]', function (event) {
                kui.closeDialog($(this));
            });
        }

        function onFormPjaxSubmit() {
            $(document).on('submit', 'form[data-pjax]', function (event) {
                var $container = _findPjaxTarget($(this));
                $.pjax.submit(event, $container);
                return false;
            });
        }

        /**
         * Pjax
         */
        function onPjaxLink() {
            var PJAX_SELECTORS = '[data-pjax] a:not([data-kui-dialog],[data-dialog],[data-pjax-disabled],[data-ajax],[data-ajax-link],[data-kui-ajax-link],.ui-tabs-anchor,[data-toggle]), a[data-pjax]';
            $(document).on('click', PJAX_SELECTORS, function (event) {
                var $this = $(this), url = $this.attr("href");
                // Validate pjax request
                if (!_checkConfirmation($this) || ktl.isNotBlank($this.attr("disabled"))) {
                    return false;
                }
                if (!ktl.isValidAjaxUrl(url) || ktl.isNotBlank($this.attr('target'))) {
                    return true;
                }
                var $container = _findPjaxTarget($this);
                ktl.trackLink(url);
                if ($.support.pjax === true) {
                    return $.pjax.click(event, $container);
                } else {
                    var options = {
                        url: url,
                        type: "GET",
                        beforeSend: function (xhr) {
                            xhr.setRequestHeader('X-PJAX', 'true');
                            xhr.setRequestHeader('X-PJAX-Container', $container.selector);
                        }
                    };
                    callAjax(options).done(function (data) {
                        $container.html(data);
                    });
                    window.location.hash = url;
                    event.preventDefault();
                    return false;
                }
            });
        }

        /**
         * Call a link via AJAX and display response in target container
         * <a href="..." data-kui-ajax-link data-kui-target="#...">...</a>
         * data-ajax-link or data-ajax(deprecated): indicate this is an AJAX link
         * data-confirm="some confirm message?": display confirm dialog before invoking
         * data-kui-target: show response in target, a jQuery selection string
         */
        function onAjaxLink() {
            $(document).on('click', 'a[data-kui-ajax-link],a[data-ajax],a[data-ajax-link]', function (event) {
                var $a = $(this);
                if ($a.attr('disabled') || $a.hasClass("disabled"))
                    return false;
                if (_checkConfirmation($a)) {
                    var url = this.href;
                    $.ajax({
                        url: url,
                        success: function (data) {
                            var container = _findAjaxTarget($a);
                            if (container != null) {
                                var $dialog = container.closest('.ui-dialog');
                                var title = $(data).data('title');
                                if ($dialog.length > 0 && ktl.isNotBlank(title)) {
                                    $('.ui-dialog-title', $dialog).html(title);
                                }
                                container.html(data);
                            }
                        }
                    });
                    ktl.trackLink(url);
                }
                return false;
            });
        }


        /**
         * Click to open a AJAX dialog by tag annotation.
         * Example:
         * <code><a href="xxx" data-kui-dialog class="">View</a></code>
         */
        function onDialogLink() {
            $(document).on('click', 'a[data-kui-dialog],a[data-dialog]', function (e) {
                var $owner = $(this);
                if (!_checkConfirmation($owner) ||
                    ktl.isNotBlank($owner.attr("disabled")) ||
                    $owner.hasClass("disabled")) {
                    return false;
                }
                var url = $owner.attr("href");
                if (_isJavascriptLink(url)) {
                    return true;
                }
                createSmartDialog($owner, url);
                e.preventDefault();
                ktl.trackLink(url);
                //LEO: if return false, it will stop events from other controls. For example, when invoke dialog from bootstrap
                // dropdown menu, if return false, it will not close the dropdown menu after clicking.
                return false;
            });
        }

        function _isJavascriptLink(link) {
            return ktl.isNotBlank(link) && link.indexOf("javascript:") === 0;
        }

        function onShortAccesskey() {
            // http://www.mkyong.com/jquery/jquery-keyboard-events-example/
            var $doc = $(document);
            $doc.bind('keypress', handleKeyPress);
            $doc.on('focus', "input,textarea,select", function () {
                $doc.unbind('keypress');
            }).on('blur', "input,textarea,select", function () {
                $doc.bind('keypress', handleKeyPress);
            });
            function handleKeyPress(e) {
                e = e || window.event;
                //keyCode - IE , charCode - NS6+
                var k = e.charCode || e.keyCode || 0;
                var keyPressed = String.fromCharCode(k);
                var $anchor = $('[accesskey="' + keyPressed + '"]:visible:last');
                if ($anchor.length > 0) {
                    $anchor.scrollintoview({
                        complete: function () {
                            // highlight the element so user's focus gets where it needs to be
                            $anchor.focus().click();
                            e.preventDefault();
                        }
                    });
                }
            }
        }

        /**
         * Global AJAX error handler
         */
        function onAjaxError() {
            $(document).ajaxError(function (e, jqxhr, settings, exception) {
                kui.showAjaxError(jqxhr);
            });
            $(document).on('pjax:error', function (xhr, textStatus, errorThrown, options) {
                // Some error is abort: errorThrown=abort, options=abort,textStatus.status=0,textStatus.statusText=abort
                logger.warn("pjax:error", xhr, textStatus, errorThrown, options);
                // Returning false will prevent the the fallback redirect
                // return false;
            });
        }


        /**
         * data-kui-dialog
         * data-kui-dialog-title: string, "View"
         * data-kui-dialog-aftersubmit: string, "refreshTable"
         * data-kui-dialog-afterclose: "refreshTable"
         * data-kui-dialog-class: "kui-webform-lg"
         * data-kui-dialog-inline: "true" | "false"(default)
         * data-kui-dialog-content-type: "" (default) | "iframe"
         * data-kui-dialog-resizable: "true"
         * data-kui-dialog-modal: "false"
         * data-kui-dialog-title: "A Dialog Title"
         * data-kui-dialog-style: "width:200px"
         * data-kui-dialog-error
         * data-kui-dialog-buttons
         *
         * NOTE: previous data-dialog-* are deprecated with data-kui-dialog-*
         * @param $linker
         * @param url
         * @param content content to be displayed in dialog
         * @private
         * @return {*}
         */
        function createSmartDialog($linker, url, content) {
            var options = {modal: true, resizable: false};

            // Determine if auto create dialog div
            var selector = $linker.data("kui-dialog");
            if (ktl.isBlank(selector)) {
                selector = $linker.data("dialog");
            }
            var cssClass = $linker.data('kui-dialog-class');
            if (ktl.isNotBlank(cssClass)) {
                options.dialogClass = cssClass;
            }

            var isInline = !!(ktl.isNotBlank($linker.data("dialog-inline")) || ktl.isNotBlank($linker.data("kui-dialog-inline")));
            var contentType = $linker.data("kui-dialog-content-type");
            if (ktl.isBlank(contentType)) {
                contentType = $linker.data("dialog-content-type");
            }
            var isIframe = contentType == "iframe";
            var $content = $(selector);
            var isAutoDiv = ktl.isBlank(selector);
//        logger.debug("createSmartDialog: isAutoDiv=" + isAutoDiv + "; selector=" + selector + " length=" + $dialogDiv.length);
            if (isAutoDiv) {
                $content = $('<div class="auto-dialog"></div>').uniqueId();
                var $body = $('body');
                $content.appendTo($body);
                options.position = {
                    my: "top",
                    at: "top+70",
                    of: $body
                };
            } else if ($content.length === 0) {
                logger.error("Cannot find dialog element by selector '" + selector + "'");
                return null;
            }

            // Dialog option: buttons
            var buttons = $linker.data("kui-dialog-buttons") || $linker.data("dialog-buttons");
            if (ktl.isNotBlank(buttons)) {
                options.buttons = [
                    { "text": "关闭", "class": "btn",
                        "click": function () {
                            $(this).dialog("close");
                        }
                    }
                ];
            }
            var optModal = $linker.data("kui-dialog-modal") || $linker.data("dialog-modal");
            if (ktl.isNotBlank(optModal)) {
                options.modal = optModal;
            }
            var optResizable = $linker.data("kui-dialog-resizable") || $linker.data("dialog-resizable");
            if (ktl.isNotBlank(optResizable)) {
                options.resizable = optResizable;
            }

            // Dialog option: title
            var title = $linker.data("kui-dialog-title") || $linker.data("dialog-title");
            if (ktl.isBlank(title)) {
                title = $linker.attr("title");
                if (ktl.isBlank(title) && $linker.is("a")) // Only work for link
                    title = $linker.html();
            }
            options.title = title;

            // hide is custom option defined in jquery.ui.dialog.minmax.custom.js will make close malfunctional
            // If hide is null, close will not be triggered
            options.hide = function () {
            };
            // Dialog option: after submit or close
            var aftersubmit = $linker.data("kui-dialog-aftersubmit") || $linker.data("dialog-aftersubmit");
            var afterclose = $linker.data("kui-dialog-afterclose") || $linker.data("dialog-afterclose");
            options.close = function () {
//            logger.debug('createSmartDialog: close invoked');
                if (isAutoDiv) {
                    $content.remove();
                }
                if (!ktl.isBlank(aftersubmit)) {
                    if (kui.isFormSubmitted()) {
                        try {
                            eval(aftersubmit);
                        } catch (err) {
                            logger.error("Error handling dialog-aftersubmit code: " + aftersubmit + "\n" + err);
                        }
                    }
                }
                if (!ktl.isBlank(afterclose)) {
                    try {
                        eval(afterclose);
                    } catch (err) {
                        logger.error("Error handling dialog-afterclose code: " + afterclose + "\n" + err);
                    }
                }
            };


            // Load URL and show dialog
            var hasError = false;
            if (isIframe) {
                var $iframe = $('<iframe src="" class="iframe"></iframe>').appendTo($content);
                $iframe.attr("src", url);

            } else if (ktl.isNotBlank(content)) {
                $content.html(content);
            } else if (ktl.isValidAjaxUrl(url)) {
                $content.html(kui.showLoading("inline"));
                var errorMsg = $linker.data('kui-dialog-error') || $linker.data('dialog-error');
                $.ajax({
                    url: url,
                    global: false,
                    success: function (xhr) {
                        $content.html(xhr);
                    }, error: function (xhr) {
                        if (ktl.isBlank(errorMsg)) {
//                            errorMsg = _findErrorMessageFromErrorPage(xhr);
                            kui.showAjaxError(xhr, $content);
                        } else {
                            $content.html(errorMsg);
                        }
//                        _generateAjaxErrorMessage(xhr, $content);
//                        $content.html(errorMsg + "<!--" + xhr.responseText + "-->");
//                        hasError = true;
                    }
                });
            }

            if (isInline == false) {
                $content.kuiDialog(options);
            }

            // Custom dialog option: css
            var style = $linker.data("kui-dialog-style") || $linker.data("dialog-style");
            if (!ktl.isBlank(style)) {
                var $dialog = $content.closest('.ui-dialog');
                $dialog.attr('style', $dialog.attr('style') + ';' + style);
            }
            return $content;
        }


        /**
         * function flash message before send
         * @param $item
         * @returns {Boolean|*|created}
         * @deprecated not necessary
         * @private
         */
        function _flashMessageBeforeSend($item) {
            var message = $item.data("flash-message-beforesend");
            return (ktl.isBlank(message) || (ktl.isNotBlank(message) && kui.showToast("success", message, 3)));
        }

        /**
         * function flash message after send
         * @param $item
         * @returns {Boolean|*|created}
         * @deprecated not necessary
         * @private
         */
        function _flashMessageAfterSend($item) {
            var message = $item.data("flash-message-aftersend");
            return (ktl.isBlank(message) || (ktl.isNotBlank(message) && kui.showToast("success", message, 3)));
        }


        function initControls() {
            $.datepicker.setDefaults($.datepicker.regional[ "zh-CN" ]);
        }
    });
})(jQuery, ktl, kui, logger);