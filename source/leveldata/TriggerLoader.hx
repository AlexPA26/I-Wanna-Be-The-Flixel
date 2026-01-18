// package leveldata;

// import flixel.FlxState;
// import flixel.group.FlxGroup;
// import flixel.addons.editors.tiled.TiledMap;
// import flixel.addons.editors.tiled.TiledObjectLayer;
// import flixel.FlxSprite;

// class TriggerLoader
// {
//     public static function loadExits(tiledData:TiledMap, state:FlxState):Map<String, FlxGroup>
//     {
//         var exitGroups = [
//             "right" => new FlxGroup(),
//             "left"  => new FlxGroup(),
//             "up"    => new FlxGroup(),
//             "down"  => new FlxGroup()
//         ];

//         var layer = tiledData.getLayer("exits");
//         if (layer != null && Std.isOfType(layer, TiledObjectLayer))
//         {
//             var objLayer:TiledObjectLayer = cast layer;
//             for (obj in objLayer.objects)
//             {
//                 var trigger = new FlxSprite(obj.x, obj.y);
//                 trigger.makeGraphic(Std.int(obj.width), Std.int(obj.height), 0x8800FF00); 
//                 trigger.immovable = true;

//                 if (exitGroups.exists(obj.name)) {
//                     exitGroups.get(obj.name).add(trigger);
//                 }
//             }
//         }

//         for (group in exitGroups) state.add(group);

//         return exitGroups;
//     }
// }