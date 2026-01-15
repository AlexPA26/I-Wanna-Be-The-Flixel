package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PauseState extends FlxSubState
{
    var closeBoton = new FlxSprite();
	var exitBoton = new FlxSprite();
	var retryBoton = new FlxSprite();

    override public function create()
    {
        FlxG.mouse.visible = true;

        var bgOption = new FlxSprite();
        var bgShader = new FlxSprite();
        var mainText = new FlxText();

        super.create();

        bgOption.loadGraphic(AssetPaths.OptionBG__png, false);
        bgOption.screenCenter();
        bgOption.alpha = 0.85;
        add(bgOption);

        bgShader.makeGraphic(1150, 630, FlxColor.BLACK);
        bgShader.screenCenter();
        bgShader.alpha = 0.5;
        add(bgShader);

        closeBoton.loadGraphic(AssetPaths.menuClose__png, true, 63, 63);
		closeBoton.animation.add("normal", [0], 1, false);
		closeBoton.animation.add("active", [1], 1, false);
		closeBoton.animation.play("normal");
        closeBoton.screenCenter();
        closeBoton.y -= 265;
        closeBoton.x += 520;
        add(closeBoton);

        mainText = new FlxText("Game Paused");
		mainText.size = 64;
		mainText.color = FlxColor.ORANGE;
        mainText.setBorderStyle(OUTLINE, FlxColor.WHITE, 6);

		mainText.screenCenter();
		mainText.y -= 200;
		add(mainText);
        
		exitBoton.loadGraphic(AssetPaths.buttonTitleV2__png, true, 213, 58);
		exitBoton.animation.add("normal", [0], 1, false);
		exitBoton.animation.add("active", [1], 1, false);
		exitBoton.animation.play("normal");
		exitBoton.screenCenter();
		exitBoton.y += 80;
		add(exitBoton);

		retryBoton.loadGraphic(AssetPaths.buttonTitleV2__png, true, 213, 58);
		retryBoton.animation.add("normal", [0], 1, false);
		retryBoton.animation.add("active", [1], 1, false);
		retryBoton.animation.play("normal");
		retryBoton.screenCenter();
		retryBoton.y -= 20;
		add(retryBoton);


        
    }

	override public function update(elapsed:Float)
	{
        super.update(elapsed);

        closeBotonMenu();

        // if (FlxG.keys.justPressed.ESCAPE)
        //     closeBoton();


    }

    function closeBotonMenu():Void
    {
        if (FlxG.mouse.overlaps(closeBoton))
        {
            closeBoton.animation.play("active");
        }

        else
        {
            closeBoton.animation.play("normal");
        }

        if (FlxG.mouse.overlaps(closeBoton) && FlxG.mouse.justPressed || FlxG.keys.justPressed.ESCAPE)
            close();

    }

	function retryBotonFunction():Void
	{
		if (FlxG.mouse.overlaps(retryBoton))
		{
			retryBoton.animation.play("active");
		}

		else
		{
			retryBoton.animation.play("normal");
		}

        if (FlxG.mouse.overlaps(retryBoton) && FlxG.mouse.justPressed)
        {
            FlxG.resetState();
            close();
        }
	}

    function exitBotonFunction():Void
    {
        if (FlxG.mouse.overlaps(exitBoton))
        {
            exitBoton.animation.play("active");
        }

        else
        {
            exitBoton.animation.play("normal");
        }
    }

}