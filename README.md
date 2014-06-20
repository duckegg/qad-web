This is web tier for qad core. It contains freemarker templates and struts configuration for qad core features.

It is distributed as a jar file and placed in your application.

Development Guide...
===================

## Basic
### Configuration
Make directory of `qad.repo.baseDir` writable

### MySql
Change MySql setting by `vi /etc/my.cnf`.

   - Make sure schema uses UTF-8 encode ([StackOverflow](http://stackoverflow.com/questions/1172849/problem-with-utf-8-in-create-schema-by-hibernate)).
   - On Linux, make sure table name case insensitive ([Identifier Case Sensitivity](http://dev.mysql.com/doc/refman/5.0/en/identifier-case-sensitivity.html)).

        [mysqld]
        character-set-server=utf8
        lower_case_table_names=1

### Struts2
Use `<include file="struts/qad-all.xml"/>` in your `struts.xml`

### Javascript
`/modules/qad/public/qad-js.ftl` contains all qad related scripts. Include following statement in you ftl file.
`<#include "/modules/qad/public/qad-js.ftl"/>`

## Advanced
### CORS
To support Cross Origin Resource Sharing, add CORS filter in `WEB-INF/web.xml`

    ```
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
    ```
### HTTPS Login
1. __CORS__ must be enabled
2. In `WEB-INF/classes/shiro.ini`, add SSL authentication for login

```
[urls]
/login=ssl[8443],authc
/login-inline=ssl[8443]
```