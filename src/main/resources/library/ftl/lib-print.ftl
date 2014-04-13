<#--
********************************************************************************
@desc Freemarker macro to build printable report
@author Leo Liao, 2012/05/22, created
@author Leo Liao, 2014/03/10, rename print to xhtml to make more sense
********************************************************************************
-->
<#assign docInfo=dataModel.docInfo!{}/>
<#assign dataTable=dataModel.dataTable!{"rows":[]}/>
<#assign params=dataModel.sparams!{}/>

<#macro xhtml title columns>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <@xhtml_head title=title/>
    <@xhtml_body>
    <@xhtml_body_header title=title />
    <@xhtml_body_summary />
    <#nested />
    <@xhtml_data_table columns=columns />
    <@xhtml_body_footer />
</@xhtml_body>
</html>
</#macro>

<#macro xhtml_body>
<body>
    <#nested/>
</body>
</#macro>

<#macro xhtml_data_table columns>
<h2>详细信息</h2>
<table class="print">
    <thead>
    <tr>
        <#list columns?split(",") as colPair>
            <th class="${colPair_index/2}">${colPair?trim?substring(colPair?trim?index_of("=")+1)}</th>
        </#list>
    </tr>
    </thead>
    <tbody>
        <#list dataTable.rows as row>
        <tr>
            <#list columns?split(",") as colPair2>
                <#assign colName=colPair2?trim?substring(0,colPair2?trim?index_of("="))/>
                <td><#if row.cells[colName]??>${row.cells[colName]?xhtml}</#if></td>
            </#list>
        </tr>
        </#list>
    </tbody>
</table>
</#macro>

<#macro xhtml_body_header title>
<h1 style="display:inline-block">${title}</h1>
<#-- Image path shall be relative to report base dir "/" -->
<div style="float:right;display: inline-block"><img src="media/images/report-logo.png"/></div>
<div style="clear:both"/>
</#macro>

<#macro xhtml_body_footer>
<div class="footer"></div>
</#macro>

<#macro xhtml_head title>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <style type="text/css">
        body {
            font-family: "Microsoft YaHei", Arial;
            font-size: 12px;
        }

        .clearfix {
            clear: both;
        }

        strong {
            font-weight: bold;
        }

        h2 {
            color: #808080;
        }

        div.header {
            padding: 5px;
            border-top: 1px solid #ccc;
            border-bottom: 1px solid #ccc;
            line-height: 150%;
        }

        table {
            width: 100%;
            border: 1px solid #ccc;
        }

        table {
            border-collapse: collapse;
        }

        table td, table th {
            border: 1px solid #ccc;
            padding: 4px;
            word-wrap: break-word;
        }

        table thead {
            background-color: #eee;
        }

        table.no-border {
            border: 0;
        }

        table.no-border td,
        table.no-border th {
            border: 0;
        }

        thead th {
            text-align: center;
        }

        div.footer {
            margin-top: 10px;
        }

        .metadata {
            text-align: right;
        }

        .section .section-title {
            border-bottom: 1px solid #CCC;
            margin: 1em 0;
        }

        .section .section-content {
            padding-left: 2em;
        }

        .dl-horizontal dt {
            display: block;
            float: left;
            clear: left;
            text-align: right;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            width: 6em;
            margin-right: 1em;
            line-height: 200%;
            font-weight: bold;
        }

        .dl-horizontal dd {
            margin-left: 0;
            display: block;
            float: left;
            clear: right;
        }
    </style>
    <title>${title}</title>
</head>
</#macro>

<#--====== Report doc info ======-->
<#macro xhtml_body_summary>
<div class="header">
    <div>
        <div><#if docInfo.comment??>${docInfo.comment?xhtml?replace("\n","<br/>")?replace(" ","&nbsp;")}</#if></div>
        <div class="metadata">
            <#if docInfo.session??><span
                    class="username">${docInfo.session['userFullName']!""}</span></#if>
            @<span class="time">${.now?iso("GMT+8")}</span>
        </div>
    </div>
</div>
<h2>报告范围：
    <#assign cnt=0/>
    <#list params?keys as key>
        <#if params[key]!="">${key}=${params[key]},
            <#assign cnt=cnt+1/>
        </#if>
    </#list>
    <#if cnt ==0>
        所有记录
    </#if>
</h2>
</#macro>