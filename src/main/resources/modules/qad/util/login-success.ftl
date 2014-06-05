<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/5/29, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="login-success"/>
<@ui.page id=pageId title="Login Success">
<script type="text/javascript">
    $(function () {
        $('.page-header').load("${base}/utils/layout/navbar");
        $('.page-sidebar-left').load("${base}/utils/layout/sidebar", function () {
            $('#page-sidebar-left').kuiSidebar('init');
        });
        kui.closeDialog("#${pageId}");
    })
</script>
</@ui.page>
