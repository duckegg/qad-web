/*******************************************************************************
 *
 * Mobile UI kit
 *
 * @author Leo Liao, 2012/11, created
 *
 ******************************************************************************/

$.fn.kuiTabs = function (settings) {
    $('[data-role="page"]', $(this)).appendTo($('body'));
    return $(this);
};

//$.mobile.ajaxEnabled=false;

//==============================================================================
//                            DESKTOP UI KIT
//==============================================================================
function MobileUiKit() {
    UiKit.call(this);
    this.type = "mobile";
    this.uiBuildPortlet = function (key) {
        makeMobilePortlet(key);
    };
    function makeMobilePortlet(key) {
        // Put all portlets in one container
        var $container = $('<div></div>').appendTo($('[data-role="page"]:last .ui-content'));

        $('.portlet-container').each(function (i, container) {
//            $container = $(container);
            $container.attr('data-role', 'collapsible-set').attr('data-inset', 'false');
            $('.portlet', $(container)).each(function (j, portlet) {
                var $portlet = $(portlet);
                var title = $portlet.data('title') || '&nbsp;';
                $portlet.attr('data-role', 'collapsible')/*.attr('data-inset','false')*/
                    // Make initial status to expand, otherwise jqplot may not work properly
                    .attr('data-collapsed', 'false')
                    .appendTo($container);
                var $content = $('<div class="portlet-content"></div>');
                $portlet.wrapInner($content);
                $portlet.prepend('<h3>' + title + '</h3>').collapsible();
                var url = $portlet.data('url');
                if (isValidAjaxUrl(url)) {
                    $content.html('<div style="text-align: center">正在加载...</div>').load(url, "decorator=ajax&confirm=true", function () {
                        $portlet.trigger('collapse');
                    });
                }
            });
        });
        $('.portlet-container').empty();
    }
}

MobileUiKit.prototype = new UiKit();
var uiKit = new MobileUiKit();