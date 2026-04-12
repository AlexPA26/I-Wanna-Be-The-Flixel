package leveldata.blockdata;

import flixel.FlxSprite;

class NormalSlab extends FlxSprite
{
    public function new(x:Float, y:Float, TileID:Int)
    {
        super(x, y);
        // This combines normal slab, night and poison lol
        loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
        offset.set(0, 0);
        animation.frameIndex = TileID;
        immovable = true;
        allowCollisions = UP; 
    }
}