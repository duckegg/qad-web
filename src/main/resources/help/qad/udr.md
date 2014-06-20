# 自定义资源

内置变量 -  页面ID `${pageId}`

## 基本的表格查询页面

```html
<!--初始赋值-->
<#assign tableId="${pageId}-table"/>

<!--定义查询条件-->
<form id="${pageId}-form" action="${base}/query/json/table" method="post"
    onsubmit="refreshDataTable('${tableId}');return false;">
    <input type="hidden" name="qid" value="db:your-package.YOUR_QUERY_DEF"/>
    <button type="submit" class="btn btn-default">刷新</button>
</form>

<!--定义表格展示列-->
<script type="text/javascript">
    kui.setTableColumns('${tableId}', [
        { "mData": "${databaseFieldName1}", "sTitle": "表格显示列名" },
        { "mData": "${databaseFieldName2}", "sTitle": "表格显示列名" }
    ]);
</script>

<!--生成表格-->
<@ui.ajaxTable tableId="${tableId}" ajaxForm='#${pageId}-form'/>
```