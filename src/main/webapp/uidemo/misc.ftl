<#-- 2012/11/14 -->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageNo=(Parameters.page!1)?number/>
<@ui.page id="misc" title="其它">
<h4>分页</h4>
    <@ui.pagination size=10 records=1087 current=pageNo link="${base}/uidemo/misc?page=[page]&size=10" verbose=true/>
<div class="well">
    第${pageNo}页
</div>
<h4>滚动条</h4>
<a href="${base}/democode/index">DemoCode</a>
<h3>滚动条</h3>
<div style="width:300px;max-height: 300px; border:1px solid grey;overflow: auto"
     class="fancyscroller">
    里面内容的长度和宽度都超过了外框
    <div style="width:500px;height:500px; background-color: darkseagreen">Hello</div>
    This is bottom
</div>
</@ui.page>