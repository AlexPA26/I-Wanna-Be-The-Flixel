package levels.worldtest;

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

class Stage04a extends FlxState
{
    var player:Player;
    var map:FlxTilemap;
    //###################
    var DangerObjects:FlxGroup;
    var spikes:FlxGroup;
    //###################
    var debugText:flixel.text.FlxText;
    var entryTimer:Float = 0;

override public function create():Void
{
    var tiledData = new TiledMap("assets/data/testworld/map04.tmx");
    var layer:TiledTileLayer = cast tiledData.getLayer("tiles");
    

    FlxG.cameras.bgColor = 0xFF5B7B6A;
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
            FlxG.resetState();
        }

            
    }

    function TransitionUP(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = player.x;
            PlayerData.spawnY = PlayerData.spawnY = FlxG.height - 50;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            PlayerData.savedCanDoubleJump = player.canDoubleJump;
            FlxG.switchState(() -> new Stage02());
        }

    function TransitionRIGHT(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = FlxG.width - 100;
            PlayerData.spawnY = 50;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            PlayerData.savedCanDoubleJump = player.canDoubleJump;
            FlxG.switchState(() -> new Stage04b());
        }

    function TransitionDOWN(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = FlxG.width -100;
            PlayerData.spawnY = player.y = 0;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            PlayerData.savedCanDoubleJump = player.canDoubleJump;
            FlxG.switchState(() -> new Stage03());
        }

    function TransitionLEFT(tile:FlxObject, obj:FlxObject):Void
        {
            PlayerData.spawnX = FlxG.width;
            PlayerData.spawnY = 50;
            PlayerData.lastVelX = player.acceleration.x;
            PlayerData.lastVelY = player.velocity.y;
            PlayerData.savedCanDoubleJump = player.canDoubleJump;
            FlxG.switchState(() -> new Stage01());
        }

    

}