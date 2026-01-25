package leveldata;

import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.FlxSprite;
import leveldata.*;
import levels.chapters.chapter1.Chapter1State;

class ObjectLoader
{
    public static function loadEverything(tiledData:TiledMap, state:Chapter1State, offsetX:Float, offsetY:Float):Void
    {

        for (layer in tiledData.layers)
        {
            if (layer.type == TiledLayerType.OBJECT)
            {
                var objectLayer:TiledObjectLayer = cast layer;

                for (obj in objectLayer.objects)
                {
                    var spawnX = obj.x + offsetX;
                    var spawnY = obj.y + offsetY;

                    if (obj.gid > 0) 
                    {
                        spawnY -= obj.height;
                    }

                    switch (obj.name)
                    {
                        case "spike":
                            var tileset = tiledData.getGidOwner(obj.gid);
                            var localID:Int = obj.gid - tileset.firstGID;

                            var spike = new NormalSpike(spawnX, spawnY, localID);
                            state.DangerObjects.add(spike);

                        case "save":
                            var save = new SavePoint(spawnX, spawnY);
                            state.savesGroup.add(save);

                        case "laser":
                            var dir:String = "hor";
                            if (obj.properties.contains("direction")) { dir = obj.properties.get("direction"); }
                            var laser = new YellowLaser(spawnX, spawnY, dir); 
                            state.DangerObjects.add(laser);

                        case "trampoline":
                            var tramp = new NormalTrampoline(spawnX, spawnY);
                            state.trampolines.add(tramp);

                        case "platform":
                            var dir = obj.properties.get("direction");
                            var plat = new MovingBlock(spawnX, spawnY + 50, dir);
                            state.platforms.add(plat);
                    }
                }
            }
        }
    }
}