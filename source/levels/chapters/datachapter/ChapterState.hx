package levels.chapters.datachapter;

import flixel.ui.FlxVirtualPad;
import flixel.effects.particles.FlxEmitter;
import leveldata.background.BackgroundManager;
import gui.DeathState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.editors.tiled.*;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;
import flixel.addons.display.FlxBackdrop;
import leveldata.deco.*;
import leveldata.events.*;
import leveldata.misc.*;
import leveldata.hazards.*;
import leveldata.blockdata.*;

@:allow(levels.chapters.RoomLoader)
class ChapterState extends FlxState
{
    var player:Player;
    var virtualPad:FlxVirtualPad;
    var padScale:Float = 2.5;
    var hudGroup:FlxGroup;
    var bullets:FlxTypedGroup<FlxSprite>;
    var PlayerGlow:FlxSprite;
    var cameraTarget:FlxObject;
    var scrollSpeed:Float = 0;
    var isAutoscrolling:Bool = false;

    public var bg:FlxSprite;
    public var currentBGName:String = "";
    public var tilesPath:String = "assets/images/levels/tiles/ch" + PlayerData.currentChapter + "tiles.png";
    var map:FlxTilemap;
    var mapDeco:FlxTilemap;
    var mapDeco2:FlxTilemap;

    var currentRoomName:String;
    public var warpsGroup:FlxTypedGroup<WarpTrigger>;
    var vignite:FlxSprite;

    public var backEffectObj:FlxBackdrop;
    public var currentBackEffectName:String = "";
    public var lastBackScrollBoost:Float = 0;

    public var backDecoEffectObj:FlxBackdrop;
    public var currentBackDecoEffectName:String = "";
    public var lastDecoScrollBoost:Float = 0;

    public var doubleEffectObj:FlxBackdrop;
    public var currentDoubleEffectName:String = "";
    public var lastDoubleScrollBoost:Float = 0;

    public var frontEffectObj:FlxBackdrop;
    public var currentFrontEffectName:String = "";
    public var lastFrontScrollBoost:Float = 0;

    public var topEffectObj:FlxBackdrop;
    public var currentTopEffectName:String = "";
    public var lastTopScrollBoost:Float = 0;

    public var savesGroup:FlxTypedGroup<SavePoint>;
    public var popups:FlxTypedGroup<FlxText>;
    public var saveParticlesGroup:FlxTypedGroup<FlxEmitter>;
    public var doubleJumpGroup:FlxTypedGroup<DoubleJumpObj>;
    public var flipGroup:FlxTypedGroup<FlipSwitch>;
    public var portalGroup:FlxTypedGroup<PortalWarp>;
    public var trampolines:FlxTypedGroup<NormalTrampoline>;
    public var trampolinesMini:FlxTypedGroup<NormalTrampolineMini>;
    public var platforms:FlxTypedGroup<MovingBlock>;
    public var fallingBlock:FlxTypedGroup<FallingBlock>;
    public var lightsGroup:FlxTypedGroup<LightTorch>;
    public var DangerObjects:FlxGroup;
    public var slabs:FlxTypedGroup<NormalSlab>;
    public var slabsNight:FlxTypedGroup<NormalSlabNight>;

