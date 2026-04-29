package main;

import haxe.zip.Reader;
import haxe.zip.Entry;
import haxe.io.BytesInput;
import openfl.Assets;

class MapPacker
{
    public static var currentMaps:Map<String, String> = new Map();

    public static function loadChapter(chapter:Int):Void
    {
        currentMaps.clear();

        var datPath = "assets/data/chapters/chapter" + chapter + ".dat";
        var bytes = Assets.getBytes(datPath);
        
        if (bytes == null) 
        {
            trace("Could not find dat file: " + datPath);
            return;
        }

        var bytesInput = new BytesInput(bytes);
        var zipReader = new Reader(bytesInput);
        var entries:List<Entry> = zipReader.read();

        for (entry in entries)
        {
            var uncompressedBytes = Reader.unzip(entry);
            var xmlData = uncompressedBytes.toString();
            var mapName = entry.fileName.split(".")[0];
            currentMaps.set(mapName, xmlData);
        }
    }
}