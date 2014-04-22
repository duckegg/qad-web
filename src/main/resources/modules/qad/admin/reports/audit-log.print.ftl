<#--
********************************************************************************
@desc system audit log printable page
@author Leo Liao, 2012/07/14, created
********************************************************************************
-->
<#include "/library/ftl/lib-print.ftl"/>
<@xhtml
title="看板使用日志"
columns=
"username=用户,
action_name=操作,
action_param=操作参数,
log_level=级别,
create_date=时间,
host=来访地址"/>
