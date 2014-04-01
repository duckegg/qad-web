<#-- 2012/05/17 -->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/ui-builder.ftl" parse=true/>
<div id="js-home-bboard" data-pjax data-pjax-container>正在加载公告...</div>
<script type="text/javascript">
    $(function () {
    <#-- Load Bulletins -->
        $('#js-home-bboard').load("${base}/jpost/bulletin/list?portlet=js-home-bboard&so.size=5");
    });
</script>