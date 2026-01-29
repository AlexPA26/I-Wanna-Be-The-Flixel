package leveldata;

import flixel.FlxSprite;

class LightTorch extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic(AssetPaths.light__png, true, 200, 200);
        offset.set(-100, -100);
        immovable = true;
    }

    override function update(elapsed:Float):Void
        {
            super.update(elapsed);
            alpha = 1 - Math.random() * 0.2;
    }

}