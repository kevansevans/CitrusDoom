package;

import game.GameCore;
import haxe.Http;
import haxe.Json;
import haxe.ui.components.Button;
import haxe.ui.components.DropDown;
import haxe.ui.components.HorizontalProgress;
import haxe.ui.components.Label;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.UIEvent;
import haxe.zip.Reader;
import haxe.zip.Uncompress;
import haxe.zip.Entry;
import lime.graphics.RenderContext;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.WindowAttributes;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import lime.net.HTTPRequest;

import openfl.display.Stage;

import haxe.io.Bytes;
import lime.ui.KeyCode;


#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
#else
import lime.utils.Assets;
#end

#if js
import js.Browser;
#end

import lime.utils.Bytes;
import lime.app.Application;
import lime.ui.KeyCode;

import haxe.ui.Toolkit;

class Main extends Application 
{
	
	var gamecore:GameCore;
	var closeAfterLaunch:Bool = true;
	var multiwad:Bool;
	var haswad:Bool = false;
	
	var entryway:Stage;
	
	#if sys
	var pathlist:Map<String, String>;
	#end
	
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
		getwads();
	}
	
	var root_vbox:HBox = new HBox();
	var taskbox:VBox;
	var leftbox:VBox;
	var rightbox:VBox;
	var grabwads:Button;
	var iwad_selector:DropDown;
	var wadDataSource:ArrayDataSource<String> = new ArrayDataSource();
	function build_ui() 
	{
		Toolkit.init();
		
		entryway.addChild(root_vbox);
		root_vbox.x = root_vbox.y = 5;
		
		leftbox = new VBox();
		rightbox = new VBox();
		leftbox.width = rightbox.width = 200;
		root_vbox.addComponent(leftbox);
		root_vbox.addComponent(rightbox);
		
		taskbox = new VBox();
		rightbox.addComponent(taskbox);
		
		iwad_selector = new DropDown();
		leftbox.addComponent(iwad_selector);
		
		grabwads = new Button();
		grabwads.text = "Update Wad List";
		grabwads.onClick = function(e:UIEvent) {
			grabwads.disabled = true;
			download_wads();
		}
		leftbox.addComponent(grabwads);
		
		iwad_selector.disabled = true;
		iwad_selector.width = 150;
	}
	
	function getwads()
	{
		
		var wadlist:Array<String> = new Array();
		
		#if !sys
		
		var shareware = Assets.getBytes("IWADS/DOOM1.WAD");
		multiwad = false;
		
		#else
		
		var templist:Array<String> = new Array();
		pathlist = new Map();
		
		var env = Sys.environment();
		
		if (env["DOOMWADDIR"] != null) {
			templist = FileSystem.readDirectory(env["DOOMWADDIR"]);
		}
		
		for (wad in templist) {
			var name = wad.toUpperCase();
			if (name.lastIndexOf(".WAD") != -1) {
				var iwad:Bool = verify_iwad(File.read(env["DOOMWADDIR"] + "/" + wad, true));
				if (iwad) {
					haswad = true;
					pathlist[wad] = env["DOOMWADDIR"] + "/" + wad;
				}
			}
		}
		
		multiwad = true;
		
		wadDataSource = new ArrayDataSource();
		for (wad in pathlist.keys()) {
			wadDataSource.add(wad);
		}
		if (wadDataSource.size != 0) {
			iwad_selector.disabled = false;
			iwad_selector.value = "Select Wad...";
		} else {
			wadDataSource.add("No IWADS found");
			iwad_selector.disabled = true;
		}
		iwad_selector.dataSource = wadDataSource;
		
		#end
	}
	
	#if sys
	function verify_iwad(read:sys.io.FileInput):Bool
	{
		var file = read;
		if (file.readString(4) == "IWAD") return true;
		else return false;
	}
	
	var pendingdownload:Int = 0;
	
	function download_wads() {
		
		var env = Sys.environment();
		if (env["DOOMWADDIR"] == null) {
			Sys.putEnv("DOOMWADDIR", Sys.programPath());
		}
		
		if (!FileSystem.isDirectory(env["DOOMWADDIR"] + "/downloads/")) FileSystem.createDirectory(env["DOOMWADDIR"] + "/downloads/");
		
		var freedoom_github = new Http("https://api.github.com/repos/freedoom/freedoom/releases/latest");
		//haxe you fucking crybaby
		freedoom_github.onData = function(_packet:String) {
			var data:Dynamic = Json.parse(_packet);
			for (index in 0...(Std.int(data.assets.length - 1))) {
				download_file(data.assets[index].browser_download_url, env["DOOMWADDIR"] + "/downloads/", data.assets[index].name);
			}
		}
		freedoom_github.onError = function(_packet:String) {
			return null;
		}
		freedoom_github.onStatus = function(_packet:Int) {
			trace(_packet);
		}
		freedoom_github.setHeader('User-Agent', 'CitrusDoom');
		freedoom_github.request();
		
		download_file('http://distro.ibiblio.org/pub/linux/distributions/slitaz/sources/packages/d/doom1.wad', env["DOOMWADDIR"], "doom1.wad");
	}
	
	function download_file(_url:String, _path:String, _name:String) {
		
		++pendingdownload;
		
		var label = new Label();
		var bar = new HorizontalProgress();
		label.value = _name;
		taskbox.addComponent(label);
		taskbox.addComponent(bar);
		
		var file = File.write(_path + "/" + _name);
		var httpfile = new HTTPRequest<Bytes>(_url);
		httpfile.followRedirects = true;
		httpfile.load().onError(function (_msg) 
		{
			trace(_msg);
			--pendingdownload;
			checkifstilldownloading();
		}).onProgress(function(loaded, total)
		{
			bar.max = total;
			bar.value = loaded;
		}).onComplete(function (bytes:Bytes) {
			file.write(bytes);
			file.close();
			taskbox.removeComponent(bar);
			taskbox.removeComponent(label);
			--pendingdownload;
			checkifstilldownloading();
		});
	}
	
	function checkifstilldownloading() {
		if (pendingdownload == 0) {
			grabwads.disabled = false;
			process_downloads();
		}
	}
	
	function process_downloads() 
	{
		var env = Sys.environment();
		var downloads = FileSystem.readDirectory(env["DOOMWADDIR"] + "/downloads/");
		for (item in downloads) {
			if (item.indexOf(".zip", item.length - 4) != -1) {
				var zip = File.read(env["DOOMWADDIR"] + "/downloads/" + item);
				var entries = Reader.readZip(zip);
				var redist_path:String = "";
				for (entry in entries) {
					var path = env["DOOMWADDIR"];
					if (entry.fileName.indexOf("/", entry.fileName.length - 1) != -1) {
						redist_path = entry.fileName;
					}
					else if (entry.fileName.indexOf(".wad") != -1 || entry.fileName.indexOf(".WAD") != -1) {
						if (FileSystem.exists(path + "/" + entry.fileName)) FileSystem.deleteFile(path + "/" + entry.fileName);
						var itemname = entry.fileName;
						itemname = itemname.substring(itemname.indexOf("/") + 1, itemname.length);
						var fileout = File.write(path + "/" + itemname);
						fileout.write(cust_unzip(entry));
						fileout.close();
					}
					else if ((item.indexOf("freedm") != -1 || item.indexOf("freedoom") != -1) && entry.fileName.indexOf("/", entry.fileName.length -1) == -1) {
						path = env["DOOMWADDIR"] + "/freedoom redist/";
						if (!FileSystem.isDirectory(path + redist_path)) FileSystem.createDirectory(path + redist_path);
						if (FileSystem.exists(path + redist_path + entry.fileName)) FileSystem.deleteFile(path + redist_path + entry.fileName);
						var fileout = File.write(path + entry.fileName);
						fileout.write(cust_unzip(entry));
						fileout.close();
					}
				}
				zip.close();
			}
			FileSystem.deleteFile(env["DOOMWADDIR"] + "/downloads/" + item);
		}
		FileSystem.deleteDirectory(env["DOOMWADDIR"] + "/downloads");
		getwads();
	}
	
	function cust_unzip(f:Entry) {
		//Lime override's Haxe's normal reader function, this is just a copy and paste of it
		if (!f.compressed)
			return f.data;
		var c = new haxe.zip.Uncompress(-15);
		var s = haxe.io.Bytes.alloc(f.fileSize);
		var r = c.execute(f.data, 0, s, 0);
		c.close();
		if (!r.done || r.read != f.data.length || r.write != f.fileSize)
			throw "Invalid compressed data for " + f.fileName;
		f.compressed = false;
		f.dataSize = f.fileSize;
		f.data = s;
		return f.data;
	}
	
	#end
	
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