<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/5/6, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="help"/>
<#assign markdownToHtml="hpps.qad.base.freemarker.MarkdownToHtmlMethod"?new()/>
<@ui.page id=pageId>
    <#assign markdownContent>
        <#include "${module}/${topic}.md" parse=false/>
    </#assign>
${markdownToHtml(markdownContent)}
<script type="text/javascript">
    $(function(){
        $('#${pageId} pre code').each(function(i, e) {hljs.highlightBlock(e)});
    });
</script>
</@ui.page>
