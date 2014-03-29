<#--
********************************************************************************
@desc after delete a user
@author Leo Liao, 2013/03/21, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<div id="user-delete_do">
    <script type="text/javascript">
        $(function(){
            closeDialog('#user-delete_do');
            flashMessage("success","用户已删除");
        });
    </script>
</div>
