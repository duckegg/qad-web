<#--
********************************************************************************
@desc Sidebar menu navigation
@author Leo Liao, 2012/05/03, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/functions.ftl" parse=true/>

<#assign cur_month=timeOffset(.now, -1, "month", "yyyy-MM")/>

<ul class="nav nav-tabs">
    <li class="active"><a href="#menu-by-customer" data-toggle="tab" title="按功能"><i
            class="fa fa-align-justify"></i></a></li>
    <li><a href="#menu-by-asset" data-toggle="tab" title="按资产"><i class="fa fa-cogs"></i></a></li>
</ul>
<a class="sidebar-toggler hidden-phone" title="切换侧栏"><i class="fa fa-exchange"></i> </a>
<div class="tab-content">
<div class="tab-pane" id="menu-by-asset">
    <ul class="nav nav-list-tree dark">
        <li><a href="${base}/rs6000/asset-lpar"><i class="fa fa-desktop"></i> <span class="title">LPAR</span></a>
        </li>
        <li><a href="${base}/rs6000/asset-hmc"><i class="fa fa-desktop"></i> <span
                class="title">HMC</span></a></li>
    </ul>
</div>
<div class="tab-pane active" id="menu-by-customer">
<ul class="nav nav-list-tree dark">
<li>
    <a href="#"><i class="imgicon-rs6000"></i> <span class="title">RS6000</span></a>
    <ul>
        <li><a href="${base}/rs6000/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li><a href="${base}/rs6000/asset"><i class="fa fa-tag"></i> 资产信息</a></li>
    <@shiro.hasPermission name="sysadm:*:*">
        <li class="menu-item"><a href="${base}/rs6000/ucmdb/asset-objective-infos"><i
                class="fa fa-tag"></i> 客观资产</a></li>
    </@shiro.hasPermission>
    <#--<li><a href="${base}/rs6000/ci/asset-ci"><i class="fa fa-globe"></i> CI资产</a></li>-->
        <li class="menu-item in-develop"><a href="${base}/rs6000/duty?token=rs6000"><i
                class="fa fa-calendar"></i> 日常值班</a></li>
        <li><a href="${base}/rs6000/duty-beta?token=rs6000"><i class="fa fa-calendar"></i> 日常值班</a>
        </li>
        <li><a href="${base}/rs6000/audit-policy"><i class="fa fa-list-ol"></i> 检查策略</a></li>
        <li><a href="${base}/rs6000/capacity-manage"><i class="fa fa-cloud"></i> 容量管理</a></li>
        <li><a href="${base}/ootask/mgmt/main"><i class="fa fa-magic"></i> 一键任务</a></li>
        <li><a href="${base}/rs6000/drill/index" data-kui-menu-key="${base}/drill"><i
                class="fa fa-flag"></i> 演练管理</a></li>
    <@shiro.hasPermission name="sysadm:*:*">
        <li><a href="${base}/provision/provision-index"><i class="fa fa-suitcase"></i> 投产管理</a></li>
    </@shiro.hasPermission>
        <li><a href="#"><i class="fa fa-medkit"></i> 补丁管理</a>
            <ul>
                <li><a href="${base}/patch/patchmatrix/index">软件矩阵</a></li>
                <li><a href="${base}/patch/patchfirmware/index">硬件微码</a></li>
                <li><a href="${base}/patch/patch/index">补丁信息</a></li>
            </ul>
        </li>
    <#--<li><a href="${base}/itil/itil-index"><i class="fa fa-credit-card"></i> ITIL管理</a></li>-->
        <li><a href="${base}/sa/sa-root-sort"><i class="fa fa-beer"></i> SA Root权限管理</a></li>
        <li><a href="${base}/rs6000/developer/dvlp-prvlg"><i class="fa fa-beer"></i> 开发人员权限管理</a>
        </li>
        <li><a href="${base}/rs6000/vendor-check"><i class="fa fa-check"></i> 厂商巡检</a></li>
    <#--<li><a href="${base}/riskmodel/riskmodel/index"><i class="fa fa-fire"></i> 风险模型分析</a></li>-->
    </ul>
</li>

