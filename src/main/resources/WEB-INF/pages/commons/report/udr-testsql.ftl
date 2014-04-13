<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/6, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#assign pageId="udr-testsql"/>
<#assign tableId="${pageId}-table"/>
<@ui.page id=pageId title="Test SQL">
    <@simpleStaticTable tableId=tableId dataTable="testSqlResult"/>
</@ui.page>