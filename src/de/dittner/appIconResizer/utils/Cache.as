package de.dittner.appIconResizer.utils {
import de.dittner.async.utils.invalidateOf;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class Cache {
	public function Cache() {}

	private static var initialized:Boolean = false;
	private static var dbFile:File;
	private static var dbData:Object = {};
	private static var writeFileStream:FileStream;
	private static const APP_ROOT:String = "APP_ICON_RESIZER/";

	public static function init():void {
		if (!initialized) {
			initialized = true;

			var dbRootFile:File = File.documentsDirectory.resolvePath(APP_ROOT);
			if (!dbRootFile.exists) dbRootFile.createDirectory();
			dbFile = File.documentsDirectory.resolvePath(APP_ROOT + "data.cache");
			if (dbFile.exists) {
				loadHashData();
			}
			else {
				writeFileStream = new FileStream();
				writeFileStream.open(dbFile, FileMode.WRITE);
				writeFileStream.writeObject(dbData);
				writeFileStream.close();
				writeFileStream = null;
			}
		}
	}

	private static function loadHashData():void {
		var fileStream:FileStream = new FileStream();
		try {
			fileStream.open(dbFile, FileMode.READ);
			dbData = fileStream.readObject();
			fileStream.close();
		}
		catch (e:Error) {
			trace("LocalCache, error in loadHashData by path: " + dbFile.nativePath);
			if (fileStream) fileStream.close();
		}
	}

	private static var needFlush:Boolean = false;

	public static function has(key:String):Boolean {
		return dbData.hasOwnProperty(key);
	}

	public static function read(key:String):* {
		return has(key) ? dbData[key] : null;
	}

	public static function write(key:String, object:*):void {
		dbData[key] = object;
		needFlush = true;
		invalidateOf(flushNow);
	}

	public static function remove(key:String):void {
		delete dbData[key];
		needFlush = true;
		invalidateOf(flushNow);
	}

	public static function flushNow():void {
		if (needFlush) {
			needFlush = false;
			store();
		}
	}

	public static function clear():void {
		dbData = {};
		store();
	}

	public static function store():void {
		try {
			if (!writeFileStream) {
				writeFileStream = new FileStream();
			}

			writeFileStream.open(dbFile, FileMode.UPDATE);
			writeFileStream.writeObject(dbData);
			writeFileStream.close();
		}
		catch (e:Error) {
			trace("LocalStorage, error in store: " + e.message);
			if (writeFileStream) {
				writeFileStream.close();
				writeFileStream = null;
			}
		}
	}
}
}
