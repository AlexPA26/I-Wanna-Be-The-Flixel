package leveldata.events;

import flixel.FlxObject;

class WarpTrigger extends FlxObject
{
    public var newChapter:String = "";
    public var targetRoom:String;
    public var direction:String;

    public function new(X:Float, Y:Float, W:Float, H:Float, Target:String, Direction:String)
    {
        super(X, Y, W, H);
        this.targetRoom = Target;
        this.direction = Direction;
    }
}