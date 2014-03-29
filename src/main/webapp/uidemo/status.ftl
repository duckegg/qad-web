<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-30, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="uidemo-status"/>
<@ui.page id=pageId title="状态和提示">
    <#if permissionResolver.allow('perm_hello')>hello</#if>
<h3>Flash Message</h3>
<p>
    <code>flashMessage('success','some message');</code>
</p>
<ul class="nav nav-pills">
    <li><a href="#" onclick="flashMessage('success','SUCCESS: 操作成功，消息3秒后自动关闭');"><i
            class="fa fa-check"></i> success提示</a>
    </li>
    <li><a href="#"
           onclick="flashMessage('info','INFO: 操作正在进行，消息3秒后自动关闭');"><i
            class="fa fa-info-circle"></i> info提示</a></li>
    <li><a href="#"
           onclick="flashMessage('warn','WARN: 输入不正确，消息3秒后自动关闭');"><i
            class="fa fa-warning"></i> warn提示</a></li>
    <li><a href="#"
           onclick="flashMessage('error','ERROR: 系统错误，消息3秒后自动关闭')"><i
            class="fa fa-times"></i> error提示</a></li>
    <li><a href="#"
           onclick="flashMessage('info','朝辞白帝彩云间，千里江陵一日还，两岸猿声啼不住，轻舟已过万重山。白日依山尽，黄河入海流，欲穷千里目，更上一层楼。大风起兮云飞扬，威加海内兮归故乡。',0)"><i
            class="fa fa-info-circle"></i> 长消息</a></li>
</ul>
<h3>Alert</h3>
<p>
    <code>&lt;@ui.alert level="success"&gt;success&lt;/@ui.alert&gt;</code>
</p>
    <@ui.alert level="success">
    &lt;@ui.alert level="success"&gt;&lt;/@ui.alert&gt;
    </@ui.alert>
    <@ui.alert level="info">
    &lt;@ui.alert level="info"&gt;&lt;/@ui.alert&gt;
    </@ui.alert>
    <@ui.alert level="warning">
    &lt;@ui.alert level="warning"&gt;&lt;/@ui.alert&gt;
    </@ui.alert>
    <@ui.alert level="error">
    &lt;@ui.alert level="error"&gt;&lt;/@ui.alert&gt;
    </@ui.alert>
    <@ui.alert level="danger">
    &lt;@ui.alert level="danger"&gt;&lt;/@ui.alert&gt;
    </@ui.alert>
<h3>Ajax状态</h3>
<div class="row">
<ul class="col-md-3 nav nav-tabs nav-stacked">
    <li><a href="javascript:$('#ajax-loading').append(showLoading('bar'));">Ajax loading bar</a>
    </li>
    <li><a href="javascript:$('#ajax-loading').append(showLoading('inline'));">Ajax loading
        inline</a></li>
    <li><a href="javascript:hideLoading();">Hide Ajax
        Loading</a></li>
</ul>
<div id="ajax-loading" class="col-md-4 debug">ajax loading shows here</div>
</div>
</@ui.page>
