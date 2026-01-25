package levels.chapters.chapter1;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.util.FlxDirectionFlags;
import flixel.addons.display.FlxBackdrop;
import leveldata.*;

class Chapter1State extends FlxState
{
    // #########################
    var player:Player;
    var bullets:FlxTypedGroup<FlxSprite>;
    // #########################
    var bg:FlxSprite;
    var currentBGName:String = "";
    var mapEffect:FlxBackdrop;
    var currentEffectName:String = "";
    var map:FlxTilemap;
    var mapDeco:FlxTilemap;
    // #########################
    var currentRoomName:String;
    var warpUP:FlxTilemap;
    var warpRIGHT:FlxTilemap;
    var warpDOWN:FlxTilemap;
    var warpLEFT:FlxTilemap;
    // #########################
    var vignite:FlxSprite;

    public var savesGroup:FlxTypedGroup<SavePoint>;
    public var trampolines:FlxTypedGroup<NormalTrampoline>;
    public var platforms:FlxTypedGroup<MovingBlock>;
    public var DangerObjects:FlxGroup;

    // #########################
    var spikes:FlxGroup;
    var saveAnimation:FlxSprite;
    var tiledData:TiledMap;
    var spawnTimer:Float = 0.2;
    var playerDeaths:FlxText;
    var currentRoom:FlxText;
    // #########################

override public function create():Void
{

    FlxG.mouse.visible = true;

    FlxG.bitmap.add(AssetPaths.death__png);
    FlxG.bitmap.add(AssetPaths.spikes__png);
    FlxG.bitmap.add(AssetPaths.laser__png);
    FlxG.bitmap.add(AssetPaths.save__png);
    FlxG.sound.cache(AssetPaths.death_bgm__ogg);
    FlxG.sound.cache(AssetPaths.trampoline_bounce__ogg);

    DangerObjects = new FlxGroup();
    add(DangerObjects);

    savesGroup = new FlxTypedGroup<SavePoint>(); add(savesGroup);
    trampolines = new FlxTypedGroup<NormalTrampoline>(); add(trampolines);
    platforms = new FlxTypedGroup<MovingBlock>(); add(platforms);

    loadRoom(PlayerData.currentRoom);

    bullets = new FlxTypedGroup<FlxSprite>(); add(bullets);
    player = new Player(PlayerData.spawnX, PlayerData.spawnY); add(player);
    vignite = new FlxSprite();
    vignite.loadGraphic(AssetPaths.vignite__png, false);
    vignite.screenCenter();
    add(vignite);

    #if debug
    FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);
    #end

    saveAnimation = new FlxSprite();
    saveAnimation.makeGraphic(FlxG.width + 1, FlxG.height, FlxColor.WHITE, false);
    saveAnimation.alpha = 0;
    add(saveAnimation);

    setupHUD();

    super.create();

}

override public function update(elapsed:Float):Void
{

    FlxG.collide(player, map);
    playerDeaths.text = "Deaths: " + PlayerData.totalDeaths;
    currentRoom.text = "Last Save: " + PlayerData.currentRoom;

    super.update(elapsed);

    if (warpUP != null) 
        warpUP.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 44) TransitionUP(tile, player); return true; });
    if (warpRIGHT != null) 
        warpRIGHT.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 45) TransitionRIGHT(tile, player); return true; });
    if (warpDOWN != null) 
        warpDOWN.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 46) TransitionDOWN(tile, player); return true; });
    if (warpLEFT != null) 
        warpLEFT.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 47) TransitionLEFT(tile, player); return true; });

    FlxG.overlap(player, savesGroup, (p, s) -> { saveLogicSprite(cast s); });
    FlxG.collide(player, trampolines, (p, t) ->
    { var tramp:NormalTrampoline = cast t;
        if (player.touching == DOWN && tramp.touching == UP) { player.velocity.y = -1000; tramp.launch();
            FlxG.sound.play(AssetPaths.trampoline_bounce__ogg, 0.5, false);}});

