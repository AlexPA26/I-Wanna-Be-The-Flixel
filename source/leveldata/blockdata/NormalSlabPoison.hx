package leveldata.blockdata;

import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;

class NormalSlabPoison extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        loadGraphic(AssetPaths.slabPoison__png, false, 50, 50);

        immovable = true;
        allowCollisions = UP; 
    }
}