<li>
    <a href="#"><i class="fa fa-strikethrough fa-lg" style="padding-left: 6px"></i> <span
            class="title" style="padding-left: 6px">S390</span></a>
    <ul>
        <li><a href="${base}/s390/asset-ucmdb"><i class="fa fa-tag"></i> 资产信息</a></li>
    </ul>
</li>

<li>
    <a href="#"><i class="imgicon-win"></i> <span class="title">Windows</span></a>
    <ul>
        <li><a href="${base}/windows/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li><a href="${base}/windows/vm-status"><i class="fa fa-random"></i> VM变动</a></li>
        <li><a href="${base}/windows/pu-resource"><i class="fa fa-briefcase"></i> PU资源</a></li>
        <li><a href="${base}/windows/audit-comp-sort"><i class="fa fa-check"></i> 合规检查</a></li>
        <li><a href="${base}/windows/audit-health"><i class="fa fa-stethoscope"></i> 应用检查</a></li>
        <li><a href="${base}/windows/server-list"><i class="fa fa-tag"></i> 资产信息</a></li>
        <li><a href="${base}/prm/handle?token=2"><i class="fa fa-wrench"></i> PRM管理</a></li>
        <li>
            <a href="#"><i class="fa fa-globe"></i> SA Portal</a>
            <ul>
                <li>
                    <a href="${base}/outlink?next=http://saportal/AggregateWarnings/WarningPivot.aspx">当前活动警报</a>
                </li>
                <li><a href="${base}/outlink?next=http://10.1.18.49/netpayview">网银交易图表</a></li>
                <li><a href="${base}/outlink?next=http://10.1.18.49/">iLO入口捷径</a></li>
                <li><a href="#">值班日志管理</a>
                    <ul>
                        <li>
                            <a href="${base}/outlink?next=http://saportal/Winportal/CheckHistory.aspx">填写值班记录</a>
                        </li>
                        <li>
                            <a href="${base}/outlink?next=http://saportal/Winportal/SearchHistory.aspx">搜索值班记录</a>
                        </li>
                    </ul>
                </li>
            </ul>
        </li>
        <li><a href="#"><i class="fa fa-bar-chart-o"></i> 故障诊断</a>
            <ul>
                <li><a href="${base}/windows/prm/prm-dashboard"><i class="fa fa-tag"></i> 监控汇总</a>
                </li>
                <li><a href="${base}/windows/prm/prm-unigw"><i class="fa fa-tag"></i> 网上支付诊断</a>
                </li>
            </ul>
        </li>
    </ul>
</li>
<li>
    <a href="#"><i class="imgicon-processing"></i> <span class="title">运行一线</span></a>
    <ul>
        <li><a href="${base}/as400/duty?token=as400"><i class="fa fa-calendar"></i> 日常值班</a></li>
    </ul>
</li>
<li>
    <a href="#"><i class="imgicon-db"></i><span class="title"> 数据库</span></a>
    <ul>
        <li><a href="#"><i class="fa fa-dashboard"></i> Dashboard</a>
            <ul>
                <li><a href="${base}/database/dashboard/dashboard-manage"> KPI指标</a></li>
            </ul>
        </li>
        <li><a href="#"><i class="fa fa-calendar"></i> 值班监控与警告</a>
            <ul>
                <li><a href="${base}/database/status/status-monitor"> 状态监控</a></li>
                <li><a href="${base}/database/status/status-monitor-beta"> 状态监控<span
                        class="notice-tag new">beta</span></a></li>
                <li><a href="${base}/database/duty/duty"> 日常值班</a></li>
                <li><a href="${base}/database/audit/audit-manage"> 合规检查</a></li>
                <li><a href="${base}/database/capacity/capacity-manage"> 容量管理</a></li>
                <li class="menu-item"><a href="${base}/database/check/check-strategy"> 检查策略</a></li>
                <li><a href="${base}/database/permission/right-managerment"> 权限管理</a></li>
            </ul>
        </li>
        <li><a href="#"><i class="fa fa-check"></i> 日常管理</a>
            <ul>
            <@shiro.hasPermission name="dutyhandle:edit:*">
                <#if permissionResolver.allow('perm_dutyhandle_edit')>
                    <li><a href="${base}/database/duty/duty-report-daily?token=report"> 值班报告</a>
                    </li>
                </#if>
            </@shiro.hasPermission>
                <li><a href="${base}/database/capacityReport/edit?month=${cur_month}"> 容量报告</a></li>
                <li><a href="${base}/database/drills/drills-manage"> 切换演练</a></li>
                <li class="menu-item in-develop"><a
                        href="${base}/database/knowledge/knowledge-manage"><i
                        class="fa fa-check"></i>应知应会</a></li>
                <li class="menu-item in-develop"><a href="${base}/database/kpi/kpi-manage"><i
                        class="fa fa-bar-chart"></i>指标管理</a></li>
            </ul>
        </li>
        <li><a href="#"><i class="fa fa-tag"></i> 配置项</a>
            <ul>
                <li><a href="${base}/database/asset/asset-manage"> 资产信息</a></li>
            </ul>
        </li>
        <li><a href="#"><i class="fa fa-magic"></i> 自动化</a>
            <ul>
                <li><a href="${base}/database/robot/robot-manage"> 自动任务</a></li>
            </ul>
        </li>
    </ul>
