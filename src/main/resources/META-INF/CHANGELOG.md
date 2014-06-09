# CHANGE LOG

qad-web-2.0.6@201406
-------------------

### New Features
* N/A

### Bug Fixes
* N/A

### Enhancements
* __Login__: refresh sidebar after popup login

### Code Changes
* __scripts.ftl__: to support HTTPS login, add `<script type="text/javascript">window.qadHttpsPort=8443;</script>`
before `<#include "/modules/qad/public/qad-js.ftl"/>`. Here `8443` should be changed to HTTPS port.
* __web.xml__: to support Cross Origin Resource Sharing, add CORS filter

        <filter>
            <filter-name>CORS</filter-name>
            <filter-class>com.thetransactioncompany.cors.CORSFilter</filter-class>
            <init-param>
                <param-name>cors.allowOrigin</param-name>
                <param-value>*</param-value>
            </init-param>
        </filter>
        <filter-mapping>
            <filter-name>CORS</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>

* __login.ftl__:
Replace `<@ui.strutsErrors/>` with

        <#if Request.shiroLoginFailure??>
            <div class="alert alert-danger">
                用户名或密码错误 <!--${Request.shiroLoginFailure}-->
            </div>
        </#if>

qad-web-2.0.5@20140604
-------------------

### New Features
* __Login__: inline pop-up login when session timeout.
* Add CORS support for HTTPS

### Bug Fixes
* __User Defined Page__: returned JSON does not include `so` which cause `$scope.so` is undefined

### Enhancements
* N/A

### Code Changes
* __shiro.ini__: add `authc = hpps.qad.core.appsec.filter.AjaxSupportedFormAuthcFilter` under `[main]`
* __navbar.ftl__: use `<a href="${base}/login-inline" data-kui-dialog><i class="fa fa-user"></i> 请登录</a>`

qad-web-2.0.4@20140527
-------------------

### New Features
* __User defined page__: tagging, filter, sort

### Bug Fixes
* __Bulletin__: disable Delete button when no post selected
* __Bulletin__: remove debug post id

### Enhancements
* __User Defined Page__: better error message in user defined page
* __UI__: scroll to current menu item in sidebar when click
* __Search__: fields not matching but defined in translation will be displayed in search result
* __Sidebar__: add `data-kui-sidebar-min-icon="true|false"` to show/hide icons when sidebar collapsed.

### Code Changes
* N/A

qad-web-2.0.3@201405
-------------------

### Bug Fixes
* Fix `kui.replotChart()` does not replot
* Fix link of "modify" after save CI type.

### Enhancements
* When use `serverSide=true` with `<@ui.ajaxTable>`, do not save DataTable's `aaSorting` setting in `localStorage` to speed load time (without `ORDER BY`) in the case of millions of records in database.

### Code Changes
* Extract udr struts routing from `qad-report.xml` to `qad-udr.xml`

qad-web-2.0.0@20410423
-------------------
* Extract qad web content to this jar