<#-- 2012/05/03 -->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="uidemo-dialog"/>
<@ui.page id=pageId title="Dialog Demo">
<div id="demo-dialog" class="hide"></div>
<div class="row">
    <ul class="nav nav-pills">
        <li>
            <a href="${base}/uidemo/server-detail"
               data-dialog>
                <h4>Ajax内容 (缺省：模态，不可伸缩)</h4>

                <p>data-dialog</p>
            </a></li>
        <li><a href="${base}/uidemo/chart" data-dialog data-dialog-modal="false">
            <h4>Ajax内容 (非模态，不可伸缩)</h4>

            <p>
                data-dialog data-dialog-modal="false"
            </p>
        </a></li>
        <li><a href="${base}/uidemo/server-detail" data-dialog data-dialog-modal="false"
               data-dialog-resizable="true">
            <h4>Ajax内容 (非模态，可伸缩)</h4>

            <p>
                data-dialog data-dialog-modal="false" data-dialog-resizable
            </p>
        </a></li>
        <li><a href="${base}/uidemo/chart" data-dialog="#demo-dialog" data-dialog-resizable="true">
            <h4>在指定div加载Ajax</h4>

            <p>data-dialog="#demo-dialog"</p></a></li>
        <li><a href="${base}/uidemo/chart" data-dialog="#non-exist-dialog-div"
               data-dialog-modal="false"><h4><strong
                class="error">Error:
            指定不存在的对话框</strong></h4>

            <p>data-dialog="#non-exist-dialog-div"</p>
        </a></li>
        <li><a href="" data-dialog="#local-message"><h4>加载本地很长的静态内容</h4>

            <p>data-dialog="#local-message"</p>
        </a>
        </li>
        <!--li><a href="#" data-dialog="#local-message" data-dialog-modal="true"
               data-dialog-title="小对话框"
               data-dialog-resizable="true" data-dialog-style="width:100px;height:100px">
            <h4>指定对话框大小 (初始100×100px)</h4>

            <p>data-dialog data-dialog-style="width:100px;height:100px"</p>
        </a></li-->
        <li><a href="#" data-dialog="#local-message" data-dialog-modal="false"
               data-dialog-afterclose="alert('closed')"
               data-dialog-resizable="true"><h4>关闭对话框后进行处理</h4>

            <p>data-dialog-afterclose="alert('closed')"</p>
        </a>
        </li>
        <li><a href="#" data-dialog="#local-message" data-dialog-modal="false"
               data-dialog-aftersubmit="alert('submitted')"
               data-dialog-resizable="true"><h4>提交对话框后进行处理</h4>

            <p>data-dialog-aftersubmit="alert('submitted')"</p>
        </a>
        </li>
        <li><a href="${base}/not-exist-url" data-dialog data-dialog-error="页面不存在哦，亲"
                >
            <h4><strong
                    class="error">Error:
                自定义的错误信息</strong></h4>

            <p>data-dialog-error="页面不存在哦，亲"</p>
        </a>
        </li>
        <li><a href="http://www.163.com" data-dialog data-dialog-content-type="iframe"
               data-dialog-style="width:800px;border:2px solid red;">
            通过iframe调用其它页面
        </a>
        </li>
        <li><a href="${base}/uidemo/multi-iframe" data-dialog>
            多个iframe
        </a>
        </li>
    </ul>
    <div class="col-md-8">

    </div>
</div>
<div id="local-message" class="hide">
    <form action="#" method="POST" data-ajax-form data-kui-target="#hide-layer">
        <#list 1..200 as num>
            <p>This is local message ${num}</p>
        </#list>
        <button type="submit" class="btn btn-primary">Submit</button>
        <button type="reset" class="btn btn-default">Close</button>
    </form>
</div>
<div id="hide-layer" class="hide"></div>
</@ui.page>