package levels.debuglevels;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;

class StageDebugLEFT extends FlxState
{
    var player:Player;
    var map:FlxTilemap;
    //###################
    var DangerObjects:FlxGroup;
    var spikes:FlxGroup;
    //###################

override public function create():Void
{
    var tiledData = new TiledMap("assets/data/debug-maps/devmapLEFT.tmx");
    var layer:TiledTileLayer = cast tiledData.getLayer("tiles");

    FlxG.cameras.bgColor = 0xFF6EFF75;
    FlxG.mouse.visible = true;

    DangerObjects = new FlxGroup();

    map = new FlxTilemap();
    map.loadMapFromArray(layer.tileArray,
        tiledData.width,
        tiledData.height,
        AssetPaths.dummy__png, 50, 50, OFF, 1);
    
    map.x = -60;
    map.y = -90;

    map.setTileProperties(1, ANY, null, null, 1);
    map.setTileProperties(25, NONE, TransitionUP, null,25);
    map.setTileProperties(26, ANY, TransitionRIGHT, null, 26);
    map.setTileProperties(27, NONE, TransitionDOWN, null,27);
    map.setTileProperties(28, NONE, TransitionLEFT, null,28);
    // map.screenCenter();
    add(map);

    spikes = leveldata.ObjectLoader.loadEverything(tiledData, this, map.x, map.y);
    DangerObjects.add(spikes);

    player = new Player(PlayerData.spawnX, PlayerData.spawnY);
    player.velocity.x = PlayerData.lastVelX; 
    player.velocity.y = PlayerData.lastVelY;
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

        map.objectOverlapsTiles(player, (tile, player) ->
        { if (tile.index == 25)
        {
            TransitionUP(tile, player);
            // trace("TOUCHED TILE 25");
        }
        return true; 
        });

        map.objectOverlapsTiles(player, (tile, player) ->
        { if (tile.index == 26)
        {
            TransitionRIGHT(tile, player);
            // trace("TOUCHED TILE 26");
        }
        return true; 
        });

        map.objectOverlapsTiles(player, (tile, player) ->
        { if (tile.index == 27)
        {
            TransitionDOWN(tile, player);
            // trace("TOUCHED TILE 27");
        }
        return true; 
        });

        map.objectOverlapsTiles(player, (tile, player) ->
        { if (tile.index == 28)
        {
            TransitionLEFT(tile, player);
            // trace("TOUCHED TILE 28");
        }
        return true; 
        });

        if (FlxG.overlap(player, DangerObjects))
        {
            FlxG.resetState();
        }

        if (FlxG.keys.justPressed.TAB)
        {
            FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
        }

        if (FlxG.keys.justPressed.R)
        {
            FlxG.switchState(() -> new StageDebugMID());
        }

            
    }

    function TransitionUP(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = player.x;
            PlayerData.spawnY = FlxG.height -30;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            FlxG.switchState(() -> new StageDebugUP());
        }

    function TransitionRIGHT(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = 0;
            PlayerData.spawnY = player.y;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            FlxG.switchState(() -> new StageDebugMID());
        }

    function TransitionDOWN(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = player.x;
            PlayerData.spawnY = player.y = 0;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            FlxG.switchState(() -> new StageDebugDOWN());
        }

    function TransitionLEFT(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = FlxG.width;
            PlayerData.spawnY = player.y;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            PlayerData.savedCanDoubleJump = player.canDoubleJump;
            FlxG.switchState(() -> new StageDebugLEFT());
        }

    

}