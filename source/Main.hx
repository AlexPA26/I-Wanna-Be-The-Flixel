package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import levels.chapters.chapter1.Chapter1State;

class Main extends Sprite
{
	public function new()
	{
		super();

		#if !debug
		addChild(new FlxGame(0, 0, Chapter1State, 60, 60, true, false));
		addChild(new FPS(10, 10, 0xffffff));
		flixel.FlxG.autoPause = false;
		#end

		#if debug
		addChild(new FlxGame(0, 0, Chapter1State, 60, 60, true, false));
		addChild(new FPS(10, 10, 0xFFFFFF));
		flixel.FlxG.autoPause = false;
		#end
		
	}
}
