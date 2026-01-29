package leveldata;

import flixel.FlxSprite;
using flixel.util.FlxDirectionFlags;
using flixel.FlxG;

class FallingBlock extends FlxSprite
{
    var moveDir:String;
    var speed:Float = 600;
    var activeMoving:Bool = false;

    public function new(X:Float, Y:Float, MoveDir:String)
    {
        super(X, Y);
        loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
        offset.set(0, 0);
        animation.frameIndex = 39;
        
        this.moveDir = MoveDir;
        immovable = true;
    }

    override public function update(elapsed:Float):Void
    {
        if (!activeMoving && touching.has(FlxDirectionFlags.UP))
        {
            activeMoving = true;
        }

        if (activeMoving)
        {
            switch (moveDir)
            {
                case "up":    velocity.y = -600;
                case "down":  velocity.y = 600;
                case "left":  velocity.x = -600;
                case "right": velocity.x = 600;
            }
        }

        if (x < -100 || x > 2000 || y < -100 || y > 2000) { kill(); }

        super.update(elapsed);
        
        touching = FlxDirectionFlags.NONE;
    }
}