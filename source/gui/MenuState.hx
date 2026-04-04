package gui;

import levels.chapters.datachapter.ChapterState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.ui.FlxButton;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import PlayerData;
import leveldata.misc.SaveManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class MenuState extends FlxState
{
    var scanline:FlxBackdrop;
    var titleText:FlxText;
	var versionText:FlxText;
    var vignite:FlxSprite;
    var logo:FlxSprite;
    var effectLogo:FlxEffectSprite;
    var glitchEffect:FlxGlitchEffect;

	var btnNewGame:FlxButton;
    var btnContinue:FlxButton;
	var btnExit:FlxButton;

    var outlineColors:Array<FlxColor> =
	[
        FlxColor.RED, FlxColor.GREEN, FlxColor.BLUE, FlxColor.YELLOW, FlxColor.CYAN
    ];

    override public function create():Void
    {
		FlxG.mouse.visible = true;

        scanline = new FlxBackdrop(AssetPaths.scanline__png, Y);
        scanline.velocity.set(0, 40);
        scanline.scrollFactor.set(0, 0);
        scanline.alpha = 0.1;
        add(scanline);

        titleText = new FlxText(0, 75, FlxG.width, "I Wanna Be The Flixel");
        titleText.setFormat(null, 60, FlxColor.WHITE, CENTER);
        titleText.setBorderStyle(OUTLINE, FlxColor.RED, 2);
		titleText.y = 75;
        add(titleText);

		versionText = new FlxText(0, 100, FlxG.width, "v.0.1.3");
        versionText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        versionText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		versionText.x = 350;
		versionText.y = 145;
        add(versionText);

        new FlxTimer().start(1, function(tmr:FlxTimer)
		{
            titleText.borderColor = FlxG.random.getObject(outlineColors);
        }, 0);

        logo = new FlxSprite();
        logo.loadGraphic(AssetPaths.haxeflixelLogo__png);
		logo.updateHitbox();

        effectLogo = new FlxEffectSprite(logo);
        glitchEffect = new FlxGlitchEffect(10, 2, 0.035);
        effectLogo.effects = [glitchEffect];
        effectLogo.x = 560;
		effectLogo.y = 150;
		effectLogo.scale.set(0.75, 0.75);
        add(effectLogo);

		btnNewGame = new FlxButton(0, 200, "New Game", clickNewGame);
        btnNewGame.screenCenter(X);
        btnNewGame.x = 300;
		btnNewGame.y = 230;
        customizeButton(btnNewGame);
        add(btnNewGame);

        btnContinue = new FlxButton(0, 400, "Continue", clickContinue);
        btnContinue.screenCenter(X);
        btnContinue.x = 300;
		btnContinue.y = 300;
        customizeButton(btnContinue);
        add(btnContinue);

		btnExit = new FlxButton(0, 400, "Quit Game", clickQuit);
        btnExit.screenCenter(X);
        btnExit.x = 300;
		btnExit.y = 470;
        customizeButton(btnExit);
        add(btnExit);

		vignite = new FlxSprite();
		vignite.loadGraphic(AssetPaths.vigniteTitle__png, false);
		vignite.scrollFactor.set(0, 0);
		vignite.screenCenter();
		vignite.alpha = 0.5;
		add(vignite);

		playMenuMusic();

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.random.bool(10))
		{
            glitchEffect.strength = FlxG.random.int(5, 20);
        }
		
		else
		{
            glitchEffect.strength = 3;
        }

        scanline.alpha = 0.1 - (Math.random() * 0.05);
		effectLogo.alpha = 0.65 - (Math.random() * 0.2);
    }

	function clickNewGame():Void
    {
        PlayerData.currentRoom = "map01";
        PlayerData.spawnX = 300;
        PlayerData.spawnY = 400;
        PlayerData.totalDeaths = 0;
        
        FlxG.switchState(ChapterState.new);
    }

    function clickContinue():Void
    {
        if (SaveManager.loadGame()) 
        {
            FlxG.switchState(ChapterState.new);
        }
        else 
        {
            btnContinue.color = FlxColor.GRAY;
            FlxG.camera.shake(0.01, 0.1);
        }
    }

	function customizeButton(btn:FlxButton):Void
	{
		if (btn.label != null) 
		{
			btn.label.setFormat(null, 28, FlxColor.WHITE, CENTER);
			btn.label.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		}

		btn.makeGraphic(200, 60, FlxColor.TRANSPARENT); 
	}

	function playMenuMusic():Void
	{
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(AssetPaths.mainMenu__ogg, 0.7, false);
		}
	}

	function clickQuit():Void
{
    #if sys
        Sys.exit(0);
    #else
        trace("Quit not supported on this platform.");
    #end
}

}