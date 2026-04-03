package gui;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import PlayerData;

class DeathState extends FlxSubState
{        
    var particles:FlxSprite;
    var bg:FlxSprite;
    var maintext:FlxText;
    var subtext:FlxText;
    var blood:FlxEmitter;

    override public function create():Void
    {
        FlxG.sound.play(AssetPaths.death_bgm__ogg, 0.5, false);

        blood = new FlxEmitter(PlayerData.deathX, PlayerData.deathY, 150);
        blood.makeParticles(3, 3, FlxColor.RED, 150);
        blood.launchMode = CIRCLE;
        blood.speed.set(300, 700); 
        blood.acceleration.set(0, 1200); 
        blood.lifespan.set(2, 4);
        blood.alpha.set(1, 1, 0, 0);
        
        blood.scale.set(0.5, 0.5, 1.5, 1.5);
        add(blood);
        blood.start(true, 0, 150);

        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width + 1, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        bg.alpha = 0;
        bg.scrollFactor.set(0, 0);
        add(bg);

        maintext = new FlxText("GAME OVER");
		maintext.size = 100;
		maintext.color = FlxColor.WHITE;
		maintext.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		maintext.screenCenter();
		maintext.y -= 120;
        maintext.scrollFactor.set(0, 0);
		add(maintext);

        subtext = new FlxText("PRESS 'R' TO RESPAWN");
		subtext.size = 26;
		subtext.color = FlxColor.WHITE;
		subtext.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        subtext.screenCenter();
		subtext.y -= 50;
        subtext.scrollFactor.set(0, 0);
		add(subtext);

        super.create();
        

    }

    override public function update(elapsed:Float):Void

    {
        
        super.update(elapsed);

        if (bg.alpha < 1)
        {
            bg.alpha += 0.005; 
        }
        if (FlxG.keys.justPressed.R)
        {
            if (FlxG.sound.music != null) FlxG.sound.music.stop();
            FlxG.resetState();
        }
        
    }
}