<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/15, created
********************************************************************************
-->
<h2>初始赋值</h2>
内置变量
<ul>
    <li><code>${r"${pageId}"}</code> 页面ID</li>
</ul>
<#noparse>
<pre>
&lt;#assign tableId=&quot;${pageId}-table&quot;/&gt;
</pre>
</#noparse>
<h2>定义查询条件</h2>
<#noparse>
<pre>
&lt;form id=&quot;${pageId}-form&quot; action=&quot;${base}/query/json/table&quot; method=&quot;post&quot;
    onsubmit=&quot;refreshDataTable('${tableId}');return false;&quot;&gt;
    &lt;input type=&quot;hidden&quot; name=&quot;qid&quot; value=&quot;db:your-package.YOUR_QUERY_DEF&quot;/&gt;
    &lt;button type=&quot;submit&quot; class=&quot;btn btn-default&quot;&gt;&#21047;&#26032;&lt;/button&gt;
&lt;/form&gt;
</pre>
</#noparse>
<h2>定义表格展示列</h2>
<#noparse>
<pre>
&lt;script type="text/javascript"&gt;
    kui.setTableColumns('${tableId}', [
        { "mDataProp": "low", "sTitle": "最低" },
        { "mDataProp": "high", "sTitle": "最高" },
        { "mDataProp": "open", "sTitle": "开盘" },
        { "mDataProp": "close", "sTitle": "收盘" },
        { "mDataProp": "symbol", "sTitle": "代码" },
        { "mDataProp": "date", "sTitle": "日期" }
    ]);
&lt;/script&gt;
</pre>
</#noparse>
<h2>初始化表格</h2>
<#noparse>
<pre>
&lt;@ui.ajaxTable tableId=&quot;${tableId}&quot; ajaxForm='#${pageId}-form'/&gt;
</pre>
</#noparse>
