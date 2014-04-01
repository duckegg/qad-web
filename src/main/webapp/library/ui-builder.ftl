<#--
********************************************************************************
@desc Freemarker macro to build UI elements.
@author Leo Liao, 2012/05/22, created
********************************************************************************
-->
<#--
================================================================================
Action Tabs
@param smartList true to display smart filter, sorting
@deprecated use smartList instead
================================================================================
-->
<#macro actionTabs id class="" smartList=true scrollable=true listStyle="">
<div id="${id}" class="action-tabs ${class}">
    <#if smartList==true>
        <div class="js-smart-list horizontal accordion" data-role="collapsible" data-mini='true'>
            <h3>过滤</h3>

            <div>
                <input type="text" class="search input-small" placeholder="过滤" accesskey="f"
                       title="根据输入过滤列表中的内容"/>
            <span class="sort" data-sort="desc" style="cursor: pointer;margin:0 0.5em"
                  title="按名称排序"><i
                    class="fa fa-tag"></i> 按名称</span>
            <span class="sort" data-sort="number" style="cursor: pointer;margin:0 0.5em"
                  title="按数量排序"><i
                    class="fa fa-list-ol"></i> 按数量</span>
            </div>
        </div>
    </#if>
    <#if scrollable==true>
        <div class="carousel-controls">
            <div class="pager"></div>
            <a class="carousel-control left" href="#" data-slide="prev">&lsaquo;</a>
            <a class="carousel-control right" href="#" data-slide="next">&rsaquo;</a>
        </div>
    </#if>
<#--<ul class="listing-tab list <#if scrollable>listing-scrollable</#if>" data-role="listview">-->
<#-- class list is needed for list plugin https://github.com/javve/list -->
    <ul class="nav nav-pills <#--listing-tab--> list <#if scrollable>listing-scrollable</#if> ${listStyle}"
        data-role="listview" data-ajax-nav data-kui-target="#${id}-ntarget">
        <#nested>
    </ul>
</div>
<div class="tab-content" id="${id}-ntarget">
</div>
</#macro>

<#--
@param tooltip describe meaning of count number
-->
<#macro stats title count link badge="" badgeTooltip="" id="" class="" accesskey="" tooltip="" badgeClass="">
<li <#if class!="">class="${class}"</#if>>
    <a href="${link}" id="${id}" <#if accesskey!="">accesskey="${accesskey}"</#if>
       <#--data-url="${link}" -->class="stat-box" data-toggle="tab">
        <#if badge!="">
            <span class="badge badge-custom-stick <#if badgeClass!="">${badgeClass}<#else><#if (badge!="0")>badge-important<#else>badge-success</#if></#if>"
                  title="${badgeTooltip}">${badge}</span>
        </#if>
        <div class="number ui-li-count"
             title="<#if tooltip=''>${count}<#else>${tooltip}</#if>">${count}</div>
        <div class="desc" title="${title}">${title}</div>
    </a>
</li>
</#macro>

<#--
================================================================================
Form Elements
================================================================================
-->
<#--
Textfield
@description if value is not specified or empty, it will try evaluate name as value using
`${.vars[myKeyString]}`
@reference http://freemarker.624813.n4.nabble.com/Interpolation-name-as-String-and-retrieve-value-td625424.html
-->
<#macro textfield name label="" id="" style="" class="" title="" maxlength="" value="" placeholder=""
readonly=false disabled=false required=false helpText="" englishonly=false fontColor="" isPassword=false>
<#-- TODO: control-group only used for bootstrap 2 -->
<div class="form-group control-group">
    <label class="control-label" for="${id}" style="color: ${fontColor}"><#if label!="">${label}
        :</#if></label>

    <div class="controls">
        <input type="<#if isPassword>password<#else>text</#if>" <#if id!=''>id="${id}"</#if>
               name="${name}" value="<#if value=="">${.vars[name]!''}<#else>${value}</#if>"
               class="form-control ${class}" title="${title}" style="${style}"
               maxlength="${maxlength}"
               <#if placeholder!=''>placeholder="${placeholder}"
               <#elseif title!=''>placeholder="${title}"</#if>
               <#if readonly>readonly="readonly"</#if>
               <#if disabled>disabled="disabled"</#if>
               <#if required>required="required"</#if>
               <#if englishonly>onkeyup="value=value.replace(/[^\w\.\/]/ig,'')"</#if>/>
        <#if helpText!="">
            <span class="help-block">${helpText}</span>
        </#if>
    </div>
