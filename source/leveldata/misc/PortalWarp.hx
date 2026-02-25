package leveldata.misc;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class PortalWarp extends FlxSprite
{
	var onTweenComplete(default, null):Null<TweenCallback>;
    public function new(x:Float, y:Float)
        {
        super(x, y);
        scale.set(0.65, 0.65);
        updateHitbox();
        loadGraphic(AssetPaths.portal__png, false, 128, 128);
        FlxTween.angle(this, 0, 360, 4.0, { type: LOOPING } );

        }

    
}