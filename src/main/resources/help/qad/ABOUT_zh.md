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
