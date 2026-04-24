package leveldata.events;

import flixel.addons.editors.tiled.TiledMap;
import main.ChapterState;
import leveldata.background.AcidFluid;

class EventLoader
{
    public static function loadEvents(tiledData:TiledMap, state:ChapterState):Void
    {
        var acidActive:Bool = false;

        for (layer in tiledData.layers) // ACID EFFECT
        {
            if (layer.name == "acidlayer")
            {
                acidActive = true;
                break;
            }
        }

        if (acidActive)
        {
            if (state.roomAcid == null) 
            {
                state.roomAcid = new AcidFluid(50);
                state.eventEffectGroup.add(state.roomAcid);
            }

        }
    }
}