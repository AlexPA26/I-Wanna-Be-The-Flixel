package leveldata.hazards;

import flixel.FlxSprite;

class YellowLaser extends FlxSprite
{
    public function new(X:Float, Y:Float, Direction:String)
    {
        super(X, Y);

        loadGraphic(AssetPaths.laser__png, true, 50, 50);
        
        animation.add("horizontal", [0, 1, 2, 3, 4, 5], 12, true);
        animation.add("vertical", [6, 7, 8, 9, 10, 11], 12, true);
        animation.add("horizontalOFF", [14, 15], 3, true);
        animation.add("verticalOFF", [12, 13], 3, true);

        if (Direction == "v") 
        {
            width = 8; height = 50; offset.set(20, 0);
            x += offset.x;
            y += offset.y;
            animation.play("vertical");
        }
        else if (Direction == "h")
        {
            width = 50; height = 8;  offset.set(0, 20);
            x += offset.x;
            y += offset.y;
            animation.play("horizontal");
        }

        else if (Direction == "voff")
        {
            width = 0; height = 0; offset.set(0, 0);
            x += offset.x;
            y += offset.y;
            animation.play("verticalOFF");
            allowCollisions = NONE;
        }

        else if (Direction == "hoff")
        {
            width = 0; height = 0;  offset.set(0, 0);
            x += offset.x;
            y += offset.y;
            animation.play("horizontalOFF");
            allowCollisions = NONE;
        }

        immovable = true;
    }
}