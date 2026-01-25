package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;
import PlayerData;

class Player extends FlxSprite
{
    public var canDoubleJump:Bool = true;
    var safeJump:Float = 0;
    var safeJumpMax:Float = 0.15;
    var playerSprite:FlxSprite;

    public var canDash:Bool = false;
    var dashTimer:Float = 0;
    var dashDirection:Int = 0;
    var isDashing:Bool = false;

    var animationJumpUp:Bool = false;
    var animationJumpDown:Bool = false;

    public static var lastFacing:FlxDirectionFlags = RIGHT;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic(AssetPaths.thekid__png, true, 50, 50);
        animation.add("idle", [0, 1, 2, 3], 11, true);
        animation.add("jumpUp", [6], 16, false);
        animation.add("jumpDown", [7], 1, false);
        animation.add("walking", [8, 9, 10, 11, 12, 13], 24, true);
        width = 20; 
        height = 30;
        offset.set(20, 20);

        setFacingFlip(LEFT, true, false);
        setFacingFlip(RIGHT, false, false);

        drag.x = 4000; 
        maxVelocity.set(400, 1000);
        acceleration.y = 2000;

    }

    override public function update(elapsed:Float):Void
    {
        acceleration.x = 0;
         
        if (isTouching(DOWN))
        {
            safeJump = safeJumpMax;
            canDoubleJump = true;

            canDash = true;

            animationJumpUp = false;
            animationJumpDown = false;
            
        }
        else
        {
            safeJump -= elapsed;
        }

        var jumpPressed = FlxG.keys.anyJustPressed([SPACE, UP, W]) || FlxG.mouse.justPressed;
        var dashPressed = FlxG.keys.anyJustPressed([SHIFT, TAB, F]) || FlxG.mouse.justPressedRight;

        var left = (FlxG.keys.anyPressed([LEFT, A]));
        var right = (FlxG.keys.anyPressed([RIGHT, D]));
    
        if (left) 
        { 
            acceleration.x = -1500; 
            facing = LEFT;
            offset.set(10, 20);
        }
        else if (right) 
        { 
            acceleration.x = 1500; 
            facing = RIGHT;
            offset.set(20, 20);
        }

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
            
            if (left)
            {
                acceleration.x = -4000; facing = LEFT;
            }

            else if (right)
            {
                acceleration.x = 4000; facing = RIGHT;
            }

            else
            {

            }

            if (jumpPressed)
            {
                if (safeJump > 0) 
                {
                    velocity.y = -650; 
                    safeJump = 0;
                    FlxG.sound.play(AssetPaths.jump__ogg, 0.5);
                    animationJumpUp = true;
                    animationJumpDown = false;
                }
                else if (canDoubleJump) 
                {
                    canDoubleJump = false;
                    velocity.y = -600;
                    FlxG.sound.play(AssetPaths.doublejump__ogg, 0.5);
                    animationJumpUp = true;
                    animationJumpDown = false;
                }
            }
        }

        var hardwarePressed = (FlxG.keys.pressed.D || FlxG.keys.pressed.A);

        super.update(elapsed);

        // trace("PLAYER X: " + x + " PLAYER Y: " + y);

        if (FlxG.keys.anyJustReleased([SPACE, UP, W]) || FlxG.mouse.justReleased && velocity.y < 0)
        {
            velocity.y *= 0.8;
            animationJumpDown = true;
            animationJumpUp = false;
        }

        if (isDashing) 
        {
            animation.play("walking");
        }

        else if (!isTouching(DOWN) && Math.abs(velocity.y) > 50) 
        {
            
            if (velocity.y < 0)
            {
                animation.play("jumpUp");
            }
            else
            {
                animation.play("jumpDown");
            }
        }

        else 
            {
                if (Math.abs(velocity.x) > 20) 
                    animation.play("walking");
                else 
                    animation.play("idle");
            }

    }
}