FlxG.collide(player, platforms, function(p:Player, plat:MovingBlock) {
    if (p.touching.has(FlxDirectionFlags.DOWN) && plat.touching.has(FlxDirectionFlags.UP))
    {
        if (plat.velocity.y != 0)
        {
            p.y = plat.y - p.height;
        }

        p.velocity.y = 0;
    }
});
            
    if (spawnTimer > 0) { spawnTimer -= elapsed; } else

        { if (FlxG.overlap(player, DangerObjects)) { killPlayer(); } }

        if (FlxG.keys.justPressed.TAB)
        {
            FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
        }

        if (FlxG.keys.justPressed.R)
        {
            FlxG.resetState();
        }

        if (saveAnimation.alpha > 0)
        {
            saveAnimation.alpha -= 0.01;
        }

        if (FlxG.keys.justPressed.Z) PlayerShoot();
        FlxG.collide(bullets, map, (bullet, wall) -> { bullet.kill(); });  

}

function PlayerShoot():Void
{
    var bullet:FlxSprite;
    bullet = new FlxSprite(player.x + 25, player.y + 7);
    bullet.makeGraphic(4,4, FlxColor.YELLOW);
    add(bullet);

    if (Player.lastFacing == LEFT)
    {
        bullet.velocity.x = -400;
    }

    else if (Player.lastFacing != LEFT)
    {
        bullet.velocity.x = 400;
        bullet.x -= 20;
    }

    bullets.add(bullet);

}

function TransitionUP(tile:FlxObject, obj:FlxObject):Void
{
        var layer = tiledData.getLayer("warps-up");
        var destination = layer.properties.get("target");
        loadRoom(destination);
        player.y = FlxG.height - 20;

}

function TransitionRIGHT(tile:FlxObject, obj:FlxObject):Void
{

    var layer = tiledData.getLayer("warps-right");
    var destination = layer.properties.get("target");
    loadRoom(destination);
    player.x = 0;

}

function TransitionDOWN(tile:FlxObject, obj:FlxObject):Void
{
        var layer = tiledData.getLayer("warps-down");
        var destination = layer.properties.get("target");
        loadRoom(destination);
        player.y = -20;

}

function TransitionLEFT(tile:FlxObject, obj:FlxObject):Void
{
        var layer = tiledData.getLayer("warps-left");
        var destination = layer.properties.get("target");
        loadRoom(destination);
        player.x = 1265;

}