</li>
<li>
    <a href="#"><i class="fa fa-camera-retro fa-lg" style="padding-left: 6px"></i> <span
            class="title" style="padding-left: 6px">TD监控</span></a>
    <ul>
        <li><a href="${base}/monitor/td-monitor"><i class="fa fa-dashboard"></i> 监控指标</a></li>
    </ul>
</li>
<li>
    <a href="#"><i class="imgicon-network"></i><span class="title"> 网络室</span></a>
    <ul>
        <li><a href="${base}/network/applb"><i class="fa fa-cogs"></i> F5负载均衡配置</a></li>
        <li><a href="#"><i class="fa fa-check"></i> 网络合规</a>
            <ul>
                <li><a href="${base}/network/dashboard">Dashboard</a></li>
                <li><a href="${base}/network/network-check">合规检查</a></li>
            </ul>
        </li>
        <li><a href="#"><i class="fa fa-retweet"></i> 配置变更</a>
            <ul>
                <li><a href="${base}/network/config-changed-sort">配置变更检查</a></li>
                <li>
                    <a href="${base}/network/auditrecord/asset-network-audit-record-list">配置变更审计记录</a>
                </li>
                <li><a href="${base}/network-config/index">标准配置模板</a></li>
            </ul>
        </li>
        <li><a href="${base}/network/asset"><i class="fa fa-tag"></i> 资产管理</a></li>
        <li><a href="#"><i class="fa fa-cogs"></i> 外联网配置</a>
            <ul>
                <li><a href="${base}/network/extranet/asset-network-extranet-interface-list"><i
                        class="fa fa-tag"></i> 线路端口</a></li>
                <li><a href="${base}/network/extranet/asset-network-extranet-firewall"><i
                        class="fa fa-tag"></i> 防火墙配置</a></li>
            </ul>
        </li>
    </ul>
</li>
<li>
    <a href="#"><i class="imgicon-sec"></i><span class="title"> 安全室</span></a>
