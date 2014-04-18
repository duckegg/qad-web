<#--
********************************************************************************
@desc 
@author Leo Liao, 13-5-25, created
********************************************************************************
-->
<#include "/library/taglibs.ftl" parse=true/>

<@ui.page id="help-appsec" title="系统安全管理">
    <#noparse>
    <div class="alert">适用于开发人员和管理员</div>
    <h2>概念定义</h2>
    <dl>
        <dt>权限定义</dt>
        <dd><code>domain:action:target</code>形式的shiro权限定义。
            权限定义在看板GUI中定义。
        </dd>
        <dt>权限表达式</dt>
        <dd>多个shiro权限定义的与（&&）、或（||）逻辑组合
            权限表达式在shiro/permcode.properties中定义。
        </dd>
        <dt>权限代码</dt>
        <dd>permcode，对应一条权限定义，或者一个权限表达式。在ftl和配置代码中，通过代码来屏蔽具体的权限
            权限代码在shiro/permcode.properties中定义。
        </dd>
    </dl>
    <h2>如何配置权限</h2>
    示例：将CBS Switches一键任务的执行权限赋予RS6000组
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>步骤</th>
            <th>What</th>
            <th>Why</th>
            <th>Where</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>1</td>
            <td>定义执行一键任务的权限代码和对应权限表达式。<br/>
                假设CBS Switches的ID为27
                <code><strong>perm_ootask_execute</strong>=ootask:execute:${id}</code>
            </td>
            <td>建立权限代码，通过代码来引用权限，屏蔽shiro的domain:action:target权限表达式并增加权限逻辑组合的功能
            </td>
            <td>shiro/permcode.properties
            </td>
        </tr>
        <tr>
            <td>2</td>
            <td>添加一键任务执行URL
                <code>/ootask/input=authec, permcode["<strong>perm_ootask_execute</strong>"]</code>
            </td>
            <td>定义一键任务的执行URL必须要具有perm_ootask_execute权限的登录用户才能执行
            </td>
            <td>shiro.ini
            </td>
        </tr>
        <tr>
            <td>3</td>
            <td>在看板增加一条执行ID为27的ootask的权限
                <code>ootask:execute:27</code>
            </td>
            <td>定义执行CBS Switches任务的权限</td>
            <td>看板GUI
            </td>
        </tr>
        <tr>
            <td>4</td>
            <td>将权限<code>ootask:execute:27</code>赋予用户组RS6000。至此已经完成了后台对URL的权限控制</td>
            <td></td>
            <td>看板GUI</td>
        </tr>
        <tr>
            <td>5</td>
            <td>在合适的地方增加
                <code>
                    <#if permissionResolver.allow("perm_ootask_execute")>
                </code>
                来判断是否显示执行按钮
            </td>
            <td>通过权限来控制页面元素的显示状态（隐藏/只读等）</td>
            <td>ftl页面</td>
        </tr>
        </tbody>
    </table>
    </#noparse>
</@ui.page>
