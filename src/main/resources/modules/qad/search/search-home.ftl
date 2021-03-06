<#--
********************************************************************************
@desc search home
@author Leo Liao, 13-5-6, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" />
<#--<#import "/library/json.ftl" as json>-->
<#assign pageId="search-home"/>
<@ui.page id=pageId title="搜索">
<div class="alert alert-info">
    <form action="${base}/search" method="GET" class="form-inline"
          data-pjax>
        <div class="input-group input-group-sm">
            <input type="text" class="form-control" id="${pageId}-input" name="query" value="${query?html}"/>
            <span class="input-group-btn">
            <button class="btn btn-primary"><i class="fa fa-search"></i></button>
            </span>
        </div>
        <p class="small muted" style="margin-top:0.5em">
            搜索技巧 <code>""</code> 全字匹配，<code>*</code> 通配符，<code>AND</code> 与，<code>OR</code> 或
        </p>

        <div class="form-group">
            <select name="searchTypes" class="select2 kui-flat" multiple="multiple" style="width:100%"
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
            <#--<div class="col-md-4">-->
            <#--<@ui.alert level="warning">-->
            <#--搜索功能还在调试，如有搜索不到的情况，请 <a href="${base}/jpost/feedback/create" data-kui-dialog><i-->
            <#--class="fa fa-comment-o"></i> 联系我们</a>-->
            <#--有以下已知问题，我们正在修复：-->
            <#--<ol>-->
            <#--<li class="fixed">搜索结果的字段名用中文显示</li>-->
            <#--<li class="fixed">搜索结果很大的时候，分页数字太多</li>-->
            <#--<li class="fixed">中文显示搜索范围和CI类型</li>-->
            <#--</ol>-->
            <#--</@ui.alert>-->
            <#--</div>-->
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
        <#if searchOutput?? && !searchOutput.mapResult.error??>
            var searchResult = ${searchOutput.jsonResult};
            <#assign toJson="hpps.qad.base.freemarker.ToJsonMethod"?new()/>
            var indexTypeCit = ${toJson(definedCiTypes)};
            var translation = ${translationJson!'{}'};
            var fieldsConfig = ${fieldsConfigJson!'{}'} || {};
            var hits = searchResult.hits.hits;
            var $list = $('#search-result-list');
            $('#${pageId}-input').focus();
            var html = "";
            for (var i = 0, j = hits.length; i < j; i++) {
                html += '<li id="search-result-"' + i + '>';
                var hit = hits[i];
                html += '<h4>' + renderHitLink(hit) + '</h4>';
                var field;
                var displayFields = {};

                // All matching fields in `hit.highlight` need display
                for (var hf in hit.highlight) {
                    if (typeof displayFields[hf] == 'undefined') {
                        displayFields[hf] = {title: translateField(hit._type, hf), value: hit.highlight[hf]};
                    } else {
                        displayFields[hf].value = hit.highlight[hf];
                    }
                }
                // All fields defined in `hit._source` and translation need display
                for (var sf in hit._source) {
                    if (typeof displayFields[sf] == "undefined" && isAlwaysDisplayField(hit._type, sf)) {
                        displayFields[sf] = {title: translateField(hit._type, sf), value: hit._source[sf]};
                    }
                }

                // Construct HTML based on display fields
                for (field in displayFields) {
                    html += '<p><span class="kui-search-result-field">' + displayFields[field].title
                            + ': </span><span class="kui-search-result-content">'
                            + ktl.stripHtmlTags(displayFields[field].value + "", '<b>') + '</span></p>';
                }
                html += '<div class="text-right">';
                html += '</div></li>';
            }
            $list.html(html);

            function translateType(type) {
                var ciType = indexTypeCit[type];
                if (ktl.isNotBlank(ciType)) {
                    return ciType.name + " (" + type + ")";
                }
                return type;
            }

            /**
             * If a field should always display
             */
            function isAlwaysDisplayField(type, field) {
                if (fieldsConfig[type] && fieldsConfig[type][field.toLowerCase()]) {
                    var newVar = fieldsConfig[type][field.toLowerCase()]["alwaysDisplay"];
                    console.debug(field,!!newVar);
                    return !!newVar;
                }
                return false;
            }

            /**
             * If a field is defined in translation
             */
            function isFieldDefinedInTranslation(type, field) {
                if (translation[type]) {
                    return ktl.isNotBlank(translation[type][field.toLowerCase()]);
                }
                return false;
            }

            /**
             * Translate field name to display title
             * @param type CI type
             * @param field field name
             * @returns {*}
             */
            function translateField(type, field) {
//                if (isFieldDefinedInTranslation(type, field)) {
//                    return translation[type][field.toLowerCase()];
//                }
//                return field;

                if (fieldsConfig[type]) {
                    var config = fieldsConfig[type][field.toLowerCase()];
                    if (ktl.isNotBlank(config)) {
                        if (typeof config === "string") {
                            return config;
                        } else if (ktl.isNotBlank(config.title)) {
                            return config.title;
                        }
                    }
                }
                return field;
            }

            function renderHitLink(hit) {
                var html = '';
                var ciType = indexTypeCit[hit._type];
                var isDefined = ktl.isNotBlank(ciType) && ktl.isNotBlank(ciType.fullViewUrl);
                var msg = isDefined ? hit._type : '没有为[' + hit._type + ']定义结果展示页面';
                var url = isDefined ? '${base}' + ciType.fullViewUrl.replace("${r'${id}'}", hit._id) : "javascript:alert('" + msg + "')";
                html += '<a data-dialog data-dialog-style="width: 1000px;" title="' + msg + '" class="kui-search-result-heading" href="' + url + '">'
                        + (isDefined ? '' : '<i class="fa fa-exclamation-triangle text-danger"></i> ')
                        + translateType(hit._type) + '</a>';
                return html;
            }
        </#if>
    });
</script>
</@ui.page>
