package;

class PlayerData
{
    public static var currentChapter:Int = 1;
    public static var currentRoom:String = "01";
    public static var currentSong:String = "";
    public static var timeElapsed:String = "00:00:00";

    public static var spawnX:Float = 200;
    public static var spawnY:Float = 250;
    public static var deathX:Float;
    public static var deathY:Float;
    public static var lastVelX:Float = 0;
    public static var lastVelY:Float = 0;
    public static var totalDeaths:Int = 0;
    public static var lastMusicTime:Float = 0;
    public static var isRespawning:Bool = false;
    public static var saveCooldown:Float = 0;

}