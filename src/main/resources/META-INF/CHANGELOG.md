# CHANGE LOG

qad-web-2.0.4@20140527
-------------------
### Bug Fixes
* __Bulletin__: disable Delete button when no post selected
* __Bulletin__: remove debug post id

### Enhancements
* __User Defined Page__: better error message in user defined page
* __UI__: scroll to current menu item in sidebar when click
* __Search__: fields not matching but defined in translation will be displayed in search result
* __Sidebar__: add `data-kui-sidebar-min-icon="true|false"` to show/hide icons when sidebar collapsed.

### New Features
* __User defined page__: tagging, filter, sort

### Change
N/A

qad-web-2.0.3@201405
-------------------
### Bug Fixes
* Fix `kui.replotChart()` does not replot
* Fix link of "modify" after save CI type.

### Code Changes
* Extract udr struts routing from `qad-report.xml` to `qad-udr.xml`

### Enhancements
* When use `serverSide=true` with `<@ui.ajaxTable>`, do not save DataTable's `aaSorting` setting in `localStorage` to speed load time (without `ORDER BY`) in the case of millions of records in database.


qad-web-2.0.0@20410423
-------------------
* Extract qad web content to this jar