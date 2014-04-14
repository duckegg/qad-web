<#--
********************************************************************************
@desc after delete
@author Leo Liao, 2013/03/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="citype-delete_do">
    <script type="text/javascript">
        $(function(){
            closeDialog('#citype-delete_do');
            flashMessage("success","对象已删除");
        });
    </script>
</div>
