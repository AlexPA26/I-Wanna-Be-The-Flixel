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
                        case 31: // SPIKE ARRIBA
                            offX = 7; offY = 10; spikeweight = 35; spikeheight = 35;
                        
                        case 32: // SPIKE DERECHA
                            offX = 4; offY = 15; spikeweight = 35; spikeheight = 20;

                        case 33: // SPIKE ABAJO
                            offX = 10; offY = 4; spikeweight = 30; spikeheight = 35;

                        case 34: // SPIKE IZQUIERDA
                            offX = 11; offY = 15; spikeweight = 35; spikeheight = 20;
                            
                        default: // SPIKE DE REPUESTO
                            offX = 20; offY = 20; spikeweight = 10; spikeheight = 10;
                    }

                // ######################
                // HITBOX DEL SPIKE!!!!!!
                // ######################

                    var hitbox = new FlxSprite(obj.x + offX, spikeY + offY);
                    
                    if (obj.gid != -1) 
                    {
                        hitbox.loadGraphic(AssetPaths.ch1tiles__png, true, 50, 50);
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