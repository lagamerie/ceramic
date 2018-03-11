package tools.tasks.web;

import tools.Helpers.*;
import tools.Project;
import tools.Colors;
import tools.Files;
import haxe.io.Path;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

import js.node.Os;
import js.node.ChildProcess;
import npm.StreamSplitter;

using StringTools;

class Web extends tools.Task {

    override public function info(cwd:String):String {

        return "Generate or update Web/HTML5 project to run or debug it";

    } //info

    override function run(cwd:String, args:Array<String>):Void {

        var project = ensureCeramicProject(cwd, args, App);

        var webProjectPath = Path.join([cwd, 'project/web']);
        var webProjectFilePath = Path.join([webProjectPath, 'index.html']);

        var doRun = extractArgFlag(args, 'run');

        // Create web project if needed
        WebProject.createWebProjectIfNeeded(cwd, project);

        // Copy built files and assets
        var flowProjectPath = Path.join([cwd, 'out', 'luxe', 'web' + (context.variant != 'standard' ? '-' + context.variant : '')]);
        var flowWebHtmlPath = Path.join([flowProjectPath, 'bin/web']);

        // Copy assets
        Files.copyDirectory(Path.join([flowWebHtmlPath, 'assets']), Path.join([cwd, 'project/web/assets']));

        // Copy javascript files
        var jsName = project.app.name;
        if (FileSystem.exists(Path.join([flowWebHtmlPath, jsName + '.js.map']))) {
            File.copy(Path.join([flowWebHtmlPath, jsName + '.js.map']), Path.join([cwd, 'project/web', jsName + '.js.map']));
        }
        File.copy(Path.join([flowWebHtmlPath, jsName + '.js']), Path.join([cwd, 'project/web', jsName + '.js']));

        // Stop if not running
        if (!doRun) return;

        // Run project through electron/ceramic-runner
        print('Start ceramic runner...');
        var webAppFilesPath = Path.join([cwd, 'project/web']);

        var status = 0;

        Sync.run(function(done) {

            var cmdArgs = ['--app-files', webAppFilesPath];

            if (context.debug) {
                cmdArgs = ['--remote-debugging-port=9223'].concat(cmdArgs);
            }

            cmdArgs = ['.'].concat(cmdArgs);

            var proc = ChildProcess.spawn(
                'node_modules/.bin/electron',
                cmdArgs,
                { cwd: context.ceramicRunnerPath }
            );

            var out = StreamSplitter.splitter("\n");
            proc.stdout.pipe(untyped out);
            proc.on('close', function(code:Int) {
                status = code;
            });
            out.encoding = 'utf8';
            out.on('token', function(token) {
                token = formatLineOutput(flowProjectPath, token);
                stdoutWrite(token + "\n");
            });
            out.on('done', function() {
                done();
            });
            out.on('error', function(err) {
                warning(''+err);
            });

            var err = StreamSplitter.splitter("\n");
            proc.stderr.pipe(untyped err);
            err.encoding = 'utf8';
            err.on('token', function(token) {
                token = formatLineOutput(flowProjectPath, token);
                stderrWrite(token + "\n");
            });
            err.on('error', function(err) {
                warning(''+err);
            });

        });

    } //run

} //Web