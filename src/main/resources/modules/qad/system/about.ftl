<#--
********************************************************************************
@desc 
@author Leo Liao, 2014/4/29, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" parse=true/>
<#assign pageId="about"/>
<#assign markdownToHtml="hpps.qad.base.freemarker.MarkdownToHtmlMethod"?new()/>
<@ui.page id=pageId title="ABOUT">
    <#assign markdownContent>
        <#include "/help/qad/about.md" parse=false/>
    </#assign>
${markdownToHtml(markdownContent)}
<script type="text/javascript">
    $(function(){
        $('#${pageId} pre code').each(function(i, e) {hljs.highlightBlock(e)});
    });
</script>
</@ui.page>
