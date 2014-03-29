<#--
********************************************************************************
@desc Sidebar menu navigation
@author Leo Liao, 2012/05/03, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/functions.ftl" parse=true/>
<#-- TODO: do not put cur_month here! -->
<#assign cur_month=timeOffset(.now, -1, "month", "yyyy-MM")/>
<ul class="nav nav-list-tree dark">
    <li><a href="${base}/my">My Dashboard</a>
    </li>
    <li>
        <a href="#"><i class="imgicon-rs6000"></i> <span class="title">Sample</span></a>
        <ul>
            <li><a href="${base}/sample/stock/list"><i class="fa fa-cash"></i>
                Stock</a>
            </li>
            <li><a href="${base}/report/sample/report-index"><i class="fa fa-cash"></i>
                Report</a>
            </li>
            <li><a href="${base}/udr"><i class="fa fa-file-text"></i> 自定义报告</a>
            </li>
        </ul>
    </li>

    <li>
        <a href="#"><i class="imgicon-sysadmin"></i><span class="title"> 系统管理</span></a>
        <ul>

        <@shiro.hasPermission name="sysadm:*">

            <li><a href="#"><i class="fa fa-wrench"></i> 配置</a>
                <ul>
                    <li><a href="${base}/admin/config/search"><i class="fa fa-search"></i>
                        搜索管理</a></li>
                    <li><a href="${base}/admin/config/citype"><i class="fa fa-folder"></i>
                        CI定义</a></li>
                </ul>
            </li>
            <li><a href="#"><i class="fa fa-users"></i> 用户</a>
                <ul>
                    <li><a href="${base}/user/list"><i class="fa fa-user"></i> 用户</a></li>
                    <li><a href="${base}/admin/people/role/list"><i
                            class="fa fa-suitcase"></i> 角色</a></li>
                    <li><a href="${base}/admin/people/permission/list"><i
                            class="fa fa-key"></i> 权限</a></li>
                </ul>
            </li>
            <li><a href="${base}/admin/reports/audit-log"><i class="fa fa-barcode"></i> 使用日志</a>
            </li>
        </@shiro.hasPermission>
            <li><a href="${base}/jpost/feedback/list"><i class="fa fa-comments"></i>
                看板反馈</a></li>

        <@shiro.hasPermission name="sysadm:*">
            <li><a href="#"><i class="fa fa-code"></i> 开发工具箱</a>
                <ul>
                    <li><a href="${base}/admin/devel/sql-console"><i
                            class="fa fa-bug"></i>
                        SQL Console</a></li>
                    <li><a href="${base}/admin/devel/webtail"><i class="fa fa-list-alt"></i>
                        系统日志</a></li>
                    <li><a href="${base}/uidemo/index"><i class="fa fa-coffee"></i>
                        UIDemo</a></li>
                    <li><a href="${base}/m" data-pjax-disabled><i
                            class="fa fa-mobile-phone"></i> 移动版本</a></li>
                </ul>
            </li>
        </@shiro.hasPermission>
        </ul>
    </li>
</ul>
<script type="text/javascript">
    $(function () {
        function initMmenuSidebar() {
            var $sidebar = $('.page-sidebar-left');
            $sidebar.mmenu();
            var openSidebar = function (e) {
                $sidebar.trigger("open.mm");
            };
            $('.sidebar-toggler').on('click', openSidebar).mouseenter(openSidebar);
            openSidebar();
            console.debug("mmenu initialized");
        }

        function initSidebar() {
            $('.page-sidebar .nav-list-tree').kuiListTree();
            uiKit.uiBuildSidebar(".page-sidebar");
        }

        initSidebar();
    });
</script>