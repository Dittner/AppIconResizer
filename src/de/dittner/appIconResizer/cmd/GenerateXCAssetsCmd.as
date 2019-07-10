package de.dittner.appIconResizer.cmd {
import de.dittner.appIconResizer.model.AppIcon;
import de.dittner.appIconResizer.utils.BitmapUtils;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.ProgressOperation;
import de.dittner.async.utils.invalidateOf;

public class GenerateXCAssetsCmd extends ProgressOperation implements IAsyncCommand {
	public function GenerateXCAssetsCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;

	public function execute():void {
		state.xcassets.length = 0;
		if (state.originIcon) {
			prepareXCassets();
			createNextXCAsset();
		}
		else {
			dispatchSuccess();
		}
	}

	var xcassets:Array = [];
	private function prepareXCassets() {
		xcassets.push(new AppIcon("AppIcon-20.png", 20));
		xcassets.push(new AppIcon("AppIcon-20@2x.png", 40));
		xcassets.push(new AppIcon("AppIcon-20@3x.png", 60));
		xcassets.push(new AppIcon("AppIcon-29.png", 29));
		xcassets.push(new AppIcon("AppIcon-29@2x.png", 58));
		xcassets.push(new AppIcon("AppIcon-29@3x.png", 87));
		xcassets.push(new AppIcon("AppIcon-40.png", 40));
		xcassets.push(new AppIcon("AppIcon-40@2x.png", 80));
		xcassets.push(new AppIcon("AppIcon-40@3x.png", 120));
		xcassets.push(new AppIcon("AppIcon-60@2x.png", 120));
		xcassets.push(new AppIcon("AppIcon-60@3x.png", 180));
		xcassets.push(new AppIcon("AppIcon-76.png", 76));
		xcassets.push(new AppIcon("AppIcon-76@2x.png", 152));
		xcassets.push(new AppIcon("AppIcon-83.5@2x.png", 167));
		xcassets.push(new AppIcon("AppIcon-1024.png", 1024));
	}
	
	private function createNextXCAsset():void {
		_total = 15;
		_progress = _total - xcassets.length;
		notifyProgressChanged();
		if (xcassets.length > 0) {
			var appIcon:AppIcon = xcassets.pop();
			appIcon.bitmapData = BitmapUtils.resample(state.originIcon, appIcon.size, appIcon.size);
			state.xcassets.push(appIcon);
			invalidateOf(createNextXCAsset);
		}
		else {
			dispatchSuccess();
		}
	}

}
}
