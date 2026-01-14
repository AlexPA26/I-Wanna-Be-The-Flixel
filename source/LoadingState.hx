package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;

class LoadingState extends FlxSubState
{

    var fill:FlxSprite;
	
	override public function create()
	{
		super.create();


        fill = new FlxSprite();
        fill.makeGraphic(1280, 720, FlxColor.BLACK);
        fill.screenCenter();
        fill.alpha = 0;
        add(fill);

	}

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (fill.alpha <= 1)
        {
            fill.alpha = fill.alpha + 0.1;
        }

        if (fill.alpha == 1)
        {
            FlxG.switchState(() -> new DebugState());
            close();
        }

        



}
}