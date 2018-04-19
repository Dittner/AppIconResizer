package de.dittner.appIconResizer.cmd {
import de.dittner.appIconResizer.model.AppIcon;
import de.dittner.appIconResizer.utils.BitmapUtils;
import de.dittner.async.AsyncCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.ProgressOperation;
import de.dittner.async.utils.invalidateOf;

public class GenerateIconsCmd extends ProgressOperation implements IAsyncCommand{
	public function GenerateIconsCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;
	private var curSizeInd:int = -1;

	public function execute():void {
		state.icons.length = 0;
		if (state.originIcon)
			createNextIcon();
		else
			dispatchSuccess();
	}

	private function createNextIcon():void {
		curSizeInd++;
		_total = state.iconSizes.length;
		_progress = curSizeInd;
		notifyProgressChanged();
		if (curSizeInd < state.iconSizes.length) {
			var size:Number = state.iconSizes[curSizeInd];
			var iconName:String = state.iconNameTemplate.replace(/SIZE/g, size);
			var icon:AppIcon = new AppIcon(iconName, size);
			icon.bitmapData = BitmapUtils.resample(state.originIcon, size, size);
			state.icons.push(icon);
			invalidateOf(createNextIcon);
		}
		else {
			dispatchSuccess();
		}
	}

}
}
