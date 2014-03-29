<#--
********************************************************************************
@desc bulletin news ticker wrapper
@author Leo Liao, 2012/08/31, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<div id="newsticker" class="newsticker" style="float: right;">
    正在加载公告...
</div>
<script type="text/javascript">
    $(function () {
        $('#newsticker').load('${base}/jpost/bulletin/newsticker');
    })
</script>