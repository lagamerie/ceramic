package ceramic;

import ceramic.Assets;
import ceramic.Shortcuts.*;

using StringTools;

@:allow(ceramic.App)
class RenderTexture extends Texture {

    static var _clearQuad:Quad = null;

    public var autoRender:Bool = true;

    public var clearOnRender:Bool = true;

    public var renderDirty:Bool = false;

    public var dependingTextures:IntIntMap = null;

    public var priority(default, null):Float = 0;

/// Lifecycle

    public function new(width:Int, height:Int, density:Float = -1 #if ceramic_debug_entity_allocs , ?pos:haxe.PosInfos #end) {

        if (density == -1) density = screen.texturesDensity;

        var backendItem = app.backend.textures.createRenderTarget(
            Math.round(width * density),
            Math.round(height * density)
        );

        super(backendItem, density #if ceramic_debug_entity_allocs , pos #end);

        isRenderTexture = true;

        app.renderTextures.push(this);

    } //new

    override function destroy() {

        super.destroy();

        app.renderTextures.remove(this);

    } //destroy

/// Public API / Utilities

    /** Draws the given visual onto the render texture.
        The drawing operation is not done synchronously.
        It waits for the next draw stage of the app to perform it,
        then calls done() when finished.
        This is expected to be used with a texture `autoRender` set to `false`. */
    public function stamp(visual:Visual, done:Void->Void) {

        // Keep original values as needed
        var visualParent = visual.parent;
        var visualRenderTarget = visual.renderTarget;
        var visualVisible = visual.visible;

        // Set new values
        if (visualParent != null) visualParent.remove(visual);
        visual.renderTarget = this;
        visual.visible = true;

        // Request full update in current frame
        app.requestFullUpdateAndDrawInFrame();

        // Running post-update code allows to ensure this is executed after visuals
        // have been prepared for update, but before this is applied
        app.onceUpdate(this, function(_) {

            renderDirty = true;

            app.onceFinishDraw(this, function() {

                // Restore visual state
                visual.visible = visualVisible;
                visual.renderTarget = visualRenderTarget;
                if (visualParent != null) {
                    visualParent.add(visual);
                    visualParent = null;
                }
                visual = null;
                visualRenderTarget = null;

                done();
                done = null;

            });
        });

    } //stamp

    /** Clears the texture, or a specific area of it with a fill color and alpha.
        The drawing operation is not done synchronously.
        It waits for the next draw stage of the app to perform it,
        then calls done() when finished.
        This is expected to be used with a texture `autoRender` set to `false`. */
    public function clear(color:Color = 0xFFFFFF, alpha:Float = 0, clipX:Float = -1, clipY:Float = -1, clipWidth:Float = -1, clipHeight:Float = -1, done:Void->Void) {

        if (_clearQuad == null) {
            _clearQuad = new Quad();
            _clearQuad.active = false;
            _clearQuad.blending = SET;
            _clearQuad.anchor(0, 0);
        }

        _clearQuad.color = color;
        _clearQuad.alpha = alpha;
        _clearQuad.depth = -1;

        if (clipX != -1 && clipY != -1 && clipWidth != -1 && clipHeight != -1) {
            _clearQuad.size(clipWidth, clipHeight);
            _clearQuad.pos(clipX, clipY);
        }
        else {
            _clearQuad.size(width, height);
            _clearQuad.pos(0, 0);
        }

        stamp(_clearQuad, done);

    } //clear

    @:noCompletion inline public function dependsOnTexture(texture:Texture):Bool {

        return dependingTextures != null && dependingTextures.get(texture.index) > 0;

    } //dependsOnTexture

    @:noCompletion inline public function incrementDependingTextureCount(texture:Texture):Void {

        if (dependingTextures == null) {
            dependingTextures = new IntIntMap();
        }
        var prevValue = dependingTextures.get(texture.index);
        dependingTextures.set(texture.index, prevValue + 1);

    } //incrementDependingTextureCount

    @:noCompletion inline public function resetDependingTextureCounts():Void {

        if (dependingTextures != null) {
            dependingTextures.clear();
        }

    } //decrementDependingTextureCount

} //RenderTexture
