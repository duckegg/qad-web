<#--
********************************************************************************
@desc Page to display keyboard shortcut info
@author Leo Liao, 2012/06/12, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<title>键盘快捷键</title>
<div id="shortcuts" class="webform">
    <h4>所有页面</h4>
    <dl class="dl-horizontal">
        <dt><code>h</code></dt>
        <dd>显示本页面</dd>
        <dt><code>g</code></dt>
        <dd>全文搜索</dd>
    </dl>

    <h4>表格显示页面</h4>
    <dl class="dl-horizontal">
        <dt><code>q</code></dt>
        <dd>在有表格的页面，定位到过滤框</dd>
        <dt><code>esc</code></dt>
        <dd>取消表格过滤框的输入</dd>
        <dt><code>t</code>+<code>enter</code></dt>
        <dd>在有表格的页面，按<code>t</code>定位到表格，再按<code>enter</code>定位到单元格</dd>
        <dt><code>enter</code></dt>
        <dd>单元格内，如果有checkbox或链接，将激活</dd>
        <dt><code>v</code></dt>
        <dd>激活查询条件</dd>
    </dl>
    <h4>对话框或弹窗</h4>
    <dl class="dl-horizontal">
        <dt><code>esc</code></dt>
        <dd>关闭当前的对话框或弹窗</dd>
    </dl>
</div>