    var spikes:FlxGroup;
    var saveAnimation:FlxSprite;
    var tiledData:TiledMap;
    var spawnTimer:Float = 0.1;
    var timeElapsed:FlxText;
    var currentChapter:FlxText;
    var playerDeaths:FlxText;
    var lastSave:FlxText;

override public function create():Void
{
    #if !debug
    #if !mobile
    FlxG.mouse.visible = false;
    #end
    #end

    #if debug
        #if !mobile
        FlxG.mouse.visible = true;
        #end
    #end
    FlxG.fixedTimestep = true;

    hudGroup = new FlxGroup();
    virtualPad = new FlxVirtualPad(LEFT_RIGHT, A);

    FlxG.bitmap.clearUnused();
    imgCache();
    sfxCache();

    DangerObjects = new FlxGroup(); 

    savesGroup = new FlxTypedGroup<SavePoint>();
    popups = new FlxTypedGroup<FlxText>();
    saveParticlesGroup = new FlxTypedGroup<FlxEmitter>();
    doubleJumpGroup = new FlxTypedGroup<DoubleJumpObj>();
    flipGroup = new FlxTypedGroup<FlipSwitch>();
    portalGroup = new FlxTypedGroup<PortalWarp>();
    trampolines = new FlxTypedGroup<NormalTrampoline>();
    trampolinesMini = new FlxTypedGroup<NormalTrampolineMini>();
    platforms = new FlxTypedGroup<MovingBlock>();
    fallingBlock = new FlxTypedGroup<FallingBlock>();
    lightsGroup = new FlxTypedGroup<LightTorch>();
    slabs = new FlxTypedGroup<NormalSlab>();
    slabsNight = new FlxTypedGroup<NormalSlabNight>();
    bullets = new FlxTypedGroup<FlxSprite>();

    PlayerGlow = new FlxSprite();
    PlayerGlow.loadGraphic(AssetPaths.playerGlow__png, false);
    PlayerGlow.blend = flash.display.BlendMode.ADD;
    PlayerGlow.alpha = 0.15;

    warpsGroup = new FlxTypedGroup<WarpTrigger>(); add(warpsGroup);
    player = new Player(PlayerData.spawnX, PlayerData.spawnY);

    vignite = new FlxSprite();
    vignite.loadGraphic(AssetPaths.vignite__png, false);
    vignite.scrollFactor.set(0, 0);
    vignite.alpha = 1;
    vignite.visible = true;
    vignite.screenCenter();

    saveAnimation = new FlxSprite();
    saveAnimation.makeGraphic(FlxG.width + 1, FlxG.height, FlxColor.WHITE, false);
    saveAnimation.alpha = 0;
    saveAnimation.scrollFactor.set(0,0);

    RoomLoader.loadRoom(this, PlayerData.currentRoom);

    #if debug
    FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);
    #end

    super.create();

}