</div>
</#macro>
<#--
Textarea
@param size "small","middle","large"
 TODO: remove fontColor please. Use class
-->
<#macro textarea name id="" label="" style="" class="" size="middle" dataAttribute=""
maxlength=""
title="" help=""  placeholder=""
readonly=false disabled=false required=false
fontColor="">
    <#local captured><#nested></#local>
    <#if id==""><#assign id=name/></#if>
<div class="form-group control-group">
    <#if label!="">
        <label class="control-label" for="${id}"
               style="color: ${fontColor}"><#if label=''>${label}<#else>${label}:</#if></label>
    </#if>
    <div class="controls">
        <textarea name="${name}" id="${id}" style="${style}"
                  class="form-control ${class} kui-${size}"
                  title="${title}" ${dataAttribute}
                  maxlength="${maxlength}" <#if placeholder!="">placeholder="${placeholder}"</#if>
                  <#if readonly>readonly="readonly"</#if>
                  <#if required>required="required"</#if>
                  <#if disabled>disabled="disabled"</#if>><#if captured?length != 0>${captured}<#else>${.vars[name]!''}</#if></textarea>
        <#if help!=""><span class="help-block">${help}</span></#if>
    </div>
</div>
</#macro>

<#macro labelControlGroup label="" elementType="div" cssClass="">
<#-- Label and control group -->
<${elementType} class="form-group control-group ${cssClass}">
<label class="control-label"><#if label!="">${label}:</#if></label>
<div class="controls">
    <#nested>
</div>
</${elementType}>
</#macro>
<#-- Button and Group -->
<#macro button label="" id="" type="submit" class="" name="" value="" style="">
<button type="${type}" id="${id}" class="btn ${class}" name="${name}" value="${value}"
        style="${style}"><#if label!="">${label}<#else><#nested></#if></button>
</#macro>
<#macro buttonGroup style="">
<div class="form-actions"<#if style!="">style="${style}"</#if>>
    <#nested />
</div>
</#macro>
<#-- Radio Button -->
<#macro radio name label list={} id="" style="" class="" title="" maxlength="" value="" readonly=false required=false>
<div class="form-group control-group">
    <label class="control-label" for="${id}">${label}:</label>

    <div class="controls">
        <input type="radio" id="${id}" name="${name}" value="${value}" class="${class}"
               title="${title}" style="${style}" <#if readonly>readonly="readonly"</#if>/>
    </div>
</div>
</#macro>
<#-- Plain Text -->
<#macro text id="" label="" class="" style="">
<div class="form-group control-group">
    <label class="control-label" style="${style}" for="${id}">${label}<#if label!="">:</#if></label>

    <div class="controls"><span id="${id}" class="${class}"><#nested></span></div>
</div>
</#macro>
<#--
================================================================================
Pagination.
@param size: number of records per page
@param current: current page number, starting from 1
@param records: number of total records
@param link: hyper link for page, available token is [page] for page number
================================================================================
-->
<#macro pagination size current link records class="" verbose=false>
    <#if (size<=0 || records==0 )><#return /></#if>
    <#assign pages=(records/size)?ceiling/>
    <#if pages==1 ><#return /></#if>
<#-- pages_per_pager: how many page numbers in one row of pager indicator (pager) -->
    <#assign pages_per_pager=10/>
<#-- current_pager: start from 0 -->
    <#assign current_pager=((current-1)/pages_per_pager)?floor/>
<#-- total_pager: how many pagers in total -->
    <#assign total_pager=pages/pages_per_pager?ceiling/>
    <#assign start_page = (current_pager*pages_per_pager)+1/>
    <#assign end_page = min(start_page+pages_per_pager-1,pages)/>
    <#if verbose>
    <div class="text-muted muted">
        当前${current}/${pages}页，${(current-1)*size+1}~${min((current-1)*size+size,records)}
        /${records}项
    </div>
    </#if>
