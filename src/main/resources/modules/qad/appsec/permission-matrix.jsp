<%@ page import="hpps.qad.core.appsec.perm.Permission" %>
<%@ page import="hpps.qad.core.appsec.role.Role" %>
<%@ page import="hpps.qad.core.appsec.user.User" %>
<%@ page import="hpps.qad.core.appsec.user.UserService" %>
<%@ page import="hpps.qad.core.appsec.user.UserServiceImpl" %>
<%@ page import="hpps.qad.core.citype.CiTypeHelper" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="hpps.qad.base.dao.DaoProvider" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String paramRoleType = request.getParameter("roleType");
    String paramUsername = request.getParameter("username");
    String paramShowOwn = request.getParameter("showOwnAction");

    UserService userService = new UserServiceImpl();
    Collection<Role> allRoles;
    boolean loadPrivate = StringUtils.equals(paramRoleType, Role.VISIBILITY_PRIVATE);
    boolean showOwnAction = StringUtils.equals(paramShowOwn, Permission.OWN_ACTION);
    allRoles = userService.findAllRole(true, loadPrivate);
    Collection<Role> userRoles = new HashSet<Role>();
    if (StringUtils.isNotBlank(paramUsername)) {
        User user = new UserServiceImpl().findUser(paramUsername);
        if (user != null) {
            userRoles = user.getRoles();
        }
    }

    Collection<Permission> perms = DaoProvider.instance().getDao(Permission.class).findAll();
    Map<String, List<Permission>> permMap = new HashMap<String, List<Permission>>();
    for (Permission perm : perms) {
        if (!showOwnAction && perm.isOwnAction())
            continue;
        String domain = perm.getDomain();
        List<Permission> permList = permMap.get(domain);
        if (permList == null) {
            permList = new ArrayList<Permission>();
            permMap.put(domain, permList);
        }
        permList.add(perm);
    }

    int roleSize = allRoles.size() + 1;

%>
<title>权限矩阵</title>

