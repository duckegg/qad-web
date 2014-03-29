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
<#import "/library/ui-builder.ftl" as ui/>
<#import "/library/functions.ftl" as func/>
<#setting url_escaping_charset="UTF-8">
<#setting number_format="#">
<#if !permissionResolver??><#assign permissionResolver=Request.permissionResolver/></#if>
