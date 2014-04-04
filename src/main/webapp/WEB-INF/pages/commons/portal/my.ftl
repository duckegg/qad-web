<#--
********************************************************************************
@desc
@author Leo Liao, 2014/3/27, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="my-portal"/>
<script type="text/javascript" src="${base}/media/text/marked.js"></script>
<@ui.page id=pageId title="My">
<div class="kui-action-at-page-right">
<#--<button class="btn btn-default js-edit-mode js-hide-in-edit-mode">修改布局</button>-->
    <a class="btn btn-info js-add-portlet"
       data-kui-dialog="#${pageId}-new-portlet-dialog"><i class="fa fa-plus"></i> 添加 Portlet
    </a>
</div>
<div class="portlet-container akui-init-disable-sort horizontal" id="${pageId}-portlets"></div>
<div id="${pageId}-new-portlet-dialog" style="display: none">
    <form data-kui-ajax-form
          data-kui-target="#${pageId}">
    <#--<@ui.text label="ID"></@ui.text>-->
        <input type="hidden" name="id"/>
        <@ui.textfield label="标题" name="title" required=true/>
        <@ui.labelControlGroup label="内容类型">
            <label class="radio-inline"><input type="radio" name="contentType"
                                               value="url"/>URL</label>
            <label class="radio-inline"><input type="radio" name="contentType"
                                               value="text"/>Text</label>
        </@ui.labelControlGroup>
        <@ui.textarea label="内容" name="content" class="js-markdown-input" required=true></@ui.textarea>
        <div class="js-markdown-preview well" style="max-height: 8em;overflow-y: scroll"></div>
        <@ui.buttonGroup>
            <button class="btn btn-default" type="reset">取消</button>
            <button class="btn btn-primary" type="submit">保存</button>
        </@ui.buttonGroup>
    </form>
