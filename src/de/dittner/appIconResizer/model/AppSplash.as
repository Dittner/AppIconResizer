package de.dittner.appIconResizer.model {
import com.adobe.images.PNGEncoder;

import flash.display.BitmapData;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class AppSplash {
	public static const FACTOR_3X:String = "FACTOR_3X";
	public static const FACTOR_2X:String = "FACTOR_2X";
	public static const FACTOR_1X:String = "FACTOR_1X";

	public function AppSplash(name:String, width:Number, height:Number, factor:String) {
		this.name = name;
		this.width = width;
		this.height = height;
		this.factor = factor;
	}

	public var name:String = "";
	public var width:Number = 0;
	public var height:Number = 0;
	public var factor:String = "";
	public var bitmapData:BitmapData;

	public function store(destDir:File):void {
		var png:ByteArray = PNGEncoder.encode(bitmapData);
		var fileStream:FileStream = new FileStream();
		var file:File = new File(destDir.nativePath + File.separator + name);
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(png, 0, png.length);
		fileStream.close();
		png.clear();
	}

}
}
