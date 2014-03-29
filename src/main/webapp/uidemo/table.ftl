<#--
********************************************************************************
@desc table display
@author Leo Liao, 2012/06/07, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#include "/library/table-builder.ftl" parse=true/>
<#assign pageId="uidemo-table"/>
<@ui.page id=pageId title="Table Demo">
<h3>Long text table</h3>
<table id="demo-long-text-table" class="table table-condensed">
    <thead>
    <tr>
        <th>#</th>
        <th data-dts-type="ip-address">IP</th>
        <th>Browser</th>
        <th>Platform(s)</th>
        <th>Engine version</th>
        <th>CSS grade</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>1</td>
        <td>10.1.1.1</td>
        <td class="word-wrap">longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong</td>
        <td>Win 95+</td>
        <td class="center"> 4</td>
        <td class="center">X</td>
    </tr>
    <tr>
        <td>1</td>
        <td>10.1.1.22</td>
        <td>Win 95+</td>
        <td class="word-wrap">longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong</td>
        <td class="center"> 4</td>
        <td class="center">X</td>
    </tr>
    <tr>
        <td>1</td>
        <td>10.1.1.10</td>
        <td>Win 95+</td>
        <td class="word-wrap">longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong</td>
        <td class="center"> 4</td>
        <td class="center">X</td>
    </tr>
    <tr>
        <td>1</td>
        <td>10.1.1.11</td>
        <td class="word-wrap">longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong</td>
        <td>Win 95+</td>
        <td class="center"> 4</td>
        <td class="center">
            <div class="btn-group">
                <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                    Action
                    <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                    <!-- dropdown menu links -->
                    <li><a href="">aaa</a> </li>
                    <li><a href="">bbb</a> </li>
                    <li><a href="">ccc</a> </li>
                    <li><a href="">ddd</a> </li>
                    <li><a href="">eee</a> </li>
                    <li><a href="">fff</a> </li>
                    <li><a href="">ggg</a> </li>
                </ul>
            </div>
        </td>
    </tr>
    <tr>
        <td>1</td>
        <td>10.1.1.2</td>
        <td class="word-wrap">longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong</td>
        <td>Win 95+</td>
        <td class="center"> 4</td>
        <td class="center">X</td>
    </tr>
    </tbody>
</table>
<@staticTable tableId="demo-long-text-table" scrollable=true/>

<h3>Table Group</h3>
<script type="text/javascript">
    var columns_demoRowGroupTable = [
        { "mDataProp": "name", "sTitle": "配对名称"},
        {"mDataProp": "serial_number", "sTitle": "ln", sClass: "center", bUseRendered: false,
            fnRender: function (o) {
                var ah = '<a data-dialog '
                        + 'data-dialog-modal="false" data-dialog-resizable="true"'
                        + 'data-dialog-title="[' + o.aData['name'] + ']"'
                        + 'href="${base}/rs6000/chart-pair'
                        + '?sparams[\'name\']=' + o.aData['name']
                        + '">+</a>';
                return ah;
            }
        },
        { "mDataProp": "hmc", "sTitle": "HMC"},
        { "mDataProp": "model", "sTitle": "型号" },
        { "mDataProp": "serial_number", "sTitle": "序列号" },
        { "mDataProp": "location", "sTitle": "位置" },
        { "mDataProp": "used_cpus", "sTitle": "已启用CPU" },
        { "mDataProp": "idle_cpus", "sTitle": "空闲CPU" },
        { "mDataProp": "surplus_cpus", "sTitle": "剩余CPU", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                return showProgressbar(o.aData["surplus_cpus"]);
            }
        },
        { "mDataProp": "used_mem", "sTitle": "已启用内存" },
        { "mDataProp": "idle_mem", "sTitle": "空闲内存" },
        { "mDataProp": "surplus_mem", "sTitle": "剩余内存", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                return showProgressbar(o.aData["surplus_mem"]);
            }
        },
        { "mDataProp": "micro_code_release_version", "sTitle": "微码发行版本" },
        { "mDataProp": "micro_code_mini_version", "sTitle": "微码小版本" },
        { "mDataProp": "server_status", "sTitle": "运行状态" },
        { "mDataProp": "description", "sTitle": "描述" } ,
        { "mDataProp": "id", sTitle: "操作", sClass: "center",
            bUseRendered: false,
            fnRender: function (o) {
                var href = '${base}/pair/edit?id=' + o.aData['id'];
                return '<a data-dialog data-dialog-aftersubmit="refreshTable()" class="btn btn-sm" href="' + href + '"><i class="fa fa-edit"></i></a>';
            }
        }
    ];
</script>

<@ajaxTable tableId="demoRowGroupTable" ajaxUrl="${base}/uidemo/data/table-data.jsp" rowGroup="default"/>
</@ui.page>