<div id="user-matrix">
    <form id="user-matrix-form" action="${base}/user/matrix" method="get"
          class="form-inline with-padding"
          data-ajax-form data-kui-target="#matrix-container">
        <label class="checkbox"><input type="checkbox" name="roleType" value="PRIVATE"
                                       <%if (loadPrivate) {%>checked="checked"<%}%>>显示个人角色</label>
        <label class="checkbox-inline"><input type="checkbox" name="showOwnAction" value="own"
                                              <%if (showOwnAction) {%>checked="checked"<%}%>>显示所有者权限</label>

        <div class="input-append">
            <input type="text" name="username" value="<%=paramUsername==null?"":paramUsername%>"
                   placeholder="输入用户名"/>
            <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
        </div>
        <%--<button type="submit" name="roleType" value="PRIVATE" class="btn">显示个人角色</button>--%>
    </form>
    <table class="table table-bordered matrix">
        <thead>
        <tr valign="middle">
            <th colspan="3" class="layer-header1" style="text-align: center" title="查看权限列表">
                <a href="${base}/permission/list"><i class="icomoon-key-2"></i> 权限</a>
                <a href="${base}/permission/create" data-dialog data-dialog-aftersubmit="refreshPage()"
                   title="新增权限"><i class="icon-plus"></i></a>
            </th>
            <th colspan="<%=roleSize+1%>" class="layer-header1" style="text-align: center">
                <a href="${base}/role/list"
                   title="查看角色列表"><i class="icomoon-user-3"></i> 角色</a>
                <a href="${base}/role/create" data-dialog data-dialog-aftersubmit="refreshPage()"
                   title="新增角色"><i class="icon-plus"></i></a>

                <div class="pull-right">
                    <a href="${base}/user/list"
                       title="查看所有用户"><i class="icomoon-users"></i> 所有用户</a>
                    <a href="${base}/user/create" title="新增用户"
                       data-dialog data-dialog-aftersubmit="refreshPage()"><i
                            class="icon-plus"></i></a>
                </div>
            </th>
        </tr>
        <tr>
            <td class="layer-header2"><a href="${base}/citype/list"><i class="icomoon-cube"></i>
                对象类型</a>
                <a href="${base}/citype/create" data-dialog data-dialog-aftersubmit="refreshPage()"
                   title="新增对象类型"><i class="icon-plus"></i></a>
            </td>
            <td class="layer-header2"><i class="icomoon-cog"></i> 操作</td>
            <td class="layer-header2"><i class="icomoon-cube-2"></i> 对象</td>
            <% for (Role role : allRoles) {
                int roleUsers = role.getUsers().size();
                String status = roleUsers > 0 ? "" : "warning";
                boolean isUserRole = userRoles.contains(role);
            %>
            <td class="js-role layer-header3 <%=role.isPrivate()?"private":""%> <%=isUserRole?" highlight":""%> ">
                <a
                        href="${base}/role/update?id=<%=role.getId()%>"
                        data-dialog data-dialog-aftersubmit="refreshPage()"><i
                        class="<%=role.isPrivate()?"icomoon-user":"icomoon-users"%>"></i> <%=role.getName()%>
                    &nbsp;&nbsp;<span
                            class="badge badge-<%=status%>"><%=roleUsers%></span></a>

                <div id="role-<%=role.getId()%>" class="js-role-users alert alert-<%=status%>"
                     style="display: none;position: absolute">
                    <% if (roleUsers > 0) {%>
                    <ul class="listing listing-bullet">
                        <%for (User user : role.getUsers()) {%>
                        <li><a href="${base}/user/update?id=<%=user.getId()%>"
                               data-dialog
                               data-dialog-aftersubmit="refreshPage()"><%=user.getFullName()%>
                        </a></li>
                        <%}%>
                    </ul>
                    <%} else {%>
                    没有用户属于该角色
                    <%}%>

                </div>
            </td>
            <%}%>
        </tr>
        </thead>
        <tbody>
        <%
            for (String domain : permMap.keySet()) {
                List<Permission> pl = permMap.get(domain);
                int rows = pl.size();
        %>
        <tr>
            <td rowspan="<%=rows+1%>" class="layer-header2"><a
                    href="${base}/citype/update?key=<%=domain%>" data-dialog
                    data-dialog-aftersubmit="refreshPage()"><%=domain%>
            </a>
            </td>
        </tr>
        <% for (Permission perm : pl) {
            String url = CiTypeHelper.getFullViewUrl(domain, perm.getTarget());
            String target = perm.getTarget();
            if (StringUtils.isBlank(target) || StringUtils.equals("*", target)) {
                url = null;
                target = "所有";
            }
            String action = perm.getAction();
            if (StringUtils.isBlank(action) || StringUtils.equals("*", action))
                action = "所有";
        %>
        <tr>
            <%--<td rowspan="<%=rows+1%>"></td>--%>
            <td class="layer-header3"
                title="<%=perm.getDescription()!=null?perm.getDescription():""%>"><a
                    href="${base}/permission/update?id=<%=perm.getId()%>"
                    data-dialog
                    data-dialog-aftersubmit="refreshPage()"><%=action%>
            </a></td>
            <td class="layer-header3"><% if (url != null) {%><a href="${base}/<%=url%>"
                                                                title="<%=perm.getPermkey()%>"
                                                                data-dialog
                                                                data-dialog-aftersubmit="refreshPage()"><%}%><%=target%>
                <% if (url != null) {%></a><%}%></td>
            <% for (Role role : allRoles) {
                Set<Permission> rolePerms = role.getPermissions();
                boolean hasPerm = rolePerms != null && rolePerms.contains(perm);
                String css = hasPerm ? "success" : "";
                boolean isUserRole = userRoles.contains(role);
            %>
            <td class="status status-<%=css.toLowerCase()%> <%=isUserRole?" highlight":""%>"
                align="center">
                <input type="checkbox" <%=hasPerm ? "checked" : ""%> class="js-toggle-perm"
                       data-link="${base}/role/assign?id=<%=role.getId()%>&permId=<%=perm.getId()%>"/>
            </td>
            <%}%>
        </tr>
        <%}%>
        <%}%>
        </tbody>
    </table>
    <script type="text/javascript">
        $(function () {
            var $page = $("#user-matrix");
            $('#user-matrix-form input:first').focus();
            $('.js-role', $page).on({mouseenter: function () {
                $(this).find('.js-role-users').show();
            }, mouseleave: function () {
                $(this).find('.js-role-users').hide();
            }});
            $page.on('click', '.js-toggle-perm', function () {
                var $item = $(this);
                var isChecked = $(this).is(':checked');
                var subact = isChecked ? "[add_perm]" : "[remove_perm]";
                postAjax({
                    url: $item.data('link') + "&subact=" + subact,
                    success: function (data) {
                        $item.closest('.status').alterClass('status-*', 'status-' + (isChecked ? "success" : ""));
                        flashMessage("success", "权限更新");
                    }
                });
            });
            $('.highlight', $page).effect("highlight", {}, 2000);
        });
        function refreshPage() {
            $('#user-matrix-form').trigger('submit');
            <%--callPjax("${base}/user/matrix", "权限更新", 3);--%>
        }
    </script>
</div>
<style type="text/css">
    .private {
        background-color: #a9a9a9;
    }

    .highlight:not(.status-success) {
        background-color: #fff5ba;
    }
</style>