package leveldata;

import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;

class NormalSlab extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        
        loadGraphic(AssetPaths.slab__png, false, 50, 50);

        immovable = true;
        allowCollisions = UP; 
    }
}