<#--<ul>-->
<#--<li><a href="#"><i class="fa fa-sitemap"></i> 网络合规</a>-->
<#--<ul>-->
<#--<li><a href="${base}/sec/dashboard-trend">合规率趋势</a></li>-->
<#--<li><a href="${base}/sec/dashboard-rate">合规率</a></li>-->
<#--<li><a href="${base}/sec/dashboard-rank">不合规项排名</a></li>-->
<#--<li><a href="${base}/sec/dashboard-item">不合规项趋势</a></li>-->
<#--</ul>-->
<#--</li>-->
<#--<li><a href="#"><i class="fa fa-check"></i> 服务器合规</a>-->
<#--<ul>-->
<#--<li><a href="${base}/sec/sec-server-comp-trend">合规率趋势</a></li>-->
<#--<li><a href="${base}/sec/sec-server-comp-rate">合规率</a></li>-->
<#--<li><a href="${base}/sec/sec-server-noncomp-rank">不合规项排名</a></li>-->
<#--<li><a href="${base}/sec/sec-server-comp-item-trend">合规项趋势</a></li>-->
<#--</ul>-->
<#--</li>-->
<#--</ul>-->
</li>
<li>
    <a href="#"><i class="imgicon-platform"></i><span class="title"> 自动化平台</span></a>
    <ul>
        <li><a href="${base}/platform/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li><a href="${base}/platform/sa-opslog"><i class="fa fa-list-alt"></i> SA操作日志</a></li>
        <li><a href="${base}/platform/sa-oo-jobinfo"><i class="fa fa-tasks"></i> SA/OO任务列表</a></li>
        <li><a href="${base}/platform/sa-user"><i class="fa fa-user"></i> SA用户统计</a></li>
        <li><a href="${base}/platform/system-check"><i class="fa fa-heart"></i> 平台健康状况</a></li>
        <li><a href="${base}/jpost/bulletin/list"><i class="fa fa-bullhorn"></i> 看板公告</a></li>
        <li><a href="${base}/km/course"><i class="fa fa-book"></i> 培训课程</a></li>
        <li class="menu-item in-develop"><a href="${base}/platform/calendar"> 工作日历</a></li>
    </ul>
</li>
<li>
<#--<a href="#"><i class="imgicon-sysadmin"></i><span class="title"> 系统管理</span></a>-->
<#--<ul>-->
<#--<li><a href="${base}/jpost/feedback/list"><i class="fa fa-comments"></i> 看板反馈</a></li>-->

<#--<@shiro.hasPermission name="sysadm:*">-->
<#--<li><a href="${base}/platform/app-audit-log"><i class="fa fa-barcode"></i> 看板日志</a></li>-->
<#--<li><a href="${base}/admin/config/search"><i class="fa fa-search"></i> 搜索管理</a></li>-->
<#--<li><a href="${base}/sysadm/sysparam/index"><i class="fa fa-cogs"></i> 系统参数</a></li>-->
<#--<li><a href="${base}/user/index"><i class="fa fa-group"></i> 用户和权限</a></li>-->
<#--</@shiro.hasPermission>-->

<#--<li><a href="${base}/sitemap"><i class="fa fa-sitemap"></i> Sitemap</a></li>-->
<#--<@shiro.hasPermission name="sysadm:*">-->
<#--<li><a href="#"><i class="fa fa-briefcase"></i> 开发工具箱</a>-->
<#--<ul>-->
<#--<li><a href="${base}/sysadm/sql-console"><i class="fa fa-search"></i> SQL Console</a></li>-->
<#--<li><a href="${base}/sysadm/webtail"><i class="fa fa-legal"></i> 系统日志</a></li>-->
<#--<li><a href="${base}/uidemo/index"><i class="fa fa-coffee"></i> UIDemo</a></li>-->
<#--<li><a href="${base}/m" data-pjax-disabled><i class="fa fa-mobile-phone"></i> 移动版本</a></li>-->
<#--</ul>-->
<#--</li>-->
<#--</@shiro.hasPermission>-->
<#--</ul>-->
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
                <li>
                    <a href="#"><span class="title">Sample</span></a>
                    <ul>
                        <li><a href="${base}/sample/stock/list"><i class="fa fa-cash"></i>
                            Stock</a>
                        </li>
                        <li><a href="${base}/report/sample/stock/quote-table"><i
                                class="fa fa-cash"></i>
                            Report</a>
                        </li>
                        <li><a href="${base}/udr"><i class="fa fa-file-text"></i> 自定义报告</a>
                        </li>
                    </ul>
                </li>
            </ul>
        </li>
    </@shiro.hasPermission>
    </ul>
</li>
<li>
    <a href="#"><i class="fa fa-link"></i><span class="title"> WIKI</span></a>
    <ul>
        <li><a href="http://k.cmbchina.com:88/wiki" target="_blank"><i class="fa fa-link"></i> WIKI</a>
        </li>
    </ul>
</li>
</ul>
</div>
</div>
<script type="text/javascript">
    $(function () {
        $('.page-sidebar .nav-list-tree').kuiListTree();
        uiKit.uiBuildSidebar(".page-sidebar");
    });
</script>