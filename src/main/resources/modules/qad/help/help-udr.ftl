<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/15, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl"/>
<@ui.page id="help-udr" title="自定义资源">
内置变量
<ul>
    <li><code>${r"${pageId}"}</code> 页面ID</li>
</ul>
    <#noparse>
    <pre class="prettyprint linenums lang-html">
&lt;!--初始赋值--&gt;
&lt;#assign tableId="${pageId}-table"/&gt;

&lt;!--定义查询条件--&gt;
&lt;form id="${pageId}-form" action="${base}/query/json/table" method="post"
    onsubmit="refreshDataTable('${tableId}');return false;"&gt;
    &lt;input type="hidden" name="qid" value="<em>db:your-package.YOUR_QUERY_DEF</em>"/&gt;
    &lt;button type="submit" class="btn btn-default"&gt;刷新&lt;/button&gt;
&lt;/form&gt;

&lt;!--定义表格展示列--&gt;
&lt;script type="text/javascript"&gt;
    kui.setTableColumns('${tableId}', [
        { "mData": "${databaseFieldName1}", "sTitle": "表格显示列名" },
        { "mData": "${databaseFieldName2}", "sTitle": "表格显示列名" }
    ]);
&lt;/script&gt;

&lt;!--生成表格--&gt;
&lt;@ui.ajaxTable tableId="${tableId}" ajaxForm='#${pageId}-form'/&gt;
</pre>
    </#noparse>
</@ui.page>