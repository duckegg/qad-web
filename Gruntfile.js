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
        less: {
            build: {
                options: {
                    yuicompress: true
                },
                files: {
                    "<%=client_src_css%>/app.css": ["<%=client_src_less%>/app.less"],
                    "<%=client_src_lib%>/kui.css": ["<%=client_src_less%>/kui.less"]
                }
            }
        },
        watch: {
            less: {
                files: ["<%=client_src_less%>/*.less", "<%=client_src_lib%>/*.less"],
                tasks: ["less:build"]
            }
        },
        // Compress Package
        compress: {
            patch: {
                options: {
                    archive: '<%=app_patch_dir%>/<%=app_patch_filename%>'
                },
                files: [
                    // Exclude jars in /WEB-INF/lib and huge font file
                    {expand: true, cwd: '<%=app_staging_dir%>', src: ['**', '!WEB-INF/lib/**', '!media/font/*'], dest: '.'},
                    {expand: true, cwd: '<%=app_staging_dir%>', src: ['WEB-INF/lib/hpps*.jar'], dest: '.'}
                ]
            }
        },
        // SSH
        secret: grunt.file.readJSON('secret.json'),
        sftp: {
            upload: {
                files: {
                    "<%=app_patch_dir%>": "<%=app_patch_filename%>"
                },
                options: {
                    path: '<%=remote_upload_dir%>',
                    host: '<%= secret.host %>',
                    username: '<%= secret.username %>',
                    password: '<%= secret.password %>',
                    showProgress: true
                }
            }
        },
        sshexec: {
            restart_jetty: {
                command: ['rm -rf <%=remote_deploy_dir%>/WEB-INF/lib/hpps-*.jar',
                    'unzip -o <%=remote_upload_dir%>/<%=app_patch_filename%> -d <%=remote_deploy_dir%>',
                    'service jetty restart'],
                options: {
                    host: '<%= secret.host %>',
                    username: '<%= secret.username %>',
                    password: '<%= secret.password %>'
                }
            }

        }
    });

    grunt.loadNpmTasks('grunt-ssh');
    grunt.loadNpmTasks('grunt-contrib-compress');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Default task(s).
    grunt.registerTask('default', ['less:build']);
    grunt.registerTask('deploy-remote', ['compress:patch', 'sftp:upload', 'sshexec']);

};