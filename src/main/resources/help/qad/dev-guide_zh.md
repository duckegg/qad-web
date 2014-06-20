开发指南
=================

开发准备<a name="dev-prepare"></a>
-----------------

在`pom.xml`中加入以下依赖

```xml
<dependency>
    <groupId>hpps</groupId>
    <artifactId>qad-core</artifactId>
    <version>2.0.3</version>
</dependency>
<dependency>
    <groupId>hpps</groupId>
    <artifactId>qad-web</artifactId>
    <version>2.0.3</version>
</dependency>
```

数据查询
-----------------

### 定义SQL查询<a name="data-query-qdf"></a>

在Java和Freemarker页面中，不直接写SQL语句，SQL语句定义为`qdf`（QueryDef）。KANBAN对qdf中的SQL语句进行了增强处理，可以自适应匹配参数，模糊查询等。Qdf可以保存在名为`qdf.xml`的文件中，也可以保存在数据库中。

```xml
<!-- -->
<query name="STOCK_QUOTE_LIST" dbConn="mysql">
    <description>Query stock quotes based on input symbol</description>
    <dynamics>
        <orderBy field="symbol" sort="asc">len(symbol),asc</orderBy>
        <orderBy field="symbol" sort="desc">len(symbol),desc</orderBy>
    </dynamics>
    <sql><![CDATA[
         SELECT * FROM stock_quote WHERE symbol=:symbol
    ]]>
    </sql>
</query>
```

属性说明

- `name`:查询的名称，在一个qdf文件中，name必须唯一
- `dbConn`:采用的数据库连接，一个dbConn对应一个.cfg.xml文件，在上面的例子中，应该有一个`mysql.cfg.xml`的数据库配置文件
- `description`:说明这个查询的用途，使用场景，注意事项等
- `sql`:查询SQL语句，注意把SQL语句包在`<![CDATA[`和`]]>`中
- `fuzzySearch`:模糊查询的字段
- `nullableParameters`:
- `dynamics`
    + `orderBy`


大部分查询都需要接受从页面传入的查询参数，在qdf中查询参数通过`:`加参数名的方式定义。如果定义了参数（形参），但是没有传入实际值（实参），qdf会查找包含该参数的两层括号`(())`，将其替换成`1==1`，即该条件始终成立。
如下面的qdf定义：

```sql
SELECT symbol,date,open,close,high,low,volume FROM stock_quote WHERE (symbol=(:symbol))
```

如果传入`sparams['symbol']`为空，则生成的SQL为：

```sql
SELECT symbol,date,open,close,high,low,volume FROM stock_quote WHERE (1==1)
```

如果传入`sparams['symbol']`为`"ZSL"`，则生成的SQL为：

```sql
SELECT symbol,date,open,close,high,low,volume FROM stock_quote WHERE (symbol='ZSL')
```

前端页面<a name="page"></a>
-----------------

### 页面框架<a name="page-layout"></a>

Web页面通过Freemarker模板来编写，一个ftl文件的框架如下：

```html
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="unique-id-of-the-page"/>
                 ``````````````````````[1]
<@ui.page id=pageId title="Title of the Page">
    Page content goes here...
</@ui.page>
```

__注意__: 保持`pageId`在整个系统中唯一。

### 页面样式<a name="page-css"></a>

系统样式采用bootstrap3，请参考[bootstrap网站](http://www.getbootstrap.com)

### 展示表格数据<a id="table"></a>

表格的数据源有两种：AJAX和静态HTML，分别通过`<@ui.ajaxTable>`和`<@ui.staticTable>`来实现

AJAX表格页面的基础框架如下：

```html
<!-- 1. Define a unique table ID -->
<#assign tableId="${pageId}-table"/>

<!-- 2. Use form to wrap AJAX request to fetch table data -->
<form id="${pageId}-form" action="${base}/query/json/table" method="post"
    onsubmit="kui.refreshDataTable('${tableId}');return false;">
    <input type="hidden" name="qid" value="db:your-package.YOUR_QUERY_DEF"/>
                              `````[1]
    <button type="submit" class="btn btn-default">刷新</button>
</form>

<!-- 3. Define table columns -->
<script type="text/javascript">
    kui.setTableColumns('${tableId}', [
        { "mData": "sql_column_name_1", "sTitle": "table_display_title_1" },
          ```````[2]                    ````````[3]
        { "mData": "sql_column_name_2", "sTitle": "table_display_title_2" },
        // More column definitions...
        { "mData": "sql_column_name_N", "sTitle": "table_display_title_N" }
    ]);
</script>

<!-- 4. Call freemarker macro to build table -->
<@ui.ajaxTable tableId=tableId ajaxForm='#${pageId}-form'/>
```

__参数含义__

1. `qid`: 对应一个SQL查询，如果是存在数据库中，要加前缀`db:`，如果是存在`qdf.xml`文件中，无需前缀。
2. `mData`: SQL查询出来的字段名
3. `sTitle`: 表格显示的列名


静态HTML表格

```html
<#macro staticTable>
```

### 展示图形数据<a id="chart"></a>

当前的图形支持折线图、直方图、饼图，分别用`<@chart.lineChart>`，`<@chart.barChart>`和`<@chart.pieChart>` 三个预定义的标签来实现。
图形展示的基本页面如下：

```html
<#assign chartId="${pageId}-chart"/>
<!-- 1. Use a form to send AJAX request to fetch chart data -->
<form id="${chartId}-qform" action="${base}/query/json/jqplot" method="post"
    class="form-inline" onsubmit="kui.replotChart('${chartId}');return false;">
    <!-- qid, chartOptions are essential for chart data -->
    <input type="hidden" name="qid" value="db:sample.STOCK_QUOTE_LIST"/>
                              `````[1]
    <input type="hidden" name="chartOptions.xField" value="date"/>
                               ```````````````````[2]
    <input type="hidden" name="chartOptions.yField" value="close"/>
                               ```````````````````[3]
    <input type="hidden" name="chartOptions.seriesField" value="symbol"/>
                               ````````````````````````[4]
    <@ui.textfield name="sparams['symbol']" value="SH600001"/>
                         ```````````````[5]
</form>
<!-- 2. Call freemarker macro to build chart -->
<@chart.lineChart id=chartId title="Your Chart Title" ajaxForm="#${chartId}-qform"/>
        `````````[6]
```
__参数含义__

1. `qid`: 查询ID
2. `chartOptions.xField`: X轴字段
3. `chartOptions.yField`: Y轴字段
4. `chartOptions.seriesField`: 序列字段
5. `sparams['paramInSql']`: 其它在qdf中定义的SQL参数
6. 可以替换成`<@chart.barChart>`或`<@chart.pieChart>`，具体参数参考API文档


开发文档
-----------------

- [Javascript函数](http://www.leoplay.com/qad/jsdoc/index.html)
- [Freemarker](http://www.leoplay.com/qad/fmdoc/index.html)
- [JavaDoc](http://www.leoplay.com/qad/javadoc/index.html)

