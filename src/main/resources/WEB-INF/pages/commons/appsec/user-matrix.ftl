<#--
********************************************************************************
@desc user matrix
@author Leo Liao, 2013/03/27, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#include "_appsec-helper.ftl" parse=true/>
<div id="matrix-container">
<@userNavbar level="matrix"/>
<@s.include value="permission-matrix.jsp" />
</div>