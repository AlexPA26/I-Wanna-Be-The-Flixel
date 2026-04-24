package leveldata.events;

import main.ChapterState;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import main.Player;

class SavePoint extends FlxSprite
{
    public var particle:FlxEmitter;
    var words:Array<String> =
    ["Great!", "Good!", "Neat!",
    "Yeah!", "Saved!", "Nice!",
    "Sweet!", "So Close!", "Woah!",
    "Cool!", "Not Bad!", "Wow!",
    "No Way!", "Perfect!", "Epic!",
    "Amazing!"];

    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic(AssetPaths.save__png, false, 50, 50);
        FlxTween.tween(this, {y: y - 5}, 1, {type: PINGPONG, ease: FlxEase.sineInOut});

        particle = new FlxEmitter(x + (width / 2), y + (height / 2), 40);
        particle.makeParticles(4, 4, FlxColor.WHITE, 40);
        particle.color.set(FlxColor.RED, FlxColor.YELLOW, FlxColor.BLUE, FlxColor.LIME);
        
        particle.lifespan.set(0.5, 1.2);
        particle.speed.set(100, 400);
        particle.launchMode = CIRCLE;
        
        particle.acceleration.set(0, 500); 
        particle.drag.set(100, 100);
        
        particle.angularVelocity.set(-300, 300);
    }

    public function pop(playerRef:FlxSprite):Void
    {
        particle.start(true, 0, 30);
        
        var randomWord = words[FlxG.random.int(0, words.length - 1)];
        var popup = new FlxText(0, 0, 0, randomWord, 20);
        popup.setBorderStyle(OUTLINE, FlxColor.BLACK, 0);

        popup.x = playerRef.x + (playerRef.width / 2) - (popup.width / 2);
        popup.y = playerRef.y - 30;
        
        var state = cast(FlxG.state, ChapterState);
        state.popups.add(popup);

        FlxTween.num(0, 60, 0.8,
        {
            ease: FlxEase.circOut, 
            onComplete: function(twn:FlxTween)
            { 
                popup.destroy(); 
            }
        }, 
        function(v:Float)
        {
            if (popup != null && popup.exists && playerRef != null && playerRef.exists)
            {
                popup.alpha = 1 - (v / 60);
                
                popup.x = playerRef.x + (playerRef.width / 2) - (popup.width / 2);
                popup.y = playerRef.y - 30 - v;
            }
        });
    }
    
    override function destroy()
    {
        super.destroy();
        if (particle != null) particle.destroy();
    }
    
}