<#--
********************************************************************************
@desc after delete a permission
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="role-delete_do">
    <script type="text/javascript">
        $(function(){
            closeDialog('#role-delete_do');
            flashMessage("success","角色已删除");
        });
    </script>
</div>
