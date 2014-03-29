<#--
********************************************************************************
@desc Select users
@author Leo Liao, 2012/08/24, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#include "/library/ui-builder.ftl" parse=true/>
<#assign tableId="userSelector${Parameters.token!''}"/>
<@ui.page id="user-select">
<div class="alert">如果没有找到你要的人员，请通知管理员将其登记入看板系统。</div>
<#--===== Query Form =====-->
    <@s.form id="${tableId}Qform" action="tabledata" method="post" cssClass="form-inline">
    <input type="hidden" name="qid" value="user.USR_SYS_USER_LIST"/>
    </@s.form>
<#--===== Table Setup =====-->
<script type="text/javascript">
    var columns_${tableId} = [
        { "mDataProp": "login_name", "sTitle": "#",
            "bUseRendered": false,
            "fnRender": function (o) {
                return '<input type="checkbox" name="username" value="' + o.aData['full_name'] + '" data-name="' + o.aData['login_name'] + '" data-full-name="' + o.aData['full_name'] + '" data-department="' + o.aData['department'] + '" data-phone="' + o.aData['phone'] + '"/>';
            }
        },
        { "mDataProp": "login_name", "sTitle": "用户名"},
        { "mDataProp": "full_name", "sTitle": "全名"}
    ];
</script>
<form action="#" method="post" id="js-user-select-form">
    <@ajaxTable tableId="${tableId}" ajaxForm="#${tableId}Qform" autoWidth=false />
    <@buttonGroup>
        <button type="submit" class="btn btn-primary">确定</button>
        <button type="reset" class="btn btn-default">取消</button>
    </@buttonGroup>
</form>
<script type="text/javascript">
    <#-- A global variable -->
    var g_selectedUsers;
    $(function () {
        var $form = $('#js-user-select-form');
        $form.kuiAjaxForm({
            beforeSubmit: function () {
                g_selectedUsers = [];
                $("input:checkbox:checked", $form).each(function (index, item) {
                    g_selectedUsers.push($(item).data());
                });
                setFormSubmited(true);
                closeDialog($form);
                return false;
            }
        });
    });
</script>
</@ui.page>