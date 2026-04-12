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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.ui.MouseCursor;
import flixel.system.scaleModes.RatioScaleMode;

class MenuState extends FlxState
{
    var scanline:FlxBackdrop;
    var scanline2:FlxBackdrop;
    var titleText:FlxText;
    var versionText:FlxText;
    var vignite:FlxSprite;
    var logo:FlxSprite;
    var effectLogo:FlxEffectSprite;
    var glitchEffect:FlxGlitchEffect;
    var bg:FlxSprite;

    var btnNewGame:FlxButton;
    var btnContinue:FlxButton;
    var btnExit:FlxButton;

    var activeTweens:Map<FlxButton, FlxTween> = new Map();

    var outlineColors:Array<FlxColor> =
    [
        FlxColor.RED, FlxColor.GREEN, FlxColor.BLUE, FlxColor.YELLOW, FlxColor.CYAN
    ];

    override public function create():Void
    {
        FlxG.scaleMode = new RatioScaleMode();

        #if !mobile
        FlxG.mouse.visible = true;
        FlxG.mouse.useSystemCursor = true;
        #end

        bg = new FlxSprite();
        bg.makeGraphic(1280, 720, 0xFF1B76FF, false);
        bg.screenCenter();
        bg.alpha = 0.15;
        add(bg);

        scanline = new FlxBackdrop(AssetPaths.scanline__png, Y);
        scanline.velocity.set(0, 40);
        scanline.scrollFactor.set(0, 0);
        scanline.alpha = 0.1;
        add(scanline);

        scanline2 = new FlxBackdrop(AssetPaths.scanline__png, Y);
        scanline2.velocity.set(0, 40);
        scanline2.scrollFactor.set(0, 0);
        scanline2.alpha = 0.05;
        scanline2.y = 10;
        add(scanline2);

        titleText = new FlxText(0, 75, FlxG.width, "I Wanna Be The Flixel");
        titleText.setFormat(null, 60, FlxColor.WHITE, CENTER);
        titleText.setBorderStyle(OUTLINE, FlxColor.RED, 2);
        FlxTween.tween(titleText, {y: titleText.y - 3}, 0.8, {type: PINGPONG, ease: FlxEase.sineInOut});
        add(titleText);

        #if !mobile
        versionText = new FlxText(0, 100, FlxG.width, "v.0.1.5");
        versionText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        versionText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        versionText.x = 350;
        versionText.y = 145;
        add(versionText);
        #end

        #if mobile
        versionText = new FlxText(0, 100, FlxG.width, "v.0.1.5 ANDROID PREVIEW");
        versionText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        versionText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
        versionText.x = 220;
        versionText.y = 145;
        add(versionText);
        #end

        new FlxTimer().start(0.5, function(tmr:FlxTimer)
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

        btnNewGame = new FlxButton(300, 230, "New Game", clickNewGame);
        customizeButton(btnNewGame);
        add(btnNewGame);

        #if mobile
            btnContinue = new FlxButton(300, 340, "Continue", clickContinue);
        #else
            btnContinue = new FlxButton(300, 300, "Continue", clickContinue);
        #end
        customizeButton(btnContinue);
        add(btnContinue);

        #if mobile
            btnExit = new FlxButton(300, 540, "Quit Game", clickQuit);
        #else
            btnExit = new FlxButton(300, 470, "Quit Game", clickQuit);
        #end
        customizeButton(btnExit);

        #if !html5
        add(btnExit);
        #end

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

        #if !mobile
        if (FlxG.keys.justPressed.F11)
        {
            if (FlxG.fullscreen == false) FlxG.fullscreen = true;
            else FlxG.fullscreen = false;
        }
        #end

        if (FlxG.random.bool(10)) glitchEffect.strength = FlxG.random.int(5, 40);
        else glitchEffect.strength = 3;

        scanline.alpha = 0.1 - (Math.random() * 0.05);
        scanline2.alpha = 0.1 - (Math.random() * 0.1);
        effectLogo.alpha = 0.55 - (Math.random() * 0.4);
    }

    function customizeButton(btn:FlxButton):Void
    {
        btn.makeGraphic(270, 60, FlxColor.TRANSPARENT); 
        
        if (btn.label != null) 
        {
            #if mobile
                btn.label.setFormat(null, 36, FlxColor.WHITE, CENTER);
            #else
                btn.label.setFormat(null, 28, FlxColor.WHITE, CENTER);
            #end

            btn.label.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
            btn.label.fieldWidth = 300;
            btn.label.centerOffsets();
            btn.label.centerOrigin();
        }

        btn.onOver.callback = function()
        {
            openfl.ui.Mouse.cursor = MouseCursor.BUTTON;

            FlxTween.tween(btn.label.scale, {x: 1.1, y: 1.1}, 0.05, {ease: FlxEase.quadOut});

            var twn = FlxTween.angle(btn, -5, 5, 0.6, {type: PINGPONG, ease: FlxEase.sineInOut});
            activeTweens.set(btn, twn);

            
            
        };

        btn.onOut.callback = function()
        {
            openfl.ui.Mouse.cursor = MouseCursor.ARROW;

            FlxTween.tween(btn.label.scale, {x: 1.0, y: 1.0}, 0.1, {ease: FlxEase.quadIn});
            
            if (activeTweens.exists(btn))
            {
                activeTweens.get(btn).cancel();
                activeTweens.remove(btn);
            }
            FlxTween.tween(btn, {angle: 0}, 0.1, {ease: FlxEase.quadOut});
            btn.label.angle = 0;

            FlxG.sound.play(AssetPaths.trigger__ogg, 0.025, false);
        };
    }

    function clickNewGame():Void
    {
        PlayerData.currentChapter = 1;
        PlayerData.currentRoom = "map" + "01";
        PlayerData.spawnX = 250;
        PlayerData.spawnY = 450 + 5;
        PlayerData.totalDeaths = 0;
        if (FlxG.sound.music != null) { FlxG.sound.music.stop(); }
        FlxG.switchState(ChapterState.new);
    }

    function clickContinue():Void
    {
        if (SaveManager.loadGame())
        {
            if (FlxG.sound.music != null) { FlxG.sound.music.stop(); }
            FlxG.switchState(ChapterState.new);
        }
            
        else
        {
            btnContinue.color = FlxColor.GRAY;
            FlxG.camera.shake(0.01, 0.05);
            FlxG.sound.play(AssetPaths.error__ogg, 1, false);
        }
    }

    function clickQuit():Void
    {
        #if sys
            Sys.exit(0);
        #else trace("Quit not supported.");
        #end
    }

    function playMenuMusic():Void
    {
        if (FlxG.sound.music == null || !FlxG.sound.music.playing)
        {
            FlxG.sound.playMusic(AssetPaths.mainMenu__ogg, 0.7, true);
        }
            
    }
}