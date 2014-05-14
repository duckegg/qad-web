KANBAN是一套应用开发框架，适合于构建数据驱动的Web应用，例如报表、数据面板、集中展示、数据集成。
KANBAN源自现实的IT运维数据集成项目，它剥离了具体的数据处理逻辑，将公共的功能抽象提取，力图成为一个通用的数据展示和集成开发框架。

KANBAN的定位介于开箱即用的数据产品（如[Birt](https://www.eclipse.org/birt/)、[Kettle](http://community.pentaho.com/projects/data-integration/)）
与单纯的Web开发框架（如[Spring](http://projects.spring.io/spring-framework/), [Dijango](https://www.djangoproject.com/)，[Zend](http://www.zend.com)）
之间。开箱即用的数据产品使用简单，但在UI定制和功能扩展方面存在困难；纯开发框架虽然可以在上面进行丰富的定制和扩展，但是基础开发工作量大。
KANBAN的目标用户是有一定Java基础的开发人员，通过简单和规范的配置，能够实现丰富的UI和扩展功能。


技术特性
-----------------

KABAN采用成熟的开源产品Struts2、Freemarker、Hibernate4作为框架核心，在上面封装了基础功能模块，所以KANBAN理论上是可以开发任何Web应用。

目前封装的功能有：

- 数据展现：采用[DataTables](http://www.datatables.net)提供丰富的表格（分页、过滤、排序、导出PDF/Word/Excel/HTML/JSON）功能；采用[jqplot](http://www.jqplot.com)提供饼图、直方图、折线图
- 数据查询：多数据源的qdf（Query Definition）数据查询，开发人员只需要提供SQL语句即可实现和表格、图形相匹配的前台展示数据
- 页面定制：采用[Freemarker](http://www.freemarker.org)作为页面模板引擎，预定义了丰富的宏和函数，提供了快速和一致的UI开发方式。
- 富客户端：采用[Bootstrap3](http://www.getbootstrap.com)作为CSS基础样式，具有良好的扩展性，采用[jQuery](http://www.jquery.com)和[AngularJS](http://www.angularjs.org)进行富客户端操作。
- 权限管理：采用[Shiro](http://shiro.apache.org)进行授权管理，支持本地数据库和LDAP双重认证
- 全文搜索：采用[Elasticsearch](http://elasticsearch.org)作为搜索引擎


开发指南
=================

基础
-----------------

# 页面框架

Web页面通过Freemarker模板来编写，一个ftl文件的框架如下：

```html
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="unique-id-of-the-page"/>
                 ``````````````````````[1]
<@ui.page id=pageId title="Title of the Page">
    Page content goes here...
</@ui.page>
```

注意，保持`pageId`在整个系统中唯一。

# 定义SQL查询qdf

在Java和Freemarker页面中，不直接写SQL语句，SQL语句定义为qdf（QueryDef）。KANBAN对qdf中的SQL语句进行了增强处理，可以自适应匹配参数，模糊查询等。Qdf可以保存在名为`qdf.xml`的文件中，也可以保存在数据库中。

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

- name:
- dbConn:
- description:
- sql:
- dbConn:
- fuzzySearch:
- nullableParameters:
- dynamics
    + orderBy

## 查询参数

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

# Maven

TODO

数据展示
-----------------

### 表格展示数据

表格的数据源有两种：AJAX和静态HTML，分别通过`<@ui.ajaxTable>`和`<@ui.staticTable>`来实现

AJAX表格页面的基础框架如下：

```html
<!-- 1. Define a unique table ID -->
<#assign tableId="${pageId}-table"/>

<!-- 2. Use form to wrap AJAX request to fetch table data -->
<form id="${pageId}-form" action="${base}/query/json/table" method="post"
    onsubmit="refreshDataTable('${tableId}');return false;">
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

> 参数含义：
>
> 1. `qid`: 对应一个SQL查询，如果是存在数据库中，要加前缀`db:`，如果是存在`qdf.xml`文件中，无需前缀。
> 2. `mData`: SQL查询出来的字段名
> 3. `sTitle`: 表格显示的列名

静态HTML表格

```html
<#macro staticTable>
```


### 图形展示数据

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
> 参数含义：
>
> 1. `qid`: 查询ID
> 2. `chartOptions.xField`: X轴字段
> 3. `chartOptions.yField`: Y轴字段
> 4. `chartOptions.seriesField`: 序列字段
> 5. `sparams['paramInSql']`: 其它在qdf中定义的SQL参数
> 6. 可以替换成`<@chart.barChart>`或`<@chart.pieChart>`，具体参数参考API文档

权限配置
-----------------

定义权限
框架定义：qad-core、qad-web

开发文档
-----------------

- [Javascript函数](http://www.leoplay.com/qad/jsdoc/index.html)
- [Freemarker](http://www.leoplay.com/qad/fmdoc/index.html)
- [JavaDoc](http://www.leoplay.com/qad/javadoc/index.html)

