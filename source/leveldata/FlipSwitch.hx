package leveldata;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class FlipSwitch extends FlxSprite
{
	var onTweenComplete(default, null):Null<TweenCallback>;
    public function new(x:Float, y:Float)
        {
        super(x, y);
        loadGraphic(AssetPaths.flip__png, false, 32, 32);
        FlxTween.tween(this, {y: y - 5}, 0.5, {type: PINGPONG, ease: FlxEase.sineInOut});
        }
}