<ul class="pagination pagination-sm">
    <#if (current==1 || pages<=1)>
        <li class="disabled"><a href="javascript:;">« 上一页</a></li>
    <#else>
        <li><a href="${link?replace("[page]",max(current-1,0)?string)}">« 上一页</a></li>
    </#if>
    <#if current_pager gt 0>
        <li><a href="${link?replace("[page]","1")}">1</a></li>
        <li><span>...</span></li>
    </#if>
    <#list start_page..end_page as page>
        <#if current=page>
            <li class="active"><span>${page}</span></li>
        <#else>
            <li><a href="${link?replace("[page]",page)}">${page}</a></li>
        </#if>
    </#list>
    <#if current_pager<total_pager-1>
        <li><span>...</span></li>
        <li><a href="${link?replace("[page]",pages?string)}">${pages}</a></li>
    </#if>
    <#if (current==pages || pages<=1)>
        <li class="disabled"><span>下一页 »</span></li>
    <#else>
        <li><a href="${link?replace("[page]",min(current+1,pages)?string)}">下一页 »</a></li>
    </#if>
</ul>
</#macro>

<#-- Helper -->
<#--TODO: move to functions.ftl -->
<#function max x y>
    <#if (x<y)><#return y><#else><#return x></#if>
</#function>
<#function min x y>
    <#if (x<y)><#return x><#else><#return y></#if>
</#function>

<#-- Timer refresh -->
<#macro timer id action enabled=false manualRefreshText="手工刷新" defaultInterval="10">
<form id="${id}-timer-form" class="form-inline">
    <input name="interval" type="number" value="${defaultInterval}" class="input-mini"
           style="width:4em" min="5" max="60" step="5"/>
    秒定时刷新
    <a href="#" class="js-timer-toggler btn btn-xs"><i class="fa fa-play"></i></a>
    <a href="#" class="js-manual-refresh btn btn-xs" title="手工刷新"><i
            class="fa fa-refresh"></i> ${manualRefreshText}
    </a>
    <span class="js-timer-indicator fa fa-refresh" style="font-size:smaller"></span>
    <#nested>
</form>
<script type="text/javascript">
    var global_timers;
    if (isBlank(global_timers)) {
        logger.debug("Init global timers");
        global_timers = {};
    }
    function getTimerInterval() {
        return $('#${id}-timer-form [name=interval]').val();
    }
    function getTimerAuto() {
        return $('#${id}-timer-form .js-timer-toggler').data('timer-enabled');
    }
    $(function () {
        var timer = global_timers['${id}'];
        if (isNotBlank(timer)) {
            clearInterval(timer);
        }
        var $form = $('#${id}-timer-form');
        var $timerToggler = $('.js-timer-toggler', $form);

        toggleTimer(${enabled?string});

        <#if Parameters.interval??>
            $('[name=interval]', $form).val("${Parameters.interval}");
        </#if>


        /**
         * Toggle refresh timer
         * @param status (optional) true or false
         */
        function toggleTimer(status) {
            var isEnabled = status;
            if (isBlank(status)) {
                isEnabled = !$timerToggler.data('timer-enabled');
            }
            var text = isEnabled ? "定时刷新已开启" : "定时刷新已关闭";
            var css = isEnabled ? "fa-pause" : "fa-play";
            var icon = '<i class="fa ' + css + '" style="color:green"></i>';
            $timerToggler.data('timer-enabled', isEnabled)
                    .attr("title", isEnabled ? "点击关闭自动刷新" : "点击开启自动刷新")
                    .toggleClass('btn-danger', isEnabled);
            $('i', $timerToggler).alterClass("fa-*", css);
            $('.js-timer-indicator', $form).css('color', isEnabled ? "green" : "gray").attr("title", text);
            if (isEnabled) {
                var seconds = $('[name=interval]', $form).val();
                timer = setInterval(function () {
                    if ($form.length == 0) {
                        clearInterval(timer);
                    } else {
                        ${action};
                    }
                }, seconds * 1000);
                global_timers['${id}'] = timer;
            } else {
                clearInterval(timer);
            }
        }

        $timerToggler.click(function () {
            toggleTimer();
            return false;
        });

        $(".js-manual-refresh", $form).click(function () {
            ${action};
            return false;
        });
    });
</script>
</#macro>

<#macro page id title="" class="">
    <#if title!=""><title>${title}</title></#if>
<div id="${id}" <#if class!="">class="${class}"</#if>>
    <@strutsErrors/>
    <@strutsMessages/>
    <#nested />
    <script type="text/javascript">
        $(function () {
            uiKit.initPage('#${id}');
        });
    </script>
</div>
</#macro>

