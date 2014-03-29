<#--
********************************************************************************
@desc XML response
@author Leo Liao, 2013/04/16, created
********************************************************************************
-->
<#escape x as x?xml>
<jpost>
    <id>${jpost.id!''}</id>
    <parentId>${jpost.parentId!''}</parentId>
    <title>${jpost.title!''}</title>
    <content>${jpost.content!''}</content>
    <tags>
        <category>${jpost.tagCategory!''}</category>
        <#list jpost.tagLabels as tag>
            <tag>${tag!''}</tag>
        </#list>
    </tags>
</jpost>
</#escape>
