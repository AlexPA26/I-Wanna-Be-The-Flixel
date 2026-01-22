package levels.chapters.chapter1;

import flixel.text.FlxText;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxDirection;
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

// TENGO QUE HACER QUE LOS TILES DE LOS PINCHOS SEAN DIFERENTES A TODO (OTRO PNG)
class Chapter1State extends FlxState
{
    //###################
    var player:Player;
    var bg:FlxSprite;
    var map:FlxTilemap;
    var mapDeco:FlxTilemap;
    var currentRoomName:String;
    //###################
    var warpUP:FlxTilemap;
    var warpRIGHT:FlxTilemap;
    var warpDOWN:FlxTilemap;
    var warpLEFT:FlxTilemap;
    var deathBlock:FlxTilemap;
    var saveLayer:FlxTilemap;
    var saveAnimation:FlxSprite;
    //###################
    var DangerObjects:FlxGroup;
    var spikes:FlxGroup;
    //###################
    var tiledData:TiledMap;
    var spawnTimer:Float = 0.2;
    //###################
    var playerDeaths:FlxText;
    var currentRoom:FlxText;

override public function create():Void
{
    FlxG.sound.playMusic(AssetPaths.rain__ogg, 0.3, true);
    FlxG.cameras.bgColor = 0xFF2B3156;
    FlxG.mouse.visible = true;
    FlxG.bitmap.add("assets/images/shared/death.png");
    FlxG.sound.cache(AssetPaths.death_bgm__ogg);
    
    DangerObjects = new FlxGroup();
    add(DangerObjects);

    loadRoom(PlayerData.currentRoom);

    player = new Player(PlayerData.spawnX, PlayerData.spawnY);
    add(player);

    #if debug
    FlxG.camera.follow(player, FlxCameraFollowStyle.LOCKON);
    #end

    saveAnimation = new FlxSprite();
    saveAnimation.makeGraphic(FlxG.width + 1, FlxG.height, FlxColor.WHITE, false);
    saveAnimation.alpha = 0;
    add(saveAnimation);

    playerDeaths = new FlxText("Deaths: ");
    playerDeaths.y = FlxG.height - 80;
    playerDeaths.x += 50;
    playerDeaths.color = FlxColor.WHITE;
    playerDeaths.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
    playerDeaths.scrollFactor.set(0, 0);
    playerDeaths.size = 22;
    add(playerDeaths);

    currentRoom = new FlxText("Last Save: ");
    currentRoom.y = FlxG.height - 50;
    currentRoom.x += 50;
    currentRoom.color = FlxColor.WHITE;
    currentRoom.setBorderStyle(OUTLINE, FlxColor.BLACK, 3);
    currentRoom.scrollFactor.set(0, 0);
    currentRoom.size = 22;
    add(currentRoom);
    
    super.create();
}

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(player, map);
        playerDeaths.text = "Deaths: " + PlayerData.totalDeaths;
        currentRoom.text = "Last Save: " + PlayerData.currentRoom;
        super.update(elapsed);
    
