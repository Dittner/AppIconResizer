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

		state.iconsDir = File.documentsDirectory.resolvePath("appIcons" + File.separator);
		if (state.iconsDir.exists) state.iconsDir.deleteDirectory(true);
		state.iconsDir.createDirectory();

		state.splashesDir = File.documentsDirectory.resolvePath("appIcons" + File.separator + "splash" + File.separator);
		state.splashesDir.createDirectory();

		dispatchSuccess();
	}

}
}
