<#--
********************************************************************************
@desc 
@author Leo Liao, 3/26/2014, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="stock-barchart"/>
<@ui.page id=pageId title="Bar Chart">
<div class="row">
    <div class="col-md-6">
        <@ui.panel contentUrl="${base}/report/sample/stock/stock-count-by-pe-barchart"/>
    </div>
</div>
</@ui.page>
