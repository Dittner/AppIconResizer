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
		_total = pendingIconsAmount();
		storeIcons();
	}

	private function pendingIconsAmount():int {
		return state.as3Icons.length + state.xcIOsIcons.length + state.xcMacOsIcons.length + state.splashes.length;
	}

	private function storeIcons():void {
		_progress = _total - pendingIconsAmount();
		notifyProgressChanged();

		if (state.as3Icons.length > 0) {
			var icon:AppIcon = state.as3Icons.pop();
			icon.store(state.iconsDir);
			state.iconsLog += state.logItemTemplate.replace(/SIZE/g, icon.size) + "\n";
			invalidateOf(storeIcons);
		}
		else {
			storeXCAssets();
		}
	}

	private function storeXCAssets():void {
		_progress = _total - pendingIconsAmount();
		notifyProgressChanged();

		if (state.xcIOsIcons.length > 0) {
			var iosIcon:AppIcon = state.xcIOsIcons.pop();
			iosIcon.store(state.xcIOsAssetsDir);
			invalidateOf(storeXCAssets);
		}
		else if (state.xcMacOsIcons.length > 0) {
			var macIcon:AppIcon = state.xcMacOsIcons.pop();
			macIcon.store(state.xcMacOsAssetsDir);
			invalidateOf(storeXCAssets);
		}
		else {
			storeXCIconsContents();
			storeSplashes();
		}
	}

	private function storeXCIconsContents():void {
		var contentsFile:File = File.applicationDirectory.resolvePath("ios/Contents.json");
		if (!contentsFile.exists) throw new Error("Не обнаружена ios/Contents.json в папке с ресурсами");
		contentsFile.copyTo(state.xcIOsAssetsDir.resolvePath("Contents.json"), true);

		contentsFile = File.applicationDirectory.resolvePath("mac/Contents.json");
		if (!contentsFile.exists) throw new Error("Не обнаружена mac/Contents.json в папке с ресурсами");
		contentsFile.copyTo(state.xcMacOsAssetsDir.resolvePath("Contents.json"), true);
	}

	private function storeSplashes():void {
		_progress = _total - pendingIconsAmount();
		notifyProgressChanged();

		if (state.splashes.length > 0) {
			var icon:AppSplash = state.splashes.pop();
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