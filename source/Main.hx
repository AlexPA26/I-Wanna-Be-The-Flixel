package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import levels.debuglevels.StageDebugMID;
import levels.debuglevels.StageDebugUP;
import levels.debuglevels.StageDebugRIGHT;
import levels.debuglevels.StageDebugDOWN;
import levels.debuglevels.StageDebugLEFT;
import levels.worldtest.Stage01;

class Main extends Sprite
{
	public function new()
	{
		super();

		#if !debug
		addChild(new FlxGame(0, 0, MenuState, 60, 60, true, false));
		addChild(new FPS(10, 10, 0xffffff));
		flixel.FlxG.autoPause = false;
		#end

		#if debug
		addChild(new FlxGame(0, 0, Stage01, 60, 60, true, false));
		// addChild(new FPS(10, 10, 0xffffff));
		flixel.FlxG.autoPause = false;
		#end
		
	}
}