override public function update(elapsed:Float):Void
{

    if (isAutoscrolling && cameraTarget != null) 
    {
        cameraTarget.x += scrollSpeed * elapsed;
        cameraTarget.y = 300;
        
        if (player.x + player.width < FlxG.camera.scroll.x) { killPlayer(); }
    }

    #if !mobile
    if (FlxG.keys.justPressed.F11)
    {
        if (FlxG.fullscreen == false) FlxG.fullscreen = true;
        else FlxG.fullscreen = false;
    }
    #end

    FlxG.collide(player, map);
    FlxG.collide(player, slabs);
    FlxG.collide(player, slabsNight);

    // timeElapsed.text = "Time: " + PlayerData.timeElapsed;
    if (currentChapter != null) currentChapter.text = "Current Chapter: " + PlayerData.currentChapter;
    if (playerDeaths != null) playerDeaths.text = "Total Deaths: " + PlayerData.totalDeaths;
    if (lastSave != null) lastSave.text = "Last Save: " + PlayerData.currentRoom;

    if (PlayerData.saveCooldown > 0)
    {
        PlayerData.saveCooldown -= elapsed;
        if (PlayerData.saveCooldown < 0) PlayerData.saveCooldown = 0;
    }

    super.update(elapsed);

    FlxG.overlap(player, warpsGroup, (p, w) -> { handleWarp(cast w); });
    FlxG.overlap(player, savesGroup, (p, s) -> { saveLogicSprite(cast s); });
    FlxG.overlap(player, doubleJumpGroup, (p, d) -> { doubleJumpObjLogic(cast d); });
    FlxG.overlap(player, portalGroup, (p, pw) -> { portalWarpLogic(cast pw); });
    FlxG.overlap(player, flipGroup, (p, sw) -> { FlipSwitchObjLogic(cast sw); });

    FlxG.collide(player, trampolines, (p, t) -> { var tramp:NormalTrampoline = cast t;
        if (player.touching == DOWN && tramp.touching == UP)
            {
                player.velocity.y = -1000; tramp.launch();
                FlxG.sound.play(AssetPaths.trampoline_bounce__ogg, 0.5, false);
            }});
    FlxG.collide(player, trampolinesMini, (p:Player, t:NormalTrampolineMini) ->
    { 
        var trampMini:NormalTrampolineMini = cast t;
        
        if (trampMini.animation.curAnim != null && 
            StringTools.startsWith(trampMini.animation.curAnim.name, "jump") && 
            !trampMini.animation.finished) return;

        var hitFloor = p.touching.has(DOWN);
        var hitPlayerLeft = p.touching.has(LEFT);
        var hitPlayerRight = p.touching.has(RIGHT);

        switch (trampMini.launchDir) 
        {
            case "up":
                if (hitFloor)
                {
                    p.velocity.y = -730;
                    p.canDoubleJump = true; 
                    trampMini.launch();
                    FlxG.sound.play(AssetPaths.trampoline_bounce__ogg, 0.5);
                }
                
            case "left":
                if (hitPlayerLeft && !hitFloor)
                {
                    p.maxVelocity.x = 800;
                    p.velocity.x = 800;
                    p.velocity.y = -600;
                    p.canDoubleJump = true;
                    p.canDash = true;
                    trampMini.launch();
                    FlxG.sound.play(AssetPaths.big_bounce__ogg, 0.5);
                    FlxG.sound.play(AssetPaths.lateral_bounce__ogg, 0.5);
                }

            case "right":
                if (hitPlayerRight && !hitFloor)
                {
                    p.maxVelocity.x = 800; 
                    p.velocity.x = -800; 
                    p.velocity.y = -600;
                    p.canDoubleJump = true;
                    p.canDash = true;
                    trampMini.launch();
                    FlxG.sound.play(AssetPaths.big_bounce__ogg, 0.5);
                    FlxG.sound.play(AssetPaths.lateral_bounce__ogg, 0.5);
                }
        }
        });

    FlxG.collide(player, platforms, function(p:Player, plat:MovingBlock)
        {
        if (p.touching.has(FlxDirectionFlags.DOWN) && plat.touching.has(FlxDirectionFlags.UP))
        {
            
            if (plat.velocity.y != 0)
            {
                
                p.y = plat.y - p.height;
            }
            p.velocity.y = 0;
        }
        });

    FlxG.collide(platforms, map, function(plat:MovingBlock, wall:FlxObject)
        { plat.stopMovement(); });

    FlxG.collide(player, fallingBlock, function(p:Player, plat:FallingBlock)
        {
        if (p.touching.has(FlxDirectionFlags.DOWN) && plat.touching.has(FlxDirectionFlags.UP))
        {
            FlxG.sound.play(AssetPaths.break_block__ogg, 0.5, false);
            if (plat.velocity.y != 0)
            {
                p.y = plat.y - p.height;
            }

            p.velocity.y = 0;
        }
        });
            
    if (spawnTimer > 0) { spawnTimer -= elapsed; }
    
    else
        { if (FlxG.overlap(player, DangerObjects)) { killPlayer(); } }

    #if !mobile
    if (FlxG.keys.justPressed.TAB)
    {
        FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
    }
    #end

    #if !mobile
    if (FlxG.keys.justPressed.R)
    {
        FlxG.resetState();
        PlayerData.totalDeaths++;
    }
    #end

    #if !mobile
    if (FlxG.keys.justPressed.K) { killPlayer(); }
    #end

    if (saveAnimation.alpha > 0)
        {
            saveAnimation.alpha -= 0.01;
        }

    #if !mobile
    if (FlxG.keys.justPressed.Z) PlayerShoot();
        FlxG.collide(bullets, map, (bullet, wall) -> { bullet.kill(); });  
    #end

    #if !mobile
    if (FlxG.keys.justPressed.ESCAPE)
    {
        FlxG.resetGame();
    }
    #end

    if (player != null && player.exists && PlayerGlow != null)
    {
        PlayerGlow.exists = true;
        PlayerGlow.x = player.x + (player.width / 2) - (PlayerGlow.width / 2);
        PlayerGlow.y = player.y + (player.height / 2) - (PlayerGlow.height / 2);
    }
    else if (PlayerGlow != null)
    {
        PlayerGlow.exists = false;
    }

    switch(PlayerData.currentChapter)
    {
        case 1: chapter1Cache();
        case 2: chapter2Cache();
    }

    #if mobile
    if (virtualPad.buttonA.justPressed) 
    {
        PlayerShoot(); 
    }
    #end

    #if !debug
    if (player.x > map.width || player.y > map.height - 50) killPlayer();
    #end

    #if !mobile
    if (FlxG.keys.justPressed.ONE) RoomLoader.loadRoom(this, "map13");
    #end
}

