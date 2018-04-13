package de.dittner.appIconResizer.utils {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import mx.graphics.codec.JPEGEncoder;
import mx.graphics.codec.PNGEncoder;

public class BitmapLocalSaver {
	public static const LAST_SAVED_DIR_PATH:String = "LAST_SAVED_DIR_PATH";

	public function BitmapLocalSaver() {}

	private static var curOp:AsyncOperation;
	private static var curPng:ByteArray;
	private static var fileName:String;

	public static function save(bd:BitmapData, fileName:String, asPNG:Boolean = true):IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		if (curPng) curPng.clear();
		curPng = asPNG ? new PNGEncoder().encode(bd) : new JPEGEncoder(100).encode(bd);
		BitmapLocalSaver.fileName = fileName;

		curOp = new AsyncOperation();
		var file:File;
		if (Cache.has(LAST_SAVED_DIR_PATH)) {
			file = new File(Cache.read(LAST_SAVED_DIR_PATH));
			if (!file.exists) file = File.documentsDirectory;
		}
		else file = File.documentsDirectory;
		try {
			file.addEventListener(Event.SELECT, dirSelected);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			file.browseForDirectory("Wählen Sie bitte den Ordner");
		}
		catch (error:Error) {
			curOp.dispatchError("Browse file error: " + error.message);
		}

		return curOp;
	}

	private static function ioError(event:Event):void {
		curOp.dispatchError();
	}

	private static function dirSelected(event:Event):void {
		var dir:File = event.target as File;
		Cache.write(LAST_SAVED_DIR_PATH, dir.nativePath);
		var fileStream:FileStream = new FileStream();
		var file:File = new File(dir.nativePath + File.separator + fileName);
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(curPng, 0, curPng.length);
		fileStream.close();
		curOp.dispatchSuccess();
	}

}
}