function loadRoom(roomName:String):Void
{
    currentRoomName = roomName;

    var path = "assets/data/chapters/chapter1/ch1-" + roomName + ".tmx";
    tiledData = new TiledMap(path);
    updateBackground();

    if (map != null) { remove(map); map.destroy(); }
    if (mapDeco != null) { remove(mapDeco); mapDeco.destroy(); }
    if (warpUP != null) { remove(warpUP); }
    if (warpRIGHT != null) { remove(warpRIGHT); }
    if (warpDOWN != null) { remove(warpDOWN); }
    if (warpLEFT != null) { remove(warpLEFT); }

    var decoLayer = tiledData.getLayer("tiles-deco");
    if (decoLayer != null) {
        mapDeco = new FlxTilemap();
        mapDeco.loadMapFromArray(cast(decoLayer, TiledTileLayer).tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
        mapDeco.x = -60; mapDeco.y = -65;
        add(mapDeco);
    }

    var mainLayer:TiledTileLayer = cast tiledData.getLayer("tiles-main");
    map = new FlxTilemap();
    map.loadMapFromArray(mainLayer.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    map.x = -60; map.y = -65;
    add(map);

    DangerObjects.clear();
    savesGroup.clear();
    platforms.clear();
    trampolines.clear();
    
    ObjectLoader.loadEverything(tiledData, this, map.x, map.y);

    loadWarpLayer("warps-up", 44, warpUP);
    loadWarpLayer("warps-right", 45, warpRIGHT);
    loadWarpLayer("warps-down", 46, warpDOWN);
    loadWarpLayer("warps-left", 47, warpLEFT);

    updateEffect();
    add(DangerObjects);
    add(platforms);
    add(savesGroup);
    add(trampolines);
    
    if (player != null) { remove(player); add(player); }
}

function loadWarpLayer(name:String, tileID:Int, warpMap:FlxTilemap):Void
{
    var layer = tiledData.getLayer(name);
    if (layer != null) {
        warpMap = new FlxTilemap();
        warpMap.loadMapFromArray(cast(layer, TiledTileLayer).tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
        warpMap.setTileProperties(tileID, ANY);
        warpMap.x = -60; warpMap.y = -65; warpMap.alpha = 0.5;
        add(warpMap);
        
        if (name == "warps-up") warpUP = warpMap;
        if (name == "warps-right") warpRIGHT = warpMap;
        if (name == "warps-down") warpDOWN = warpMap;
        if (name == "warps-left") warpLEFT = warpMap;
    }
}

function setupHUD():Void
{
    playerDeaths = new FlxText(50, FlxG.height - 80, 0, "Deaths: 0", 22);
    playerDeaths.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
    playerDeaths.scrollFactor.set(0, 0);
    add(playerDeaths);

    currentRoom = new FlxText(50, FlxG.height - 110, 0, "Last Save: ", 18);
    currentRoom.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
    currentRoom.scrollFactor.set(0, 0);
    add(currentRoom);

}

function saveLogicSprite(saveObj:SavePoint):Void
{
    if (saveObj.alive) 
    {
        PlayerData.spawnX = player.x; 
        PlayerData.spawnY = player.y;
        PlayerData.currentRoom = currentRoomName;
        
        saveAnimation.alpha = 0.5;
        FlxG.sound.play(AssetPaths.savedgame__ogg, 0.5, false);
        saveObj.kill(); 
    }
}

function killPlayer():Void
{
    if (player.exists)
    {
        PlayerData.deathX = player.x; PlayerData.deathY = player.y;
        PlayerData.totalDeaths++;
        remove(player);

        if (FlxG.sound.music != null) FlxG.sound.music.pause();
        openSubState(new DeathState());
    }

}

function updateBackground():Void
{
    var bgLayer = tiledData.getLayer("bg");
    
    if (bgLayer != null)
    {
        if (bgLayer.properties.contains("bgName"))
        {
            var newBG:String = bgLayer.properties.get("bgName");
            if (newBG != currentBGName)
            {
                trace("Changing Background to: " + newBG);
                
                if (bg != null) { remove(bg); bg.destroy(); }

                bg = new FlxSprite(0, 0);
                bg.loadGraphic("assets/images/backgrounds/" + newBG + ".png");
                bg.screenCenter();
                bg.scrollFactor.set(0, 0);
                bg.active = false;
                
                currentBGName = newBG;
                insert(0, bg);
            }
        }
        else { trace("Layer 'bg' found, but it has no 'bgName' property in Tiled!"); }
    }
    else 
    {
        trace("Could not find a layer named 'bg' in this map.");
    }
}

function updateEffect():Void
{
    var effectLayer = tiledData.getLayer("mapEffect");
    
    if (effectLayer != null && effectLayer.properties.contains("effectType"))
    {
        var newEffect = effectLayer.properties.get("effectType");
        if (newEffect != currentEffectName)
        {
            if (mapEffect != null)
            { remove(mapEffect); mapEffect.destroy(); mapEffect = null; }

            switch (newEffect)
            {
                case "fog":
                    mapEffect = new FlxBackdrop(AssetPaths.white_fog__png, X);
                    mapEffect.velocity.set(40, 0);
                    mapEffect.alpha = 0.25;
                    mapEffect.scrollFactor.set(0, 0);

                case "rain":
                    mapEffect = new FlxBackdrop(AssetPaths.rain__png, XY);
                    mapEffect.velocity.set(-100, 500);
                    mapEffect.alpha = 0.6;
                    mapEffect.scrollFactor.set(0, 0);
                
                case "none":
                    newEffect = "";
            }

            if (mapEffect != null)
            {
                currentEffectName = newEffect;
                insert(1, mapEffect);
            }
        }
    }
    else if (mapEffect != null) 
    {
        remove(mapEffect);
        mapEffect.destroy();
        mapEffect = null;
        currentEffectName = "";
    }
}

}