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

function MobileUiKit() {
    this.type = "mobile";
}

Mobilekui.prototype = new UiKit();
var uiKit = new MobileUiKit();