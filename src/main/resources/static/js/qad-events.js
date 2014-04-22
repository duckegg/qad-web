/*******************************************************************************
 *
 * JavaScript for global events handling.
 *
 * @author Leo Liao, 2012/11/13, extracted from app.util.js
 *
 ******************************************************************************/

//==============================================================================
// Global events
//==============================================================================
$(function () {
    // Default body content
    var BODY_CONTENT = $('#body-content');
    registerGlobalEvents();
    initControls();

    function registerGlobalEvents() {
        onToggleDisplay();
        onAjaxError();
        onFormAjaxSubmit();
        onFormPjaxSubmit();
        onFormReset();
        onAjaxLink();
        onPjaxLink();
        onDialogLink();
        onShortAccesskey();

        function onToggleDisplay() {
            $(document).on('click', '[data-kui-toggle-display]', function () {
                var $this = $(this);
                var target = $this.data('kui-toggle-display');
                if (isBlank(target))
                    return;
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
//                console.debug(fnSerialize);

                $(this).ajaxSubmit({
                    beforeSerialize: function () {
                        if (isNotBlank(fnSerialize)) {
                            try {
                                return eval(fnSerialize);
                            } catch (error) {
                                logger.error("Program Error in ajaxSubmit.beforeSerialize: " + error.message);
//                                console.error(error);
                                return false;
                            }
                        }
                        return true;
                    },
                    beforeSubmit: function () {
                        _flashMessageBeforeSend($form);
                        var isValid = true;
                        var fnValidate = $form.data("kui-validate") || $form.data("form-validate");
                        if (isNotBlank(fnValidate)) {
                            isValid = _validateForm($form, ":hidden", fnValidate);
                        }
                        if (isValid) {
                            isValid = _checkConfirmation($form);
                        }
                        if (isValid && !isDialog)
                            $ajaxTarget.append(showLoading("inline"));
                        return  isValid;
                    },
                    success: function (xhr) {
                        setFormSubmited(true);
                        hideLoading();
                        _flashMessageAfterSend($form);
                        if (isDialog) {
                            var $dialog = _createSmartDialog($form, null, xhr).closest('.ui-dialog');
                            var title = $(xhr).data('title');
                            if ($dialog.length > 0 && isNotBlank(title)) {
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

        /**
         * Find error message from error page
         * @param jqxhr
         * @returns {*|jQuery}
         * @deprecated
         */
        function _findErrorMessageFromErrorPage(jqxhr) {
            return $("#error-message", $(jqxhr.responseText)).text();
        }

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
            if (isBlank(elem)) {
//                if (throwErrorIfNotFound)
                logger.error("No target specified for data-kui-target");
                return null;
            }
//            var container = elem.indexOf("#") == 0 ? $(elem) : $('#' + elem);
            if (elem == "none") {
                return null;
            }
            var container = $(elem);
            if (container.length == 0) {
//                if (throwErrorIfNotFound)
                logger.error("Cannot find element by id '" + elem + "'");
                return null;
            }
            return container;
        }

        function _checkConfirmation($item) {
            var conf = $item.data("confirm");
            if (isBlank(conf))
                return true;
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
                    console.error(error);
                }
            }
            return isValid;
        }

        function onFormReset() {
            $(document).on('reset', '.ui-dialog form[data-kui-ajax-form],.ui-dialog form[data-ajax],.ui-dialog form[data-ajax-form]', function (event) {
                closeDialog($(this));
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
                if (!_checkConfirmation($this))         return false;
                if (isNotBlank($this.attr("disabled"))) return false;
                if (!isValidAjaxUrl(url))               return true;
                if (isNotBlank($this.attr('target')))   return true;
                var $container = _findPjaxTarget($this);
                piwikTrackLink(url);
                if ($.support.pjax == true) {
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
                    callAjax({
                        url: url,
                        success: function (data) {
                            var container = _findAjaxTarget($a);
                            if (container != null) {
                                var $dialog = container.closest('.ui-dialog');
                                var title = $(data).data('title');
                                if ($dialog.length > 0 && isNotBlank(title)) {
                                    $('.ui-dialog-title', $dialog).html(title);
                                }
                                container.html(data);
                            }
                        }
                    });
                    piwikTrackLink(url);
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
                if (!_checkConfirmation($owner) || isNotBlank($owner.attr("disabled")) || $owner.hasClass("disabled")) {
                    return false;
                }
                var url = $owner.attr("href");
                if (_isJavascriptLink(url)) {
                    return true;
                }
                _createSmartDialog($owner, url);
                e.preventDefault();
                piwikTrackLink(url);
                //LEO: if return false, it will stop events from other controls. For example, when invoke dialog from bootstrap
                // dropdown menu, if return false, it will not close the dropdown menu after clicking.
                return false;
            });
        }

        function _isJavascriptLink(link) {
            return klib.isNotBlank(link) && link.indexOf("javascript:") == 0;
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
         *
         * @param jqxhr AJAX return data
         * @param container where to display the message
         */
        function _generateAjaxErrorMessage(jqxhr, container) {
            if (jqxhr.status == 0) {
                // status ==0 means abort, timeout, which may happen when two requests happen too quickly
                return null;
            }
            hideLoading();
            var status;
            switch (jqxhr.status) {
                case 400:
                case 401:
                case 404:
                    status = "warn";
                    break;
                default:
                    status = "error";
            }
            var msg = '<strong>' + jqxhr.status + '</strong> ' + jqxhr.statusText + ' <a href="#" class="js-details" data-pjax-disabled>...</a>';
            var flash;
            if (isBlank(container))
                flash = flashMessage(status, msg, 15);
            else
                flash = container.html(msg);
            $(flash).on('click', '.js-details', function (e) {
                window.open().document.write(jqxhr.responseText);
                e.preventDefault();
            });
            return flash;
        }

        /**
         * Global AJAX error handler
         */
        function onAjaxError() {
            $(document).ajaxError(function (e, jqxhr, settings, exception) {
                _generateAjaxErrorMessage(jqxhr);
            });
            $(document).on('pjax:error', function () {
                console.debug("Got pjax:error");
                // Returning false will prevent the the fallback redirect
                return false;
            })
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
         * @return {*}
         */
        function _createSmartDialog($linker, url, content) {
            var options = {modal: true, resizable: false};

            // Determine if auto create dialog div
            var selector = $linker.data("kui-dialog");
            if (klib.isBlank(selector))
                selector = $linker.data("dialog");
            var cssClass = $linker.data('kui-dialog-class');
            if (klib.isNotBlank(cssClass)) {
                options.dialogClass = cssClass;
            }

            var isInline = !!(klib.isNotBlank($linker.data("dialog-inline")) || klib.isNotBlank($linker.data("kui-dialog-inline")));
            var contentType = $linker.data("kui-dialog-content-type");
            if (klib.isBlank(contentType))
                contentType = $linker.data("dialog-content-type");
            var isIframe = contentType == "iframe";
            var $content = $(selector);
            var isAutoDiv = klib.isBlank(selector);
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
            } else if ($content.length == 0) {
                logger.error("Cannot find dialog element by selector '" + selector + "'");
                return null;
            }

            // Dialog option: buttons
            var buttons = $linker.data("kui-dialog-buttons") || $linker.data("dialog-buttons");
            if (klib.isNotBlank(buttons)) {
                options.buttons = [
                    { "text": "关闭", "class": "btn",
                        "click": function () {
                            $(this).dialog("close");
                        }
                    }
                ];
            }
            var optModal = $linker.data("kui-dialog-modal") || $linker.data("dialog-modal");
            if (klib.isNotBlank(optModal))
                options.modal = optModal;
            var optResizable = $linker.data("kui-dialog-resizable") || $linker.data("dialog-resizable");
            if (klib.isNotBlank(optResizable))
                options.resizable = optResizable;

            // Dialog option: title
            var title = $linker.data("kui-dialog-title") || $linker.data("dialog-title");
            if (klib.isBlank(title)) {
                title = $linker.attr("title");
                if (klib.isBlank(title) && $linker.is("a")) // Only work for link
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
                if (!klib.isBlank(aftersubmit)) {
                    if (isFormSubmitted()) {
                        try {
                            eval(aftersubmit);
                        } catch (err) {
                            logger.error("Error handling dialog-aftersubmit code: " + aftersubmit + "\n" + err);
                        }
                    }
                }
                if (!klib.isBlank(afterclose)) {
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

            } else if (klib.isNotBlank(content)) {
                $content.html(content);
            } else if (isValidAjaxUrl(url)) {
                $content.html(showLoading("inline"));
                var errorMsg = $linker.data('kui-dialog-error') || $linker.data('dialog-error');
                $.ajax({
                    url: url,
                    global: false,
                    success: function (xhr) {
                        $content.html(xhr);
                    }, error: function (xhr) {
                        if (klib.isBlank(errorMsg)) {
//                            errorMsg = _findErrorMessageFromErrorPage(xhr);
                            _generateAjaxErrorMessage(xhr, $content);
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
            if (!klib.isBlank(style)) {
                var $dialog = $content.closest('.ui-dialog');
                $dialog.attr('style', $dialog.attr('style') + ';' + style);
            }
            return $content;
        }
    }

    /**
     * function flash message before send
     * @param $item
     * @returns {Boolean|*|created}
     * @private
     */
    function _flashMessageBeforeSend($item) {
        var message = $item.data("flash-message-beforesend");
        return (isBlank(message) || (isNotBlank(message) && flashMessage("success", message, 3)));
    }

    /**
     * function flash message after send
     * @param $item
     * @returns {Boolean|*|created}
     * @private
     */

    function _flashMessageAfterSend($item) {
        var message = $item.data("flash-message-aftersend");
        return (isBlank(message) || (isNotBlank(message) && flashMessage("success", message, 3)));
    }


    function initControls() {
        $.datepicker.setDefaults($.datepicker.regional[ "zh-CN" ]);
    }
});