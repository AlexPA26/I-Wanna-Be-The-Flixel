package leveldata;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledLayer;

class MapSettings 
{
    /**
     * Checks for a layer named "Autoscroll" or "PlayerSpeed" 
     * and returns the settings found.
     */
    public static function getMapValue(tiledData:TiledMap, layerName:String, propertyName:String, defaultValue:Float):Float
    {
        for (layer in tiledData.layers)
        {
            // We search for a layer with the specific name
            if (layer.name == layerName && layer.type == TiledLayerType.OBJECT)
            {
                var objectLayer:TiledObjectLayer = cast layer;
                if (objectLayer.properties.contains(propertyName))
                {
                    return Std.parseFloat(objectLayer.properties.get(propertyName));
                }
                // If layer exists but property doesn't, we can return a "found" signal 
                // (like 1.0 for true) or just the default.
                return defaultValue; 
            }
        }
        return defaultValue;
    }

    /**
     * Helper to specifically check if a layer exists at all (for Autoscroll)
     */
    public static function layerExists(tiledData:TiledMap, layerName:String):Bool
    {
        for (layer in tiledData.layers)
        {
            if (layer.name == layerName) return true;
        }
        return false;
    }
}