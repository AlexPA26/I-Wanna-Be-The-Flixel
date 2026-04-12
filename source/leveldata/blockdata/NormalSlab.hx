package leveldata.blockdata;

import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;

class NormalSlab extends FlxSprite
{
    public function new(x:Float, y:Float, TileID:Int)
    {
        super(x, y);
        
        loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
        offset.set(0, 0);
        animation.frameIndex = TileID;
        immovable = true;
        allowCollisions = UP; 
    }
}