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
		_total = state.icons.length + state.xcassets.length + state.splashes.length;
		_progress = storeIconInd + storeSplashInd;
		notifyProgressChanged();

		if (storeIconInd < state.icons.length) {
			var icon:AppIcon = state.icons[storeIconInd];
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
		_total = state.icons.length + state.xcassets.length + state.splashes.length;
		_progress = storeIconInd + storeXCAssetInd;
		notifyProgressChanged();

		if (storeXCAssetInd < state.xcassets.length) {
			var icon:AppIcon = state.xcassets[storeXCAssetInd];
			icon.store(state.xcassetsDir);
			invalidateOf(storeXCAssets);
		}
		else {
			storeSplashes();
		}
	}

	private function storeSplashes():void {
		storeSplashInd++;
		_total = state.icons.length + state.xcassets.length + state.splashes.length;
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
			var iconsLogFile:File = new File(state.iconsDir.nativePath + File.separator + "IconsLogs");
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