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
    UiKit.call(this);
    this.type = "mobile";
}

MobileUiKit.prototype = new UiKit();
var uiKit = new MobileUiKit();