package levels.chapters.chapterdebug;

import flixel.util.FlxDirectionFlags;
import flixel.util.FlxDirection;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;

class ChapterDebug01 extends FlxState
{
    var player:Player;
    var map:FlxTilemap;
    var warpUP:FlxTilemap;
    var warpRIGHT:FlxTilemap;
    var warpDOWN:FlxTilemap;
    var warpLEFT:FlxTilemap;
    //###################
    var DangerObjects:FlxGroup;
    var spikes:FlxGroup;
    //###################
    var tiledData:TiledMap;
    var spawnTimer:Float = 0.1;

override public function create():Void
{
    
    FlxG.cameras.bgColor = 0xFFC469AB;
    FlxG.mouse.visible = true;
    FlxG.bitmap.add("assets/images/shared/death.png");
    FlxG.sound.cache(AssetPaths.death_bgm__ogg);
    
    if (FlxG.sound.music == null || !FlxG.sound.music.active)
    {
        FlxG.sound.playMusic(AssetPaths.chapter0bgm__ogg, 0.5, true);
    }


    DangerObjects = new FlxGroup();
    add(DangerObjects);

    loadRoom("map01");

    player = new Player(PlayerData.spawnX, PlayerData.spawnY);
    player.velocity.set(PlayerData.lastVelX, PlayerData.lastVelY);
    add(player);

    #if debug
    FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);
    #end
    
    super.create();
}

    override public function update(elapsed:Float):Void
    {
        
        FlxG.collide(player, map);
        super.update(elapsed);
    
    warpUP.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 31) TransitionUP(tile, player); return true; });
    warpRIGHT.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 32) TransitionRIGHT(tile, player); return true; });
    warpDOWN.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 33) TransitionDOWN(tile, player); return true; });
    warpLEFT.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 34) TransitionLEFT(tile, player); return true; });

    if (spawnTimer > 0) 
        {
        spawnTimer -= elapsed;
        }
        else
        {

        if (FlxG.overlap(player, DangerObjects)) {
            PlayerData.deathX = player.x;
            PlayerData.deathY = player.y;
            remove(player);
            FlxG.sound.music.pause();
            openSubState(new DeathState());
        }
    }
    
        if (FlxG.keys.justPressed.TAB)
        {
            FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
        }

        if (FlxG.keys.justPressed.R)
        {
            FlxG.resetState();
        }
            
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
    var path = "assets/data/chapters/chaptertest/" + roomName + ".tmx";
    tiledData = new TiledMap(path);
    
    var mainLayer = tiledData.getLayer("tiles-main");
    var warpUpData:TiledTileLayer = cast tiledData.getLayer("warps-up");
    var warpRightData:TiledTileLayer = cast tiledData.getLayer("warps-right");
    var warpDownData:TiledTileLayer = cast tiledData.getLayer("warps-down");
    var warpLeftData:TiledTileLayer = cast tiledData.getLayer("warps-left");
    var tileLayer:TiledTileLayer = cast mainLayer;
    
    if (map != null) remove(map);
    if (warpUP != null) remove(warpUP);
    if (warpRIGHT != null) remove(warpRIGHT);
    if (warpDOWN != null) remove(warpDOWN);
    if (warpLEFT != null) remove(warpLEFT);

    map = new FlxTilemap();
    map.loadMapFromArray(tileLayer.tileArray, tiledData.width, tiledData.height, AssetPaths.tiles__png, 50, 50, OFF, 1);
    map.setTileProperties(1, ANY);
    map.x = -60;
    map.y = -65;

    if (spikes != null)
    {
        DangerObjects.remove(spikes);
        spikes.destroy();
    }
    DangerObjects.clear();
    spikes = leveldata.ObjectLoader.loadEverything(tiledData, this, map.x, map.y);
    DangerObjects.add(spikes);
    add(map);
    
    warpUP = new FlxTilemap();
    warpUP.loadMapFromArray(warpUpData.tileArray, tiledData.width, tiledData.height, AssetPaths.tiles__png, 50, 50, OFF, 1);
    warpUP.setTileProperties(31, ANY);
    warpUP.x = -60; 
    warpUP.y = -65;
    warpUP.alpha = 0.5;
    add(warpUP);

    warpRIGHT = new FlxTilemap();
    warpRIGHT.loadMapFromArray(warpRightData.tileArray, tiledData.width, tiledData.height, AssetPaths.tiles__png, 50, 50, OFF, 1);
    warpRIGHT.setTileProperties(32, ANY);
    warpRIGHT.x = -60; 
    warpRIGHT.y = -65;
    warpRIGHT.alpha = 0.5;
    add(warpRIGHT);

    warpDOWN = new FlxTilemap();
    warpDOWN.loadMapFromArray(warpDownData.tileArray, tiledData.width, tiledData.height, AssetPaths.tiles__png, 50, 50, OFF, 1);
    warpDOWN.setTileProperties(33, ANY);
    warpDOWN.x = -60; 
    warpDOWN.y = -65;
    warpDOWN.alpha = 0.5;
    add(warpDOWN);

    warpLEFT = new FlxTilemap();
    warpLEFT.loadMapFromArray(warpLeftData.tileArray, tiledData.width, tiledData.height, AssetPaths.tiles__png, 50, 50, OFF, 1);
    warpLEFT.setTileProperties(34, ANY);
    warpLEFT.x = -60; 
    warpLEFT.y = -65;
    warpLEFT.alpha = 0.5;
    add(warpLEFT);

    if (player != null)
    {
        remove(player);
        add(player);
    }

    spawnTimer = 0.1;
}


}

