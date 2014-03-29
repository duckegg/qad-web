<#--
********************************************************************************
@desc Sample performance
@author Leo Liao, 2013/06/25, created
********************************************************************************
-->

<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<#assign pageId="server-detail"/>
<@ui.page id=pageId title="服务器信息">
<form id="${pageId}-qform" action="${base}/uidemo/data/chart-json.jsp" class="form-vertical">
</form>
<div class="row">
    <div class="well well-small row">
        <div class="list-unstyled list-inline form-horizontal form-horizontal-narrow">
            <div class="pull-right" style="width:120px">
                <img src="${base}/media/app/images/brands/db2.gif"/>
                <p class="text-right">
                    <a class="accordion-toggle " data-toggle="collapse" href="#collapseOne">更多...</a>
                </p>
            </div>
            <h4>基本信息</h4>

            <div class="row">
                <@ui.labelControlGroup label="CPU" cssClass="col-md-3">2</@ui.labelControlGroup>
                <@ui.labelControlGroup label="内存" cssClass="col-md-3">8G</@ui.labelControlGroup>
                <@ui.labelControlGroup label="磁盘" cssClass="col-md-3">200G</@ui.labelControlGroup>
                <@ui.labelControlGroup label="时区" cssClass="col-md-3">GMT+8</@ui.labelControlGroup>
                <@ui.labelControlGroup label="位置" cssClass="col-md-3">业务一区</@ui.labelControlGroup>
            </div>
            <h4>管理信息</h4>

            <div class="row">
                <@ui.labelControlGroup label="管理员" cssClass="col-md-3">林耘逸</@ui.labelControlGroup>
                <@ui.labelControlGroup label="上线时间" cssClass="col-md-3">
                    2012-02-01</@ui.labelControlGroup>
                <@ui.labelControlGroup label="业务系统" cssClass="col-md-3">黄金交易</@ui.labelControlGroup>
                <@ui.labelControlGroup label="业务系统" cssClass="col-md-3">黄金交易</@ui.labelControlGroup>
                <@ui.labelControlGroup label="业务系统" cssClass="col-md-3">黄金交易</@ui.labelControlGroup>
                <@ui.labelControlGroup label="业务系统" cssClass="col-md-3">黄金交易</@ui.labelControlGroup>
                <@ui.labelControlGroup label="业务系统" cssClass="col-md-3">黄金交易</@ui.labelControlGroup>
                <@ui.labelControlGroup label="业务系统" cssClass="col-md-3">黄金交易</@ui.labelControlGroup>
            </div>
            <div id="collapseOne" class="accordion-body collapse row">
                <@ui.labelControlGroup label="属性1" cssClass="col-md-3">属性1</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性2" cssClass="col-md-3">属性2</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
                <@ui.labelControlGroup label="属性3" cssClass="col-md-3">属性3</@ui.labelControlGroup>
            </div>
        </div>
    </div>
    <div>
        <div class="tabbable tabbable-custom">
            <@ui.ajaxNav target="#js-tab-content" class="nav-tabs">
                <li class="active"><a href="#chart-tab-2" data-toggle="tab">CPU利用率</a></li>
                <li><a href="#chart-tab-3" data-toggle="tab">事务数</a></li>
                <li><a href="#chart-tab-4" data-toggle="tab">响应时间</a></li>
                <li><a href="#chart-tab-5" data-toggle="tab">IO</a></li>
                <li><a href="#chart-tab-6" data-toggle="tab">Paging Space</a></li>
                <li><a href="#chart-tab-7" data-toggle="tab">VM</a></li>
            </@ui.ajaxNav>
        </div>
        <div id="js-tab-content" class="tab-content tab-custom">
            <div class="tab-pane active" id="chart-tab-2">
                <@lineChart id="${pageId}-chart2"  title="线图，X为时分秒" ajaxForm="#${pageId}-qform" xAxisFormat="%H:%M:%S"/>
            </div>
            <div class="tab-pane active" id="chart-tab-3">
                <@lineChart id="${pageId}-chart3"  title="线图，X为时分秒" ajaxForm="#${pageId}-qform" xAxisFormat="%H:%M:%S"/>
            </div>
            <div class="tab-pane active" id="chart-tab-4">
                <@lineChart id="${pageId}-chart4"  title="线图，X为时分秒" ajaxForm="#${pageId}-qform" xAxisFormat="%H:%M:%S"/>
            </div>
            <div class="tab-pane active" id="chart-tab-5">
                <@lineChart id="${pageId}-chart5"  title="线图，X为时分秒" ajaxForm="#${pageId}-qform" xAxisFormat="%H:%M:%S"/>
            </div>
            <div class="tab-pane active" id="chart-tab-6">
                <@lineChart id="${pageId}-chart6"  title="线图，X为时分秒" ajaxForm="#${pageId}-qform" xAxisFormat="%H:%M:%S"/>
            </div>
            <div class="tab-pane active" id="chart-tab-7">
                <@lineChart id="${pageId}-chart7"  title="线图，X为时分秒" ajaxForm="#${pageId}-qform" xAxisFormat="%H:%M:%S"/>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('#${pageId}-qform').submit(function () {
                replotAll();
                return false;
            });
        });
        function replotAll() {
        <#--replotChart("${pageId}-lineChart1");-->
            replotChart("${pageId}-lineChart2");
            replotChart("${pageId}-pieChart");
            replotChart("${pageId}-barChart");
        }
    </script>
</div>
</@ui.page>