</div>
<script type="text/javascript">
$(function () {
//        var Showdown = require('showdown');
//        var converter = new Showdown.converter({ extensions: ['github', 'table'] });
//        converter.makeHtml('#hello markdown!');
    var $page = $('#${pageId}');
    var $portletContainer = $('.portlet-container', $page);
    var $portletForm = $('form', '#${pageId}-new-portlet-dialog');
    var preview = $('.js-markdown-preview', $portletForm);
    var input = $('.js-markdown-input', $portletForm);
    input.on('keyup', function () {
        markdownPreview();
    });
    var markedOptions = {
        gfm: true,
        pedantic: false,
        sanitize: false,
        tables: true,
        smartLists: true,
        breaks: true
    };

    function markdownPreview() {
//            var html = markdown.toHTML(input.val());
//            var html=converter.makeHtml(input.val());
        var html = marked(input.val(), markedOptions);
        preview.html(html);
    }

    var allPortlets = [];
    loadPortalData(function (portlets) {
        buildPortlets(portlets);
        initEvent($page);
        $portletContainer.kuiPortal();
    });

    function genPortletId() {
        return new Date().getTime();
    }

    function initEvent($page) {
        $page.on('click', '.js-add-portlet', function () {
            var def = {id: genPortletId(), contentType: 'text', content: ''};
            $portletForm.assignValues(def);
        });
        /*.on('click', '.js-edit-mode', function () {
                        editMode = true;
                        setLayout(editMode);
                    }).on('click', '.js-save-edit', function () {
                        editMode = false;
                        setLayout(editMode);
                        savePortalData();
                    }).on('click', '.js-cancel-edit', function () {
                        editMode = false;
                        setLayout(editMode);
                    })*/

        $portletForm.on('submit', function (e) {
            var $form = $(this);
            var def = $form.serializeObject();
            var index = _.findIndex(allPortlets, function (d) {
                return d.id + "" == def.id
            });
            if (index >= 0) {
                allPortlets[index] = def;
            }
            else {
                allPortlets.push(def);
            }
            var $p = buildOnePortlet(def);
            if (index >= 0)
                $p.kuiPortlet("init");
            savePortalData();
            uiKit.closeDialog($form);
            e.preventDefault();
            return false;
        });
    }

    function savePortalData() {
        $.ajax({type: "POST",
            url: "${base}/my/portal/save",
            data: {myPortalJson: JSON.stringify(allPortlets)},
            success: function (xhr) {
            }
        });
    }

    function loadPortalData(afterLoad) {
        $.ajax("${base}/my/portal/data.json",
                {success: function (xhr) {
                    var portalJson = xhr.myPortal;
                    allPortlets = JSON.parse(portalJson) || [];
                    var id = genPortletId();
                    allPortlets = _.forEach(allPortlets, function (p) {
                        if (k$.isBlank(p.id)) {
                            p.id = id++;
                        }
                    });
                    afterLoad(allPortlets);
                }});
    }

    function buildPortlets(portlets) {
        for (var i = 0; i < portlets.length; i++) {
            if (k$.isBlank(portlets[i].id))
                portlets[i].id = i;
            buildOnePortlet(portlets[i]);
        }
    }

    /**
     *
     * Initialize scaffolding layout for a portlet
     * @param portlet portlet definition
     * @returns {*|jQuery|HTMLElement} portlet
     */
    function buildOnePortlet(portlet) {
        var portletId = portlet.id;
        var $p = $('#' + portletId, $page);
        var isExist = $p.length > 0;
        var content = portlet.content;
        var contentType = portlet.contentType || 'text';
        var isUrl = contentType == 'url';
        if (isUrl) {
            content = portlet.content || '';
            if (content.indexOf('/') != 0) {
                content = '${base}/' + content;
            } else {
                content = '${base}' + content;
            }
        } else {
            content = marked(content, markedOptions);
        }
        var heading = '<div class="panel-heading"><h3 class="panel-title" title="ID: ' + portlet.id + '">' + portlet.title + '</h3>' +
                '<div class="btn-group btn-group-xs">' +
                '  <a href="" class="btn btn-default js-edit-portlet" data-kui-dialog="#${pageId}-new-portlet-dialog"><i class="fa fa-pencil"/></a>' +
                '  <button class="btn btn-default js-delete-portlet"><i class="fa fa-trash-o"/></button></div>' +
                '</div>';
        var body = '<div class="panel-body">' + content + '</div>';
        if (!isExist) {
            $p = $('<div class="portlet panel panel-default">' + heading + body + '</div>').appendTo($portletContainer);
        } else {
            //Do not use $p.html(heading+footer) because jqueryUI resizable will add additional elements in it
            $('.panel-heading', $p).replaceWith(heading);
            $('.panel-body', $p).replaceWith(body);
        }
        $p.attr('id', portletId);
        if (isUrl) {
            $p.attr('data-kui-content-url', content);
        }

        $p.on('click.kui', '.js-delete-portlet', function () {
            if (confirm("确定要删除吗？")) {
                var id = $p.attr('id');
                var index = _.findIndex(allPortlets, function (p) {
                    return (p.id + "") == id;
                });
                allPortlets.splice(index, 1);
                $p.remove();
                savePortalData();
            }
        }).on('click.kui', '.js-edit-portlet', function () {
            var id = $p.attr('id');
            var index = _.findIndex(allPortlets, function (p) {
                return (p.id + "") == id;
            });
            $portletForm.assignValues(allPortlets[index]);
            markdownPreview();

        });
        return $p;
    }

//        function setLayout(editMode) {
//            $('.js-show-in-edit-mode', $page).toggle(editMode);
//            $('.js-hide-in-edit-mode', $page).toggle(!editMode);
//        }

    $.fn.serializeObject = function () {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function () {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };
    $.fn.assignValues = function (json) {
        for (var prop in json) {
            var value = json[prop];
            var $elem = $('[name="' + prop + '"]', this);
            var controlType = $elem.prop('type');
            if (controlType == 'radio' || controlType == 'checkbox') {
                $(':' + controlType + '[name=' + prop + '][value=' + value + ']', this).click();
            } else {
                $elem.val(value);
            }
        }
    };
});
</script>
</@ui.page>
