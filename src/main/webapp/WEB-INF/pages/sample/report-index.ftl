<#--
********************************************************************************
@desc 
@author Leo Liao, 3/20/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="report-index"/>
<@ui.page id=pageId title="Report">
<div >
    <@ui.ajaxNav target="#${pageId}-display" class="nav-pills">
        <@ui.ajaxNavItem href="${base}/report/sample/stock/quote-table">表格</@ui.ajaxNavItem>
        <@ui.ajaxNavItem href="${base}/report/sample/stock/quote-linechart">折线图</@ui.ajaxNavItem>
        <@ui.ajaxNavItem href="${base}/report/sample/stock/stock-barchart">柱状图</@ui.ajaxNavItem>
        <@ui.ajaxNavItem href="${base}/report/sample/stock/quote-piechart">饼图</@ui.ajaxNavItem>
    </@ui.ajaxNav>
</div>
<div id="${pageId}-display" class="tab-content" style="margin-top:1em;">
</div>
</@ui.page>
