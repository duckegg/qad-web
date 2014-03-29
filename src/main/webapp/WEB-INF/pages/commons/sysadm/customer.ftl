<#--
********************************************************************************
@desc manage customer
@author Leo Liao, 2012/11/29, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/ui-builder.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<title>室组管理</title>
<style type="text/css">
    #customer {
        width: 600px;
    }

    .customer-card {
        margin: 0 10px 10px 0;
        background-color: #fff;
        padding: 1em;
        border: 1px solid #ddd;
    }

</style>
<div id="customer" class="webform">
    <div class="navbar">
            <ul class="nav">
                <li><a href="${base}/admin/config/customer/list">室组列表</a></li>
                <li><a href="${base}/admin/config/customer/edit">新建室组</a></li>
            </ul>
    </div>

<#if function == "edit">
    <div id="js-customer-edit" class="section">
        <form id="js-customer-edit-form" action="${base}/admin/config/customer/save" method="post"
              class="form-horizontal">
            <input type="hidden" name="actionResult" value="json"/>
            <@s.hidden key="customer.id"/>
            <@textfield name="customer.keyword" value="${customer.keyword!''}" label="室组Key" title="室组的唯一标识，请用英文和字母" class="required"/>
            <@textfield name="customer.name" value="${customer.name!''}" label="室组名称" title="室组的名称" class="required"/>
            <@buttonGroup>
                <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 保存
                </button>
                <button type="reset" class="btn btn-default">取消</button>

            </@buttonGroup>
        </form>
        <script type="text/javascript">
            $(function () {
                $('#js-customer-edit-form').kuiAjaxForm({success: function (response) {
                    flashMessage("success",'客户 <strong>' + response.customer.name + '</strong> 已保存');
                    callPjax("${base}/admin/config/customer/list");
                }});
            });
        </script>
    </div>
</#if>
<#if function="list">
    <div id="js-customer-list" class="section">

        <ul class="list-unstyled list-inline">
            <#list customers as cust>
                <li class="customer-card"><a href="${base}/admin/config/customer/edit?id=${cust.id}">${cust.keyword}
                    <br/> ${cust.name}</a></li>
            </#list>
        </ul>
        <div class="clearfix"></div>
    </div>
</#if>
</div>