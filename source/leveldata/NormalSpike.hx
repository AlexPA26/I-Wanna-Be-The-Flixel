package leveldata;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.util.FlxColor;

class NormalSpike
{

    public static function loadHazards(tiledData:TiledMap, spikesGroup:FlxGroup):Void
    {
        var objectLayer = tiledData.getLayer("spike-normal");

        if (objectLayer != null && Std.isOfType(objectLayer, TiledObjectLayer))
        {
            var castLayer:TiledObjectLayer = cast objectLayer;

            for (obj in castLayer.objects)
            {
                if (obj.type == "spike" || obj.gid != -1)
                {
                    var spikeY:Float = obj.y;
                    if (obj.gid != -1) spikeY -= obj.height;

                    var offX:Float = 0;
                    var offY:Float = 0;
                    
                    var hitbox = new FlxSprite(obj.x + offX, spikeY + offY);
                    
                    if (obj.gid != -1) 
                    {
                        hitbox.loadGraphic(AssetPaths.dummy__png, true, 50, 50);
                        hitbox.animation.frameIndex = obj.gid - 1; 
                        // ######################
                        // HITBOX DEL SPIKE!!!!!!
                        // ######################
                        hitbox.width = 5; 
                        hitbox.height = 5;
                        // ######################
                        // HITBOX DEL SPIKE!!!!!!
                        // ######################
                        hitbox.offset.set(offX, offY); 
                    }

                    else // Esto es por si no existe o hay otra cosa que no sea un Spike

                    {
                        hitbox.makeGraphic(Std.int(obj.width), Std.int(obj.height), FlxColor.TRANSPARENT);
                    }
                    
                    hitbox.immovable = true;
                    spikesGroup.add(hitbox);
                }
            }
        }
    }
}