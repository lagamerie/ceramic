package tools;

import tools.Context;
import tools.Helpers;
import tools.Vscode;
import tools.Helpers.*;
import backend.tools.BackendTools;

@:keep
class ToolsPlugin {

    public var backend:BackendTools;

    static function main():Void {
        
        var module:Dynamic = js.Node.module;
        module.exports = new ToolsPlugin();

    } //main

/// Tools

    public function new() {}

    public function init(context:Context):Void {

        // Use same context as parent
        Helpers.context = context;

        // Set backend
        var prevBackend = context.backend;
        backend = new BackendTools();
        context.backend = backend;

        // Add tasks
        var tasks = context.tasks;
        tasks.set('snow targets', new tools.tasks.Targets());
        tasks.set('snow setup', new tools.tasks.Setup());
        tasks.set('snow hxml', new tools.tasks.Hxml());
        tasks.set('snow build', new tools.tasks.Build('Build'));
        tasks.set('snow run', new tools.tasks.Build('Run'));
        tasks.set('snow clean', new tools.tasks.Build('Clean'));
        tasks.set('snow assets', new tools.tasks.Assets());
        tasks.set('snow icons', new tools.tasks.Icons());
        tasks.set('snow update', new tools.tasks.Update());
        tasks.set('snow info', new tools.tasks.Info());
        tasks.set('snow libs', new tools.tasks.Libs());

        // Restore default backend
        context.backend = prevBackend;

    } //init

    public function extendVscodeTasksChooser(items:Array<VscodeChooserItem>) {

        // Add snow-related tasks
        //
        var backendName = 'snow';

        for (target in backend.getBuildTargets()) {

            for (config in target.configs) {

                var name:String = null;
                var kind:String = null;

                switch (config) {
                    case Build(name_):
                        name = name_;
                        kind = 'build';
                    case Run(name_):
                        name = name_;
                        kind = 'run';
                    case Clean(name_):
                }

                if (kind == null) continue;

                for (editor in [false, true]) {

                    if (editor && (target.name != 'web' || kind != 'build')) continue;

                    for (debug in [false, true]) {

                        if (editor && !debug) continue;

                        var tasksContent:Array<VscodeChooserItemTask> = [
                            {
                                type: "shell",
                                label: "build",
                                command: "ceramic",
                                presentation: {
                                    echo: true,
                                    reveal: "always",
                                    focus: false,
                                    panel: "shared"
                                },
                                args: [backendName, kind, target.name, '--setup', '--assets', '--vscode-editor', '--hxml-output', 'completion.hxml'].concat(debug ? ['--debug'] : []).concat(editor ? ['--variant', 'editor'] : []),
                                group: {
                                    kind: "build",
                                    isDefault: true
                                },
                                problemMatcher: "$haxe"
                            }
                        ];

                        items.push({
                            displayName: '▶︎ ' + backendName + ' / ' + name + (debug && !editor ? ' (debug)' : '') + (editor ? ' (editor)' : ''),
                            description: 'ceramic ' + backendName + ' ' + kind + ' ' + target.name + ' --setup --assets' + (debug ? ' --debug' : '') + (editor ? ' --variant editor' : ''),
                            tasks: tasksContent,
                            onSelect: {
                                command: "ceramic",
                                args: [backendName, "hxml", target.name, "--output", "completion.hxml"].concat(debug ? ['--debug'] : []).concat(editor ? ['--variant', 'editor'] : [])
                            }
                        });

                    }
                }

            }

        }

    } //extendVscodeTasksChooser

} //ToolsPlugin