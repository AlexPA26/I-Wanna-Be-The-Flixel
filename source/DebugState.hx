package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class DebugState extends FlxState
{
    var player:Player;
    var map:FlxTilemap;

    override public function create():Void
    {
        var tiledData = new TiledMap("assets/data/dummy.tmx");
        var layer:TiledTileLayer = cast tiledData.getLayer("tilebox-dummy");

        FlxG.cameras.bgColor = FlxColor.GRAY;
        FlxG.mouse.visible = false;

        map = new FlxTilemap();
        map.loadMapFromArray(
            layer.tileArray, 
            tiledData.width, 
            tiledData.height, 
            AssetPaths.dummy__png, 
            50, 50, 
            OFF, 1 
        );

        map.setTileProperties(1, ANY, null, null, 8); 
        
        add(map);

        player = new Player(100, 140);
        add(player);

        FlxG.sound.playMusic(AssetPaths.devmap__ogg, 0.1, true);

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(player, map);
        super.update(elapsed);

        if (FlxG.keys.justPressed.R) FlxG.resetState();
    }
}