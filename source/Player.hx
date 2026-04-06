package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;
// import PlayerData;

class Player extends FlxSprite
{
    public var canDoubleJump:Bool = true;
    public var doubleJumpEffect:FlxEmitter;
    public var dashEffect:FlxEmitter;

    var safeJump:Float = 0;
    var safeJumpMax:Float = 0.15;
    var playerSprite:FlxSprite;
    public var mapMaxSpeed:Float = 400;

    public var canDash:Bool = false;
    var dashTimer:Float = 0;
    var dashDirection:Int = 0;
    var isDashing:Bool = false;

    var animationJumpUp:Bool = false;
    var animationJumpDown:Bool = false;

    public static var isFacingRIGHT:Bool = false;

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
        maxVelocity.set(mapMaxSpeed, 1000);
        acceleration.y = 2500;

        doubleJumpEffect = new FlxEmitter(0, 0, 50);
        doubleJumpEffect.loadParticles(AssetPaths.particle__png, 5);
        doubleJumpEffect.lifespan.set(0.4, 0.8);
        doubleJumpEffect.velocity.set(-100, -50, 100, 50);
        doubleJumpEffect.scale.set(1.2, 1.2, 1.2, 1.2);
        doubleJumpEffect.alpha.set(1, 1, 0, 0);
        doubleJumpEffect.launchMode = CIRCLE;

        dashEffect = new FlxEmitter(-10, -10, 5);
        dashEffect.makeParticles(4, 4, FlxColor.WHITE, 5);
        dashEffect.color.set(FlxColor.RED, FlxColor.YELLOW, 0xFF820000, 0xFFC92727);
        dashEffect.lifespan.set(0.4, 0.8);
        dashEffect.velocity.set(-100, -50, 100, 50);
        dashEffect.scale.set(1.2, 1.2, 1.2, 1.2);
        dashEffect.alpha.set(1, 1, 0, 0);
        dashEffect.launchMode = CIRCLE;
        dashEffect.angularVelocity.set(-300, 300);

    }

    override public function update(elapsed:Float):Void
    {
        acceleration.x = 0;
        maxVelocity.x = mapMaxSpeed;
         
        if (isTouching(DOWN))
        {
            safeJump = safeJumpMax;
            canDoubleJump = true;
            drag.x = 4000;
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
            isFacingRIGHT = false;
        }
        else if (right) 
        { 
            acceleration.x = 1500; 
            facing = RIGHT;
            offset.set(20, 20);
            isFacingRIGHT = true;
        }

        if (dashPressed && canDash && !isDashing && !isTouching(DOWN))
        {
            isDashing = true;
            canDash = false;
            dashTimer = 0.15;
            
            if (left) dashDirection = -1;
            else if (right) dashDirection = 1;
            else dashDirection = (facing == LEFT) ? -1 : 1;
            
            maxVelocity.x = 800;
            dashEffect.setPosition(x + (width / 2), y + (height / 2));
            if (left) dashEffect.acceleration.set(200, 0);
            if (right) dashEffect.acceleration.set(-200, 0); 
            dashEffect.start(true, 0, 5);
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
                maxVelocity.x = mapMaxSpeed;
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
                    FlxG.sound.play(AssetPaths.jump__ogg, 1);
                    animationJumpUp = true;
                    animationJumpDown = false;
                }
                else if (canDoubleJump) 
                {
                    doubleJumpEffect.setPosition(x + (width / 2), y + height);
                    doubleJumpEffect.start(true, 0, 10);
                    canDoubleJump = false;
                    velocity.y = -600;
                    FlxG.sound.play(AssetPaths.doublejump__ogg, 1);
                    animationJumpUp = true;
                    animationJumpDown = false;
                }
            }
        }

        // ##############################
        // TRAMPOLINE RED ADJUSTMENTS!!!!
        // ##############################
        if (maxVelocity.x > 400)
        {
            maxVelocity.x -= 600 * elapsed; 
            if (maxVelocity.x < 400) maxVelocity.x = 400;
        }

        if (isTouching(DOWN))
        {
            maxVelocity.x = mapMaxSpeed;
            drag.x = 4000;
        }

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