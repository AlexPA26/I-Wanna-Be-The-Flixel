package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
    var canDoubleJump:Bool = false;
    var safeJump:Float = 0;
    var safeJumpMax:Float = 0.15;

    var canDash:Bool = false;
    var dashTimer:Float = 0;
    var dashDirection:Int = 0;
    var isDashing:Bool = false;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        makeGraphic(30, 40, FlxColor.RED);
		// width = 15;
		// height = 35;
		// offset.set(15, 5); 

        drag.x = 4000; 
        maxVelocity.set(400, 1500);
        acceleration.y = 2000;
    }

    override public function update(elapsed:Float):Void
    {
        if (isTouching(DOWN))
        {
            safeJump = safeJumpMax;
            canDoubleJump = true; 
            canDash = true;
        }
        else
        {
            safeJump -= elapsed;
        }

        var jumpPressed = FlxG.keys.anyJustPressed([SPACE, UP, W]) || FlxG.mouse.justPressed;
        var dashPressed = FlxG.keys.anyJustPressed([SHIFT, F]) || FlxG.mouse.justPressedRight;

        var left = FlxG.keys.pressed.A;
        var right = FlxG.keys.pressed.D;

        if (dashPressed && canDash && !isDashing && !isTouching(DOWN))
        {
            isDashing = true;
            canDash = false;
            dashTimer = 0.2;
            
            if (left) dashDirection = -1;
            else if (right) dashDirection = 1;
            else dashDirection = (facing == LEFT) ? -1 : 1;
            
            maxVelocity.x = 800;
            FlxG.sound.play(AssetPaths.dash__ogg, 0.5);
        }

        if (dashTimer > 0)
        {
            dashTimer -= elapsed;
            velocity.x = 800 * dashDirection;
            velocity.y = 0;
            acceleration.y = 0;
        }
        else 
        {
            if (isDashing) 
            {
                isDashing = false;
                maxVelocity.x = 400;
            }

            acceleration.y = 2000;
            acceleration.x = 0;
            
            if (left) { acceleration.x = -4500; facing = LEFT; }
            else if (right) { acceleration.x = 4500; facing = RIGHT; }

            if (jumpPressed)
            {
                if (safeJump > 0) 
                {
                    velocity.y = -650; 
                    safeJump = 0;
                    FlxG.sound.play(AssetPaths.jump__ogg, 0.5);
                }
                else if (canDoubleJump) 
                {
                    canDoubleJump = false;
                    velocity.y = -600;
                    FlxG.sound.play(AssetPaths.doublejump__ogg, 0.5); 
                    scale.set(1.2, 0.8); 
                }
            }
        }

        super.update(elapsed);

        scale.x = flixel.math.FlxMath.lerp(scale.x, 1, 0.1);
        scale.y = flixel.math.FlxMath.lerp(scale.y, 1, 0.1);

        if (FlxG.keys.anyJustReleased([SPACE, UP, W]) || FlxG.mouse.justReleased && velocity.y < 0)
        {
            velocity.y *= 0.5;
        }
    }
}