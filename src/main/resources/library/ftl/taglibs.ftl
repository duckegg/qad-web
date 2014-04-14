<#--
********************************************************************************
@desc Script includes commonly used JSP taglibs
@author Leo Liao, 2012/05/03, created
********************************************************************************
-->
<#assign s=JspTaglibs["/WEB-INF/tld/struts-tags.tld"]>
<#assign c=JspTaglibs["http://java.sun.com/jstl/core"]>
<#assign shiro=JspTaglibs["/WEB-INF/tld/shiro.tld"]>
<#assign mobileView=Session?? && (Session.isMobile!false)>
<#assign isDebugMode=Session?? && ((Session.debug!"false")=="true")>
<#import "/library/ftl/lib-ui.ftl" as ui/>
<#import "/library/ftl/lib-function.ftl" as func/>
<#import "/library/ftl/lib-chart.ftl" as chart/>
<#setting url_escaping_charset="UTF-8">
<#setting number_format="#">
<#if !permissionResolver??><#assign permissionResolver=Request.permissionResolver/></#if>
