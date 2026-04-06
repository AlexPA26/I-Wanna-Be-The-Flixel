package leveldata.events;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledLayer;

class MapSettings 
{
    public static function getMapValue(tiledData:TiledMap, layerName:String, propertyName:String, defaultValue:Float):Float
    {
        for (layer in tiledData.layers)
        {
            if (layer.name == layerName && layer.type == TiledLayerType.OBJECT)
            {
                var objectLayer:TiledObjectLayer = cast layer;
                if (objectLayer.properties.contains(propertyName))
                {
                    return Std.parseFloat(objectLayer.properties.get(propertyName));
                }

                return defaultValue; 
            }
        }
        return defaultValue;
    }

    public static function layerExists(tiledData:TiledMap, layerName:String):Bool
    {
        for (layer in tiledData.layers)
        {
            if (layer.name == layerName) return true;
        }
        return false;
    }
}