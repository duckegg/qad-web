<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-15, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="uidemo-ajax"/>
<@ui.page id=pageId title="Ajax">
<ul class="breadcrumb">
    <li><a href="${base}/uidemo/index">Home</a> <span class="divider">/</span></li>
    <li class="active">Ajax</li>
</ul>
<h3>Ajax Form</h3>
<ul class="list-unstyled list-inline">
    <li>
        <div class="alert alert-info">
            <p><code>data-ajax-form</code> <code>data-kui-target="#${pageId}-target1"</code></p>

            <form action="${base}/uidemo/ajax-result" method="GET" data-ajax-form
                  data-kui-target="#${pageId}-target1" class="form-inline">
                <@ui.textfield name="inputMessage"/>
                <button type="submit" class="btn btn-default">提交并在target1显示结果</button>
            </form>
        </div>
    </li>
    <li>
        <div class="alert alert-info">
            <p>提交之前需要校验，必填字段增加<code>class="required"</code></p>

            <form action="${base}/uidemo/ajax-result" method="GET" data-ajax-form
                  data-kui-target="#${pageId}-target1"
                  class="form-inline">
                <@ui.textfield name="inputMessage" placeholder="必填字段" class="required"/>
                <button type="submit" class="btn btn-default">提交并在target1显示结果</button>
            </form>
        </div>
    </li>
    <li>
        <div class="alert alert-info">
            <p>提交到一个对话框展示结果<code>data-ajax-form data-dialog data-kui-target="#..."</code></p>

            <form data-ajax-form action="${base}/uidemo/ajax-result" method="GET"
                  data-kui-target="#${pageId}-ajax-dialog" data-dialog
                  data-dialog-title="Ajax Form提交结果"
                  class="form-inline">
                <@ui.textfield name="inputMessage"/>
                <button type="submit" class="btn btn-default">提交并在对话框显示结果</button>
            </form>
        </div>
    </li>
</ul>
<div id="${pageId}-ajax-dialog"></div>
<div class="row">
    <h3>Ajax Link</h3>
    <ul class="list-unstyled list-inline">
        <li><a href="${base}/uidemo/ajax-result?inputMessage=Earth" data-ajax-link
               data-kui-target="#${pageId}-target2">在target2显示结果</a>

            <p class="alert alert-info">
                <code>data-ajax-link data-kui-target="#${pageId}-target2"</code>
            </p>
        </li>
        <li><a href="${base}/uidemo/ajax-result?inputMessage=Moon" data-ajax-link
               data-kui-target="#${pageId}-target2"
               data-confirm="确定之后才会执行连接">在target2显示结果（先确认）</a>

            <p class="alert alert-info">
                <code>data-confirm="Some message to be confirmed"</code>
            </p>
        </li>
    </ul>
</div>
<div class="row">
    <div class="col-md-4">
        <h4>#uidemo-ajax-target1</h4>

        <div id="${pageId}-target1" class="debug">
            这是target1
        </div>
    </div>
    <div class="col-md-4">
        <h4>#uidemo-ajax-target2</h4>

        <div id="${pageId}-target2" class="debug">
            这是target2
        </div>
    </div>
</div>
<h3>Pjax</h3>
<a href="${base}/uidemo/ajax" data-pjax>这是一个Pjax连接，浏览器不应刷新，但地址栏应变为${base}/uidemo/ajax</a>
</@ui.page>
