package de.dittner.appIconResizer.model {
import com.adobe.images.PNGEncoder;

import de.dittner.appIconResizer.ui.common.dialogBox.showNotification;
import de.dittner.appIconResizer.utils.BitmapUtils;
import de.dittner.appIconResizer.utils.FileChooser;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.invalidateOf;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;
import flash.utils.ByteArray;

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
	//  isProcessing
	//--------------------------------------
	private var _isProcessing:Boolean = false;
	[Bindable("isProcessingChanged")]
	public function get isProcessing():Boolean {return _isProcessing;}
	public function set isProcessing(value:Boolean):void {
		if (_isProcessing != value) {
			_isProcessing = value;
			dispatchEvent(new Event("isProcessingChanged"));
		}
	}

	//--------------------------------------
	//  processingInfo
	//--------------------------------------
	private var _processingInfo:String = "";
	[Bindable("processingInfoChanged")]
	public function get processingInfo():String {return _processingInfo;}
	public function set processingInfo(value:String):void {
		if (_processingInfo != value) {
			_processingInfo = value;
			dispatchEvent(new Event("processingInfoChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function init():void {
		iconNameTemplate = "AppIconSIZExSIZE.png";
		logItemTemplate = "<imageSIZExSIZE>icons/AppIconSIZExSIZE.png</imageSIZExSIZE>";
		iconSizes = "29, 36, 40, 48, 50, 57, 58, 60, 72, 75, 76, 80, 87, 96, 100, 114, 120, 144, 152, 167, 180, 192, 512, 1024";
	}

	private static const BROWSE_FILE_FILTERS:Array = [new FileFilter("PNG-file", "*.png"), new FileFilter("PNG-file", "*.PNG")];
	public function selectIcon():void {
		var op:IAsyncOperation = FileChooser.browse(BROWSE_FILE_FILTERS);
		op.addCompleteCallback(imageBrowsed);
	}

	private function imageBrowsed(op:IAsyncOperation):void {
		if (op.isSuccess && op.result) {
			selectedIcon = op.isSuccess ? (op.result[0] as Bitmap).bitmapData : null;
			if (selectedIcon && (selectedIcon.width != 1024 || selectedIcon.width != 1024)) {
				selectedIcon = null;
				showNotification("Selected icon has not size equals 1024px!");
			}
		}
	}

	public function generateIcons():void {
		if (!selectedIcon) return;
		isProcessing = true;
		store(getResizedIconsFrom(selectedIcon));
	}

	private function getResizedIconsFrom(origin:BitmapData):Array {
		var res:Array = [];
		var sizeHash:Object = {};
		var sizes:Array = iconSizes.replace(/( )/g, "").split(",");
		for each(var size:Number in sizes)
			if (!isNaN(size) && size <= 1024 && size > 0 && !sizeHash[size]) {
				sizeHash[size] = true;
				var icon:BitmapData = BitmapUtils.resample(origin, size, size);
				res.push(icon);
			}

		return res;
	}

	private var logs:String = "";
	private var total:Number = 0;
	private var complete:Number = 0;
	private var availableIcons:Array = [];
	private var destDir:File;
	private function store(icons:Array):void {
		logs = "";
		complete = 0;
		total = icons.length;
		availableIcons = icons;

		destDir = File.documentsDirectory.resolvePath("appIcons" + File.separator);
		if (destDir.exists) destDir.deleteDirectory(true);
		destDir.createDirectory();

		storeNextIcon();
	}

	private function notify():void {
		if (total == 0)
			processingInfo = "No available icons!";
		else if (total == complete)
			processingInfo = "documents/appIcons";
		else
			processingInfo = complete + "/" + total + " icons...";
	}

	private function storeNextIcon():void {
		complete = total - availableIcons.length;
		notify();

		if (availableIcons.length == 0) {
			isProcessing = false;
			writeLogs(logs, "logs.txt");
		}
		else {
			try {
				var pngIcon:BitmapData = availableIcons.shift();
				var pngName:String = iconNameTemplate.replace(/SIZE/g, pngIcon.width);
				var png:ByteArray = PNGEncoder.encode(pngIcon);
				writeFile(png, pngName);
				logs += logItemTemplate.replace(/SIZE/g, pngIcon.width) + "\n";
				invalidateOf(storeNextIcon);
			}
			catch (e:Error) {
				isProcessing = false;
				processingInfo = "";
				showNotification(e.message || "Error!");
			}
		}
	}

	private function writeFile(bytes:ByteArray, fileName:String):void {
		var fileStream:FileStream = new FileStream();
		var file:File = new File(destDir.nativePath + File.separator + fileName);
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(bytes, 0, bytes.length);
		fileStream.close();
	}

	private function writeLogs(txt:String, fileName:String):void {
		var fileStream:FileStream = new FileStream();
		var file:File = new File(destDir.nativePath + File.separator + fileName);
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(txt);
		fileStream.close();
	}

}
}
