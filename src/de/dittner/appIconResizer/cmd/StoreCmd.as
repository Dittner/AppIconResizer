package de.dittner.appIconResizer.cmd {
import de.dittner.appIconResizer.model.AppIcon;
import de.dittner.appIconResizer.model.AppSplash;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.ProgressOperation;
import de.dittner.async.utils.invalidateOf;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class StoreCmd extends ProgressOperation implements IAsyncCommand {
	public function StoreCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;

	public function execute():void {
		storeIcons();
	}

	private var storeIconInd:int = -1;
	private var storeXCAssetInd:int = -1;
	private var storeSplashInd:int = -1;

	private function storeIcons():void {
		storeIconInd++;
		_total = state.as3Icons.length + state.xcIcons.length + state.splashes.length;
		_progress = storeIconInd + storeSplashInd;
		notifyProgressChanged();

		if (storeIconInd < state.as3Icons.length) {
			var icon:AppIcon = state.as3Icons[storeIconInd];
			icon.store(state.iconsDir);
			state.iconsLog += state.logItemTemplate.replace(/SIZE/g, icon.size) + "\n";
			invalidateOf(storeIcons);
		}
		else {
			storeXCAssets();
		}
	}

	private function storeXCAssets():void {
		storeXCAssetInd++;
		_total = state.as3Icons.length + state.xcIcons.length + state.splashes.length;
		_progress = storeIconInd + storeXCAssetInd;
		notifyProgressChanged();

		if (storeXCAssetInd < state.xcIcons.length) {
			var icon:AppIcon = state.xcIcons[storeXCAssetInd];
			icon.store(state.xcassetsDir);
			invalidateOf(storeXCAssets);
		}
		else {
			storeXCIconsContents();
			storeSplashes();
		}
	}

	private function storeXCIconsContents():void {
		var contentsFile:File = File.applicationDirectory.resolvePath("Contents.json");
		if (!contentsFile.exists) throw new Error("Не обнаружена Contents.json в папке с ресурсами");
		contentsFile.copyTo(state.xcassetsDir.resolvePath("Contents.json"), true);

	}

	private function storeSplashes():void {
		storeSplashInd++;
		_total = state.as3Icons.length + state.xcIcons.length + state.splashes.length;
		_progress = storeIconInd + storeXCAssetInd + storeSplashInd;
		notifyProgressChanged();

		if (storeSplashInd < state.splashes.length) {
			var icon:AppSplash = state.splashes[storeSplashInd];
			icon.store(state.splashesDir);
			state.splashesLog += '"' + icon.name + '", ';
			invalidateOf(storeSplashes);
		}
		else {
			storeLogs();
		}
	}

	private function storeLogs():void {
		if (state.iconsLog) {
			var iconsLogStream:FileStream = new FileStream();
			var iconsLogFile:File = new File(state.iconsDir.nativePath + File.separator + "IconsLogs.txt");
			iconsLogStream.open(iconsLogFile, FileMode.WRITE);
			iconsLogStream.writeUTFBytes(state.iconsLog);
			iconsLogStream.close();
		}

		if (state.splashesLog) {
			var splashesStream:FileStream = new FileStream();
			var splashesFile:File = new File(state.splashesDir.nativePath + File.separator + "SplashesLogs");
			splashesStream.open(splashesFile, FileMode.WRITE);
			splashesStream.writeUTFBytes(state.splashesLog);
			splashesStream.close();
		}
		dispatchSuccess();
	}
}
}