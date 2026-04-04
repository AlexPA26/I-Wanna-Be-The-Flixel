package gui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
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

    var outlineColors:Array<FlxColor> =
	[
        FlxColor.RED, FlxColor.GREEN, FlxColor.BLUE, FlxColor.YELLOW, FlxColor.CYAN
    ];

    override public function create():Void
    {
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
        effectLogo.x = 360;
		effectLogo.y = 100;
		effectLogo.scale.set(0.65, 0.65);
        add(effectLogo);

		vignite = new FlxSprite();
		vignite.loadGraphic(AssetPaths.vigniteTitle__png, false);
		vignite.scrollFactor.set(0, 0);
		vignite.screenCenter();
		vignite.alpha = 0.5;
		add(vignite);

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
}