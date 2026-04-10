package leveldata.background;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;

class AcidFluid extends FlxBackdrop
{
    public function new(scrollSpeed:Float = 40)
    {
        super(AssetPaths.acid__png, X, 0, 0);
    
        y = FlxG.height - 96;
        velocity.x = scrollSpeed;
        scrollFactor.set(0, 0); 
    }
}