<#-- 2012/05/03 -->
<#include "/library/taglibs.ftl" parse=true/>
<#include "_demo-navigation.ftl" parse=true/>
<#assign pageId="uidemo-nav"/>
<@ui.page id=pageId title="Nav Demo">
    <@ui.alert level="info" icon=true>各种导航示例，包括Tab、Pill、List</@ui.alert>
<#--<div class="row">-->
<#--<div class="col-md-2">-->
<#--<@demoNav id="vertical-nav" style="vertical" target="#js-right-pane"/>-->
<#--</div>-->
<div id="js-right-pane" class="tab-content">
    <div class="tabbable tabbable-custom">
        <@ui.ajaxNav target="#${pageId}-nav-target" class="nav-tabs">
            <li class="active"><a href="#${pageId}-pill-horizontal" data-toggle="tab">Pill -
                Horizontal</a></li>
            <li><a href="#${pageId}-pill-vertical" data-toggle="tab">Pill - Vertical</a></li>
            <li><a href="#${pageId}-tab-horizontal" data-toggle="tab">Tab - Horizontal</a></li>
            <#--<li><a href="#${pageId}-tab-vertical" data-toggle="tab">Tab - Vertical</a></li>-->
            <li><a href="#${pageId}-navbar" data-toggle="tab">Navbar</a></li>
            <li><a href="#${pageId}-list-tree" data-toggle="tab">List Tree</a></li>
            <li><a href="#${pageId}-actiontab" data-toggle="tab">ActionTab</a></li>
        </@ui.ajaxNav>
    </div>
    <div id="${pageId}-nav-target" class="tab-content">
        <div id="${pageId}-pill-horizontal" class="tab-pane">
            <h3>Pill Style - Horizontal</h3>

            <@ui.ajaxNav target="#tab-content1" class="nav-pills">
                <li><a href="#tab1" data-toggle="tab">Local 1</a></li>
                <li class="active"><a href="#tab2" data-toggle="tab">Local 2</a></li>
                <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a></li>
            </@ui.ajaxNav>
            <div class="tab-content" id="tab-content1">
                <div id="tab1" class="tab-pane">
                    Local content 1
                </div>
                <div id="tab2" class="tab-pane">
                    Local content 2
                </div>
            </div>
        </div>

        <div id="${pageId}-pill-vertical" class="tab-pane">
            <h3>Pill Style - Vertical</h3>

            <div class="row">
                <@ui.ajaxNav target="#tab-content5" class="nav-pills nav-stacked col-md-2">
                    <li><a href="#tab5-1" data-toggle="tab">Local 1</a></li>
                    <li><a href="#tab5-2" data-toggle="tab">Local 2</a></li>
                    <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a></li>
                </@ui.ajaxNav>
                <div id="tab-content5" class="tab-content col-md-10">
                    <div id="tab5-1" class="tab-pane">
                        Local content 1
                    </div>
                    <div id="tab5-2" class="tab-pane">
                        Local content 2
                    </div>
                </div>
            </div>
        </div>
        <#--<div id="${pageId}-tab-vertical" class="tab-pane">-->
            <#--<h3>Tab Style - Vertical</h3>-->

            <#--<div class="row">-->
                <#--<div class="col-md-2">-->
                    <#--<@ui.ajaxNav target="#tab-content2" class="nav-tabs nav-stacked">-->
                        <#--<li><a href="#tab2-1" data-toggle="tab">Local 1</a></li>-->
                        <#--<li><a href="#tab2-2" data-toggle="tab">Local 2</a></li>-->
                        <#--<li class="active"><a href="${base}/uidemo/ajax-result"-->
                                              <#--data-toggle="tab">Ajax</a></li>-->
                    <#--</@ui.ajaxNav>-->
                <#--</div>-->
                <#--<div class="col-md-10">-->
                    <#--<div class="tab-content" id="tab-content2">-->
                        <#--<div id="tab2-1" class="tab-pane">-->
                            <#--Local content 2-1-->
                        <#--</div>-->
                        <#--<div id="tab2-2" class="tab-pane">-->
                            <#--Local content 2-2-->
                        <#--</div>-->
                    <#--</div>-->
                <#--</div>-->
            <#--</div>-->
        <#--</div>-->
        <div id="${pageId}-tab-horizontal" class="row tab-pane">
            <h3>Tab Style - Horizontal</h3>


            <div class="tabbable tabbable-custom">
                <@ui.ajaxNav class="nav-tabs" target="#tab-content4">
                    <li><a href="#tab4-1" data-toggle="tab">Local 1</a></li>
                    <li class="active"><a href="#tab4-2" data-toggle="tab">Local 2</a></li>
                    <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a></li>
                </@ui.ajaxNav>
            <#--</ul>-->
            </div>
            <div class="tab-content" id="tab-content4">
                <div id="tab4-1" class="tab-pane">
                    Local content 2-1
                </div>
                <div id="tab4-2" class="tab-pane">
                    Local content 2-2
                </div>
            </div>
        </div>
        <div id="${pageId}-navbar" class="tab-pane">
            <h3>Navbar Style</h3>

            <div class="navbar navbar-default">
                    <@ui.ajaxNav target="#tab-content3" class="navbar-nav">
                        <li class="active"><a href="#tab3-1" data-toggle="tab">Local 1</a></li>
                        <li><a href="#tab3-2" data-toggle="tab">Local 2</a></li>
                        <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a></li>
                    </@ui.ajaxNav>
            </div>

            <div class="tab-content" id="tab-content3">
                <div id="tab3-1" class="tab-pane">
                    Local content 3-1
                </div>
                <div id="tab3-2" class="tab-pane">
                    Local content 3-2
                </div>
            </div>
        </div>
        <div id="${pageId}-list-tree" class="tab-pane">
            <h3>List Tree Style</h3>

            <div class="row">
                <@ui.ajaxNav target="#tab-content6" class="nav-list-tree nav-pills nav-stacked col-md-2">
                    <li><a href="#tab6-1" data-toggle="tab">Local 1</a></li>
                    <li><a href="#" data-toggle="tab">包含子菜单</a>
                        <ul>
                            <li><a href="#tab6-1" data-toggle="tab">Local 1</a></li>
                            <li><a href="#">还有子菜单</a>
                                <ul>
                                    <li><a href="${base}/uidemo/ajax-result"
                                           data-toggle="tab">Ajax</a>
                                    </li>
                                    <li><a href="#">最多4层子菜单</a>
                                        <ul>
                                            <li><a href="${base}/uidemo/ajax-result"
                                                   data-toggle="tab">Ajax</a>
                                            </li>
                                            <li><a href="#">不要再加子菜单了</a></li>
                                        </ul>
                                    </li>
                                    <li><a href="#">最多4层子菜单</a>
                                        <ul>
                                            <li><a href="#tab6-1">Local 1</a></li>
                                            <li><a href="#">不要再加子菜单了</a></li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li><a href="#tab6-2" data-toggle="tab">自定义风格子菜单</a>
                        <ul class="nav-custom-group">
                            <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a>
                            </li>
                            <li><a href="#">还有子菜单</a>
                                <ul>
                                    <li><a href="${base}/uidemo/ajax-result"
                                           data-toggle="tab">Ajax</a>
                                    </li>
                                    <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax
                                        Again</a></li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li><a href="#tab6-2" data-toggle="tab">Pills子菜单</a>
                        <ul class="nav-pills nav-stacked">
                            <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a>
                            </li>
                            <li><a href="#">还有子菜单</a>
                                <ul>
                                    <li><a href="#tab6-1">Local</a></li>
                                    <li><a href="#tab6-2">Local</a></li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li><a href="${base}/uidemo/ajax-result" data-toggle="tab">Ajax</a></li>
                </@ui.ajaxNav>
                <div id="tab-content6" class="tab-content col-md-10">
                    <div id="tab6-1" class="tab-pane">
                        Local content 6-1
                    </div>
                    <div id="tab6-2" class="tab-pane">
                        Local content 6-2
                    </div>
                </div>
            </div>
        </div>
        <div id="${pageId}-actiontab" class="tab-pane">
            <h3>ActionTab</h3>
            <#include "actiontab.ftl" parse=true/>
        </div>
    </div>
</div>
<#--</div>-->
</@ui.page>