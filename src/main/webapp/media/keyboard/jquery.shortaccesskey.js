/**
 * JQuery accesskey plugin
 *
 * shortaccesskey provides a simpler way to use the access keys assigned to HTML links.
 * You will be able to use access keys by just pressing the letter you have assigned to
 * the link instead of ALT+accesskey/ALT+SHIFT+accesskey making navigation easier for your users.
 *
 * Just call $.shortaccesskey.init() in $(document).ready
 *
 * @name shortaccesskey
 * @type jquery
 * @cat Plugin/Navigation
 * @return JQuery
 *
 * Copyright (c) 2009 Aditya Mooley <adityamooley@sanisoft.com>
 * Dual licensed under the MIT (MIT-LICENSE.txt) and GPL (GPL-LICENSE.txt) licenses
 */

(function ($) {
    $.shortaccesskey = function () {
//        var i = 0;
//        var accesskeyArr = new Array();

//        $("a[accesskey]").each(function () {
//            accesskeyArr[i] = $(this).attr('accesskey');
//            i++;
//        });

        // http://www.mkyong.com/jquery/jquery-keyboard-events-example/
        // http://api.jquery.com/keydown/
        // http://api.jquery.com/keypress/
        $(document).bind('keypress', handleKeyPress);

        $("input,textarea,select").live('focus', function () {
            $(document).unbind('keypress');
        });

        $("input,textarea,select").live('blur', function () {
            $(document).bind('keypress', handleKeyPress);
        });

        function handleKeyPress(e) {
//            var active = $('*:focus');
//            if (e.keyCode == 39 || e.keyCode == 40) {
//                // right or down
//                console.log(active.nextAll('[tabindex=0]').first());
//                active.nextAll('[tabindex=0]').first().focus();
//                return;
//            } else if (e.keyCode == 37 || e.keyCode == 38) {
//                // left or up
//                console.log(active.prevAll('[tabindex=0]').first());
//                active.prevAll('[tabindex=0]').first().focus();
//                return;
//            }
            var e = e || window.event;
            //keyCode - IE , charCode - NS6+
            var k = e.charCode || e.keyCode || 0;
            var keyPressed = String.fromCharCode(k);
            var $anchor = $("[accesskey=" + keyPressed + "]:visible:last");
            if ($anchor.length > 0) {
                $anchor.scrollintoview({
                    complete:function () {
                        // highlight the element so user's focus gets where it needs to be
                        $anchor.focus();
                        $anchor.click();
//                        $anchor.effect("highlight");
                        e.preventDefault();
                    }
                });
            }
        }
    };
})(jQuery);