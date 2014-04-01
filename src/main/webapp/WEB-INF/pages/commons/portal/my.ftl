
<#--
********************************************************************************
@desc
@author Leo Liao, 2014/3/27, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>
<#assign pageId="my-portal"/>
<@ui.page id=pageId title="My">
<div class="clearfix text-right">
    <button class="btn btn-default js-edit-mode js-hide-in-edit-mode">修改布局</button>
    <a class="btn btn-info js-add-portlet js-show-in-edit-mode"
       data-kui-dialog="#${pageId}-new-portlet-dialog"><i class="fa fa-plus"></i> 添加 Portlet
    </a>
    <button class="btn btn-default js-cancel-edit js-show-in-edit-mode"><i class="fa fa-times"></i>
        取消
    </button>
    <button class="btn btn-primary js-save-edit js-show-in-edit-mode"><i class="fa fa-check"></i> 保存
    </button>
</div>
<div class="portlet-container akui-init-disable-sort horizontal" id="${pageId}-portlets"></div>
<div id="${pageId}-new-portlet-dialog" style="display: none">
    <form data-kui-ajax-form
          data-kui-target="#${pageId}">
        <@ui.textfield label="ID" name="id" readonly=true/>
        <@ui.textfield label="标题" name="title"/>
        <@ui.textfield label="URL" name="url"/>
        <@ui.buttonGroup>
            <button class="btn btn-default" type="reset">取消</button>
            <button class="btn btn-primary" type="submit">保存</button>
        </@ui.buttonGroup>
    </form>
</div>
<script type="text/javascript">
    $(function () {
        var STORAGE_KEY = "myPortal.data";
        var $page = $('#${pageId}');
        var $portletContainer = $('.portlet-container', $page);
        var $portletForm = $('form', '#${pageId}-new-portlet-dialog');
        var editMode = false;
        setLayout(editMode);
        var allPortlets = [];
        loadPortalData(function (portlets) {
            buildPortlets(portlets);
            initEvent($page);
        });

        function genPortletId() {
            return new Date().getTime();
        }

        function initEvent($page) {
            $page.on('click', '.js-edit-mode', function () {
                editMode = true;
                setLayout(editMode);
            }).on('click', '.js-save-edit', function () {
                editMode = false;
                setLayout(editMode);
                savePortalData();
            }).on('click', '.js-cancel-edit', function () {
                editMode = false;
                setLayout(editMode);
            }).on('click', '.js-add-portlet', function () {
                var def = {id: genPortletId()};
                $portletForm.assignValues(def);
            });

            $portletForm.on('submit', function (e) {
                var $form = $(this);
                var def = $form.serializeObject();
                var index = _.findIndex(allPortlets, function (d) {
                    return d.id == def.id
                });
                if (index >= 0) {
                    allPortlets[index] = def;
                }
                else {
                    allPortlets.push(def);
                }
                savePortalData();
                buildOnePortlet(def);
                closeDialog($form);
                e.preventDefault();
//                e.stopPropagation();
                return false;
            });
        }

        function savePortalData() {
//            console.debug("savePortalData");
//            localStorage.setItem(STORAGE_KEY, JSON.stringify(allPortlets));
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
                        allPortlets=JSON.parse(portalJson) || [];
//                        //TODO: empty myPortal is a {}, not []
//                        if (!_.isArray(allPortlets)) {
//                            allPortlets = [];
//                        }
//                        console.debug("loadPortalData.allPortlets", allPortlets);
                        var id = genPortletId();
                        allPortlets = _.forEach(allPortlets, function (p) {
                            if (qadUtil.isBlank(p.id)) {
                                p.id = id++;
                            }
                        });
                        afterLoad(allPortlets);
                    }});
        }

        function buildPortlets(portlets) {
            for (var i = 0; i < portlets.length; i++) {
                if (qadUtil.isBlank(portlets[i].id))
                    portlets[i].id = i;
                buildOnePortlet(portlets[i]);
            }
        }

        function buildOnePortlet(portlet) {
            var idPrefix = '${pageId}-portlet-';
            var portletId = portlet.id;
            var $p = $('#' + idPrefix + portletId, $page);
            var isExist = $p.length > 0;
            var html = '<div class="portlet panel panel-default" data-kui-content-url="${base}/' + portlet.url + '" id="' + portletId + '">' +
                    '<div class="panel-heading"><h3 class="panel-title">' + portlet.title + '</h3>' +
                    '<div class="btn-group btn-group-xs">' +
                    '  <a href="" class="btn btn-default js-edit-portlet" data-kui-dialog="#${pageId}-new-portlet-dialog"><i class="fa fa-pencil"/></a>' +
                    '  <button class="btn btn-default js-delete-portlet"><i class="fa fa-trash-o"/></button></div>' +
                    '</div>' +
                    '<div class="panel-body"></div>' +
                    '</div>';
            if (!isExist) {
                $p = $(html).appendTo($portletContainer);
            } else {
                $p.empty().html(html);
            }
            $p.kuiPortlet({containerId: '${pageId}-portlets'});
            $p.on('click', '.js-delete-portlet', function () {
                var id = $p.attr('id');
                var index = _.findIndex(allPortlets, function (p) {
                    return (p.id + "") == id;
                });
                allPortlets.splice(index, 1);
                $p.remove();
            }).on('click', '.js-edit-portlet', function () {
                var id = $p.attr('id');
                var index = _.findIndex(allPortlets, function (p) {
                    return (p.id + "") == id;
                });
                $portletForm.assignValues(allPortlets[index]);
            })
        }

        function setLayout(editMode) {
            $('.js-show-in-edit-mode', $page).toggle(editMode);
            $('.js-hide-in-edit-mode', $page).toggle(!editMode);
//            $portletContainer.sortable({ disabled: !editMode });
        }

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
                $('[name="' + prop + '"]', this).val(json[prop]);
            }
        };
    });
</script>
</@ui.page>
