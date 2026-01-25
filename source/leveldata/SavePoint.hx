package leveldata;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class SavePoint extends FlxSprite
{
    public function new(x:Float, y:Float)
        {
        super(x, y);
        loadGraphic(AssetPaths.save__png, false, 50, 50);
        FlxTween.tween(this, {y: y - 5}, 1, {type: PINGPONG, ease: FlxEase.sineInOut});
        }
}