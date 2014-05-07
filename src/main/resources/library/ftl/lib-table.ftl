<#---
Freemarker macro to build table with DataTables.
Request parameter "trc" (total record count) to determine if use serverSide
@namespace ui2
@author Leo Liao, 2012/04/22, created
-->

<#---
Build table with AJAX data source. The AJAX source is specified by either `ajaxUrl` or `ajaxForm`.

@param tableId {string} HTML element id of the table
@param ajaxUrl {string} a URL with query string
@param ajaxForm {jQuery|HTMLElement} a form element which is submitted to fetch data
@param serverSide {boolean} If use server side pagination, sort, filter
@param pagination {boolean} If display pagination
@param autoWidth
@param height
@param printable    If display printable buttons (pdf, excel, word). If true, must have a corresponding .print.ftl page.
@param columnFilter If display filter for each column.
-->
<#macro ajaxTable tableId ajaxUrl="" ajaxForm="" serverSide=false autoColumn=false
rowGroup="" rowReordering=false rowIdDataField="" rowReorderOptions=""
filter=true colVis=true columnFilter=false scrollable=true
autoWidth=false printable=false printPid="" height="auto" theme=""
toolbarElement=""
export="pdf,xls,doc"
pagination=true keyboard=false ajaxheader=false>
    <@_buildTable tableId=tableId ajaxUrl=ajaxUrl ajaxForm=ajaxForm serverSide=serverSide autoColumn=autoColumn
    rowGroup=rowGroup rowReordering=rowReordering rowIdDataField=rowIdDataField rowReorderOptions=rowReorderOptions
    filter=filter colVis=colVis columnFilter=columnFilter scrollable=scrollable
    autoWidth=autoWidth printable=printable printPid=printPid height=height theme=theme
    toolbarElement=toolbarElement
    export=export
    pagination=pagination keyboard=keyboard ajaxheader=ajaxheader/>
</#macro>
<#--
********************************************************************************
Build table with existing static HTML table
@param tableId id of exsiting HTML table
********************************************************************************
-->
<#macro staticTable tableId
rowGroup="" rowReordering=false rowIdDataField="" rowReorderOptions=""
filter=true colVis=true columnFilter=false scrollable=true
autoWidth=false printable=false printPid="" height="auto" theme=""
toolbarElement=""
export="pdf,xls,doc"
pagination=true keyboard=false>
    <@_buildTable tableId=tableId useAjax=false
    rowGroup=rowGroup rowReordering=rowReordering rowIdDataField=rowIdDataField rowReorderOptions=rowReorderOptions
    filter=filter colVis=colVis columnFilter=columnFilter scrollable=scrollable
    autoWidth=autoWidth printable=printable printPid=printPid height=height theme=theme
    toolbarElement=toolbarElement
    export=export
    pagination=pagination keyboard=keyboard/>
</#macro>

<#---
Core macro.
@internal
-->
<#macro _buildTable tableId useAjax=true ajaxUrl="" ajaxForm="" serverSide=false autoColumn=false
rowGroup="" rowReordering=false rowIdDataField="" rowReorderOptions=""
filter=true colVis=true columnFilter=false scrollable=true
autoWidth=false pagination=true height="auto" theme=""
toolbarElement=""
export="pdf,xls,doc,json"
printable=false printPid="" keyboard=false ajaxheader=false>
<#-- Determine mandatory parameters -->
    <#if ajaxUrl=="">
        <#if ajaxForm=="">
            <#if useAjax>
            <script type="text/javascript">
                alert("Program Error: Must specify either 'ajaxUrl' or 'ajaxForm'");
            </script>
                <#return/>
            </#if>
        </#if>
    </#if>
<#-- Call mobile builder if in mobile view -->
    <#if (mobileView!false) == true>
        <@_buildMobileTable tableId=tableId ajaxForm=ajaxForm ajaxUrl=ajaxUrl/>
        <#return />
    </#if>
<#-- Determine if use server side -->
    <#assign _serverSide=serverSide/>
    <#assign totalRecord = -1/>
    <#if serverSide == false>
        <#if Parameters??>
            <#if Parameters.trc??>
            <#--TODO: convert string to number -->
                <#assign totalRecord=Parameters.trc?replace(",","")?number/>
                <#if (totalRecord > 5000)>
                    <#assign _serverSide=true/>
                </#if>
            </#if>
        </#if>
    </#if>
