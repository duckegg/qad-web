<#--
********************************************************************************
@desc Page after import CI type.
@author Leo Liao, 2013/12/6, created
********************************************************************************
-->
导入完成
<ul>
    <li>
        新建${importResult.creates?size}个
    <#list importResult.creates as s>
        <span class="label label-default">${s}</span><#if s_has_next>  </#if>
    </#list>
    </li>
    <li>
        更新${importResult.updates?size}个
    <#list importResult.updates as s>
        <span class="label label-default">${s}</span><#if s_has_next>  </#if>
    </#list>
    </li>
    <li>
        删除${importResult.deletes?size}个
    <#list importResult.deletes as s>
        <span class="label label-default">${s}</span><#if s_has_next>  </#if>
    </#list>
    </li>
</ul>