    warpUP.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 55) TransitionUP(tile, player); return true; });
    warpRIGHT.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 56) TransitionRIGHT(tile, player); return true; });
    warpDOWN.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 57) TransitionDOWN(tile, player); return true; });
    warpLEFT.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 58) TransitionLEFT(tile, player); return true; });
    // deathBlock.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 59) killPlayer(); return true; });
    saveLayer.objectOverlapsTiles(player, (tile, player) -> { if (tile.index == 60) saveLogic(tile, player); return true; });

    if (spawnTimer > 0) { spawnTimer -= elapsed; } else
            
        {

        if (FlxG.overlap(player, DangerObjects))
        {
            killPlayer();
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

        if (saveAnimation.alpha > 0)
        {
            saveAnimation.alpha -= 0.01;
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
    currentRoomName = roomName;
    var path = "assets/data/chapters/chapter1/ch1-" + roomName + ".tmx";
    tiledData = new TiledMap(path);

    if (map != null) { remove(map); map.destroy(); }
    if (mapDeco != null) { remove(mapDeco); mapDeco.destroy(); }
    if (saveLayer != null) { remove(saveLayer); saveLayer.destroy(); }
    if (warpUP != null)  remove(warpUP);
    if (warpRIGHT != null)  remove(warpRIGHT);
    if (warpDOWN != null)  remove(warpDOWN);
    if (warpLEFT != null)  remove(warpLEFT);
    if (spikes != null) { DangerObjects.remove(spikes); spikes.destroy(); }

    DangerObjects.clear();

    var mainLayer = tiledData.getLayer("tiles-main");
    var warpUpData:TiledTileLayer = cast tiledData.getLayer("warps-up");
    var warpRightData:TiledTileLayer = cast tiledData.getLayer("warps-right");
    var warpDownData:TiledTileLayer = cast tiledData.getLayer("warps-down");
    var warpLeftData:TiledTileLayer = cast tiledData.getLayer("warps-left");
    var decoLayer = tiledData.getLayer("tiles-deco");
    var sData = tiledData.getLayer("saves");

    var tileLayer:TiledTileLayer = cast mainLayer;
    map = new FlxTilemap();
    map.loadMapFromArray(tileLayer.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    map.x = -60; map.y = -65;
    add(map);

    var decoLayerCast:TiledTileLayer = cast decoLayer;
    mapDeco = new FlxTilemap();
    mapDeco.loadMapFromArray(decoLayerCast.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    mapDeco.x = -60; mapDeco.y = -65;
    add(mapDeco);

    saveLayer = new FlxTilemap();
    var savesTileLayer:TiledTileLayer = cast sData;
    saveLayer.loadMapFromArray(savesTileLayer.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    saveLayer.setTileProperties(60, ANY); 
    saveLayer.x = -60; saveLayer.y = -65;
    add(saveLayer);
    
    warpUP = new FlxTilemap();
    warpUP.loadMapFromArray(warpUpData.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    warpUP.setTileProperties(55, ANY);
    warpUP.x = -60; 
    warpUP.y = -65;
    warpUP.alpha = 0.5;
    add(warpUP);

    warpRIGHT = new FlxTilemap();
    warpRIGHT.loadMapFromArray(warpRightData.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    warpRIGHT.setTileProperties(56, ANY);
    warpRIGHT.x = -60; 
    warpRIGHT.y = -65;
    warpRIGHT.alpha = 0.5;
    add(warpRIGHT);

    warpDOWN = new FlxTilemap();
    warpDOWN.loadMapFromArray(warpDownData.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    warpDOWN.setTileProperties(57, ANY);
    warpDOWN.x = -60; 
    warpDOWN.y = -65;
    warpDOWN.alpha = 0.5;
    add(warpDOWN);

    warpLEFT = new FlxTilemap();
    warpLEFT.loadMapFromArray(warpLeftData.tileArray, tiledData.width, tiledData.height, AssetPaths.ch1tiles__png, 50, 50, OFF, 1);
    warpLEFT.setTileProperties(58, ANY);
    warpLEFT.x = -60; 
    warpLEFT.y = -65;
    warpLEFT.alpha = 0.5;
    add(warpLEFT);

    if (player != null) { remove(player); add(player); }

    spikes = leveldata.ObjectLoader.loadEverything(tiledData, this, map.x, map.y);
    DangerObjects.add(spikes);
}

function saveLogic(tile:FlxObject, obj:FlxObject):Void
{
    var tile:flixel.tile.FlxTile = cast tile;

    PlayerData.spawnX = player.x;
    PlayerData.spawnY = player.y;
    PlayerData.currentRoom = currentRoomName;

    saveAnimation.alpha = 0.2;
    FlxG.sound.play(AssetPaths.savedgame__ogg, 0.5, false);
    saveLayer.setTileIndex(tile.mapIndex, 0);
}

function killPlayer():Void
{
    if (player.exists)
    {
        PlayerData.deathX = player.x;
        PlayerData.deathY = player.y;
        PlayerData.totalDeaths++;
        remove(player);
        if (FlxG.sound.music != null) FlxG.sound.music.pause();
        openSubState(new DeathState());
    }
}

}