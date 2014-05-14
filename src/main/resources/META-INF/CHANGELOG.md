# CHANGE LOG

2.0.3@201405
-------------------
### Bug Fix
* Fix `kui.replotChart()` does not replot
* Fix link of "modify" after save CI type.

### Change
* Extract udr struts routing from `qad-report.xml` to `qad-udr.xml`

### Enhancement
* When use `serverSide=true` with `<@ui.ajaxTable>`, do not save DataTable's `aaSorting` setting in `localStorage` to speed load time (without `ORDER BY`) in the case of millions of records in database.


2.0.0@20410423
-------------------
* Extract qad web content to this jar