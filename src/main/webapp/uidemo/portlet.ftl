<#-- 2012/11/16 -->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/chart-builder.ftl" parse=true/>
<@ui.page id="portlet">
<form id="chartQform" action="${base}/uidemo/data/chart-json.jsp">
</form>
<div class="alert alert-info">用&lt;div&gt;来布局</div>
<div class="rows" style="display: table-row; width: 100%">
    <div id="container1" class="portlet-container debug" style="display: table-cell; width:20%">
        <div class="alert">Leo: 垂直container</div>
        <@ui.portlet id="p1" title="直方图Portlet">
            <@barChart id="barChart"  title="直方图" ajaxForm="#chartQform"/>
        </@ui.portlet>

        <@ui.portlet id="p2-0" class="not-moveable" title="不可移动">
            这个portlet不可以移动，设置<br/><code>&lt;div class="not-moveable"&gt;</code>
        </@ui.portlet>
        <@ui.portlet id="p2-1" class="not-editable" title="不可编辑">
            这个portlet不可以编辑，设置<br/><code>&lt;div class="not-editable"&gt;</code>
        </@ui.portlet>
        <@ui.portlet id="p2-2" class="not-resizable" title="不可改变大小">
            这个portlet不可以改变大小，设置<br/><code>&lt;div class="not-resizable"&gt;</code>
        </@ui.portlet>
        <@ui.portlet id="p2-3" class="theme-red" title="没有边框并指定theme">
            不设置box格式，<br/><code>&lt;div class="theme-red"&gt;</code>
        </@ui.portlet>

    </div>

    <div id="container2" class="portlet-container debug" style="display: table-cell; width:30%">
        <div class="alert">Leo: 垂直container</div>
        <@ui.portlet id="p4" title="线图Portlet">
            <@lineChart id="lineChart1"  title="线图" ajaxForm="#chartQform" xAxisFormat="%H:%M:%S"/>
        </@ui.portlet>

    </div>

    <div id="container3" class="portlet-container debug" style="display: table-cell; width:50%">
        <div class="alert">Leo: 垂直container</div>
        <@ui.portlet id="p5" title="饼图Portlet">
            <@pieChart id="pieChart"  title="饼图" ajaxForm="#chartQform"/>
        </@ui.portlet>

        <@ui.portlet id="p6" title="如何制作Portlet">
            <p><img src="${base}/media/app/images/logo-head.png" class="pull-left"/>Portlet是一个可以在页面中拖拽的小窗口。Portlet的内容可以是本地的，也可以通过AJAX获取远程内容。
            </p>

            <p>实现代码如下：</P>
<pre>
&lt;@ui.portlet id="{portletId}" title="{Portlet的标题}"&gt;&lt;/@ui.portlet&gt;
</pre>
            注意：
            <ul class="listing-bullet">
                <li>在一个页面中，每个Portlet必须有唯一的ID。</li>
                <li>Portlet必须存在于<code>&lt;div class="portlet-container"&gt;</code>内</li>
            </ul>
        </@ui.portlet>

    </div>
</div>
<div class="clearfix"></div>
<div id="container4" class="portlet-container horizontal debug">
    <div class="alert">Leo: 水平container</div>
    <@ui.portlet id="p8" title="加载AJAX内容"
    url="${base}/jpost/bulletin/list"></@ui.portlet>
</div>


<div class="alert alert-info">用&lt;table&gt;来布局</div>
<table class="debug" width="100%">
    <tr>
        <td id="container2-1" class="portlet-container debug" width="33.3%">
            <@ui.portlet id="p2_1" title="加载AJAX内容"
            url="${base}/jpost/bulletin/list"></@ui.portlet>
        </td>
        <td id="container2-2" class="portlet-container debug" width="33.3%">
            <@ui.portlet id="p2_2" title="Portlet">新的Portlet</@ui.portlet>
        </td>
        <td id="container2-3" class="portlet-container debug" width="33.3%">
            <@ui.portlet id="p2_3" title="加载AJAX内容"
            url="${base}/jpost/bulletin/list"></@ui.portlet>
        </td>
    </tr>
</table>
<script>
    $(function () {
        uiKit.uiBuildPortlet("demo_portlets1");
    });
</script>
</@ui.page>