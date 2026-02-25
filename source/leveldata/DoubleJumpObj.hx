package leveldata;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class DoubleJumpObj extends FlxSprite
{
    public function new(x:Float, y:Float)
        {
        super(x, y);
        loadGraphic(AssetPaths.double_jump__png, false, 32, 32);
        FlxTween.tween(this, {y: y - 5}, 0.5, {type: PINGPONG, ease: FlxEase.sineInOut});
        }
}