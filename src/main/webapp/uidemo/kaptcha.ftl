<#-- zhong, hong-wei 2012/11/14 -->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/ui-builder.ftl" parse=true/>
<#assign pageId="kaptcha"/>

<@ui.page id=pageId title="captcha demo">
<div id="captcha-demo">
<form id="captchaForm" action="/democode/verify?actionResult=json" class="form-horizontal" data-ajax-form data-kui-target="#js-show-panel">
    <div class="form-group">
        <label class="control-label">验证码:</label>
        <div class="controls">
            <input type="text" id="kpatcha" name="kpatcha" value="" style="width: 91px;"/>
            <img id="captcha" src="/kaptcha" style="cursor: pointer; width: 105px; height: 30px;"/>
        </div>
    </div>
    <div class="form-group">
        <div class="controls">
        <@s.actionerror/>
        </div>
    </div>
    <div class="form-group">
        <div class="controls">
        <@s.actionmessage/>
        </div>
    </div>
    <@buttonGroup>
        <button type="submit" class="btn btn-primary">提交</button>
    </@buttonGroup>
</form>

<script type="text/javascript">
    function refresh() {
        $("#captcha").attr("src", "/kaptcha?time=" + new Date().getTime());
    }

    $(function() {
        $("#captchaForm").kuiAjaxForm({
            success:function(xhr) {
                $("#kpatcha").val("");
                $("#kpatcha").focus();
                refresh();
            }
        });

        $("#captcha").click(function() {
            refresh();
        });
    });
</script>
</div>
</@ui.page>