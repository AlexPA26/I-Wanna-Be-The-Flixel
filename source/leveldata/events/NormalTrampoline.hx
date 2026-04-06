package leveldata.events;   

import flixel.FlxSprite;

class NormalTrampoline extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic(AssetPaths.trampoline__png, true, 50, 50);
        
        animation.add("idle", [0], 0, false);
        animation.add("jump", [2, 1, 0], 16, false);
        animation.play("idle");

        immovable = true;
    }

    public function launch():Void
    {
        animation.play("jump");
    }
}