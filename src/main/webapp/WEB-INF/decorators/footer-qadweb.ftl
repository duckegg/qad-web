<#--
2012/05/03
http://www.google.com/chrome/eula.html?hl=zh-CN&standalone=1
http://www.mozilla.org/en-US/firefox/all.html
-->
<#include "/library/taglibs.ftl" parse=true/>
<div>
    <div class="col-md-12">
        <ul class="list-unstyled list-inline text-right">
            <li>
                <a href="${base}/shortcuts" data-dialog accesskey="h"><i
                        class="fa fa-keyboard-o"></i>
                    快捷键</a></li>
            <li>
            <@shiro.user>
                <a href="${base}/jpost/feedback/create" data-kui-dialog
                   data-dialog-resizable="true"><i
                        class="fa fa-envelope-alt"></i> 意见反馈</a> |
            </@shiro.user>
                <a href="${base}/changelog" target="_blank"><#include "/VERSION.txt"/></a>
            </li>
        </ul>
    <#--<div>-->
    <#--<ul class="list-unstyled list-inline">-->
    <#--<li><i class="fa fa-cogs"></i> 快速通道</li>-->
    <#--<li><a href="https://10.1.248.33/" target="_blank"><i class="fa fa-angle-right"></i>SA 服务器自动化</a></li>-->
    <#--<li><a href="https://10.1.248.47:8443/PAS/" target="_blank"><i class="fa fa-angle-right"></i>OO 流程自动化</a></li>-->
    <#--<li><a href="https://10.0.47.5/" target="_blank"><i class="fa fa-angle-right"></i>NA 网络自动化</a></li>-->
    <#--</ul>-->
    <#--</div>-->
    </div>
</div>