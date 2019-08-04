package de.dittner.appIconResizer.cmd {
import de.dittner.appIconResizer.model.AppIcon;
import de.dittner.appIconResizer.utils.BitmapUtils;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.ProgressOperation;
import de.dittner.async.utils.invalidateOf;

public class GenerateXCIconsCmd extends ProgressOperation implements IAsyncCommand {
	public function GenerateXCIconsCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;

	public function execute():void {
		state.xcIcons.length = 0;
		if (state.originIcon) {
			prepareXCassets();
			createNextXCAsset();
		}
		else {
			dispatchSuccess();
		}
	}

	var xcIcons:Array = [];
	private function prepareXCassets() {
		xcIcons.push(new AppIcon("AppIcon-20.png", 20));
		xcIcons.push(new AppIcon("AppIcon-20@2x-1.png", 40));
		xcIcons.push(new AppIcon("AppIcon-20@2x.png", 40));
		xcIcons.push(new AppIcon("AppIcon-20@3x.png", 60));

		xcIcons.push(new AppIcon("AppIcon-29.png", 29));
		xcIcons.push(new AppIcon("AppIcon-29@2x.png", 58));
		xcIcons.push(new AppIcon("AppIcon-29@2x-1.png", 58));
		xcIcons.push(new AppIcon("AppIcon-29@3x.png", 87));

		xcIcons.push(new AppIcon("AppIcon-40.png", 40));
		xcIcons.push(new AppIcon("AppIcon-40@2x.png", 80));
		xcIcons.push(new AppIcon("AppIcon-40@2x-1.png", 80));
		xcIcons.push(new AppIcon("AppIcon-40@3x.png", 120));

		xcIcons.push(new AppIcon("AppIcon-60@2x.png", 120));
		xcIcons.push(new AppIcon("AppIcon-60@3x.png", 180));

		xcIcons.push(new AppIcon("AppIcon-76.png", 76));
		xcIcons.push(new AppIcon("AppIcon-76@2x.png", 152));

		xcIcons.push(new AppIcon("AppIcon-83.5@2x.png", 167));
		xcIcons.push(new AppIcon("AppIcon-1024.png", 1024));
	}
	
	private function createNextXCAsset():void {
		_total = 15;
		_progress = _total - xcIcons.length;
		notifyProgressChanged();
		if (xcIcons.length > 0) {
			var appIcon:AppIcon = xcIcons.pop();
			appIcon.bitmapData = BitmapUtils.resample(state.originIcon, appIcon.size, appIcon.size);
			state.xcIcons.push(appIcon);
			invalidateOf(createNextXCAsset);
		}
		else {
			dispatchSuccess();
		}
	}

}
}
