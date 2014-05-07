'use strict';

module.exports = function (grunt) {

    // Project configuration.
    grunt.initConfig({
        package: grunt.file.readJSON('package.json'),
        root_dir: '.',
        client_src: 'src/main/webapp/media/app',
        client_src_js: '<%=client_src%>/js',
        client_src_less: '<%=client_src%>/less',
        client_src_css: '<%=client_src%>/css',
        client_src_lib: '<%=client_src%>/lib',
        target_dir: 'target',
        app_patch_filename: 'app-patch.zip',
        app_patch_dir: '.', // Currently sftp seems only work with ./
        app_staging_dir: '<%=target_dir%>/<%=package.name%>/',
        remote_upload_dir: '/tmp',
        remote_deploy_dir: '/opt/jetty/webapps/qad',
        // SSH
        secret: grunt.file.readJSON('secret.json'),
        sftp: {
            update_remote: {
                files: {
                    "./": "./target/<%=package.name%>-<%=package.version%>.jar"
                },
                options: {
                    path: '/opt/jetty/webapps/qad/WEB-INF/lib',
                    host: '<%= secret.host %>',
                    username: '<%= secret.username %>',
                    password: '<%= secret.password %>',
                    showProgress: true
                }
            }
        },
        //Javascript doc
        jsdoc: {
            dist: {
                src: ['src/main/resources/static/js/qad-*.js'],
                options: {
                    destination: 'target/doc/jsdoc',
                    configure:'jsdoc.conf.json'
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-ssh');
    grunt.loadNpmTasks('grunt-jsdoc');

    // Default task(s).
    grunt.registerTask('default', ['sftp:update_remote']);

};