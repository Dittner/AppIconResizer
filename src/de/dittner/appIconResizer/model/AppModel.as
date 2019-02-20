package de.dittner.appIconResizer.model {
import de.dittner.appIconResizer.cmd.GenerateAndStoreIOSAssetsCmd;
import de.dittner.appIconResizer.cmd.GenerateIconsCmd;
import de.dittner.appIconResizer.cmd.GenerateIconsState;
import de.dittner.appIconResizer.cmd.GenerateSplashesCmd;
import de.dittner.appIconResizer.cmd.PrepareCmd;
import de.dittner.appIconResizer.cmd.StoreCmd;
import de.dittner.appIconResizer.ui.common.dialogBox.showNotification;
import de.dittner.appIconResizer.utils.Cache;
import de.dittner.appIconResizer.utils.FileChooser;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.net.FileFilter;

import mx.collections.ArrayCollection;

public class AppModel extends EventDispatcher {
	public function AppModel() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  iconNameTemplate
	//--------------------------------------
	private var _iconNameTemplate:String = "";
	[Bindable("iconNameTemplateChanged")]
	public function get iconNameTemplate():String {return _iconNameTemplate;}
	public function set iconNameTemplate(value:String):void {
		if (_iconNameTemplate != value) {
			_iconNameTemplate = value;
			dispatchEvent(new Event("iconNameTemplateChanged"));
		}
	}

	//--------------------------------------
	//  logItemTemplate
	//--------------------------------------
	private var _logItemTemplate:String = "";
	[Bindable("logItemTemplateChanged")]
	public function get logItemTemplate():String {return _logItemTemplate;}
	public function set logItemTemplate(value:String):void {
		if (_logItemTemplate != value) {
			_logItemTemplate = value;
			dispatchEvent(new Event("logItemTemplateChanged"));
		}
	}

	//--------------------------------------
	//  iconSizes
	//--------------------------------------
	private var _iconSizes:String = "";
	[Bindable("iconSizesChanged")]
	public function get iconSizes():String {return _iconSizes;}
	public function set iconSizes(value:String):void {
		if (_iconSizes != value) {
			_iconSizes = value;
			dispatchEvent(new Event("iconSizesChanged"));
		}
	}

	//--------------------------------------
	//  splashBgColor
	//--------------------------------------
	private var _splashBgColor:String = "ffFFff";
	[Bindable("splashBgColorChanged")]
	public function get splashBgColor():String {return _splashBgColor;}
	public function set splashBgColor(value:String):void {
		if (_splashBgColor != value) {
			_splashBgColor = value;
			dispatchEvent(new Event("splashBgColorChanged"));
		}
	}

	//--------------------------------------
	//  selectedIcon
	//--------------------------------------
	private var _selectedIcon:BitmapData;
	[Bindable("selectedIconChanged")]
	public function get selectedIcon():BitmapData {return _selectedIcon;}
	public function set selectedIcon(value:BitmapData):void {
		if (_selectedIcon != value) {
			_selectedIcon = value;
			dispatchEvent(new Event("selectedIconChanged"));
		}
	}

	//--------------------------------------
	//  selectedSplash
	//--------------------------------------
	private var _selectedSplash:BitmapData;
	[Bindable("selectedSplashChanged")]
	public function get selectedSplash():BitmapData {return _selectedSplash;}
	public function set selectedSplash(value:BitmapData):void {
		if (_selectedSplash != value) {
			_selectedSplash = value;
			dispatchEvent(new Event("selectedSplashChanged"));
		}
	}

	//--------------------------------------
	//  swfFileUrl
	//--------------------------------------
	private var _swfFileUrl:String = "";
	[Bindable("swfFileUrlChanged")]
	public function get swfFileUrl():String {return _swfFileUrl;}
	public function set swfFileUrl(value:String):void {
		if (_swfFileUrl != value) {
			_swfFileUrl = value;
			dispatchEvent(new Event("swfFileUrlChanged"));
		}
	}

	//--------------------------------------
	//  iosAssetColl
	//--------------------------------------
	private var _iosAssetColl:ArrayCollection;
	[Bindable("iosAssetCollChanged")]
	public function get iosAssetColl():ArrayCollection {return _iosAssetColl;}
	public function set iosAssetColl(value:ArrayCollection):void {
		if (_iosAssetColl != value) {
			_iosAssetColl = value;
			dispatchEvent(new Event("iosAssetCollChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private static const ICON_NAME_TEMPLATE:String = "ICON_NAME_TEMPLATE";
	private static const LOG_ITEM_TEMPLATE:String = "LOG_ITEM_TEMPLATE";
	private static const ICON_SIZES:String = "ICON_SIZES";
	private static const SPLASH_BG_COLOR:String = "SPLASH_BG_COLOR";
	public function init():void {
		iconNameTemplate = Cache.read(ICON_NAME_TEMPLATE) || "AppIconSIZExSIZE.png";
		logItemTemplate = Cache.read(LOG_ITEM_TEMPLATE) || "<imageSIZExSIZE>icons/AppIconSIZExSIZE.png</imageSIZExSIZE>";
		iconSizes = Cache.read(ICON_SIZES) || "20, 29, 36, 40, 48, 50, 57, 58, 60, 72, 75, 76, 80, 87, 96, 100, 114, 120, 144, 152, 167, 180, 192, 512, 1024";
		splashBgColor = Cache.read(SPLASH_BG_COLOR) || _splashBgColor;
	}

	//--------------------------------------
	//  File Browse
	//--------------------------------------

	private static const BROWSE_PNG_FILE_FILTERS:Array = [new FileFilter("PNG-file", "*.png"), new FileFilter("PNG-file", "*.PNG")];
	private static const BROWSE_SWF_FILE_FILTERS:Array = [new FileFilter("SWF-file", "*.swf"), new FileFilter("SWF-file", "*.SWF")];
	public function selectIcon():void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_PNG_FILE_FILTERS);
		op.addCompleteCallback(iconBrowsed);
	}

	private function iconBrowsed(op:IAsyncOperation):void {
		if (op.isSuccess && op.result) {
			selectedIcon = op.isSuccess ? (op.result[0] as Bitmap).bitmapData : null;
			if (selectedIcon && (selectedIcon.width != 1024 || selectedIcon.width != 1024)) {
				selectedIcon = null;
				showNotification("Selected icon has not size equals 1024px!");
			}
		}
		else {
			selectedIcon = null;
		}
	}

	public function selectSplash():void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_PNG_FILE_FILTERS);
		op.addCompleteCallback(splashBrowsed);
	}

	private function splashBrowsed(op:IAsyncOperation):void {
		selectedSplash = op.isSuccess && op.result ? (op.result[0] as Bitmap).bitmapData : null;
	}

	public function selectSWFFile():void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_SWF_FILE_FILTERS);
		op.addCompleteCallback(swfBrowsed);
	}

	private function swfBrowsed(op:IAsyncOperation):void {
		if (!op.isSuccess) return;
		var assetsMC:MovieClip = op.result && op.result.length > 0 ? op.result[0] as MovieClip : null;
		swfFileUrl = op.isSuccess && op.result.length > 0 && op.result[1] is File ? (op.result[1] as File).nativePath : "";
		var assets:Array = [];
		for (var prop:String in assetsMC)
			if (assetsMC[prop] is MovieClip) {
				var asset:IOSAsset = new IOSAsset(assetsMC[prop], prop);
				assets.push(asset);
			}
		iosAssetColl = new ArrayCollection(assets);
	}

	//--------------------------------------
	//  Generate
	//--------------------------------------

	public function generateIcons():ProgressCommand {
		Cache.write(ICON_NAME_TEMPLATE, iconNameTemplate);
		Cache.write(LOG_ITEM_TEMPLATE, logItemTemplate);
		Cache.write(ICON_SIZES, iconSizes);
		Cache.write(SPLASH_BG_COLOR, splashBgColor);

		var state:GenerateIconsState = new GenerateIconsState();
		state.originIcon = selectedIcon;
		state.originSplash = selectedSplash;
		state.iconSizes = getIconsSizes();
		state.iconNameTemplate = iconNameTemplate;
		state.logItemTemplate = logItemTemplate;
		state.splashBgColor = int("0x" + splashBgColor);

		var cmd:CompositeCommand = new CompositeCommand();
		cmd.addProgressOperation(PrepareCmd, 0.01, state);
		cmd.addProgressOperation(GenerateIconsCmd, 0.1, state);
		cmd.addProgressOperation(GenerateSplashesCmd, 0.2, state);
		cmd.addProgressOperation(StoreCmd, 1, state);

		cmd.execute();

		return cmd;
	}

	public function generateAssets():ProgressCommand {
		var state:GenerateIconsState = new GenerateIconsState();
		state.assets = iosAssetColl.source;

		var cmd:CompositeCommand = new CompositeCommand();
		cmd.addProgressOperation(PrepareCmd, 0.01, state);
		cmd.addProgressOperation(GenerateAndStoreIOSAssetsCmd, 1, state);
		cmd.execute();

		return cmd;
	}

	private function getIconsSizes():Array {
		var res:Array = [];
		var sizeHash:Object = {};
		var sizes:Array = iconSizes.replace(/( )/g, "").split(",");
		for each(var size:Number in sizes)
			if (!isNaN(size) && size <= 1024 && size > 0 && !sizeHash[size]) {
				sizeHash[size] = true;
				res.push(size);
			}
		return res;
	}

}
}