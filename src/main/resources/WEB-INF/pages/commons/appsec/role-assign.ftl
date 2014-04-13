<#--
********************************************************************************
@desc after delete a permission
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<div id="role-assign">
    <script type="text/javascript">
        $(function(){
            closeDialog('#role-assign');
            flashMessage("success","角色赋权成功");
        });
    </script>
</div>
