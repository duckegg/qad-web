
Deployment
========================
## MySql user

    create user 'appreader'@'localhost' identified by 'password';
    grant select on qad_sample.stock to 'appreader'@'localhost';
    grant select on qad_sample.stock_quote to 'appreader'@'localhost';


UTF-8 Support
========================
## Tomcat
[How to support UTF-8 URIEncoding with Tomcat] (http://struts.apache.org/2.0.6/docs/how-to-support-utf-8-uriencoding-with-tomcat.html)

If your POST and GET parameters are not UTF-8 encoded when using Tomcat 5.x, try to adjust the Connector configuration in Tomcats server.xml like this:

    <!-- Define a non-SSL HTTP/1.1 Connector on port 8080 -->
    <Connector port="8080" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   redirectPort="8443" URIEncoding="UTF-8"/>

## Jetty

Modify `<jetty_home>/etc/webdefault.xml` or application's `web.xml`, find or add

    <locale-encoding-mapping>
       <locale>zh</locale>
       <encoding>GB2312</encoding>
    </locale-encoding-mapping>

and change `encoding` to `UTF-8`

