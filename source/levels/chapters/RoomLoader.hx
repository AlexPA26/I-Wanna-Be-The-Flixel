package levels.chapters;

import leveldata.background.BackgroundManager;
import flixel.effects.particles.FlxEmitter;
import leveldata.events.SavePoint;
import leveldata.events.ObjectLoader;
import levels.chapters.datachapter.ChapterState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;

class RoomLoader 
{
    public static function loadRoom(state:ChapterState, roomName:String):Void
    {
        flixel.tweens.FlxTween.globalManager.forEach(function(twn) twn.cancel());

        #if !mobile
            var chartPath = "assets/data/chapters/chapter" + PlayerData.currentChapter + "/ch" + PlayerData.currentChapter + "-" + roomName + ".tmx";
        #else
            var chartPath = "assets/data/chapters_mobile/chapter" + PlayerData.currentChapter + "/ch" + PlayerData.currentChapter + "-" + roomName + "-mobile" + ".tmx";
        #end
        state.currentRoomName = roomName;
        state.tiledData = new TiledMap(chartPath);

        if (state.map != null) { state.remove(state.map); state.map.destroy(); }
        if (state.mapDeco != null) { state.remove(state.mapDeco); state.mapDeco.destroy(); }
        if (state.mapDeco2 != null) { state.remove(state.mapDeco2); state.mapDeco2.destroy(); }

        var mainLayer:TiledTileLayer = cast state.tiledData.getLayer("tiles-main");
        state.map = new FlxTilemap();
        state.map.loadMapFromArray(mainLayer.tileArray, state.tiledData.width, state.tiledData.height, state.tilesPath, 50, 50, OFF, 1);
        state.map.x = -60; state.map.y = -65;
        FlxG.worldBounds.set(state.map.x, state.map.y, state.map.width, state.map.height);
        state.add(state.map);

        var decoLayer = state.tiledData.getLayer("tiles-deco");
        if (decoLayer != null)
        {
            state.mapDeco = new FlxTilemap();
            state.mapDeco.loadMapFromArray(cast(decoLayer, TiledTileLayer).tileArray, state.tiledData.width, state.tiledData.height, state.tilesPath, 50, 50, OFF, 1);
            state.mapDeco.x = -60; state.mapDeco.y = -65;
            state.add(state.mapDeco);
        }

        var decoLayer2 = state.tiledData.getLayer("tiles-deco2");
        if (decoLayer2 != null)
        {
            state.mapDeco2 = new FlxTilemap();
            state.mapDeco2.loadMapFromArray(cast(decoLayer2, TiledTileLayer).tileArray, state.tiledData.width, state.tiledData.height, state.tilesPath, 50, 50, OFF, 1);
            state.mapDeco2.x = -60; state.mapDeco2.y = -65;
            state.add(state.mapDeco2);
        }

        state.DangerObjects.clear();
        state.doubleJumpGroup.clear();
        state.flipGroup.clear();
        state.portalGroup.clear();
        state.warpsGroup.clear();
        state.platforms.clear();
        state.trampolines.clear();
        state.trampolinesMini.clear();
        state.lightsGroup.clear();
        state.fallingBlock.clear();
        state.slabs.clear();
        state.slabsNight.clear();
        state.popups.clear();
        state.saveParticlesGroup.clear();

        if (state.saveParticlesGroup != null)
        {
            state.saveParticlesGroup.forEachExists(function(p:FlxEmitter)
        {
            p.active = false;
            p.visible = false;
            p.exists = false;
        });
        state.saveParticlesGroup.clear();
        }

        if (state.savesGroup != null)
        {
            state.savesGroup.forEachExists(function(s:SavePoint)
            {
                s.exists = false;
            });
        state.savesGroup.clear();
        }

        ObjectLoader.loadEverything(state.tiledData, state, state.map.x, state.map.y);
        state.add(state.PlayerGlow);
        state.add(state.DangerObjects);
        state.add(state.player);
        state.add(state.player.doubleJumpEffect);
        state.add(state.doubleJumpGroup);
        state.add(state.player.dashEffect);
        state.add(state.saveParticlesGroup);
        state.add(state.savesGroup);
        state.add(state.popups);
        state.add(state.warpsGroup);
        state.add(state.slabs);
        state.add(state.slabsNight);
        state.add(state.platforms);
        state.add(state.fallingBlock);
        state.add(state.flipGroup);
        state.add(state.portalGroup);
        state.add(state.trampolines);
        state.add(state.trampolinesMini);

        state.savesGroup.forEach(function(save:SavePoint)
        {
            state.saveParticlesGroup.add(save.particle);
        });

        BackgroundManager.updateAllEffects(state, state.tiledData);
        state.add(state.lightsGroup);
        if (state.vignite != null)
        {
            if (state.members.contains(state.vignite))
            state.remove(state.vignite);
            state.add(state.vignite);
        }
        state.add(state.vignite);
        state.setupHUD();
        state.autoScroll();
        state.cameraScroll();
        state.updateMusic();
        state.add(state.saveAnimation);

        PlayerData.saveCooldown = 0.1;
        state.spawnTimer = 0.1;

        state.hudGroup.clear();
        state.hudGroup.add(state.virtualPad);
        state.hudGroup.add(state.currentChapter);
        state.hudGroup.add(state.lastSave);
        state.hudGroup.add(state.playerDeaths);
        state.add(state.hudGroup);
        state.layoutVirtualPad();
        state.player.pad = state.virtualPad;

        #if !mobile
            state.virtualPad.visible = false;
            state.virtualPad.active = false;
        #else
            state.player.pad.alpha = 0.5;
        #end

        // --- TSX DEBUG TRACE START ---
if (state.tiledData != null && state.tiledData.tilesets != null) 
{
    trace("--- Tileset Info for: " + roomName + " ---");
    
    for (ts in state.tiledData.tilesets) 
    {
        trace("Tileset Key: " + ts.name);
        trace("First GID: " + ts.firstGID);
        
        // This is the property that holds the path to the PNG inside the TMX/TSX
        if (ts.imageSource != null) {
            trace("Internal Image Source Path: " + ts.imageSource);
        } else {
            trace("WARNING: No image source found for this tileset!");
        }
    }
} else {
    trace("!!! ERROR: tiledData or tilesets Map is null for " + roomName);
}
// --- TSX DEBUG TRACE END ---
    }

}