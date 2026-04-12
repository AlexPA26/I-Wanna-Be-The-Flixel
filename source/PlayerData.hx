package;

class PlayerData
{
    public static var currentChapter:Int;
    public static var lastSaveRoom:String;
    public static var currentRoom:String = "";
    public static var currentSong:String = "";
    public static var timeElapsed:String = "00:00:00";

    public static var spawnX:Float;
    public static var spawnY:Float;
    public static var deathX:Float;
    public static var deathY:Float;
    public static var lastVelX:Float = 0;
    public static var lastVelY:Float = 0;
    public static var totalDeaths:Int;
    public static var lastMusicTime:Float = 0;
    public static var isRespawning:Bool = false;
    public static var saveCooldown:Float = 0;

}