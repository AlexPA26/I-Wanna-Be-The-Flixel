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
                            var localID:Int = 0;
                        if (obj.properties.contains("id")) 
                        {
                            localID = Std.parseInt(obj.properties.get("id"));
                        } 
                        else 
                        {
                            var tileset = tiledData.getGidOwner(obj.gid);
                            localID = obj.gid - tileset.firstGID;
                        }
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
                            var tileset = tiledData.getGidOwner(obj.gid);
                            var localID:Int = obj.gid - tileset.firstGID;
                            var plat = new MovingBlock(spawnX, spawnY, dir, localID);
                            state.platforms.add(plat);

                        case "falling":
                            var dir = obj.properties.get("direction");
                            var fall = new FallingBlock(spawnX, spawnY, dir);
                            state.fallingBlock.add(fall);

                        case "light":
                            var light = new LightTorch(spawnX, spawnY);
                            light.x -= light.width / 2;
                            light.y -= light.height / 2;
                            
                            state.lightsGroup.add(light);
                    }
                }
            }
        }
    }
}