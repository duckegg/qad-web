<#-- zhong, hong-wei 2012/11/14 -->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="uidemo-form"/>
<@ui.page id=pageId title="Forms" class="row">
<div class="col-md-6">
    <h3>使用select2（替代chozen）</h3>
    <select placeholder="请选择一项内容" class="select2">
        <option value=""></option>
        <optgroup label="single group 1">
            <option value="option1">single option 1</option>
            <option value="option2">single option 2</option>
            <option value="option3">single option 3</option>
        </optgroup>
        <optgroup label="single group 2">
            <option value="option4">single option 4</option>
            <option value="option5">single option 5</option>
            <option value="option6">single option 6</option>
        </optgroup>
    </select>
    <select placeholder="Please select an option" multiple class="select2">
        <optgroup label="multi group 1">
            <option value="option1">multi option 1</option>
            <option value="option2">multi option 2</option>
            <option value="option3">multi option 3</option>
        </optgroup>
        <optgroup label="multi group 2">
            <option value="option4" selected="selected">
                multi option 4
            </option>
            <option value="option5">multi option 5</option>
            <option value="option6">multi option 6</option>
        </optgroup>
    </select>
</div>
<div class="col-md-6">
</div>
</@ui.page>