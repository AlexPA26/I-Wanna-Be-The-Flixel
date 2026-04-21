package leveldata.hazards;

import flixel.FlxSprite;

class SmallSpike extends FlxSprite
{
    public function new(X:Float, Y:Float, LocalID:Int)
    {
        super(X, Y);

        loadGraphic(AssetPaths.small_spikes__png, true, 25, 25);
        this.animation.frameIndex = LocalID;

        switch (LocalID)
        {
            case 0: // // SPIKE ARRIBA
                width = 23; height = 15; offset.set(2, 10); 
            
            case 1: // // SPIKE DERECHA
                width = 18; height = 20; offset.set(0, 3);

            case 2: // SPIKE ABAJO
                width = 23; height = 20; offset.set(2, 0);

            case 3: // SPIKE IZQUIERDA
                width = 20; height = 23; offset.set(5, 3);
        }

        x += offset.x;
        y += offset.y;

        immovable = true;
    }
}