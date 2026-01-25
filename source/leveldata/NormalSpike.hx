package leveldata;

import flixel.FlxSprite;

class NormalSpike extends FlxSprite
{
    public function new(X:Float, Y:Float, LocalID:Int)
    {
        super(X, Y);

        loadGraphic(AssetPaths.spikes__png, true, 50, 50);
        this.animation.frameIndex = LocalID;

        switch (LocalID)
        {
            case 0: // // SPIKE ARRIBA
                width = 45; height = 25; offset.set(2, 25); 
            
            case 1: // // SPIKE DERECHA
                width = 35; height = 35; offset.set(0, 8);

            case 2: // SPIKE ABAJO
                width = 35; height = 35; offset.set(8, 0);

            case 3: // SPIKE IZQUIERDA
                width = 35; height = 35; offset.set(12, 10);

            case 4: // SPIKE SMOL ARRIBA
                width = 30; height = 15; offset.set(10, 32);

            case 5: // SPIKE SMOL DERECHA
                width = 15; height = 30; offset.set(0, 10);

            case 6: // SPIKE SMOL ABAJO
                width = 30; height = 15; offset.set(10, 0);

            case 7: // SPIKE SMOL IZQUIERDA
                width = 15; height = 30; offset.set(33, 10);
        }

        x += offset.x;
        y += offset.y;

        immovable = true;
    }
}