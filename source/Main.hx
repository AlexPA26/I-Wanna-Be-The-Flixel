import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import levels.chapters.datachapter.ChapterState;
import gui.MenuState;
import openfl.Lib;

class Main extends Sprite
{


	public function new()
	{
		super();

		var gameWidth:Int = 1280;
		var gameHeight:Int = 720;
		var initialState = MenuState;
		var debugState = ChapterState;
		var zoom:Float = 1;
		var refreshRate:Int = Lib.current.stage.window.displayMode.refreshRate;
		if (refreshRate <= 0) refreshRate = 60;
		var updateFramerate:Int = refreshRate;
		var drawFramerate:Int = refreshRate;
		var skipSplash:Bool = true;
		var startFullscreen:Bool = false;

		#if html5
			var document = js.Browser.document;
			document.addEventListener("contextmenu", function(e:js.html.Event) { e.preventDefault(); });
		#end
		
		#if !debug
			addChild(new FlxGame(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen));
			flixel.FlxG.fixedTimestep = true;
		#if !mobile
			addChild(new FPS(10, 10, 0xffffff));
		#end

		flixel.FlxG.autoPause = false;
		#end
		
	}
}
