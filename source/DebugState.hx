package;

import flixel.FlxG;
import flixel.FlxState;
import levels.debuglevels.StageDebugMID;
import levels.debuglevels.StageDebugUP;
import levels.debuglevels.StageDebugRIGHT;
import levels.debuglevels.StageDebugDOWN;
import levels.debuglevels.StageDebugLEFT;

class DebugState extends FlxState
{        
    override public function create():Void
    {
        super.create();
        
        FlxG.switchState(() -> new StageDebugMID());

    }

    override public function update(elapsed:Float):Void

    {
        
        super.update(elapsed);
        
    }
}