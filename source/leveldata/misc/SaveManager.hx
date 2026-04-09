package leveldata.misc;

import flixel.util.FlxSave;

class SaveManager
{
    public static var save:FlxSave = new FlxSave();

    public static function saveGame():Void
    {
        save.bind("IWBTF_Save1");
        save.data.roomID = PlayerData.currentRoom;
        save.data.deaths = PlayerData.totalDeaths;
        save.data.spawnX = PlayerData.spawnX;
        save.data.spawnY = PlayerData.spawnY;
        
        save.flush(); // Writes it to the disk
    }

    public static function loadGame():Bool
    {
        save.bind("IWBTF_Save1");
        
        if (save.data.roomID != null)
        {
            PlayerData.timeElapsed = save.data.playtime;
            PlayerData.currentChapter = save.data.chapterID;
            PlayerData.currentRoom = save.data.roomID;
            PlayerData.totalDeaths = save.data.deaths;
            PlayerData.spawnX = save.data.spawnX;
            PlayerData.spawnY = save.data.spawnY;
            return true;
        }
        return false;
    }
}