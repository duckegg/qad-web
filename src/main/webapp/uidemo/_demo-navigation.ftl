<#-- 2012/11/14 -->
<#include "/library/functions.ftl"/>
<#macro demoNav id target style="horizontal">
    <#assign cssNavbar = iif(style=="horizontal","navbar navbar-default","")/>
    <#assign cssUl = iif(style=="horizontal","nav navbar-nav","nav nav-pills nav-stacked nav-list-tree")/>
    <#assign cssDropdown = iif(style=="horizontal","dropdown","")/>
    <#assign cssDropdownMenu = iif(style=="horizontal","dropdown-menu sub-menu","nav-stacked nav-custom-group")/>
    <#assign dropdownToggleCss = iif(style=="horizontal","dropdown-toggle","")/>
    <#assign dropdownToggleData = iif(style=="horizontal","dropdown","")/>
    <#assign caret=iif(style=="horizontal",'<b class="caret"></b>','')/>
<div id="${id}" class="${cssNavbar}">
    <a class="navbar-brand" href="${base}/uidemo/index" data-pjax-disabled><i
            class="fa fa-home"></i> UI Demo</a>
    <ul class="${cssUl}" data-ajax-nav data-kui-target="${target}">
        <li><a href="${base}/uidemo/nav"><i class="fa fa-folder-close-alt"></i> 导航</a></li>
        <li class="${cssDropdown}">
            <a href="#" class="${dropdownToggleCss}" data-toggle="${dropdownToggleData}"><i
                    class="fa fa-refresh"></i> Ajax ${caret} </a>
            <ul class="${cssDropdownMenu}">
                <li><a href="${base}/uidemo/index" data-pjax>Pjax请求</a>
                </li>
                <li><a href="#" onclick="callPjax('${base}/uidemo/index','回到UI Demo页面');">调用Pjax并显示成功消息</a>
                </li>
                <li><a href="${base}/non-exist.action" data-dialog>Ajax调用错误404</a>
                </li>
                <li>
                    <a href="${base}/uidemo/demo-parse-ftl" data-dialog>Ajax调用错误500</a>
                </li>
                <li><a href="#" onclick="flashMessage('info','Ajax正在处理，请稍候，10秒后自动关闭...',10)">Ajax处理状态</a>
                </li>
                <li><a href="${base}/uidemo/ajax">Ajax表单和链接</a>
                </li>
            </ul>
        </li>
        <li class="${cssDropdown}">
            <a href="#" class="${dropdownToggleCss}"
               data-toggle="${dropdownToggleData}"><i class="fa fa-align-left"></i>
                树形列表 ${caret} </a>
            <ul class="${cssDropdownMenu}">
                <li><a href="${base}/uidemo/tree">Tree</a></li>
                <li><a href="${base}/uidemo/orgchart">Orgchart</a></li>
            </ul>
        </li>
        <li>
            <a href="${base}/uidemo/status"><i class="fa fa-map-marker"></i> 状态和提示</a>
        <#--<ul class="${cssDropdownMenu}">-->
        <#--<li><a href="#" onclick="flashMessage('success','SUCCESS: 操作成功，消息3秒后自动关闭');"><i-->
        <#--class="fa fa-check"></i> success提示</a>-->
        <#--</li>-->
        <#--<li><a href="#"-->
        <#--onclick="flashMessage('info','INFO: 操作正在进行，消息3秒后自动关闭');"><i-->
        <#--class="fa fa-info-circle"></i> info提示</a></li>-->
        <#--<li><a href="#"-->
        <#--onclick="flashMessage('warn','WARN: 输入不正确，消息3秒后自动关闭');"><i-->
        <#--class="fa fa-warning"></i> warn提示</a></li>-->
        <#--<li><a href="#"-->
        <#--onclick="flashMessage('error','ERROR: 系统错误，消息3秒后自动关闭')"><i-->
        <#--class="fa fa-times"></i> error提示</a></li>-->
        <#--</ul>-->
        </li>
        <li class="${cssDropdown}"><a href="#" class="${dropdownToggleCss}"
                                      data-toggle="${dropdownToggleData}"><i
                class="fa fa-file"></i> 页面 ${caret}</a>
            <ul class="${cssDropdownMenu}">
                <li class="${cssDropdown}"><a href="#" class="${dropdownToggleCss}"
                                              data-toggle="${dropdownToggleData}">
                    FTL ${caret} </a>
                    <ul class="${cssDropdownMenu}">
                        <li><a href="${base}/uidemo/demo-parse-ftl"
                               target="_blank">FTL语法错误页面</a>
                        </li>
                        <li>
                            <a href="${base}/uidemo/demo-parse-ftl?result=good"
                               target="_blank">FTL语法正确页面</a>
                        </li>
                    </ul>
                </li>
                <li class="${cssDropdown}">
                    <a href="#" class="${dropdownToggleCss}"
                       data-toggle="${dropdownToggleData}">JSP ${caret} </a>
                    <ul class="${cssDropdownMenu}">
                        <li><a href="${base}/__jsp?next=/uidemo/demo-parse-jsp" target="_blank">JSP语法错误页面</a>
                        </li>
                        <li>
                            <a href="${base}/__jsp?next=/uidemo/demo-parse-jsp&result=good"
                               target="_blank">JSP语法正确页面</a>
                        </li>
                    </ul>
                </li>
                <li><a href="${base}/uidemo/chinese-url?msg=这是一条中文信息"
                       target="_blank">中文GET请求</a>
                </li>
            </ul>
        </li>
        <li><a href="${base}/uidemo/table"><i class="fa fa-table"></i> Table</a></li>
        <li><a href="${base}/uidemo/dialog"><i class="fa fa-folder-close"></i> Dialog</a></li>

        <li class="${cssDropdown}">
            <a href="#" class="${dropdownToggleCss}"
               data-toggle="${dropdownToggleData}"><i class="fa fa-bar-chart"></i>
                图形和Portlet ${caret} </a>
            <ul class="${cssDropdownMenu}">
                <li><a href="${base}/uidemo/portlet">Portlet</a></li>
                <li><a href="${base}/uidemo/chart">Chart</a></li>
            </ul>
        </li>
        <li><a href="${base}/uidemo/form"><i class="fa fa-list-alt"></i> 表单输入</a></li>
        <li><a href="${base}/uidemo/misc"><i class="fa fa-inbox"></i> Misc</a></li>
        <li><a href="${base}/uidemo/kaptcha">kaptcha</a></li>
        <li><a href="${base}/democode/list">DemoCode</a></li>
    </ul>
</div>
</#macro>