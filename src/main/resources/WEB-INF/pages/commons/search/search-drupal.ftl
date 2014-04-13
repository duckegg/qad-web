<#--
********************************************************************************
@desc search home
@author Leo Liao, 13-12-19, created
********************************************************************************
-->
<#include "/library/ftl/taglibs.ftl" />
<#assign pageId="search-drupal"/>
<@ui.page id=pageId>
<h1 class="page-title">搜索Drupal</h1>
<div id='embedded_search'></div>
<script type="text/javascript">
    (function ($) {
        // make the ajax request
        $.getJSON("http://localhost:8000/drupal/external-search.js?jsoncallback=?",function(data){
            // append the form to the container
            $('#embedded_search').append(data);
        }
        );
    })(jQuery);
</script>
</@ui.page>
