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
                    var spikeweight:Float = 10;
                    var spikeheight:Float = 10;

                // ######################
                // HITBOX DEL SPIKE!!!!!!
                // ######################

                    switch (obj.gid)
                    {
                        case 17: // SPIKE ARRIBA
                            offX = 15; offY = 30; spikeweight = 20; spikeheight = 15;
                        
                        case 18: // SPIKE DERECHA
                            offX = 10; offY = 20; spikeweight = 20; spikeheight = 10;

                        case 19: // SPIKE ABAJO
                            offX = 20; offY = 10; spikeweight = 10; spikeheight = 20;

                        case 20: // SPIKE IZQUIERDA
                            offX = 25; offY = 20; spikeweight = 20; spikeheight = 10;
                            
                        default: // SPIKE DE REPUESTO
                            offX = 20; offY = 20; spikeweight = 10; spikeheight = 10;
                    }

                // ######################
                // HITBOX DEL SPIKE!!!!!!
                // ######################

                    var hitbox = new FlxSprite(obj.x + offX, spikeY + offY);
                    
                    if (obj.gid != -1) 
                    {
                        hitbox.loadGraphic(AssetPaths.dummy__png, true, 50, 50);
                        hitbox.animation.frameIndex = obj.gid - 1; 

                        hitbox.width = spikeweight; 
                        hitbox.height = spikeheight;

                        hitbox.offset.set(offX, offY); 
                    }
                    else 
                    {
                        hitbox.makeGraphic(Std.int(obj.width), Std.int(obj.height), FlxColor.RED);
                    }
                    
                    hitbox.immovable = true;
                    spikesGroup.add(hitbox);
                }
            }
        }
    }
}