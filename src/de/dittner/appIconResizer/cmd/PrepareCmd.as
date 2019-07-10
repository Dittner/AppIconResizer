package de.dittner.appIconResizer.cmd {
import de.dittner.async.AsyncCommand;

import flash.filesystem.File;

public class PrepareCmd extends AsyncCommand {
	public function PrepareCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;

	override public function execute():void {
		state.iconsLog = "";
		state.splashesLog = "";

		if(state.assets && state.assets.length > 0) {
			state.assetsDir = File.documentsDirectory.resolvePath("APP_ICON_RESIZER" +  File.separator + "assets" + File.separator);
			if (state.assetsDir.exists) state.assetsDir.deleteDirectory(true);
			state.assetsDir.createDirectory();
		}
		else {
			state.iconsDir = File.documentsDirectory.resolvePath("APP_ICON_RESIZER" +  File.separator + "icons" + File.separator);
			if (state.iconsDir.exists) state.iconsDir.deleteDirectory(true);
			state.iconsDir.createDirectory();

			state.splashesDir = File.documentsDirectory.resolvePath("APP_ICON_RESIZER" +  File.separator + "icons" + File.separator + "splash" + File.separator);
			state.splashesDir.createDirectory();

			state.xcassetsDir = File.documentsDirectory.resolvePath("APP_ICON_RESIZER" +  File.separator + "icons" + File.separator + "xcassets" + File.separator);
			state.xcassetsDir.createDirectory();
		}

		dispatchSuccess();
	}
}
}