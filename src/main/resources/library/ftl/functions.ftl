<#--
********************************************************************************
@desc Freemarker utility functions.
@author Leo Liao, 2012/06/04, created
********************************************************************************
-->
<#--
================================================================================
Calculate time by offset
================================================================================
-->
<#--Todo: Vic modified it, I added second, minute and hour-->
<#function timeOffset time offset unit="day" format="yyyy-MM-dd">
    <#if offset==0>
        <#return time?string(format)/>
    <#else>
        <#assign offset_sec=0/>
        <#if unit=="day">
            <#assign offset_sec=offset*24*60*60/>
        <#elseif unit=="second">
            <#assign offset_sec=offset/>
        <#elseif unit=="minute">
            <#assign offset_sec=offset*60/>
        <#elseif unit=="hour">
            <#assign offset_sec=offset*60*60/>
        <#elseif unit=="week">
            <#assign offset_sec=offset*7*24*60*60/>
        <#elseif unit=="month">
            <#assign offset_sec=offset*30*24*60*60/>
        <#elseif unit=="year">
            <#assign offset_sec=offset*365*30*24*60*60/>
        </#if>
        <#return (time?long+offset_sec*1000)?number_to_date?string(format)/>
    </#if>
</#function>
<#--
================================================================================
Calculate time by name
================================================================================
-->
<#function calcTime name>
    <#if name="year_begin">
        <#return .now?string("yyyy")+"-01-01"/>
    <#elseif name="year_end">
        <#return .now?string("yyyy")+"-12-31"/>
    </#if>
</#function>
<#--
================================================================================
Human friendly date time. Not Work.
================================================================================
-->
<#function prettyTime time>
    <@__deprecated/>
<#--<#assign offset=(time?date?long-(.now)?long)/>-->
<#--<#assign pt = "org.ocpsoft.pretty.time.PrettyTime"?new()>-->
<#--<#assign pt = new("org.ocpsoft.pretty.time.PrettyTime")/>-->
<#--<#return pt.format(time)/>-->
<#--<#if offset<1000*60*4 && (offset>=0)>-->
<#--<#return "马上"/>-->
<#--</#if>-->
<#--<#if offset<0 && (offset>=-1000*60*4)>-->
<#--<#return "刚刚"/>-->
<#--</#if>-->
<#--<#if offset<1000*60*24>-->
<#--<#return "今天"/>-->
<#--</#if>-->
<#--<#if offset<1000*60*24>-->
<#--<#return "今天"/>-->
<#--</#if>-->
    <#return time?date?iso_utc/>
</#function>

<#--
================================================================================
Shorthand for if else assignment
================================================================================
-->
<#function iif condition resultTrue resultFalse>
    <#if condition==true>
        <#return resultTrue>
    <#else>
        <#return resultFalse>
    </#if>
</#function>

<#--
================================================================================
HTML format
================================================================================
-->
<#function cleanHtml source>
    <#if source??>
        <#return source?replace("\n","<p></p>")?replace("<script","&lt;script","i")?replace("script>","script&gt;","i")/>
    <#else>
        <#return ""/>
    </#if>
</#function>

<#--
================================================================================
Convert collection to array represented by string
================================================================================
-->
<#function colToArrayString collection>
    <@__deprecated/>
    <#assign output="["/>
    <#list collection as item>
        <#assign output=output+'"${item}"'+iif(item_has_next,",","")/>
    </#list>
    <#assign output=output+']'/>
    <#return output/>
</#function>

<#function colToString collection>
    <@__deprecated/>
    <#assign output=""/>
    <#list collection as item>
        <#assign output=output+item+iif(item_has_next,",","")/>
    </#list>
    <#return output/>
</#function>

<#macro userAvatar avatarFile cssClass="">
    <#--<#if avatarFile=="">-->
        <#--<#assign avatarFile=user.avatar!""/>-->
    <#--</#if>-->
    <#if avatarFile?? && avatarFile!="">
    <img src="${base}/user/avatar?avid=${avatarFile}" class="${cssClass}"/>
    <#else>
    <img src="${base}/media/app/images/avatar.png" class="${cssClass}"/>
    </#if>
</#macro>

<#macro __deprecated>
    <div class="alert alert-warning">DEPRECATED</div>
</#macro>