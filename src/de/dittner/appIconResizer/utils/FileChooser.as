package de.dittner.appIconResizer.utils {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;

import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

public class FileChooser {
	public function FileChooser() {}
	public static const LAST_OPENED_FILE_PATH:String = "LAST_OPENED_FILE_PATH";

	private static var curOp:AsyncOperation;
	private static var fileLoader:Loader;
	private static var file:File;

	public static function browse(filters:Array):IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		curOp = new AsyncOperation();
		var file:File;
		if (Cache.has(LAST_OPENED_FILE_PATH)) {
			file = new File(Cache.read(LAST_OPENED_FILE_PATH));
			if (!file.exists) file = File.documentsDirectory;
		}
		else file = File.documentsDirectory;
		try {
			file.addEventListener(Event.SELECT, fileSelected);
			file.browseForOpen("Select file", filters);
		}
		catch (error:Error) {
			curOp.dispatchError("Browse file error: " + error.message);
		}
		return curOp;
	}

	private static function fileSelected(event:Event):void {
		file = event.target as File;
		Cache.write(LAST_OPENED_FILE_PATH, file.nativePath);
		loadFile(file.url)
	}

	private static function loadFile(url:String):void {
		fileLoader = new Loader();
		var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
		loaderContext.allowLoadBytesCodeExecution = true;
		addListeners(fileLoader);
		var request:URLRequest = new URLRequest(url);
		request.cacheResponse = false;
		request.useCache = false;
		fileLoader.load(request, loaderContext);
	}

	private static function fileLoadFailed(event:ErrorEvent):void {
		removeListeners(fileLoader);
		curOp.dispatchError("Load file is failed: " + event.toString());
	}

	private static function fileLoaded(event:Event):void {
		removeListeners(fileLoader);
		curOp.dispatchSuccess([event.target.content, file]);
	}

	private static function addListeners(ldr:Loader):void {
		ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, fileLoaded);
	}

	private static function removeListeners(ldr:Loader):void {
		ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileLoadFailed);
		ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, fileLoaded);
	}
}
}
