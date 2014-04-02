/*******************************************************************************
 *
 * Desktop UI adaptor.
 *
 * @author Leo Liao, 2012/11, created
 * @author Leo Liao, 2014/03/28, refactored
 *
 ******************************************************************************/
'use strict';

function DesktopUiKit() {
    UiKit.call(this);
    this.type = "desktop";
}

DesktopUiKit.prototype = new UiKit();
var uiKit = new DesktopUiKit();