function imgCache():Void
{
    FlxG.bitmap.add(AssetPaths.save__png);
    FlxG.bitmap.add(AssetPaths.transitionTiles__png);
    FlxG.bitmap.add(AssetPaths.playerGlow__png);

}

function sfxCache():Void
{
    FlxG.sound.cache(AssetPaths.jump__ogg);
    FlxG.sound.cache(AssetPaths.doublejump__ogg);
    FlxG.sound.cache(AssetPaths.dash__ogg);
    FlxG.sound.cache(AssetPaths.break_block__ogg);
    FlxG.sound.cache(AssetPaths.savedgame__ogg);
    FlxG.sound.cache(AssetPaths.lateral_bounce__ogg);
    FlxG.sound.cache(AssetPaths.platform_activated__ogg);
    FlxG.sound.cache(AssetPaths.death_bgm__ogg);
    FlxG.sound.cache(AssetPaths.trampoline_bounce__ogg);
}

function chapter1Cache():Void
{
    FlxG.bitmap.add(AssetPaths.ch1tiles__png);
    FlxG.bitmap.add(AssetPaths.spikes__png);
    FlxG.bitmap.add(AssetPaths.laser__png);
    FlxG.bitmap.add(AssetPaths.trampoline_mini__png);
    FlxG.bitmap.add(AssetPaths.trampoline__png);
    FlxG.bitmap.add(AssetPaths.light__png);
    FlxG.bitmap.add(AssetPaths.slab__png);
    FlxG.bitmap.add(AssetPaths.slab_night__png);
}

function chapter2Cache():Void
{
    FlxG.bitmap.add(AssetPaths.ch2tiles__png);
    FlxG.bitmap.add(AssetPaths.laser__png);
    FlxG.bitmap.add(AssetPaths.trampoline_mini__png);
    FlxG.bitmap.add(AssetPaths.trampoline__png);
    FlxG.bitmap.add(AssetPaths.slab__png);
    FlxG.bitmap.add(AssetPaths.spikes__png);
    FlxG.bitmap.add(AssetPaths.sandstorm__png);
    FlxG.bitmap.add(AssetPaths.double_jump__png);
}

function PlayerShoot():Void
{
    var bullet:FlxSprite;
    bullet = new FlxSprite(player.x + 25, player.y + 7);
    bullet.makeGraphic(4,4, FlxColor.YELLOW);
    add(bullet);

    if (Player.isFacingRIGHT == false)
    {
        bullet.velocity.x = -600;
    }

    else if (Player.isFacingRIGHT == true)
    {
        bullet.velocity.x = 600;
        bullet.x -= 20;
    }

    bullets.add(bullet);
    FlxG.sound.play(AssetPaths.playershoot__ogg, 0.5, false);

}

