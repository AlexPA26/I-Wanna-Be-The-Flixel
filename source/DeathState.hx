package;
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

    override public function create():Void
    {
        FlxG.sound.play(AssetPaths.death_bgm__ogg, 0.5);
        particles = new FlxSprite(0, 0);
        particles.loadGraphic("assets/images/shared/death.png", true, 243, 223);
        add(particles);
        particles.x = PlayerData.deathX - (particles.width / 2);
        particles.y = PlayerData.deathY - (particles.height / 2) + 50;
        particles.animation.add("explosion", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33], 60, false);
        particles.animation.play("explosion");

        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        bg.alpha = 0;
        add(bg);

        maintext = new FlxText("GAME OVER");
		maintext.size = 100;
		maintext.color = FlxColor.WHITE;
		maintext.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
		maintext.screenCenter();
		maintext.y -= 120;
		add(maintext);

        subtext = new FlxText("PRESS 'R' TO RESPAWN");
		subtext.size = 26;
		subtext.color = FlxColor.WHITE;
		subtext.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
        subtext.screenCenter();
		subtext.y -= 50;
		add(subtext);

        super.create();
        

    }

    override public function update(elapsed:Float):Void

    {
        
        super.update(elapsed);

        if (particles.alpha > 0)
        {
            particles.alpha -= elapsed; 
        }

        if (particles.alpha <= 0)
        {
            particles.alpha = 0;
        }

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