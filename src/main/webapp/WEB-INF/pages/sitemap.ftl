<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-20, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign NOPLAN='<i class="fa fa-remove"></i>'/>
<#assign PENDING='<i class="fa fa-circle-blank"></i>'/>
<#assign DESIGN='<i class="fa fa-check"></i>'/>
<#assign CODE='<i class="fa fa-pencil"></i>'/>
<#assign SIT='<span class="label">SIT</span>'/>
<#assign UAT='<i class="fa fa-ok-circle"></i>'/>
<#assign LIVE='<i class="fa fa-ok"></i>'/>
<@ui.page id="sitemap" title="Sitemap">
<style type="text/css">
    .sitemap > li {
        margin-right: 5px;
        margin-bottom: 5px;
        padding: 5px;
        background-color: whitesmoke;
        border-radius: 4px;
    }

    .sitemap > li > ul {
        list-style: none;
        margin-left: 0;
    }
</style>
<ul class="nav nav-pills sitemap">
    <li><h4>资产与配置</h4>
        <ul>
            <li>资产信息
                <ul>
                    <li>RS6000
                        <ul>
                            <li><a href="${base}/rs6000/asset-hmc">${LIVE} HMC</a></li>
                            <li><a href="${base}/rs6000/asset-lpar">${LIVE} LPAR</a></li>
                            <li><a href="${base}/rs6000/asset-server">${LIVE} Server</a></li>
                            <li><a href="${base}/rs6000/asset-bizsys">${LIVE} Bizsys</a></li>
                            <li><a href="${base}/rs6000/asset-was">${LIVE} WAS</a></li>
                            <li><a href="${base}/rs6000/asset-user">${LIVE} User</a></li>
                            <li><a href="${base}/rs6000/asset-cluster">${LIVE} Cluster</a></li>
                            <li><a href="${base}/rs6000/asset-nim">${LIVE} NIM</a></li>
                            <li>${CODE} VIOS</li>
                        </ul>
                    </li>
                    <li>Windows</li>
                </ul>
            </li>
        </ul>
    </li>
    <li><h4>安全与合规</h4>
        <ul>
            <li>审计检查
                <ul>
                    <li>RS6000
                        <ul>
                            <li>系统健康检查</li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>补丁管理
                <ul>
                    <li>软件矩阵</li>
                    <li>硬件微码</li>
                    <li>补丁信息</li>
                </ul>
            </li>
        </ul>
    </li>
    <li><h4>维护与变更</h4>
        <ul>
            <li>故障与修复
                <ul>
                    <li>PRM故障诊断（Windows）</li>
                </ul>
            </li>
            <li>${NOPLAN} 应用发布</li>
            <li>配置变更</li>
            <li>容灾切换
                <ul>
                    <li>CBS一键切换</li>
                </ul>
            </li>
            <li>应急演练
                <ul>
                    <li><a href="${base}/rs6000/drillplan/list">${LIVE} 演练计划</a></li>
                    <li><a href="${base}/rs6000/drill/task">${LIVE} 演练任务</a></li>
                    <li><a href="${base}/rs6000/drill/templates">${LIVE} 演练模板</a></li>
                    <li><a href="${base}/rs6000/drill/go-drill-analysis">${CODE} 演练分析</a></li>
                </ul>
            </li>
            <li>${NOPLAN} 数据备份</li>
        </ul>
    </li>
    <li><h4>资源与服务</h4>
        <ul>
            <li>计算资源管理
                <ul>
                    <li><a href="${base}/rs6000/capacity-manage">${LIVE} 容量管理</a></li>
                    <li>${CODE} IP管理</li>
                </ul>
            </li>
            <li>系统装配
                <ul>
                    <li><a href="${base}/provision/provision-index">投产管理</a></li>
                </ul>
            </li>
            <li>一键任务</li>
        </ul>
    </li>
    <li><h4>管理与决策</h4>
        <ul>
            <li>${PENDING} 风险评估</li>
            <li>数据报告</li>
        </ul>
    </li>
    <li>
        <h4>自动化平台</h4>
        <ul>
            <li>
                看板相关
                <ul>
                    <li><a href="${base}/feedback/list">${LIVE} 看板反馈</a></li>
                    <li><a href="${base}/bulletin/list">${LIVE} 看板公告</a></li>
                    <li>安全管理
                        <ul>
                            <li><a href="${base}/user/list">${LIVE} 用户管理</a></li>
                            <li><a href="${base}/permission/list">${LIVE} 权限定义</a></li>
                            <li><a href="${base}/role/list">${LIVE} 角色定义</a></li>
                            <li><a href="${base}/citype/list">${LIVE} 域对象定义</a></li>
                            <li><a href="${base}/user/matrix">${LIVE} 权限矩阵</a></li>
                        </ul>
                    </li>
                    <li>
                        看板日志
                    </li>
                </ul>
            </li>
            <li>SA相关
                <ul>
                    <li><a href="${base}/platform/sa-opslog">${LIVE} SA操作日志</a></li>
                    <li><a href="${base}/platform/sa-job-list">${LIVE} SA Job</a></li>
                    <li><a href="${base}/platform/sa-user">${LIVE} SA用户</a></li>
                </ul>
            </li>
            <li>系统集成
                <ul>
                    <li><a href="${base}/rs6000/duty-schedule">${LIVE} 值班表</a></li>
                </ul>
            </li>
            <li><a href="${base}/platform/system-check">${LIVE} 平台健康状况</a></li>
            <li>培训课程</li>
        </ul>
    </li>
</ul>
<div>
    图例
    <ul class="unstyled">
        <li>${LIVE} 已上线</li>
        <li>${CODE} 正在开发</li>
        <li>${NOPLAN} 目前无开发计划</li>
        <li>${PENDING} Pending</li>
    </ul>
</div>
</@ui.page>
