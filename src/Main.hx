package;

import game.GameCore;
import lime.graphics.RenderContext;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.WindowAttributes;
import openfl.display.Stage;
import sys.io.FileInput;

import haxe.io.Bytes;
import lime.ui.KeyCode;


#if (windows || linux || macos || osx)
import sys.FileSystem;
import sys.io.File;
#end

#if js
import js.Browser;
#end

import lime.utils.Bytes;
import lime.utils.Assets;
import lime.app.Application;
import lime.ui.KeyCode;

import haxe.ui.Toolkit;

class Main extends Application 
{
	
	var gamecore:GameCore;
	var closeAfterLaunch:Bool = true;
	
	var entryway:Stage;
	
	public function new () {
		super();
	}
	
	override public function onWindowCreate():Void 
	{
		super.onWindowCreate();
		
		window.frameRate = 30;
		
		window.width = 640;
		window.height = 480;
		
		entryway = new Stage(this.window, 0xCCCCCC);
		addModule(entryway);
		
		build_ui();
	}
	
	function build_ui() 
	{
		Toolkit.init();
		
		var wadlist:Array<String> = new Array();
		
		#if !sys
		
		#else
		
		var templist:Array<String> = new Array(); 
		
		var env = Sys.environment();
		
		if (env["DOOMWADDIR"] != null) {
			templist = FileSystem.readDirectory(env["DOOMWADDIR"]);
		}
		
		for (wad in templist) {
			var name = wad.toUpperCase();
			if (name.lastIndexOf(".WAD") != -1) {
				var iwad:Bool = verify_iwad(File.read(env["DOOMWADDIR"] + "/" + wad, true));
				if (iwad) {
					wadlist.push(env["DOOMWADDIR"] + "/" + wad);
				}
			}
		}
		
		trace(wadlist);
		
		#end
	}
	
	function verify_iwad(read:sys.io.FileInput):Bool
	{
		var file = read;
		if (file.readString(4) == "IWAD") return true;
		else return false;
	}
	
	override public function render(context:RenderContext):Void 
	{
		super.render(context);
	}
	
	function launchGame() {
		gamecore = new GameCore(this, {});
		if (closeAfterLaunch) {
			this.window.close();
		}
	}
	
	/*override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyUp(keyCode, modifier);
		
		switch(keyCode) {
			
			case KeyCode.SPACE :
			
			case KeyCode.TAB :
				Environment.IS_IN_AUTOMAP = !Environment.IS_IN_AUTOMAP;
				
				Environment.NEEDS_TO_REBUILD_AUTOMAP = true;
				
			case KeyCode.NUMBER_1 :
				hxdoom.loadMap(0);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_2 :
				hxdoom.loadMap(1);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_3 :
				hxdoom.loadMap(2);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_4 :
				hxdoom.loadMap(3);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_5 :
				hxdoom.loadMap(4);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_6 :
				hxdoom.loadMap(5);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_7 :
				hxdoom.loadMap(6);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_8 :
				hxdoom.loadMap(7);
				gl_scene.programMapGeometry.buildMapGeometry();
			case KeyCode.NUMBER_9 :
				hxdoom.loadMap(8);
				gl_scene.programMapGeometry.buildMapGeometry();
				
			case KeyCode.LEFT:
				Environment.PLAYER_TURNING_LEFT = false;
			case KeyCode.RIGHT :
				Environment.PLAYER_TURNING_RIGHT = false;
			case KeyCode.UP | KeyCode.W :
				Environment.PLAYER_MOVING_FORWARD = false;
			case KeyCode.DOWN | KeyCode.S :
				Environment.PLAYER_MOVING_BACKWARD = false;
				
			case KeyCode.I :
				Environment.SCREEN_DISTANCE_FROM_VIEWER += 15;
				trace(Environment.SCREEN_DISTANCE_FROM_VIEWER);
			case KeyCode.K :
				Environment.SCREEN_DISTANCE_FROM_VIEWER -= 15;
				trace(Environment.SCREEN_DISTANCE_FROM_VIEWER);
			
			default :
				trace (keyCode);
		}
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(keyCode, modifier);
		
		switch(keyCode) {
			case KeyCode.LEFT :
				Environment.PLAYER_TURNING_LEFT = true;
			case KeyCode.RIGHT :
				Environment.PLAYER_TURNING_RIGHT = true;
			case KeyCode.UP | KeyCode.W :
				Environment.PLAYER_MOVING_FORWARD = true;
			case KeyCode.DOWN | KeyCode.S :
				Environment.PLAYER_MOVING_BACKWARD = true;
			default :
				
		}
		
		
		#if !html5
		Engine.CHEATS.logKeyStroke(String.fromCharCode(keyCode));
		#end
		
		//JS throws errors here, find an alternative method?
	}*/
	
	/*override public function onMouseWheel(deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void 
	{
		super.onMouseWheel(deltaX, deltaY, deltaMode);
		
		var mxa:Float = 
		Environment.AUTOMAP_ZOOM += (0.0001 * deltaY) / (1 / Environment.AUTOMAP_ZOOM / 200);
	}*/
	
	public static function getWadDir() {
		
	}
}