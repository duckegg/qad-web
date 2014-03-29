<#--
********************************************************************************
@desc tree display
@author Leo Liao, 2012/08/03, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<@ui.page id="uidemo-tree" class="row">
<div id="js-tree-1" class="col-md-4">
    <#include "${base}/uidemo/data/tree-data.jsp"/>
</div>
<div id="js-tree-2" class="col-md-4 well">
    <#include "${base}/uidemo/data/tree-data.jsp"/>
</div>
<#--<div id="js-tree-3" class="col-md-4">-->
    <#--<ul class="nav nav-pills nav-stacked nav-list-tree">-->
        <#--<li><a href="${base}/uidemo/tree-add-subitem" data-kui-toggle="ajaxSubMenu"><i class="fa fa-plus"></i> 增加子菜单 <span-->
                <#--class="arrow"></span></a></li>-->
    <#--</ul>-->
<#--</div>-->
<script type="text/javascript">
    $(function () {
        $("#js-tree-1>ul").tree();
        $("#js-tree-2>ul").addClass('nav nav-list-tree').kuiListTree();
        $("#js-tree-3>ul").kuiListTree();
//        $('#collapseTree').collapse({head: 'ul li h3', group: 'ul li ul'});
//        $('#uidemo-tree').on('click.kui', '.js-add-item', function () {
//            var $li = $(this).closest('li');
//            var html = '<li>' + $li.html() + '</li>';
//            $li.children('a').after('<ul class="nav-pills nav-stacked">' + html + '</ul>');
//            $li.after(html);
//            return false;
//        });
    });
</script>
</@ui.page>