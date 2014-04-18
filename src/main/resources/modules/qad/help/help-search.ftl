<#--
********************************************************************************
@desc 
@author Leo Liao, 13-11-13, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<@ui.page id="help-search" title="搜索">
<div class="alert">适用于管理员</div>
<h2>术语和概念</h2>
看板使用<a href="http://www.elasticsearch.org/" target="_blank">elasticsearch</a>作为后台搜索引擎。
搜索引擎通过JDBC方式<em>定期</em>扫描目标数据库（存储资产、审计等原始数据的数据库），并将索引保存在引擎本地的文件系统中。
<dl class="dl-horizontal">
    <dt id="search-index">搜索索引 index</dt>
    <dd>索引相当于关系数据库中的<em>数据库</em>。一个索引下面可以定义多种类型。看板的搜索引擎将索引保存在文件系统中。
        <p>为方便维护，看板使用唯一的一个索引kanban。</p></dd>
    <dt id="search-type">搜索类型 type</dt>
    <dd>类型相当于关系数据库中的<em>表</em>，表示要搜索的对象类别。以Google搜索为类比，文档、网页、图像、视频分别属于不同的类型。一个类型包含多个文档。
        <p>看板需要为每类搜索对象（例如用户、HMC、DB、OS、LPAR、ETH等）创建一个搜索类型。一个搜索类型对应一个<a href="${base}/citype/list">CI类型</a>。</p></dd>
    <dt id="search-document">搜索文档 document</dt>
    <dd>文档相当于关系数据库中表的<em>记录</em>。每个文档作为一个JSON字符串存储在索引中，包含多个字段或者键值对，其中两个关键字段为：类型（_type），ID（_id）。原始JSON文档将被存储在索引的_source字段。
    </dd>
    <dt>CI类型</dt>
    <dd>Configuration Item Type，配置项类型，指的是看板内部定义的对象类型，用于看板的开发、权限的配置等。一个搜索类型需要对应一个唯一的CI类型（CI Type）。需要和UCMDB中的CI区分开来。</dd>
</dl>
<h2>如何添加搜索</h2>
<ol>
    <li>定义<a href="${base}/admin/config/search/profile" target="_blank">索引方案</a>。需要确保索引的数据库IP、用户名和密码正确</li>
    <li>定义<a href="${base}/citype/list" target="_blank">CI类型</a>。建议从Excel中导入。</li>
    <li>在<a href="${base}/admin/config/search" target="_blank">搜索管理</a>中更新CI的索引定义，让搜索引擎重新索引。</li>
</ol>
查看日志：/usr/opshere/elasticsearch/logs/kanban-elasticsearch.log
</@ui.page>
