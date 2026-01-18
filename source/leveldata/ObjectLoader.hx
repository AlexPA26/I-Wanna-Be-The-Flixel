package leveldata;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;
import leveldata.NormalSpike;
import flixel.FlxSprite;

class ObjectLoader
{
    public static function loadEverything(tiledData:TiledMap, state:FlxState, offsetX:Float, offsetY:Float):FlxGroup
    {
        var spikesGroup = new FlxGroup();
        NormalSpike.loadHazards(tiledData, spikesGroup);
        
        spikesGroup.forEach(function(spr) {var s = cast(spr, FlxSprite);
            if (s != null)
            {
            s.x += offsetX;
            s.y += offsetY;
            }
        });

        state.add(spikesGroup);
        return spikesGroup;
    }
}