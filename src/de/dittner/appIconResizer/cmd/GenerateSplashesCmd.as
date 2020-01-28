package de.dittner.appIconResizer.cmd {
import de.dittner.appIconResizer.model.AppSplash;
import de.dittner.appIconResizer.utils.BitmapUtils;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.ProgressOperation;
import de.dittner.async.utils.invalidateOf;

public class GenerateSplashesCmd extends ProgressOperation implements IAsyncCommand {
	public function GenerateSplashesCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;

	public function execute():void {
		state.splashes.length = 0;
		if (state.originSplash) {
			prepareForIPhone();
			prepareForIPad();
			createNextIcon();
		}
		else {
			dispatchSuccess();
		}
	}

	private function prepareForIPhone():void {
		createSplash("Default~iphone.png", 640, 960, AppSplash.FACTOR_1X);
		createSplash("Default@2x~iphone.png", 640, 960, AppSplash.FACTOR_2X);
		createSplash("Default-568h@2x~iphone.png", 640, 1136, AppSplash.FACTOR_2X);
		createSplash("Default-375w-667h@2x~iphone.png", 750, 1334, AppSplash.FACTOR_2X);
		createSplash("Default-414w-736h@3x~iphone.png", 1242, 2208, AppSplash.FACTOR_3X);
		createSplash("Default-Landscape-414w-736h@3x~iphone.png", 2208, 1242, AppSplash.FACTOR_3X);
		createSplash("Default-812h@3x~iphone.png", 1125, 2436, AppSplash.FACTOR_3X);
		createSplash("Default-Landscape-812h@3x~iphone.png", 2436, 1125, AppSplash.FACTOR_3X);
	}

	private function prepareForIPad():void {
		createSplash("Default-Portrait~ipad.png", 768, 1024, AppSplash.FACTOR_1X);
		createSplash("Default-PortraitUpsideDown~ipad.png", 768, 1024, AppSplash.FACTOR_1X);
		createSplash("Default-Landscape~ipad.png", 1024, 768, AppSplash.FACTOR_1X);
		createSplash("Default-LandscapeRight~ipad.png", 1024, 768, AppSplash.FACTOR_1X);
		createSplash("Default-Portrait@2x~ipad.png", 1536, 2048, AppSplash.FACTOR_2X);
		createSplash("Default-PortraitUpsideDown@2x~ipad.png", 1536, 2048, AppSplash.FACTOR_2X);
		createSplash("Default-LandscapeLeft@2x~ipad.png", 2048, 1536, AppSplash.FACTOR_2X);
		createSplash("Default-LandscapeRight@2x~ipad.png", 2048, 1536, AppSplash.FACTOR_2X);
		createSplash("Default-Portrait-1112h@2x.png", 1668, 2224, AppSplash.FACTOR_2X);
		createSplash("Default-Landscape-1112h@2x.png", 2224, 1668, AppSplash.FACTOR_2X);
		createSplash("Default-Portrait@2x.png", 2048, 2732, AppSplash.FACTOR_2X);
		createSplash("Default-Landscape@2x.png", 2732, 2048, AppSplash.FACTOR_2X);
	}

	private function createSplash(name:String, width:Number, height:Number, factor:String):void {
		var icon:AppSplash = new AppSplash(name, width, height, factor);
		state.splashes.push(icon);
	}

	private var curIconInd:int = -1;
	private function createNextIcon():void {
		curIconInd++;
		_total = state.splashes.length;
		_progress = curIconInd;
		notifyProgressChanged();
		if (curIconInd < state.splashes.length) {
			var icon:AppSplash = state.splashes[curIconInd];
			icon.bitmapData = BitmapUtils.generateSplash(state.originSplash, icon.width, icon.height, icon.factor, state.splashBgColor);
			invalidateOf(createNextIcon);
		}
		else {
			dispatchSuccess();
		}
	}

}
}
