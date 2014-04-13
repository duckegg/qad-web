<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/11, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udr-testsql"/>
<#assign tableId="${pageId}-table"/>
<@ui.page id=pageId title="Test SQL">
    <@simpleStaticTable tableId=tableId dataTable="testSqlResult"/>
</@ui.page>