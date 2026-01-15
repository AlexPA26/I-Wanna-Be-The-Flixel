package;

import flixel.FlxG;
import flixel.FlxState;
import levels.StageDebug01;

class DebugState extends FlxState
{        
    override public function create():Void
    {

        
        super.create();
        
        FlxG.switchState(() -> new StageDebug01());


    }

    override public function update(elapsed:Float):Void

    {
        
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.R) FlxG.resetState();
    }
}