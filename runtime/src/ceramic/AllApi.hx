package ceramic;

import Std;
import StringTools;
import Math;
import Array;
import haxe.ds.Map;

import tracker.Autorun;
import tracker.DynamicEvents;
import tracker.EventDispatcher;
import tracker.Events;
import tracker.History;
import tracker.Observable;
import tracker.Model;
import tracker.SaveModel;
import tracker.Serializable;
import tracker.SerializeChangeset;
import tracker.SerializeModel;
import tracker.Tracker;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.ArcadePhysics;
import ceramic.Asset;
import ceramic.AssetId;
import ceramic.AssetOptions;
import ceramic.AssetPathInfo;
import ceramic.Assets;
import ceramic.AssetStatus;
import ceramic.Audio;
import ceramic.AudioMixer;
import ceramic.BackgroundQueue;
import ceramic.BezierEasing;
import ceramic.BitmapFont;
import ceramic.BitmapFontCharacter;
import ceramic.BitmapFontData;
import ceramic.BitmapFontDistanceFieldData;
import ceramic.BitmapFontParser;
import ceramic.Blending;
import ceramic.Border;
import ceramic.BorderPosition;
import ceramic.Click;
import ceramic.Collection;
import ceramic.CollectionEntry;
import ceramic.Collections;
import ceramic.Color;
import ceramic.Component;
import ceramic.ComputeFps;
import ceramic.ConvertComponentMap;
import ceramic.ConvertField;
import ceramic.ConvertFont;
import ceramic.ConvertFragmentData;
import ceramic.ConvertMap;
import ceramic.ConvertTexture;
import ceramic.Csv;
import ceramic.CustomAssetKind;
import ceramic.DatabaseAsset;
import ceramic.Databases;
import ceramic.DebugRendering;
import ceramic.DecomposedTransform;
import ceramic.DoubleClick;
import ceramic.Easing;
import ceramic.EditText;
import ceramic.Entity;
import ceramic.Enums;
import ceramic.Errors;
import ceramic.Extensions;
import ceramic.FieldInfo;
import ceramic.Files;
import ceramic.FileWatcher;
import ceramic.Filter;
import ceramic.Flags;
import ceramic.Float32Array;
import ceramic.FontAsset;
import ceramic.Fonts;
import ceramic.Fragment;
import ceramic.FragmentContext;
import ceramic.FragmentData;
import ceramic.FragmentItem;
import ceramic.Fragments;
import ceramic.FragmentsAsset;
import ceramic.GeometryUtils;
import ceramic.GlyphQuad;
import ceramic.HashedString;
import ceramic.ImageAsset;
import ceramic.Images;
import ceramic.InitSettings;
import ceramic.IntBoolMap;
import ceramic.IntFloatMap;
import ceramic.IntMap;
import ceramic.IntIntMap;
import ceramic.Key;
import ceramic.KeyAcceleratorItem;
import ceramic.KeyBinding;
import ceramic.KeyBindings;
import ceramic.KeyCode;
import ceramic.Lazy;
import ceramic.Line;
import ceramic.LineCap;
import ceramic.LineJoin;
import ceramic.Logger;
import ceramic.Mesh;
import ceramic.MeshColorMapping;
import ceramic.MeshPool;
import ceramic.MouseButton;
import ceramic.NapePhysics;
import ceramic.ParticleItem;
import ceramic.Particles;
import ceramic.ParticlesLaunchMode;
import ceramic.ParticlesStatus;
import ceramic.Path;
import ceramic.PersistentData;
import ceramic.Point;
import ceramic.Quad;
import ceramic.Renderer;
import ceramic.RenderTexture;
import ceramic.ReusableArray;
import ceramic.RotateFrame;
import ceramic.Runner;
import ceramic.RuntimeAssets;
import ceramic.ScanCode;
import ceramic.Screen;
import ceramic.ScreenScaling;
import ceramic.ScriptContent;
//import ceramic.Script;
//import ceramic.Scripts;
import ceramic.ScrollDirection;
import ceramic.Scroller;
import ceramic.ScrollerStatus;
import ceramic.SeedRandom;
import ceramic.SelectText;
import ceramic.Settings;
import ceramic.Shader;
import ceramic.ShaderAsset;
import ceramic.ShaderAttribute;
import ceramic.Shaders;
import ceramic.Shape;
import ceramic.Shortcuts;
import ceramic.SortRenderTextures;
import ceramic.SortVisuals;
import ceramic.Sound;
import ceramic.SoundAsset;
import ceramic.SoundPlayer;
import ceramic.Sounds;
// import ceramic.SqliteKeyValue;
// import ceramic.State;
// import ceramic.StateMachine;
// import ceramic.StateMachineImpl;
import ceramic.Text;
import ceramic.TextAlign;
import ceramic.TextAsset;
import ceramic.TextInput;
import ceramic.TextInputDelegate;
import ceramic.Texts;
import ceramic.Texture;
import ceramic.TextureFilter;
import ceramic.TextureTile;
import ceramic.TextureTilePacker;
import ceramic.Timeline;
import ceramic.TimelineColorKeyframe;
import ceramic.TimelineColorTrack;
import ceramic.TimelineDegreesTrack;
import ceramic.TimelineFloatKeyframe;
import ceramic.TimelineFloatTrack;
import ceramic.TimelineKeyframe;
import ceramic.TimelineTrack;
import ceramic.Timer;
import ceramic.Touch;
import ceramic.Touches;
import ceramic.TouchInfo;
import ceramic.TrackEntities;
import ceramic.TrackerBackend;
import ceramic.Transform;
import ceramic.TransformPool;
import ceramic.Triangle;
import ceramic.Triangulate;
import ceramic.TriangulateMethod;
import ceramic.Tween;
import ceramic.UInt8Array;
import ceramic.Utils;
import ceramic.ValueEntry;
import ceramic.Velocity;
import ceramic.Visual;
import ceramic.VisualArcadePhysics;
import ceramic.VisualNapePhysics;
import ceramic.VisualTransition;
import ceramic.WatchDirectory;