function handleWarp(w:WarpTrigger):Void
{
    if (w.newChapter != null && w.newChapter != "")
    {
        PlayerData.currentChapter = Std.parseInt(w.newChapter);
    }

    RoomLoader.loadRoom(this,w.targetRoom);

    switch (w.direction)
    {
        case "up":    player.y = FlxG.height - player.height - 10;
        case "down":  player.y = 10;
        case "left":  player.x = 1265;
        case "right": player.x = 10;
    }
}

function setupHUD():Void
{

    // timeElapsed = new FlxText(50, 20, 0, "Time: ", 22);
    // timeElapsed.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    // timeElapsed.scrollFactor.set(0, 0);
    // timeElapsed.scrollFactor.set(0, 0);
    // add(timeElapsed);

    #if !mobile
    currentChapter = new FlxText(50, FlxG.height - 140, 0, "Current Chapter: ", 18);
    currentChapter.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    currentChapter.scrollFactor.set(0, 0);
    currentChapter.scrollFactor.set(0, 0);
    add(currentChapter);

    lastSave = new FlxText(50, FlxG.height - 110, 0, "Last Save: ", 18);
    lastSave.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    lastSave.scrollFactor.set(0, 0);
    add(lastSave);

    playerDeaths = new FlxText(50, FlxG.height - 80, 0, "Total Resets: ", 22);
    playerDeaths.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    playerDeaths.scrollFactor.set(0, 0);
    playerDeaths.scrollFactor.set(0, 0);
    add(playerDeaths);
    #end

    #if mobile
    playerDeaths = new FlxText(FlxG.width - 260, 30, 0, "Total Deaths: ", 22);
    playerDeaths.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    playerDeaths.scrollFactor.set(0, 0);
    playerDeaths.scrollFactor.set(0, 0);
    add(playerDeaths);
    #end

}

function saveLogicSprite(saveObj:SavePoint):Void
{
    if (saveObj.alive) 
    {
        PlayerData.spawnX = player.x; 
        PlayerData.spawnY = player.y;
        PlayerData.currentRoom = currentRoomName;

        if (PlayerData.saveCooldown <= 0)
        {
            saveObj.pop(player);
            saveAnimation.alpha = 0.5;
            FlxG.sound.play(AssetPaths.savedgame__ogg, 0.5, false);
            SaveManager.saveGame();
            
        }

        saveObj.alive = false;
        saveObj.visible = false;
        saveObj.kill();
    }
}

function doubleJumpObjLogic(doublejObj:DoubleJumpObj):Void
{
    if (doublejObj.alive)
    {
        if (player.canDoubleJump == false) { player.canDoubleJump = true; }
        doublejObj.kill();
    }
}

function FlipSwitchObjLogic(flipSwitchObj:FlipSwitch):Void
{
    if (flipSwitchObj.alive)
    {
        if (FlxG.camera.canvas.scaleX == 1)
        {
            FlxG.camera.canvas.scaleX = -1;
            FlxG.camera.canvas.x = FlxG.width;
        }
        
        else
        
        {
            FlxG.camera.canvas.scaleX = 1;
            FlxG.camera.canvas.x = 0;
        }

        if (FlxG.camera.canvas.scaleY == 1)
        {
            FlxG.camera.canvas.scaleY = -1;
            FlxG.camera.canvas.y = FlxG.height;
        }
        
        else
            
        {
            FlxG.camera.canvas.scaleY = 1;
            FlxG.camera.canvas.y = 0;
        }

        flipSwitchObj.kill();
        FlxG.sound.play(AssetPaths.flip__ogg);
    }
}

function portalWarpLogic(portalLogic:PortalWarp):Void
{
    RoomLoader.loadRoom(this, "map10");
    FlxG.camera.shake(0.005, 0.25);
    saveAnimation.alpha = 0.5;
    FlxG.sound.play(AssetPaths.warp__ogg, 0.85, false);
    player.x = 150;
    player.y = 300;
}

