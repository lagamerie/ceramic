package plugin.spine.macros;

import ceramic.macros.AssetsMacro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.io.Path;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

using StringTools;

class SpineMacros {

    macro static public function buildNames():Array<Field> {

        var fields = Context.getBuildFields();
        var pos = Context.currentPos();
        var assetsPath = Context.definedValue('assets_path');
        var ceramicAssetsPath = Context.definedValue('ceramic_assets_path');

        AssetsMacro.initData(assetsPath, ceramicAssetsPath);
        var nameFields = AssetsMacro.computeNames(fields, pos, 'spine', ['spine'], true);


        // Assets by base name
        //
        var idsEntries = [];

        // We let assets macro do default work but want to extend
        // informations to available animations inside each spine export
        for (field in nameFields) {
            
            var spineDir = field.doc;
            if (FileSystem.exists(Path.join([assetsPath, spineDir]))) {
                spineDir = Path.join([assetsPath, spineDir]);
            }
            else if (FileSystem.exists(Path.join([ceramicAssetsPath, spineDir]))) {
                spineDir = Path.join([ceramicAssetsPath, spineDir]);
            }
            else {
                fields.push(field);
                continue;
            }

            var jsonPath = null;
            for (file in FileSystem.readDirectory(spineDir)) {
                if (file.toLowerCase().endsWith('.json')) {
                    jsonPath = Path.join([spineDir, file]);
                    break;
                }
            }

            if (jsonPath == null) {
                fields.push(field);
                continue;
            }

            var jsonData = Json.parse(File.getContent(jsonPath));
            var animations = Reflect.fields(jsonData.animations);

            var entries = [];
            for (animName in animations) {
                var constName = AssetsMacro.toAssetConstName(animName);
                if (!constName.startsWith('_')) {
                    entries.push({
                        expr: {
                            expr: EConst(CString(animName)),
                            pos: pos
                        },
                        field: constName
                    });
                }
            }

            switch(field.kind) {
                case FProp(_, _, _, expr):
                    /*entries.push({
                        expr: { expr: ECast(expr, macro :ceramic.Assets.AssetId<String>), pos: pos },
                        field: '_id'
                    });*/
                    idsEntries.push({expr: EBinop(OpArrow, {expr: EConst(CString(field.name)), pos: pos}, expr), pos: pos});
                default:
            }

            field.kind = FProp('default', 'null', null, { expr: EObjectDecl(entries), pos: pos });

            fields.push(field);

        }

        var idsExpr = idsEntries.length == 0 ? (macro new Map()) : {expr: EArrayDecl(idsEntries), pos: pos};
        var idsField = {
            pos: pos,
            name: '_ids',
            kind: FProp('default', 'null', macro :Map<String,String>, idsExpr),
            access: [AStatic, APrivate],
            doc: '',
            meta: [{
                name: ':noCompletion',
                params: [],
                pos: pos
            }]
        };
        fields.push(idsField);

        return fields;

    } //buildNames

}