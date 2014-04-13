<#--
********************************************************************************
@desc after delete a permission
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<div id="permission-delete_do">
    <script type="text/javascript">
        $(function(){
            closeDialog('#permission-delete_do');
            flashMessage("success","权限已删除");
        });
    </script>
</div>
