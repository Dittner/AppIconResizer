package de.dittner.appIconResizer.cmd {
import flash.display.BitmapData;
import flash.filesystem.File;

public class GenerateIconsState {
	public function GenerateIconsState() {}

	//icons
	public var originIcon:BitmapData;
	public var iconSizes:Array = [];
	public var as3Icons:Array = [];
	public var xcIOsIcons:Array = [];
	public var xcMacOsIcons:Array = [];
	public var iconNameTemplate:String = "";
	public var logItemTemplate:String = "";

	//splashes
	public var originSplash:BitmapData;
	public var splashBgColor:uint = 0;
	public var splashes:Array = [];

	//assets
	public var assetsDir:File;
	public var assets:Array = [];

	//store
	public var iconsDir:File;
	public var splashesDir:File;
	public var xcIOsAssetsDir:File;
	public var xcMacOsAssetsDir:File;
	public var iconsLog:String = "";
	public var splashesLog:String = "";
}
}
