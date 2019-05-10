package de.dittner.appIconResizer.utils {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;

import flash.events.Event;
import flash.filesystem.File;

public class FolderChooser {
	public function FolderChooser() {}
	public static const LAST_OPENED_FOLDER_PATH:String = "LAST_OPENED_FOLDER_PATH";

	private static var curOp:AsyncOperation;

	public static function browse():IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		curOp = new AsyncOperation();
		var dir:File;
		if (Cache.has(LAST_OPENED_FOLDER_PATH)) {
			dir = new File(Cache.read(LAST_OPENED_FOLDER_PATH));
			if (!dir.exists) dir = File.documentsDirectory;
		}
		else {
			dir = File.documentsDirectory;
		}
		try {
			dir.addEventListener(Event.SELECT, dirSelected);
			dir.addEventListener(Event.CANCEL, dirSelectCanceled);
			dir.browseForDirectory("Select folder");
		}
		catch (error:Error) {
			curOp.dispatchError("Browse folder error: " + error.message);
		}
		return curOp;
	}

	private static function dirSelected(event:Event):void {
		var selectedDir:File = event.target as File;
		Cache.write(LAST_OPENED_FOLDER_PATH, selectedDir.nativePath);
		curOp.dispatchSuccess(selectedDir);
	}

	private static function dirSelectCanceled(event:Event):void {
		curOp.dispatchAbort();
	}

}
}
