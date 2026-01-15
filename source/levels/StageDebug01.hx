package levels;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import leveldata.NormalSpike;

class StageDebug01 extends FlxState
{
    var player:Player;
    var map:FlxTilemap;
    var spikes:FlxGroup;

    override public function create():Void
    {
        var tiledData = new TiledMap("assets/data/dummy.tmx");
        var layer:TiledTileLayer = cast tiledData.getLayer("tilebox-dummy");

        FlxG.cameras.bgColor = FlxColor.PURPLE;
        FlxG.mouse.visible = false;

        map = new FlxTilemap();
        map.loadMapFromArray(
            layer.tileArray, 
            tiledData.width, 
            tiledData.height,AssetPaths.dummy__png, 50, 50, OFF, 1 );

        map.setTileProperties(1, ANY, null, null, 16);
        add(map);

        spikes = new FlxGroup();
        add(spikes);
        NormalSpike.loadHazards(tiledData, spikes);

        // ############################################
        // EL PLAYER TIENE QUE PONERSE SIEMPRE AL FINAL
        // ############################################

        player = new Player(100, 40);
        add(player);

        // ######################
        // SOUNDTRACK DEL NIVEL!!
        // ######################

        FlxG.sound.playMusic(AssetPaths.devmap__ogg, 0.1, true);


        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        FlxG.collide(player, map);

        if (FlxG.overlap(player, spikes))
        {
            FlxG.resetState();
        }

        super.update(elapsed);

        if (FlxG.keys.justPressed.TAB)
    {
        FlxG.debugger.drawDebug = !FlxG.debugger.drawDebug;
    }
        
        if (FlxG.keys.justPressed.R) FlxG.resetState();
    }
}