<#macro portlet id title="" url="" class="" style="" type="">
    <#--<#if type=="box">-->
    <#--<div id="${id}" class="${class}" style="${style}">-->
    <#--</div>-->
    <#--<script type="text/javascript">-->
        <#--$(function () {-->
            <#--$('#${id}').load("${url}");-->
        <#--});-->
    <#--</script>-->
    <#--<#else>-->
    <div id="${id}" class="portlet panel panel-default ${class}" <#if url!="">data-kui-content-url="${url}"</#if> style="${style}">
        <div class="panel-heading"><h3 class="panel-title">${title}</h3></div>
        <div class="panel-body">
            <#nested />
        </div>
    </div>
    <#--</#if>-->
</#macro>

<#macro panel id="" panelClass="panel-default" title="" contentUrl="">
<div id="${id}" class="panel ${panelClass}"
     <#if contentUrl!="">data-kui-content-url="${contentUrl}"</#if>>
    <#if title!="">
        <div class="panel-heading">
            <h3 class="panel-title">${title}</h3>
        </div>
    </#if>
    <div class="panel-body">
        <#nested>
    </div>
</div>
</#macro>

<#macro ajaxNav target id="" class="">
<ul <#if id!="">id="${id}"</#if> class="nav ${class}" data-ajax-nav data-kui-target="${target}">
    <#nested/>
</ul>
</#macro>
<#macro ajaxNavItem href>
<li><a href="${href}" data-toggle="tab"><#nested></a></li>
</#macro>
<#--
================================================================================
PAGES
================================================================================
-->
<#-- Private macro. Display page after save. -->
<#macro _afterSave link id type="">
    <#assign pageId="after-save-${id}"/>
<div id="${pageId}">
    <div class="alert alert-success">
        已保存
        <ul class="list-unstyled">
            <li><a href="${base}/${link}/view?id=${id}" accesskey="v" tabindex="-1"
                   data-ajax-link data-kui-target="#${pageId}">查看 (V)</a></li>
            <li><a href="${base}/${link}/update?id=${id}" accesskey="m" tabindex="-1"
                   data-ajax-link data-kui-target="#${pageId}">修改 (M)</a></li>
            <#if type=="create">
                <li><a href="${base}/${link}/create" accesskey="n" tabindex="-1"
                       data-ajax-link data-kui-target="#${pageId}">创建新的 (N)</a>
                </li>
            </#if>
            <li><a href="#" accesskey="c" tabindex="-1"
                   onclick="closeDialog('#${pageId}')">关闭 (C)</a></li>
        </ul>
    </div>
</div>
</#macro>
<#-- Display page after create -->
<#macro afterCreate link id>
    <@_afterSave link=link id=id type="create"/>
</#macro>
<#-- Display page after update -->
<#macro afterUpdate link id>
    <@_afterSave link=link id=id type="update"/>
</#macro>

<#--
@param level: "info", "success", "error", "danger", "warning", "help"
-->
<#macro alert level icon=true class="" style="" textOnly=false>
    <#assign alertCss={"info":"alert-info","success":"alert-success","error":"alert-danger","danger":"alert-danger","warning":"alert-warning"}/>
<div class="alert ${alertCss[level]} ${class}"
     style="${style};<#if textOnly>background:none;border:0</#if>">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <#if icon>
        <#assign iconMap={'info':'fa-info-circle',"success":"fa-check-circle",'error':'fa-times-circle','danger':'fa-exclamation-circle','warning':'fa-warning'}/>
        <i class="fa ${iconMap[level]!'fa-info-circle'}"></i>
    </#if>
    <#nested />
</div>
</#macro>

<#macro strutsErrors>
    <@s.if test="hasErrors()">
    <ul class="alert alert-danger list-unstyled">
        <#list action.actionErrors as msg>
            <li>${msg}</li>
        </#list>
        <#list action.fieldErrors?values as msg>
            <li>${msg}</li>
        </#list>
    </ul>
    </@s.if>
</#macro>

<#macro strutsMessages style="flash">
    <@s.if test="hasActionMessages()">
        <#if style=="flash">
        <script type="text/javascript">
                <#list action.actionMessages as msg>
                flashMessage("info", '${msg?js_string}', 5);
                </#list>
        </script>
        <#else>
            <@alert level="info" class="list-unstyled" icon=false>
                <#list action.actionMessages as msg>
                <li>${msg}</li>
                </#list>
            </@alert>
        </#if>
    </@s.if>
</#macro>