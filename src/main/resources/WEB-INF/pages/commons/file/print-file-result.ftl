<#--
********************************************************************************
@desc Page to display PDF generation result.
@author Leo Liao, 2012/05/28, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<@ui.page id="export-file-result">
<div class="text-center alert alert-success">
    <h4>数据导出成功</h4>
    <a href="${base}/system/download?downloadDir=${outputDir!''}&id=${displayFilename}"
       data-pjax-disabled>${displayFilename}</a>
</div>
</@ui.page>