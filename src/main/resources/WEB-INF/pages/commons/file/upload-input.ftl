<#--
********************************************************************************
@desc Upload file result.
@author Leo Liao, 2012/12/17, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<div id="upload-input">
    <div id="upload-input-result"></div>
    <form action="${base}/system/upload" method="POST" enctype="multipart/form-data" class="form-vertical" data-ajax-form data-kui-target="#upload-input">
    <#--<@s.file name="upload" label="选择上传文件" size="40" cssClass="file"/>-->
        <input type="file" name="upload" size="40" value="" id="upload">
        <input type="hidden" name="attach.ownerClass" value="${attach.ownerClass!''}"/>
        <input type="hidden" name="attach.ownerId" value="${attach.ownerId!''}"/>
        <input type="hidden" name="attach.category" value="${attach.category!''}"/>
        <#--<input type="hidden" name="attach.name" value=""/>-->
        <#--<input type="hidden" name="attach.description" value=""/>-->
    <@buttonGroup>
        <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i> 确定上传</button>
        <button type="reset" class="btn btn-default">取消</button>
    </@buttonGroup>
    </form>
</div>