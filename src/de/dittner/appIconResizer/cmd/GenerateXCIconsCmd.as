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
		state.xcIOsIcons.length = 0;
		if (state.originIcon) {
			prepareIOsAassets();
			prepareMacOsAassets();
			createNextXCAsset();
		}
		else {
			dispatchSuccess();
		}
	}

	var iosIcons:Array = [];
	private function prepareIOsAassets() {
		iosIcons.push(new AppIcon("AppIcon-20.png", 20));
		iosIcons.push(new AppIcon("AppIcon-20@2x-1.png", 40));
		iosIcons.push(new AppIcon("AppIcon-20@2x.png", 40));
		iosIcons.push(new AppIcon("AppIcon-20@3x.png", 60));

		iosIcons.push(new AppIcon("AppIcon-29.png", 29));
		iosIcons.push(new AppIcon("AppIcon-29@2x.png", 58));
		iosIcons.push(new AppIcon("AppIcon-29@2x-1.png", 58));
		iosIcons.push(new AppIcon("AppIcon-29@3x.png", 87));

		iosIcons.push(new AppIcon("AppIcon-40.png", 40));
		iosIcons.push(new AppIcon("AppIcon-40@2x.png", 80));
		iosIcons.push(new AppIcon("AppIcon-40@2x-1.png", 80));
		iosIcons.push(new AppIcon("AppIcon-40@3x.png", 120));

		iosIcons.push(new AppIcon("AppIcon-60@2x.png", 120));
		iosIcons.push(new AppIcon("AppIcon-60@3x.png", 180));

		iosIcons.push(new AppIcon("AppIcon-76.png", 76));
		iosIcons.push(new AppIcon("AppIcon-76@2x.png", 152));

		iosIcons.push(new AppIcon("AppIcon-83.5@2x.png", 167));
		iosIcons.push(new AppIcon("AppIcon-1024.png", 1024));
	}

	var macOsIcons:Array = [];
	private function prepareMacOsAassets() {
		macOsIcons.push(new AppIcon("AppIcon-16.png", 16));
		macOsIcons.push(new AppIcon("AppIcon-16@2x.png", 32));

		macOsIcons.push(new AppIcon("AppIcon-32.png", 32));
		macOsIcons.push(new AppIcon("AppIcon-32@2x.png", 64));

		macOsIcons.push(new AppIcon("AppIcon-64.png", 64));
		macOsIcons.push(new AppIcon("AppIcon-64@2x.png", 128));

		macOsIcons.push(new AppIcon("AppIcon-128.png", 128));
		macOsIcons.push(new AppIcon("AppIcon-128@2x.png", 256));

		macOsIcons.push(new AppIcon("AppIcon-256.png", 256));
		macOsIcons.push(new AppIcon("AppIcon-256@2x.png", 512));

		macOsIcons.push(new AppIcon("AppIcon-512.png", 512));
		macOsIcons.push(new AppIcon("AppIcon-512@2x.png", 1024));
	}

	private function createNextXCAsset():void {
		_total = 30;
		_progress = _total - iosIcons.length - macOsIcons.length;
		notifyProgressChanged();
		if (iosIcons.length > 0) {
			var iosIcon:AppIcon = iosIcons.pop();
			iosIcon.bitmapData = BitmapUtils.resample(state.originIcon, iosIcon.size, iosIcon.size);
			state.xcIOsIcons.push(iosIcon);
			invalidateOf(createNextXCAsset);
		}
		else if (macOsIcons.length > 0) {
			var macIcon:AppIcon = macOsIcons.pop();
			macIcon.bitmapData = BitmapUtils.resample(state.originIcon, macIcon.size, macIcon.size);
			state.xcMacOsIcons.push(macIcon);
			invalidateOf(createNextXCAsset);
		}
		else {
			dispatchSuccess();
		}
	}

}
}
