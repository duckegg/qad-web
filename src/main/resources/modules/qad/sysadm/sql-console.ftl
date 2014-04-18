<#--
********************************************************************************
@desc SQL console.
@author Leo Liao, 2012/04/26, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<@ui.page id="sql-console" title="SQL Console">
    <#if (sql!"")=="">
    <div>
        <form action="${base}/admin/devel/sql-console" method="post" class="form-vertical well" data-ajax-form
              data-kui-target="#js-query-result">
            <@ui.textfield label="DB Conn" name="dbConn"/>
            <@ui.textarea id="sql" name="sql" label="SQL" style="width:100%;height:6em;"><#escape x as x?html>${sql!""}</#escape></@ui.textarea>
<@ui.buttonGroup>
            <@ui.button id="submit" label="查询" class="btn btn-primary"/>
        </@ui.buttonGroup>
        </form>
    </div>
    <div id="js-query-result"></div>
    <#elseif dataTable??>
    <h2>Result</h2>
    <table id="sqlConsole" class="table table-bordered table-striped table-condensed">
        <thead>
        <tr>
            <@s.iterator value="dataTable.rows[0].cells" var="cell" status="status">
                <th><@s.property value="#cell.key"/></th>
            </@s.iterator>
        </tr>
        </thead>
        <tbody>
            <@s.iterator value="dataTable.rows" var="row" status="status">
            <tr>
                <@s.iterator value="#row.cells" var="cell">
                    <td class="word-wrap"
                        style="max-width: 10em"><@s.property value="#cell.value"/></td>
                </@s.iterator>
            </tr>
            </@s.iterator>
        </tbody>
    </table>
        <@ui.staticTable tableId="sqlConsole"/>
    </#if>
</@ui.page>