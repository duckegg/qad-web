<#--
********************************************************************************
@desc Upload file result.
@author Leo Liao, 2012/12/17, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<div id="upload-result">
    <ul id="upload-result-filelist">
        <li>
            <a href="${base}/download/attach/${attach.id}" data-pjax-disabled="true">${attach.name} (${attach.fileSize}
                )</a>
        </li>
    </ul>
<#--<button type="reset" onclick="closeDialog(this)">关闭</button>-->
    <script type="text/javascript">
        $(function () {
            closeDialog($('#upload-result'))
        });
    </script>
</div>