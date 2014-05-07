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
}

DesktopUiKit.prototype = new QadUi("desktop");
var kui = new DesktopUiKit();