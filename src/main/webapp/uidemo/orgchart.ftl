<#--
********************************************************************************
@desc org chart display
@author Leo Liao, 2012/08/03, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#--======= org chart =======-->
<script type="text/javascript" src="${base}/media/tree/jquery.jOrgChart.js"></script>
<link rel="stylesheet" href="${base}/media/tree/css/jquery.jOrgChart.css" type="text/css"/>

<#include "${base}/uidemo/data/tree-data.jsp"/>
<div id="js-orgchart-target" class="orgChart" style="width:100%;overflow-x: auto;">
</div>
<script>
    $(function() {
        $("#js-tree-data").jOrgChart({
            chartElement : '#js-orgchart-target',
            dragAndDrop  : true
        });
    });
</script>