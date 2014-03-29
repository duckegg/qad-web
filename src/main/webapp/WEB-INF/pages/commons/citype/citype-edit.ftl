<#--
********************************************************************************
@desc Page to edit CiType.
@author Leo Liao, 2012/06/27, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/functions.ftl" parse=true/>
<#assign pageId="citype-edit"/>
<@ui.page id=pageId class="webform" title=iif(ciType??,"新建","修改")>
<form id="${pageId}-form"
      action="${base}/admin/config/citype/${iif(ciType.id??,"update_do","create_do")}"
      method="post" class="form-horizontal"
      data-ajax-form data-kui-target="#${pageId}">
    <@s.hidden name="id"/>
    <@s.hidden name="ciType.id"/>
    <div class="tabbable tabbable-custom">
        <@ui.ajaxNav target="#${pageId}-tab-content" class="nav-tabs">
            <li class="active"><a href="#${pageId}-tab-basic" data-toggle="tab">基本信息</a></li>
            <li class="active"><a href="#${pageId}-tab-search" data-toggle="tab">搜索设置</a></li>
        </@ui.ajaxNav>
        <div class="tab-content" id="${pageId}-tab-content">
            <div id="${pageId}-tab-basic" class="tab-pane">
                <@ui.textfield name="ciType.machineName" label="标识" class="required" title="输入该类型的标识字符串（机器名称）"
                maxlength="200" required=true  value="${ciType.machineName!''}" helpText="英文字母a-Z、数字0-9和下划线_"/>
                <@ui.textfield name="ciType.name" label="名称" class="required" title="输入该类型的显示名称" maxlength="200" required=true value="${ciType.name!''}"/>
                <@ui.textfield name="ciType.fullViewUrl" label="完整视图URL" title="查看该类型某一对象的URL" maxlength="200" value="${ciType.fullViewUrl!''}" helpText="查看CI完整信息的URL，可以使用变量${r'${id}'}，搜索结果页面将跳转至此URL"/>
            <#--<@ui.textfield name="ciType.summaryViewUrl" label="概要视图URL" title="查看概要信息的URL" maxlength="200" value="${ciType.summaryViewUrl!''}" helpText="查看CI概要信息的URL，可以使用变量${r'${id}'}"/>-->
                <@ui.labelControlGroup label="自定义标签">
                    <div><label class="checkbox-inline">
                        <input type="checkbox" name="ciType.editableTag" value="1"
                               <#if ciType.isTagEditable()>checked="checked"</#if>/>启用</label>
                    </div>
                </@ui.labelControlGroup>
            </div>
            <div id="${pageId}-tab-search" class="tab-pane">
                <@ui.labelControlGroup label="全文搜索">
                    <div class="controls">
                        <label class="checkbox-inline">
                            <input id="${pageId}-search-enabled" type="checkbox"
                                   name="ciType.searchEnabled"
                                   value="1"
                                   <#if ciType.isSearchable()>checked="checked"</#if>/>启用</label>
                    </div>
                </@ui.labelControlGroup>
                <fieldset id="${pageId}-search-def">
                    <@ui.labelControlGroup label="索引方案">
                        <@s.select key="ciType.indexProfileId" cssClass="select2" title="请选择索引方案" list='availableIndexProfiles' listKey="id" listValue="name" value="ciType.indexProfileId" theme="simple"/>
                        <a href="${base}/admin/config/search/profile" target="_blank"
                           title="新增索引方案" class="btn btn-default"><i class="fa fa-plus"></i></a>
                    </@ui.labelControlGroup>
                    <@ui.textarea name="ciType.searchIndexParam" label="索引参数" help="一行一个参数，格式<code>参数名:参数值</code>">${ciType.searchIndexParam!''}</@ui.textarea>
                    <@ui.labelControlGroup label="">
                        <a href="" data-dialog="#${pageId}-index-def-${ciType.id!''}"
                           class="btn btn-default">查看索引定义</a>
                    </@ui.labelControlGroup>
                </fieldset>
                <div id="${pageId}-index-def-${ciType.id!''}" style="display: none">
                    <pre>${ciType.parsedIndexDef!''}</pre>
                </div>
            </div>

            <div class="form-actions">
                <#if ciType.id??>
                    <div style="float:left">
                        <a href="${base}/admin/config/citype/delete?id=${ciType.id}"
                           data-ajax-link data-kui-target="#${pageId}"
                           class="btn btn-danger" tabindex="-1"><i class="fa fa-times"></i> 删除</a>
                    </div>
                </#if>
                <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存
                </button>
                <button type="reset" class="btn btn-default">取消</button>
            </div>
        </div>
    </div>
</form>
<script type="text/javascript">
    $(function () {
        var $checkbox = $('#${pageId}-search-enabled');

        $checkbox.on('click', function () {
            enableSearchDef($checkbox.is(":checked"));
        });

        function enableSearchDef(status) {
            $('#${pageId}-search-def').toggle(status);
        }

        enableSearchDef($checkbox.is(":checked"));
    });
</script>
</@ui.page>