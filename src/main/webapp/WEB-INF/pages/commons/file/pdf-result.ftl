<#--
********************************************************************************
@desc Page to display PDF generation result.
@author Leo Liao, 2012/05/28, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
已生成报告：<a href="${base}/download?type=pdf_report&id=${pdfFile.name}&result=file">${pdfFile.name}</a>