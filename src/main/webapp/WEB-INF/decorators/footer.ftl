<#--
2012/05/03
http://www.google.com/chrome/eula.html?hl=zh-CN&standalone=1
http://www.mozilla.org/en-US/firefox/all.html
-->
<#include "/library/taglibs.ftl" parse=true/>
<div class="row-fluid row">
    <div class="col-md-8 span8">
        <div>
            <ul class="list-unstyled list-inline unstyled inline">
                <li>系统采用了HTML5和CSS3，
                    推荐 <a href="http://k.cmbchina.com/art/download/chrome.exe"><i
                            class="icomoon-chrome"></i> Chrome</a>，兼容 <a
                            href="http://k.cmbchina.com/art/download/firefox.exe"><i
                            class="icomoon-firefox"></i> Firefox</a>、IE8+。 </li>
            </ul>
        </div>
        <div>
            <ul class="list-unstyled list-inline unstyled inline">
                <li><i class="fa fa-cogs"></i> 快速通道</li>
                <li><a href="https://10.1.248.33/" target="_blank"><i class="fa fa-angle-right"></i>SA 服务器自动化</a></li>
                <li><a href="https://10.1.248.47:8443/PAS/" target="_blank"><i class="fa fa-angle-right"></i>OO 流程自动化</a></li>
                <li><a href="https://10.0.47.5/" target="_blank"><i class="fa fa-angle-right"></i>NA 网络自动化</a></li>
            </ul>
        </div>
    </div>
    <div class="col-md-4 span4">
        <div class="text-right">
            <ul class="list-unstyled unstyled">
                <li>
                <@shiro.user>
                    <a href="${base}/jpost/feedback/create" data-dialog
                       data-dialog-resizable="true"><i
                            class="fa fa-envelope-alt"></i> 意见反馈</a> |
                </@shiro.user>
                    <a href="${base}/changelog" target="_blank"><#include "/VERSION.txt"/></a>
                </li>
            </ul>
            <img src="${base}/media/app/images/logo-cmb.png"/>
        </div>
    </div>
</div>