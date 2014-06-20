<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="search-mgmt"/>
<#assign tableId="search_mgmt"/>
<@ui.page id=pageId title="搜索管理">
<div class="row">
    <div class="col-md-9">
        <form id="${pageId}-form" action="${base}/admin/config/search/index" method="post" data-ajax-form
              data-kui-target="#${pageId}">
            <input type="hidden" value="" name="subact" id="${pageId}-subact"/>

            <div id="${pageId}-toolbar" class="btn-groups clearfix">
                <button type="button" onclick="submitSubact('create','确定要更新索引么？');"
                        value="create" class="btn btn-default btn-sm"
                        <#if !isServerRunning>disabled="disabled"</#if>>
                    <i class="fa fa-exclamation"></i> 创建或更新索引
                </button>
                <button type="button" onclick="submitSubact('delete','确定要删除索引么？');"
                        value="delete" class="btn btn-default btn-sm"
                        <#if !isServerRunning>disabled="disabled"</#if>>
                    <i class="fa fa-times"></i> 删除索引
                </button>
            </div>
            <table id="${pageId}-index-list" class="table table-condensed">
                <thead>
                <tr>
                    <th><input type="checkbox" title="选择全部" id="${pageId}-check-all"/></th>
                    <th>类型</th>
                    <th>索引状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                    <#list searchTypes as ciType>
                        <#assign isIndexed=ciType.hasIndexed/>
                        <#assign isDefined=ciType.id??/>
                    <tr <#if !isDefined>class="error"<#elseif isIndexed>class="success"</#if>>
                        <td><#if isDefined><input type="checkbox" name="typeName"
                                                  value="${ciType.key!''}"/></#if></td>
                        <td> ${ciType.key}</td>
                        <td align="center"><#if isIndexed><span class="text-success"
                                                                title="已经建立索引">&#10004;</span></#if>${ciType.lastIndexedAt!''}
                        </td>
                        <td>
                            <#if isDefined><a
                                    href="${base}/admin/config/citype/update?machineName=${ciType.key}"
                                    data-dialog>CI定义</a><#else>CI没有定义或者不是可搜索的</#if>
                            <#if isServerRunning && ciType.id??>
                                <a href="${base}/admin/config/search/index/create?typeName=${ciType.key}"
                                   class="btn btn-default btn-sm"
                                   title="<#if !isIndexed>创建<#else>更新</#if>索引"
                                   data-ajax-link data-kui-target="#${pageId}"
                                   data-confirm="确定要更新索引么？"><i
                                        class="<#if !isIndexed>fa fa-flash<#else>fa fa-refresh</#if>"></i></a>
                                <#if isIndexed><a
                                        href="${base}/admin/config/search/index/delete?typeName=${ciType.key}"
                                        class="btn btn-default btn-sm" title="删除索引"
                                        data-ajax-link data-kui-target="#${pageId}"
                                        data-confirm="确定要删除索引么？"><i
                                        class="fa fa-times"></i></a></#if>
                                <a href="${base}/admin/config/search/index/rebuild?typeName=${ciType.key}"
                                   class="btn btn-default btn-sm" title="强制重建"
                                   data-ajax-link data-kui-target="#${pageId}"
                                   data-confirm="强制重建索引？"><i class="fa fa-rocket"></i></a>
                            </#if>
                        </td>
                    </tr>
                    </#list>
                </tbody>
            </table>
        </form>
    </div>
    <div class="col-md-3">
        <div class="alert <#if isServerRunning>alert-success<#else>alert-warning</#if> clearfix">
            <#if !isServerRunning>
                <a href="${base}/admin/config/search/server/start"
                   class="btn btn-lg btn-success pull-right" data-ajax-link
                   data-kui-target="#${pageId}" data-loading-text="正在启动搜索引擎..." title="启动搜索引擎"><i
                        class="fa fa-play"></i></a>

                <p><i class="fa fa-exclamation-circle"></i> 搜索引擎没有启动</p>
            <#else>
                <a href="${base}/admin/config/search/server/stop" class="btn btn-lg btn-danger pull-right"
                   data-ajax-link
                   data-kui-target="#${pageId}" data-confirm="确定要停止搜索引擎吗？" title="停止搜索引擎"><i
                        class="fa fa-stop"></i></a>

                <p><i class="fa fa-check-circle"></i> 搜索引擎已经启动</p>
            </#if>
        </div>
        <div class="list-group">
            <a class="list-group-item" href="${base}/help/qad/search">查看帮助</a>
            <a class="list-group-item" href="${base}/static/es_head/index.html" target="_blank">搜索控制台</a>
            <a class="list-group-item" href="${base}/admin/config/search/profile">索引方案</a>
            <a class="list-group-item" href="${base}/admin/config/search/settings/list">搜索参数</a>
        </div>
    </div>
</div>
    <@ui.staticTable tableId="${pageId}-index-list" toolbarElement="#${pageId}-toolbar"/>
<script type="text/javascript">
    function submitSubact(name, msg) {
        if (!confirm(msg))
            return;
        $('#${pageId}-subact').val(name);
        $('#${pageId}-form').trigger('submit');
    }
    $(function () {
        $('#${pageId}-check-all').on('click', function (e) {
            var isChecked = $(this)[0].checked;
            $('#${pageId} [name=typeName]').attr("checked", isChecked);
            e.preventDefault();
            e.stopPropagation();
            return false;
        });
    });
</script>
</@ui.page>
