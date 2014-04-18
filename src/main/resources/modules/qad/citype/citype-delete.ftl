<#--
********************************************************************************
@desc before delete
@author Leo Liao, 2013/03/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="citype-delete" data-title="删除确认">
    <form action="${base}/admin/config/citype/delete_do" class="form-horizontal"
          data-ajax-form data-kui-target="#citype-delete" method="POST">

        <div class="alert alert-danger">
            <p>域对象类型是系统的重要参数，请在删除之前咨询系统架构师。</p>
            确认以下对象类型吗？
        </div>
        <ul class="list-unstyled">
        <#list ciTypes as ciType>
            <li>
                <label class="checkbox-inline"><input type="checkbox" name="ids"
                                                      value="${ciType.id}" checked="checked"/>
                ${ciType.key!''} ${ciType.name!''}</label>
            </li>
        </#list>
        </ul>

    <@ui.buttonGroup>
        <button type="reset" class="btn btn-default">取消</button>
        <button type="submit" class="btn btn-danger">确认删除</button>
    </@ui.buttonGroup>
    </form>
</div>
