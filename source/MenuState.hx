package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.system.System;

class MenuState extends FlxState
{
	
	var isActivaGlobal:Bool = false;
	var isActiveStart:Bool = false;
	var isActiveOption:Bool = false;
	var isActiveQuit:Bool = false;
	var isActiveDebug:Bool = false;

	var tituloTexto:FlxText;
	var botonStart:FlxSprite;
	var botonStartText:FlxText;
	var botonOption:FlxSprite;
	var botonOptionText:FlxText;
	var botonQuit:FlxSprite;
	var botonQuitText:FlxText;
	var botonDebug:FlxSprite;
	var botonDebugText:FlxText;

	var timeclock:FlxText;

	override public function create()
	{
		super.create();

		// #########################
		// ######TEXTO TITULO#######
		// #########################

		tituloTexto = new FlxText("Juego EPICO");
		tituloTexto.size = 64;
		tituloTexto.color = FlxColor.ORANGE;
		tituloTexto.setBorderStyle(OUTLINE, FlxColor.WHITE, 6);

		tituloTexto.screenCenter();
		tituloTexto.y -= 200; // Importante!!!!11
		add(tituloTexto);

		// #########################
		// ######BOTON START########
		// #########################

		botonStart = new FlxSprite();

		botonStart.loadGraphic(AssetPaths.buttonTitleV2__png, true, 444, 58);
		botonStart.animation.add("normal", [0], 1, false);
		botonStart.animation.add("active", [1], 1, false);
		botonStart.animation.play("normal");

		botonStart.screenCenter();
		botonStart.updateHitbox();
		botonStart.y += 30;
		add(botonStart);

		// #########################
		// #######TEXTO START#######
		// #########################

		botonStartText = new FlxText("[1] Start");
		botonStartText.size = 16;
		botonStartText.color = FlxColor.WHITE;
		botonStartText.screenCenter();
		botonStartText.y += 30;
		add(botonStartText);

		// #########################
		// ######BOTON OPTION#######
		// #########################

		botonOption = new FlxSprite();

		botonOption.loadGraphic(AssetPaths.buttonTitleV2__png, true, 444, 58);
		botonOption.animation.add("normal", [0], 1, false);
		botonOption.animation.add("active", [1], 1, false);
		botonOption.animation.play("normal");

		botonOption.screenCenter();
		botonOption.updateHitbox();
		botonOption.y += 100;
		add(botonOption);

		// #########################
		// #######TEXTO OPTION######
		// #########################

		botonOptionText = new FlxText("[2] Game Options");
		botonOptionText.size = 16;
		botonOptionText.color = FlxColor.WHITE;
		botonOptionText.screenCenter();
		botonOptionText.y += 100;
		add(botonOptionText);

		// #########################
		// #######QUIT  OPTION######
		// #########################

		botonQuit = new FlxSprite();

		botonQuit.loadGraphic(AssetPaths.miniClickV2__png, true, 213, 58);
		botonQuit.animation.add("normal", [0], 1, false);
		botonQuit.animation.add("active", [1], 1, false);
		botonQuit.animation.play("normal");

		botonQuit.screenCenter();
		botonQuit.updateHitbox();
		botonQuit.x += 115;
		botonQuit.y += 170;
		add(botonQuit);

		// #########################
		// #######TEXTO QUIT########
		// #########################

		botonOptionText = new FlxText("[ESC] Quit Game");
		botonOptionText.size = 16;
		botonOptionText.color = FlxColor.WHITE;
		botonOptionText.screenCenter();
		botonOptionText.x += 115;
		botonOptionText.y += 170;
		add(botonOptionText);

		// #########################
		// #######????  OPTION######
		// #########################

		botonDebug = new FlxSprite();

		botonDebug.loadGraphic(AssetPaths.miniClickV2__png, true, 213, 58);
		botonDebug.animation.add("normal", [0], 1, false);
		botonDebug.animation.add("active", [1], 1, false);
		botonDebug.animation.play("normal");

		botonDebug.screenCenter();
		botonDebug.updateHitbox();
		botonDebug.x -= 115;
		botonDebug.y += 170;
		add(botonDebug);

		// #########################
		// #######TEXTO ????########
		// #########################

		botonDebugText = new FlxText("[3] Debug");
		botonDebugText.size = 16;
		botonDebugText.color = FlxColor.WHITE;
		botonDebugText.screenCenter();
		botonDebugText.x -= 115;
		botonDebugText.y += 170;
		add(botonDebugText);

		// #########################
		// #######HORA ACTUAL#######
		// #########################

		timeclock = new FlxText("00:00:00");
		timeclock.size = 20;
		timeclock.color = FlxColor.WHITE;
		timeclock.setBorderStyle(OUTLINE, FlxColor.RED, 2);
		timeclock.screenCenter();
		timeclock.x -= 570;
		timeclock.y += 340;
		add(timeclock);	

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// HACER CURSOR CUSTOM!!!!!!111
		checkTituloTexto();
		// checkTituloShadow();
		checkBotonOption();
		checkBotonStart();
		checkBotonQuit();
		checkBotonDebug();

	}

		// #########################
		// ########FUNCIONES########
		// #########################


function checkBotonStart():Void
{
    if (FlxG.keys.justPressed.ONE)
    {
        isActiveStart = !isActiveStart;
		isActiveDebug = false;
		isActiveOption = false;
		isActiveQuit = false;
    }


    if (FlxG.mouse.overlaps(botonStart) || isActiveStart)
    {
        botonStart.animation.play("active");

        if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)

        {
            openSubState(new LoadingState());
        }
    }
    else
    {

        botonStart.animation.play("normal");
    }


}

function checkBotonOption():Void
{
    if (FlxG.keys.justPressed.TWO)
    {
        isActiveOption = !isActiveOption;
		isActiveDebug = false;
		isActiveStart = false;
		isActiveQuit = false;
    }

    if (FlxG.mouse.overlaps(botonOption) || isActiveOption)
    {
        botonOption.animation.play("active");

        if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)

        {
			
            openSubState(new OptionsTitleState());
        }
    }
    else
    {

        botonOption.animation.play("normal");
    }


}

function checkBotonQuit():Void
{
    if (FlxG.keys.justPressed.ESCAPE)
    {
        isActiveQuit = !isActiveQuit;
		isActiveDebug = false;
		isActiveStart = false;
		isActiveOption = false;
    }

    if (FlxG.mouse.overlaps(botonQuit) || isActiveQuit)
    {
        botonQuit.animation.play("active");

        if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)

        {
            System.exit(0);
        }
    }
    else
    {

        botonQuit.animation.play("normal");
    }


}

function checkBotonDebug():Void
{
    if (FlxG.keys.justPressed.THREE)
    {
        isActiveDebug = !isActiveDebug;
		isActiveOption = false;
		isActiveStart = false;
		isActiveQuit = false;
    }

    if (FlxG.mouse.overlaps(botonDebug) || isActiveDebug)
    {
        botonDebug.animation.play("active");

        if (FlxG.mouse.justPressed || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
			
        {
            FlxG.switchState(() -> new DebugState());
        }
    }
    else
    {

        botonDebug.animation.play("normal");
    }

}

function checkTituloTexto():Void
{
		if (FlxG.mouse.overlaps(tituloTexto))
		{
			tituloTexto.color = FlxColor.YELLOW;
		}

		else
		{
			tituloTexto.color = FlxColor.ORANGE;
		}
}



}