class AllApi {

    public static function configureHscript(interp:hscript.Interp):Void {

        interp.variables.set('app', ceramic.Shortcuts.app);
        interp.variables.set('screen', ceramic.Shortcuts.screen);
        interp.variables.set('audio', ceramic.Shortcuts.audio);
        interp.variables.set('settings', ceramic.Shortcuts.settings);
        interp.variables.set('collections', ceramic.Shortcuts.collections);
        interp.variables.set('log', ceramic.Shortcuts.log);
        
        interp.variables.set('Std', ceramic.scriptable.ScriptableStd);
        interp.variables.set('StringTools', StringTools);
        interp.variables.set('Math', Math);
        
        interp.variables.set('Autorun', tracker.Autorun);
        interp.variables.set('DynamicEvents', tracker.DynamicEvents);
        interp.variables.set('EventDispatcher', tracker.EventDispatcher);
        interp.variables.set('Events', tracker.Events);
        interp.variables.set('History', tracker.History);
        interp.variables.set('Observable', tracker.Observable);
        interp.variables.set('Model', tracker.Model);
        interp.variables.set('SaveModel', tracker.SaveModel);
        interp.variables.set('Serializable', tracker.Serializable);
        interp.variables.set('SerializeChangeset', tracker.SerializeChangeset);
        interp.variables.set('SerializeModel', tracker.SerializeModel);
        interp.variables.set('Tracker', tracker.Tracker);
        
        interp.variables.set('AlphaColor', ceramic.scriptable.ScriptableAlphaColor);
        interp.variables.set('App', ceramic.App);
        interp.variables.set('ArcadePhysics', ceramic.ArcadePhysics);
        interp.variables.set('Asset', ceramic.Asset);
        interp.variables.set('AssetPathInfo', ceramic.AssetPathInfo);
        interp.variables.set('Assets', ceramic.Assets);
        interp.variables.set('AssetStatus', ceramic.AssetStatus);
        interp.variables.set('AudioMixer', ceramic.AudioMixer);
        interp.variables.set('BackgroundQueue', ceramic.BackgroundQueue);
        interp.variables.set('BezierEasing', ceramic.BezierEasing);
        interp.variables.set('BitmapFont', ceramic.BitmapFont);
        interp.variables.set('BitmapFontCharacter', ceramic.BitmapFontCharacter);
        interp.variables.set('BitmapFontData', ceramic.BitmapFontData);
        interp.variables.set('BitmapFontDistanceFieldData', ceramic.BitmapFontDistanceFieldData);
        interp.variables.set('BitmapFontParser', ceramic.BitmapFontParser);
        interp.variables.set('Blending', ceramic.scriptable.ScriptableBlending);
        interp.variables.set('Border', ceramic.Border);
        interp.variables.set('BorderPosition', ceramic.BorderPosition);
        interp.variables.set('Click', ceramic.Click);
        interp.variables.set('CollectionEntry', ceramic.CollectionEntry);
        interp.variables.set('Collections', ceramic.Collections);
        interp.variables.set('Color', ceramic.scriptable.ScriptableColor);
        interp.variables.set('Component', ceramic.Component);
        interp.variables.set('ComputeFps', ceramic.ComputeFps);
        interp.variables.set('ConvertComponentMap', ceramic.ConvertComponentMap);
        interp.variables.set('ConvertField', ceramic.ConvertField);
        interp.variables.set('ConvertFont', ceramic.ConvertFont);
        interp.variables.set('ConvertFragmentData', ceramic.ConvertFragmentData);
        interp.variables.set('ConvertMap', ceramic.ConvertMap);
        interp.variables.set('ConvertTexture', ceramic.ConvertTexture);
        interp.variables.set('Csv', ceramic.Csv);
        interp.variables.set('CustomAssetKind', ceramic.CustomAssetKind);
        interp.variables.set('DatabaseAsset', ceramic.DatabaseAsset);
        interp.variables.set('Databases', ceramic.Databases);
        interp.variables.set('DebugRendering', ceramic.scriptable.ScriptableDebugRendering);
        interp.variables.set('DecomposedTransform', ceramic.DecomposedTransform);
        interp.variables.set('DoubleClick', ceramic.DoubleClick);
        interp.variables.set('Easing', ceramic.Easing);
        interp.variables.set('EditText', ceramic.EditText);
        interp.variables.set('Entity', ceramic.Entity);
        interp.variables.set('Enums', ceramic.Enums);
        interp.variables.set('Errors', ceramic.Errors);
        interp.variables.set('Extensions', ceramic.Extensions);
        interp.variables.set('FieldInfo', ceramic.FieldInfo);
        interp.variables.set('Files', ceramic.Files);
        interp.variables.set('FileWatcher', ceramic.FileWatcher);
        interp.variables.set('Filter', ceramic.Filter);
        interp.variables.set('Flags', ceramic.scriptable.ScriptableFlags);
        interp.variables.set('FontAsset', ceramic.FontAsset);
        interp.variables.set('Fonts', ceramic.Fonts);
        interp.variables.set('Fragment', ceramic.Fragment);
        interp.variables.set('FragmentContext', ceramic.FragmentContext);
        interp.variables.set('Fragments', ceramic.Fragments);
        interp.variables.set('FragmentsAsset', ceramic.FragmentsAsset);
        interp.variables.set('GeometryUtils', ceramic.GeometryUtils);
        interp.variables.set('GlyphQuad', ceramic.GlyphQuad);
        interp.variables.set('HashedString', ceramic.HashedString);
        interp.variables.set('ImageAsset', ceramic.ImageAsset);
        interp.variables.set('Images', ceramic.Images);
        interp.variables.set('InitSettings', ceramic.InitSettings);
        interp.variables.set('Key', ceramic.Key);
        interp.variables.set('KeyAcceleratorItem', ceramic.KeyAcceleratorItem);
        interp.variables.set('KeyBinding', ceramic.KeyBinding);
        interp.variables.set('KeyBindings', ceramic.KeyBindings);
        interp.variables.set('KeyCode', ceramic.KeyCode);
        interp.variables.set('Lazy', ceramic.Lazy);
        interp.variables.set('Line', ceramic.Line);
        interp.variables.set('LineCap', ceramic.LineCap);
        interp.variables.set('LineJoin', ceramic.LineJoin);
        interp.variables.set('Logger', ceramic.Logger);
        interp.variables.set('Mesh', ceramic.Mesh);
        interp.variables.set('MeshColorMapping', ceramic.scriptable.ScriptableMeshColorMapping);
        interp.variables.set('MeshPool', ceramic.MeshPool);
        interp.variables.set('MouseButton', ceramic.scriptable.ScriptableMouseButton);
        interp.variables.set('NapePhysics', ceramic.NapePhysics);
        interp.variables.set('ParticleItem', ceramic.ParticleItem);
        interp.variables.set('Particles', ceramic.Particles);
        interp.variables.set('ParticlesLaunchMode', ceramic.ParticlesLaunchMode);
        interp.variables.set('ParticlesStatus', ceramic.ParticlesStatus);
        interp.variables.set('Path', ceramic.Path);
        interp.variables.set('PersistentData', ceramic.PersistentData);
        interp.variables.set('Point', ceramic.Point);
        interp.variables.set('Quad', ceramic.Quad);
        interp.variables.set('Renderer', ceramic.Renderer);
        interp.variables.set('RenderTexture', ceramic.RenderTexture);
        interp.variables.set('ReusableArray', ceramic.ReusableArray);
        interp.variables.set('RotateFrame', ceramic.scriptable.ScriptableRotateFrame);
        interp.variables.set('Runner', ceramic.Runner);
        interp.variables.set('RuntimeAssets', ceramic.RuntimeAssets);
        interp.variables.set('ScanCode', ceramic.ScanCode);
        interp.variables.set('Screen', ceramic.Screen);
        interp.variables.set('ScreenScaling', ceramic.ScreenScaling);
        //interp.variables.set('Script', ceramic.Script);
        //interp.variables.set('Scripts', ceramic.Scripts);
        interp.variables.set('ScrollDirection', ceramic.ScrollDirection);
        interp.variables.set('Scroller', ceramic.Scroller);
        interp.variables.set('ScrollerStatus', ceramic.ScrollerStatus);
        interp.variables.set('SeedRandom', ceramic.SeedRandom);
        interp.variables.set('SelectText', ceramic.SelectText);
        interp.variables.set('Settings', ceramic.Settings);
        interp.variables.set('Shader', ceramic.Shader);
        interp.variables.set('ShaderAsset', ceramic.ShaderAsset);
        interp.variables.set('ShaderAttribute', ceramic.ShaderAttribute);
        interp.variables.set('Shaders', ceramic.Shaders);
        interp.variables.set('Shape', ceramic.Shape);
        interp.variables.set('Shortcuts', ceramic.Shortcuts);
        interp.variables.set('SortRenderTextures', ceramic.SortRenderTextures);
        interp.variables.set('SortVisuals', ceramic.SortVisuals);
        interp.variables.set('Sound', ceramic.Sound);
        interp.variables.set('SoundAsset', ceramic.SoundAsset);
        // TODO interp.variables.set('SoundPlayer', ceramic.SoundPlayer);
        interp.variables.set('Sounds', ceramic.Sounds);
        // interp.variables.set('SqliteKeyValue', ceramic.SqliteKeyValue);
        // interp.variables.set('State', ceramic.State);
        // interp.variables.set('StateMachine', ceramic.StateMachine);
        // interp.variables.set('StateMachineImpl', ceramic.StateMachineImpl);
        interp.variables.set('Text', ceramic.Text);
        interp.variables.set('TextAlign', ceramic.TextAlign);
        interp.variables.set('TextAsset', ceramic.TextAsset);
        interp.variables.set('TextInput', ceramic.TextInput);
        interp.variables.set('TextInputDelegate', ceramic.TextInputDelegate);
        interp.variables.set('Texts', ceramic.Texts);
        interp.variables.set('Texture', ceramic.Texture);
        interp.variables.set('TextureFilter', ceramic.TextureFilter);
        interp.variables.set('TextureTile', ceramic.TextureTile);
        interp.variables.set('TextureTilePacker', ceramic.TextureTilePacker);
        interp.variables.set('Timeline', ceramic.Timeline);
        interp.variables.set('TimelineColorKeyframe', ceramic.TimelineColorKeyframe);
        interp.variables.set('TimelineColorTrack', ceramic.TimelineColorTrack);
        interp.variables.set('TimelineDegreesTrack', ceramic.TimelineDegreesTrack);
        interp.variables.set('TimelineFloatKeyframe', ceramic.TimelineFloatKeyframe);
        interp.variables.set('TimelineFloatTrack', ceramic.TimelineFloatTrack);
        interp.variables.set('TimelineKeyframe', ceramic.TimelineKeyframe);
        interp.variables.set('TimelineTrack', ceramic.TimelineTrack);
        interp.variables.set('Timer', ceramic.Timer);
        interp.variables.set('Touch', ceramic.Touch);
        interp.variables.set('Touches', ceramic.Touches);
        interp.variables.set('TouchInfo', ceramic.TouchInfo);
        interp.variables.set('TrackEntities', ceramic.TrackEntities);
        interp.variables.set('TrackerBackend', ceramic.TrackerBackend);
        interp.variables.set('Transform', ceramic.Transform);
        interp.variables.set('TransformPool', ceramic.TransformPool);
        interp.variables.set('Triangle', ceramic.Triangle);
        interp.variables.set('Triangulate', ceramic.Triangulate);
        interp.variables.set('TriangulateMethod', ceramic.TriangulateMethod);
        interp.variables.set('Tween', ceramic.Tween);
        interp.variables.set('Utils', ceramic.Utils);
        interp.variables.set('ValueEntry', ceramic.ValueEntry);
        interp.variables.set('Velocity', ceramic.Velocity);
        interp.variables.set('Visual', ceramic.Visual);
        interp.variables.set('VisualArcadePhysics', ceramic.VisualArcadePhysics);
        interp.variables.set('VisualNapePhysics', ceramic.VisualNapePhysics);
        interp.variables.set('VisualTransition', ceramic.VisualTransition);
        interp.variables.set('WatchDirectory', ceramic.WatchDirectory);

    }

}