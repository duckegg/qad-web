<#--
********************************************************************************
@desc bulletin news ticker
@author Leo Liao, 2012/08/31, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<@s.action name="jpost/${postType}/list" namespace="/" var="postListAction" rethrowException=true>
    <@s.param name="so.sort">createdAt</@s.param>
</@s.action>
<div id="jpost-newsticker" class="newsticker-body">
    <span style="float:left"><a href="${base}/jpost/${postType}/list" style="font-weight: bold;color:#888">NEWS</a></span>

    <div class="newsticker-body-text">
        <ul style="margin-bottom: 0">
        <#list postListAction.jposts as jpost>
            <li><a href="${base}/jpost/${postType}/view?id=${jpost.id}"
                   data-dialog data-dialog-resizable="true" data-dialog-modal="false"
                   tabindex="-1">${jpost.title!''}</a></li>
        </#list>
        </ul>
    </div>
    <div class="newsticker-body-controls">
        <a href="#" data-slide="prev" title="前一条"><i class="fa fa-chevron-left"></i></a>
        <a href="#" data-slide="next" title="后一条"><i class="fa fa-chevron-right"></i></a>
    </div>
</div>
<div class="newsticker-controls">
    <a class="nc-refresh" href="#" data-action="refresh" title="刷新"><i class="fa fa-refresh"></i></a>
    <a class="nc-show" href="#" data-toggle="show" title="显示" style="display: none"><i
            class="fa fa-eye-open"></i></a>
    <a class="nc-hide" href="#" data-toggle="hide" title="隐藏"><i class="fa fa-eye-close"></i></a>
</div>
<script type="text/javascript">
    $(function () {
        function toggleNewsTicker(isShow) {
            var $ticker = $('#newsticker');
            $ticker.find('.newsticker-body').toggle(isShow);
            $ticker.find('.nc-show').toggle(!isShow);
            $ticker.find('.nc-hide').toggle(isShow);
            $ticker.find('.nc-refresh').toggle(isShow);
            $ticker.css('width', (isShow ? 600 : 25) + 'px');
        }

        $('#newsticker').on('click', '.nc-refresh',function (event) {
            var $ticker = $(event.delegateTarget);
            $ticker.find('.newsticker-body-text ul').html("正在刷新...");
            $ticker.load('${base}/jpost/${postType}/newsticker');
            return false;
        }).on('click', '[data-toggle]', function () {
                    toggleNewsTicker($(this).data('toggle') === 'show');
                });
//        toggleNewsTicker(false);
        $('#newsticker').find('.newsticker-body-text ul').carouFredSel({
            direction: 'up',
            scroll: {
                items: 1,
                easing: 'swing',
                pauseOnHover: true
            },
            items: 1,
            prev: $('#newsticker [data-slide="prev"]'),
            next: $('#newsticker [data-slide="next"]')
        });
    });
</script>