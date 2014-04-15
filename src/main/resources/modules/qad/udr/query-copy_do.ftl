<#--
********************************************************************************
@desc 
@author Leo Liao, 14-3-3, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="udr-copy_do"/>
<@ui.page id=pageId title="复制成功">
<script type="text/javascript">
    callPjax("${base}/udr/query/list", "复制成功");
</script>
</@ui.page>