<#-- Determine if use KeyTable -->
    <#assign bKeyTable = keyboard && (!_serverSide && (rowGroup==""))/>
    <#if useAjax>
    <#-- Generate table wrapper -->
    <table id="${tableId}" class="table table-condensed ${theme}" _tabindex="1"
           _accesskey="t"></table>
    </#if>
<script type="text/javascript">
<#-- Init global variables -->
$(function () {
    var $table = $('#${tableId}');
    var columnDefs = kui.getTableColumns('${tableId}') || [];
//    console.debug("columns", columnDefs);
    <#if useAjax>
        <#if columnFilter>
        <#--##### Dynamically generate tfoot #####-->
        <#-- tfoot must be generated before table, otherwise the input elements will not be well aligned -->
            $table.append("<tfoot><tr></tr></tfoot>");
            for (var i in columnDefs) {
                $('tfoot tr', $table).append('<th><input type="text" class="search_init"/></th>');
            }
        </#if>
    </#if>
    var columns = [];
    <#if useAjax>
        columns = columnDefs;
    <#else>
        $('thead tr:last-child th', $table).each(function (idx, item) {
            var type = $(this).data('dts-type');
            columns.push(type == null ? null : {"sType": type});
        });
    </#if>
    var asInitVals = [];
    var $toolbarElement = null;
    <#if toolbarElement!="">
        $toolbarElement = $('${toolbarElement}');
        if ($toolbarElement.length > 0)
            $toolbarElement.hide();
    </#if>
<#--=====================================================================-->
<#-- Create table -->
<#--=====================================================================-->
    var $ajaxForm = $('${ajaxForm}');
    var oSettings = {
    <#--###### UI Style and Layout ######-->
        "bJQueryUI": false,
    <#-- t=table, T=TableTools, l=length; f=filter; i=info; p=pagination; r=processing; H=jQueryUI header; F=jQueryUI footer; R=ColResizer; C=ColVis -->
        "sDom": '<"dataTables_header"<"dataTables_toolbar">r<"dataTables_controls"R<#if colVis>C</#if>T><#if filter>f</#if>>t<"dataTables_footer row"<"col-md-6"li><"col-md-6"p>><"clearfix">',
        "sPaginationType": "full_numbers",
    <#--###### General Settings ######-->
        "bPaginate":${pagination?string},
        "bProcessing": true,
        "bStateSave": true,
        "fnCreatedRow": function (nRow, aData, iDataIndex) {
            <#if rowIdDataField!="">
                $(nRow).attr('id', aData['${rowIdDataField}']);
            <#else>
                $(nRow).attr('id', iDataIndex);
            </#if>
            $(nRow).attr('data-position', iDataIndex);
        },
        "fnStateSave": function (oSettings, oData) {
            var aParts = window.location.pathname.split('/');
            var sName = oSettings.sCookiePrefix + oSettings.sInstance;
            var sNameEQ = sName + '_' + aParts[aParts.length - 1].replace(/[\/:]/g, "").toLowerCase();
            localStorage.setItem(sNameEQ, JSON.stringify(oData));
        },
        "fnStateLoad": function (oSettings) {
            var aParts = window.location.pathname.split('/');
            var sName = oSettings.sCookiePrefix + oSettings.sInstance;
            var sNameEQ = sName + '_' + aParts[aParts.length - 1].replace(/[\/:]/g, "").toLowerCase();
            return JSON.parse(localStorage.getItem(sNameEQ));
        },
        "iCookieDuration": 60 * 60 * 24 * 30, // 30 days
        // If bDeferRender is true, KeyTable will occur error "Cannot call method 'getElementsByTagName' of null"
        // when focus is not in firt page initially
        // "bDeferRender":true,
        "bAutoWidth":${autoWidth?string},
        "oLanguage": {"sUrl": "${base}/media/datatables/lang/zh_CN.txt"},

    <#--###### Columns Setup ######-->
        "aoColumns": columns,
        <#if useAjax>
        <#--###### Ajax Call ######-->
            "bServerSide":${_serverSide?string},
        "sAjaxSource":<#if ajaxForm!="">$ajaxForm.attr('action')<#else>"${ajaxUrl}"</#if>,
        "sServerMethod":<#if ajaxForm!="">$ajaxForm.attr('method')<#else>'GET'</#if>,
            <#if ajaxForm!="">
                "fnServerParams": function (aoData) {
                    var fields = $ajaxForm.serializeArray();
                    jQuery.each(fields, function (i, field) {
                        aoData.push(field);
                    });
                },
            </#if>
            "sAjaxDataProp": "aaData",
        </#if>
    <#--###### Scroll ######-->
        <#if scrollable>
            "sScrollY": "${height}",
        <#-- Use sScrollX to prevent column width change after sorting -->
            "sScrollX": "100%",
//        "sScrollXInner": "100%",
        </#if>
        "bScrollCollapse": true,
    <#--###### ColVis Extras ######-->
        <#if colVis==true>
            "oColVis": {
                "sAlign": "left", "buttonText": '<span class="btn btn-default btn-xs" title="选择显示列"><i class="icon fa fa-columns"></i></span>', "bRestore": true, "sRestore": "Reset"
            },
        </#if>
        "fnInitComplete": function () {
            <#if useAjax>
                theTable.fnSetFilteringDelay(400);
            </#if>
            $('.dataTables_filter input').addClass('form-control');
            var $tableWrapper = $("#${tableId}_wrapper");
            <#if ajaxheader>

                var $tablehead;
                if ($tableWrapper) {
                    $tablehead = $("#" + "${tableId}_wrapper" + " .dataTables_scrollHeadInner table thead");
                } else {
                    $tablehead = $(".dataTables_scrollHeadInner table thead");
                }


                if (columns_header != null && columns_header != undefined && columns_header != "") {
                    $tablehead.prepend(columns_header);
//                    console.info($tablehead);
                }
            </#if>

        <#-- Custom toolbar -->
            if ($toolbarElement != null && $toolbarElement.length > 0) {
                var $toolbar = $('.dataTables_toolbar', $tableWrapper);
                $toolbarElement.appendTo($toolbar).show();
            }
            $tableWrapper.addClass("${theme}");
            <#if rowGroup!="" >
                theTable.rowGrouping({
                    bCollapseAllGroup:${rowGroup?contains("collapseAll")?string},
                    bExpandableGrouping: true,
                    bSetGroupingClassOnTR: true
                });
            </#if>
        <#-- Export -->
            <#if printable>
                $('a[data-toggle="export"]').on('click', function (e) {
                    exportData($(this).data('type'));
                    e.preventDefault();
                });
            </#if>
        <#-- Rowreordering -->
            <#if rowReordering>
                theTable.rowReordering(${rowReorderOptions});
            </#if>
        <#-- Enhance filter -->
            var $filter = $("div.dataTables_filter input", $tableWrapper);
            $filter.attr('accesskey', 'q');
            $filter.bind('keyup', function (e) {
            <#-- Use ESC to clear filter box and return to table -->
                if (e.keyCode == 27) {
                    if ($(this).val() != "") {
                        $(this).val("");
                        theTable.fnFilter(this.value);
                    } else {
                        $(this).val("");
                    }
                    $(this).blur();
                }
            });
        <#-- Press enter in table to put cursor in cell[0,0]. Useful for keyboard only user. -->
            $table.keypress(function (event) {
                <#if bKeyTable>
                    if (event.which == 13) {
                        keys.fnSetPosition(0, 0);
                    }
                </#if>
            });
            <#if useAjax>
            <#-- Determine if total records of input equals actual -->
                <#if (totalRecord>=0)>
                    if (theTable.fnSettings().fnRecordsTotal() != ${totalRecord}) {
                        flashMessage("warn", "汇总和明细记录数不一致，可能是数据有错误，请通知管理员");
                    } else {
                        flashMessage();
                    }
                </#if>
            </#if>
        <#--###### Restore state save for individual column filter ######-->
            <#if columnFilter>
                var oSettings = theTable.fnSettings();
                for (var i = 0; i < oSettings.aoPreSearchCols.length; i++) {
                    if (oSettings.aoPreSearchCols[i].sSearch.length > 0) {
                        $("tfoot input")[i].value = oSettings.aoPreSearchCols[i].sSearch;
                        $("tfoot input")[i].className = "";
                    }
                }
            </#if>
//            $('.dataTables_scrollBody', $tableWrapper).addClass('fancyscroller');
        },
    <#--###### TableTools Extras ######-->
        "oTableTools": {
        <#--"aButtons": [<#if printable>{"sExtends": "text", "sButtonText": printTool}</#if>]-->
        <#--http://www.datatables.net/release-datatables/extras/TableTools/bootstrap.html-->
        <#--"sSwfPath": "${base}/media/datatables/swf/copy_cvs_xls_pdf.swf",-->
            "aButtons": [<#if printable>
                {
                    "sExtends": "collection",
                    "sButtonText": '<i class="fa fa-share" title="导出"></i>',
                    "aButtons": [
                        <#if export?contains("pdf")>
                            {
                                "sExtends": "text",
                                "sButtonText": '<i class="icomoon-file-pdf"></i> 导出PDF',
                                "fnClick": function (nnButton, oConfig, oFlash) {
                                    exportData('pdf');
                                }
                            },
                        </#if>
                        <#if export?contains("xls")>
                            {
                                "sExtends": "text",
                                "sButtonText": '<i class="icomoon-file-excel"></i> 导出Excel(2003+)',
                                "fnClick": function (nnButton, oConfig, oFlash) {
                                    exportData('excel');
                                }
                            },
                        </#if>
                        <#if export?contains("doc")>
                            {
                                "sExtends": "text",
                                "sButtonText": '<i class="icomoon-file-word"></i> 导出Word(2003+)',
                                "fnClick": function (nnButton, oConfig, oFlash) {
                                    exportData('word');
                                }
                            },
                        </#if>
                        <#if export?contains("json")>
                            {
                                "sExtends": "text",
                                "sButtonText": '<i class="fa fa-code"></i> 导出JSON',
                                "fnClick": function (nnButton, oConfig, oFlash) {
                                    exportData('json');
                                }
                            },
                        </#if>
                        {
                            "sExtends": "text",
                            "sButtonText": '<i class="fa fa-print"></i> 导出HTML',
                            "fnClick": function (nnButton, oConfig, oFlash) {
                                exportData('html');
                            }
                        }
                    ]
                }

            </#if>
            ]
        }
    };


    var theTable = $table.dataTable(oSettings); // End of datatable creation
//    console.debug(theTable);
    <#--kao.oTables['${tableId}'] = theTable;-->
    kui.setDataTable('${tableId}',theTable);

//    // Set the classes that TableTools uses to something suitable for Bootstrap
//    $.extend( true, $.fn.DataTable.TableTools.classes, {
//        "container": "btn-group",
//        "buttons": {
//            "normal": "btn btn-default",
//            "disabled": "btn disabled"
//        },
//        "collection": {
//            "container": "DTTT_dropdown dropdown-menu",
//            "buttons": {
//                "normal": "",
//                "disabled": "disabled"
//            }
//        }
//    } );
//
//// Have the collection use a bootstrap compatible dropdown
//    $.extend( true, $.fn.DataTable.TableTools.DEFAULTS.oTags, {
//        "collection": {
//            "container": "ul",
//            "button": "li",
//            "liner": "a"
//        }
//    } );

<#--=====================================================================-->
<#-- Post table creation -->
<#--=====================================================================-->

<#--###### KeyTable, not work for server-side ######-->
    <#if bKeyTable>
        var keys = new KeyTable({
            "table": document.getElementById('${tableId}'),
            "datatable": theTable,
//            "focus": [ 0, 0 ],
            "tabIndex": 100
        });
        /* Apply a return key event to each cell in the table */
        keys.event.action(null, null, function (nCell) {
            var td = keys.fnGetCurrentTD();
            $(td).find('a, input[type=checkbox]').first().trigger('click');
        });
        keys.event.esc(null, null, function (nCell) {
            var td = keys.fnGetCurrentTD();
            $(td).focus();
        });
    </#if>
<#--###### Individual Column Filters ######-->
    <#if columnFilter>
        var $tableWrapper = $("#{tableId}_wrapper");
        $("tfoot input", $tableWrapper).keyup(function () {
            theTable.fnFilter(this.value, $("tfoot input").index(this));
        }).each(function (i) {
            asInitVals[i] = this.value;
        }).focus(function () {
            if (this.className == "search_init") {
                this.className = "";
                this.value = "";
            }
        }).blur(function (i) {
            if (this.value == "") {
                this.className = "search_init";
                this.value = asInitVals[$("tfoot input").index(this)];
            }
        });
    </#if>
<#--=====================================================================-->
<#-- Print Action -->
<#--=====================================================================-->
    <#if printable>
        <#if printPid=="">
        <#--Use old style export -->
            function exportData(output) {
                var action, printAction;
                var $ajaxForm = $('${ajaxForm}');
                <#if ajaxForm!="">
                    action = $ajaxForm.attr('action');
                <#else>
                    action = '${ajaxUrl}';
                </#if>
                printAction = action.replace('tabledata', 'print');
                printAction = $.param.querystring(printAction, "&pid=${pid}&outputFormat=" + output<#if ajaxForm!=''> + "&"+ $ajaxForm.serialize()</#if>, 0);
//                window.open(printAction);
                var $ajaxForm = $('${ajaxForm}');
                var url = $.param.querystring("${base}/query/export/" + output, "pid=${pid}" <#if ajaxForm!=''> + "&"+ $ajaxForm.serialize()</#if>, 0);
                window.open(url);
            }
        <#else>
            function exportData(exportFormat) {
                var $ajaxForm = $('${ajaxForm}');
                var url = $.param.querystring("${base}/query/export/" + exportFormat, "pid=${printPid}" <#if ajaxForm!=''> + "&"+ $ajaxForm.serialize()</#if>, 0);
                window.open(url);
            }
        </#if>
    </#if>
});
</script>
</#macro>

<#macro _buildMobileTable tableId ajaxForm="" ajaxUrl="">
<ul id="${tableId}" data-role="listview" data-filter="true">
    <li data-role="list-divider"><span class="columns"></span><span class="ui-li-count"></span></li>
</ul>
<script type="text/javascript">
    $(function () {
        var $list = $('#${tableId}');
        var $divider = $('[data-role="list-divider"]', $list);
        var columns = kui.getTableColumns('${tableId}');

        var html = "";
        for (var i in columns) {
            html += '<span class="column">' + columns[i].sTitle + '</span>';
        }
        $('.columns', $divider).html(html);
    var url = <#if ajaxForm!="">$('${ajaxForm}').attr('action')<#else>"${ajaxUrl}"</#if>;
    var method = <#if ajaxForm!="">$('${ajaxForm}').attr('method')<#else>'GET'</#if>;
        var data = {};
        <#if ajaxForm!="">
            var fields = $('${ajaxForm}').serializeArray();
            jQuery.each(fields, function (i, field) {
                data[field.name] = field.value;
            });
        </#if>
        $.ajax(url, {data: data,
            success: function (data, status, xhr) {
                $('.ui-li-count', $list).html(data.aaData.length);
                $.each(data.aaData, function (index, item) {
                    var line = '';
                    for (var i in columns) {
                        line += '<span class="column">' + item[columns[i].mDataProp] + '</span>'
                    }
                    $list.append('<li>' + line + '</li>')
                });
                $list.listview('refresh');
            }
        });
    });
</script>
</#macro>

<#--
********************************************************************************
Do AJAX query and build table
@param tableId     table id
@param qid         id of querydef
********************************************************************************
-->
<#macro ajaxQueryAndTable tableId qid class="" printable=false printPid="" serverSide=false export="doc,xls,pdf,html,json">
    <#assign _formId="${tableId}-qform"/>
<div class="${class} hidden">
    <h3>精确查询</h3>

    <div>
        <form id="${_formId}" action="${base}/query/json/table" method="post"
              onsubmit="kui.refreshDataTable('${tableId}');return false;"
              class="form-inline">
            <input type="hidden" name="qid" value="${qid}"/>
            <button type="submit" class="btn btn-default">刷新</button>
            <#nested/>
        </form>
    </div>
</div>
    <@ajaxTable tableId=tableId ajaxForm="#${_formId}" printable=printable printPid=printPid serverSide=serverSide export=export/>
</#macro>

<#--
********************************************************************************
Build static table with data from {@link DataTable}
@param tableId     table id
@param dataTable   string, name of object DataTable which can be found in the context
********************************************************************************
-->
<#macro simpleStaticTable tableId dataTable>
<table id="${tableId}" class="table table-bordered table-striped table-condensed">
    <thead>
    <tr>
        <@s.iterator value="${dataTable}.rows[0].cells" var="cell" status="status">
            <th><@s.property value="#cell.key"/></th>
        </@s.iterator>
    </tr>
    </thead>
    <tbody>
        <@s.iterator value="${dataTable}.rows" var="row" status="status">
        <tr>
            <@s.iterator value="#row.cells" var="cell">
                <td class="word-wrap"
                    style="max-width: 10em"><@s.property value="#cell.value"/></td>
            </@s.iterator>
        </tr>
        </@s.iterator>
    </tbody>
</table>
    <@ui.staticTable tableId=tableId/>
</#macro>