function killPlayer():Void
{
    if (player.exists)
    {
        if (FlxG.sound.music != null)
        {
            PlayerData.lastMusicTime = FlxG.sound.music.time;
        }

        PlayerData.isRespawning = true;
        PlayerData.saveCooldown = 1.0;

        PlayerData.deathX = player.x; PlayerData.deathY = player.y;
        PlayerData.totalDeaths++;
        PlayerGlow.visible = false;
        remove(player);

        if (FlxG.sound.music != null) FlxG.sound.music.stop();
        openSubState(new DeathState());
    }

}

function updateMusic():Void
{
    var musicLayer = tiledData.getLayer("music");
    if (musicLayer == null) return;

    var songName:String = musicLayer.properties.get("songName");
    var songPath = "assets/music/chapters/chapter" + PlayerData.currentChapter + "bgm/" + songName + ".ogg";
    trace("Music Changed to: " + songName);

    if (PlayerData.currentSong == songPath && FlxG.sound.music != null && FlxG.sound.music.playing)
    {
        if (PlayerData.isRespawning)
        {
            FlxG.sound.music.time = PlayerData.lastMusicTime;
            PlayerData.isRespawning = false;
        }
        return; 
    }

    PlayerData.currentSong = songPath;
    FlxG.sound.playMusic(songPath, 0.5, true);

    if (PlayerData.isRespawning)
    {
        FlxG.sound.music.time = PlayerData.lastMusicTime;
        PlayerData.isRespawning = false;
    }
}

function autoScroll():Void
{
    for (layer in tiledData.layers)
    {
        if (layer.name == "Autoscroll")
        {
            this.isAutoscrolling = true;
        }

        if (layer.type == TiledLayerType.OBJECT)
        {
            var objLayer:TiledObjectLayer = cast layer;
            
            if (layer.name == "ScrollSettings" && objLayer.properties.contains("speed"))
            {
                this.scrollSpeed = Std.parseFloat(objLayer.properties.get("speed"));
            }
            
            if (layer.name == "PlayerSpeed" && objLayer.properties.contains("value"))
            {
                var pSpeed = Std.parseFloat(objLayer.properties.get("value"));
                player.mapMaxSpeed = pSpeed;
                player.maxVelocity.x = pSpeed;
            }
        }
    }
}

function cameraScroll():Void
{
    if (this.isAutoscrolling)
    {
        cameraTarget = new flixel.FlxObject(player.x + 465, player.y, 1, 1);
        add(cameraTarget);
        FlxG.camera.follow(cameraTarget, LOCKON, 1);
    }
}

function layoutVirtualPad():Void
{
    if (virtualPad == null) return;
    var targetAlpha:Float = 0.5;
    var padScale:Float = 2.5; 

    var allButtons = [ virtualPad.getButton(LEFT), virtualPad.getButton(RIGHT), virtualPad.getButton(A)];
    
    for (button in allButtons)
    {
        if (button == null) continue;
        button.scale.set(padScale, padScale);
        button.updateHitbox();
        button.scrollFactor.set(0, 0);
        button.alpha = targetAlpha;
    }

    if (virtualPad.getButton(LEFT) != null)
    {
        virtualPad.getButton(LEFT).x = 100;
        virtualPad.getButton(LEFT).y = FlxG.height - virtualPad.getButton(LEFT).height - 90;
    }

    if (virtualPad.getButton(RIGHT) != null && virtualPad.getButton(LEFT) != null)
    {
        virtualPad.getButton(RIGHT).x = virtualPad.getButton(LEFT).x + virtualPad.getButton(LEFT).width + 40; 
        virtualPad.getButton(RIGHT).y = virtualPad.getButton(LEFT).y;
    }

    if (virtualPad.getButton(A) != null)
    {
        virtualPad.getButton(A).x = FlxG.width - virtualPad.getButton(A).width - 140;
        virtualPad.getButton(A).y = FlxG.height - virtualPad.getButton(A).height - 200;
    }
}

}