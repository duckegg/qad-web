<#--
********************************************************************************
@desc search home
@author Leo Liao, 13-5-6, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" />
<#--<#import "/library/json.ftl" as json>-->
<#assign pageId="search-home"/>
<@ui.page id=pageId title="看板搜索">
<div class="alert alert-info">
    <form action="${base}/search" method="GET" class="form-inline"
          data-pjax>
        <div class="input-append">
            <@ui.textfield id="${pageId}-input" name="query" class="input-xxlarge" value="${query?html}"/>
            <@ui.button class="btn-primary"><i class="fa fa-search"></i> </@ui.button><br/>
        </div>
        <p class="muted" style="margin-left:5px">
            搜索技巧："" 全字匹配，* 通配符，AND 与，OR 或
        </p>

        <div class="form-group">
            <select name="searchTypes" class="select2 kui-flat" multiple="multiple"
                    id="${pageId}-select-type" data-placeholder="选择查询范围">
                <#list definedCiTypes?keys as type>
                    <option value="${type!''}"
                            <#if (searchTypes![])?seq_contains(type)>selected="selected"</#if>>
                        <#if definedCiTypes[type]??>
                        ${definedCiTypes[type].name!type}
                        <#else>
                            搜索引擎找到类型${type}，但没有在系统中定义
                        </#if>
                    </option>
                </#list>
            </select>
        </div>
    </form>
</div>
<div class="kui-search-result">
    <#if searchOutput??>
        <#assign result = searchOutput.mapResult/>
        <#if result.error??>
            <span class="text-danger">输入的查询语法错误
                <a href="javascript:void(0)"
                   onclick="$('#${pageId}-error').toggle();">...</a></span>
            <pre id="${pageId}-error" style="display: none;">
            ${result.status}
            ${result.error?html}
            </pre>
        <#else>
            <#assign typeList = ""/>
            <#if searchTypes??>
                <#assign typeList= searchTypes?join(",")/>
            </#if>
            <h4>共${result.hits.total}条匹配结果</h4>

            <div>
                <@ui.pagination records=result.hits.total current=page size=size link="${base}/search?query=${query?html}&searchTypes=${typeList}&page=[page]&size=${size}" />
            </div>
            <div class="row">
                <div class="col-md-8">
                    <ul id="search-result-list" start="${(page-1)*size+1}" class="list-unstyled">
                    </ul>
                </div>
                <div class="col-md-4">
                    <@ui.alert level="warning">
                        搜索功能还在调试，如有搜索不到的情况，请 <a href="${base}/jpost/feedback/create" data-kui-dialog><i
                                class="fa fa-comment-o"></i> 联系我们</a>
                        <#--有以下已知问题，我们正在修复：-->
                        <#--<ol>-->
                            <#--<li class="fixed">搜索结果的字段名用中文显示</li>-->
                            <#--<li class="fixed">搜索结果很大的时候，分页数字太多</li>-->
                            <#--<li class="fixed">中文显示搜索范围和CI类型</li>-->
                        <#--</ol>-->
                    </@ui.alert>
                </div>
            </div>
            <@ui.pagination records=result.hits.total current=page size=size link="${base}/search?query=${query?html}&searchTypes=${typeList}&page=[page]&size=${size}" />
        </#if>
    </#if>
</div>
<style type="text/css">
    .fixed {
        text-decoration: line-through;
    }

    .kui-search-result b.matching {
        color: #dd4b39;
    }

    .kui-search-result-field {
        color: #999;
    }

    .kui-search-result-heading {
        font-weight: normal;
        /*text-transform: uppercase;*/
    }

    #search-result-list li {
        border: 0;
        background-color: #f9f9f9;
        margin-bottom: 1em;
        padding: 5px;
    }

    #search-result-summary.kui-has-content {
        -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
        padding: 1em;
    }
</style>
<script type="text/javascript">
    $(function () {
        <#if searchOutput??>
            <#if !searchOutput.mapResult.error??>
                var searchResult = ${searchOutput.jsonResult};
                <#assign toJson="hpps.qad.base.freemarker.ToJsonMethod"?new()/>
                var indexTypeCit = ${toJson(definedCiTypes)};
                var hits = searchResult.hits.hits;
                var $list = $('#search-result-list');
                var html = "";
                for (var i = 0, j = hits.length; i < j; i++) {
                    html += '<li id="search-result-"' + i + '>';
                    var hit = hits[i];
                    html += '<h4>' + renderHitLink(hit) + '</h4>';
                    var field;
                    var displayFields = {};
                    var f;
                    for (f in hit.highlight) {
                        if (typeof displayFields[f] == 'undefined')
                            displayFields[f] = {title: translateField(hit._type, f), value: hit.highlight[f]};
                        else
                            displayFields[f].value = hit.highlight[f];
                    }
                    for (field in displayFields) {
                        html += '<p><span class="kui-search-result-field">' + displayFields[field].title + ': </span><span class="kui-search-result-content">'
                                + stripHtmlTags(displayFields[field].value + "", '<b>') + '</span></p>';
                    }
                    html += '<div class="text-right">';
                    html += '</div></li>';
                }
                $list.html(html);

                function translateType(type) {
                    var ciType = indexTypeCit[type];
                    if (isNotBlank(ciType)) {
                        return ciType.name + " " + type + "";
                    }
                    return type;
                }

                function translateField(type, field) {
                    var translation = ${translationJson!'{}'};
                    console.debug(type,translation[type]);
                    if (translation[type])
                        return translation[type][field.toLowerCase()] || field;
                    return field;
                }

                function renderHitLink(hit) {
                    var html = '';
                    var ciType = indexTypeCit[hit._type];
                    var isDefined = isNotBlank(ciType) && isNotBlank(ciType.fullViewUrl);
                    var msg = isDefined ? hit._type : '没有为[' + hit._type + ']定义结果展示页面';
                    var url = isDefined ? '${base}' + ciType.fullViewUrl.replace("${r'${id}'}", hit._id) : "javascript:alert('" + msg + "')";
                    html += '<a data-dialog data-dialog-style="width: 1000px;" title="' + msg + '" class="kui-search-result-heading" href="' + url + '">'
                            + (isDefined ? '' : '<i class="fa fa-exclamation-triangle text-danger"></i> ')
                            + translateType(hit._type) + '</a>';
                    return html;
                }
            </#if>
        </#if>
    });
</script>
</@ui.page>
