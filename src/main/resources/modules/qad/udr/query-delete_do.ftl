<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-3, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udr-delete_do"/>
<@ui.page id=pageId title="删除成功">
<script type="text/javascript">
    callPjax("${base}/udr", "删除成功");
</script>
</@ui.page>
