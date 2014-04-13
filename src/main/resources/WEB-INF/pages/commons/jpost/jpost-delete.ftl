<#--
********************************************************************************
@desc Before delete
@author Leo Liao, 2013/03/23, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="jpost-delete">
    <form action="${base}/jpost/${postType}/delete_do" class="form-horizontal"
          data-ajax-form data-kui-target="#jpost-delete" method="POST">
        <div class="alert alert-danger">确认删除么？
            <ul class="list-unstyled">
            <#list id as id>
                <li><label class="checkbox-inline">
                    <input type="checkbox" name="id" value="${id}"
                           checked="checked"/>${id}
                </label></li>
            </#list>
            </ul>
        </div>
    <@buttonGroup>
        <button type="submit" class="btn btn-danger"><i class="fa fa-times"></i> 确认删除
        </button>
        <button type="reset" class="btn btn-default"><i class="fa fa-check"></i> 取消</button>
    </@buttonGroup>
    </form>
</div>