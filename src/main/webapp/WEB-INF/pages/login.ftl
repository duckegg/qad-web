<#-- 2012/05/03 -->
<#include "/library/taglibs.ftl" parse=true/>
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <title>自动化看板</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="shortcut icon" href="${base}/media/app/images/favicon.png"/>
    <script type="text/javascript" src="${base}/media/jquery/jquery-1.10.1.leo.js"></script>
    <script type="text/javascript"
            src="${base}/media/supersized/supersized.core.3.2.1.min.js"></script>
    <script type="text/javascript" src="${base}/media/bootstrap3/js/bootstrap.js"></script>
    <link type="text/css" rel="stylesheet" media="screen"
          href="${base}/media/bootstrap3/css/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" media="screen" href="${base}/media/icomoon/style.css"/>
    <link type="text/css" rel="stylesheet" media="screen"
          href="${base}/media/fontawesome/css/font-awesome.min.css"/>
    <style type="text/css">
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: "Trebuchet MS", Helvetica, sans-serif, "Open Sans";
        }

        a, a:visited, a:hover {
            text-decoration: none;
        }

        #container {
            min-height: 100%;
            position: relative;
            background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAE0lEQVQIW2M0MjKqZwACRhABAgAQfwEYjwuw4gAAAABJRU5ErkJggg==);
            /*-webkit-box-shadow: inset 0px -1px 57px black;*/
            /*-moz-box-shadow: inset 0px -1px 57px #000;*/
            /*box-shadow: inset 0px -1px 57px black;*/
        }

        #header {
            height: 140px;
        }

        #footer {
            position: absolute;
            padding: 5px 0;
            bottom: 0;
            width: 100%;
            font-size: 13px;
            color: #ddd;
            line-height: 1.5;
            background: black;
            opacity: 0.6;
            filter: alpha(opacity=60);
        }

        #footer > div {
            /*padding: 0 5px;*/
        }

        #footer a {
            color: lightyellow;
        }

        .mybox {
            padding: 0.5em;
            background-color: #666;
            background: rgba(0, 0, 0, 0.6);
            border-radius: 3px;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.5);
        }

        .mybox-content {
            padding: 1em;
            color: #666;
            background-color: #eee;
            border-radius: 3px;
        }

        .mybox-header {
            text-align: center;
            color: white;
            background-repeat: no-repeat;
            background-position: top left;
            /*background-size: auto;*/
        }

        #supersized-loader {
            position: absolute;
            top: 50%;
            left: 50%;
            z-index: 0;
            width: 60px;
            height: 60px;
            margin: -30px 0 0 -30px;
            text-indent: -999em;
            background: url(${base}/media/app/images/progress.gif) no-repeat center center;
        }

        #supersized {
            position: fixed;
            left: 0;
            top: 0;
            overflow: hidden;
            z-index: -999;
            height: 100%;
            width: 100%;
        }

        #supersized img {
            width: auto;
            height: auto;
            position: relative;
            outline: none;
            border: none;
        }

        #supersized a {
            z-index: -30;
            position: fixed;
            overflow: hidden;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #111;
            display: block;
        }

        #supersized a.image-loading {
            background: #111 url(${base}/media/app/images/progress.gif) no-repeat center center;
            width: 100%;
            height: 100%;
        }
    </style>
    <script type="text/javascript">
        if (location.href.indexOf("login") < 0 && location.href.indexOf("login") < 0) {
            location.href = "${base}/login";
        }
    </script>
</head>
<body>
<div id="container">
    <div id="header"></div>
    <div>
        <div id="body">
            <div id="login-wrapper" style="margin:0 auto; width:400px;">
                <div class="mybox">
                    <div class="mybox-header"><img src="${base}/media/app/images/logo-login.png">
                    </div>
                    <div class="mybox-content">
                        <form action="${base}/login" class="clearfix" method="post">
                            <div class="form-group">
                                <span>请输入Windows域帐户登录</span>
                            </div>

                            <div class="form-group">
                                <input type="text" id="username" name="username"
                                       class="required form-control"
                                       placeholder="用户名" style="font-weight: bold"/>
                            </div>
                            <div class="form-group">
                                <input type="password" id="password" name="password"
                                       class="required form-control"
                                       placeholder="密码" style="font-weight: bold"/>
                            </div>
                            <div>
                            <@ui.strutsErrors/>
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn btn-success col-xs-8"
                                        style="font-weight: bold"
                                        data-loading-text="正在登录...">
                                    登录
                                </button>
                                <button class="btn btn-default col-xs-offset-1 col-xs-3"
                                        name="guest" value="true">
                                    直接访问
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="footer">
    <#include "../decorators/footer-qadweb.ftl"/>
    </div>
</div>
</body>
</html>
<script type="text/javascript">
    $(function () {
        $('#username').focus();
        $('#container').supersized({
            start_slide: 0,
            slides: [
                {image: '${base}/media/app/images/wallpaper/wp-elephant.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-road.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-chips.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-data.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-traffic.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-lazydays.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-grassy.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-horse.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-device.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-sunset.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-starry.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-boat.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-lake-mountain.jpg'},
                {image: '${base}/media/app/images/wallpaper/wp-cloudy-sky.jpg'}
            ]
        });
    });

</script>