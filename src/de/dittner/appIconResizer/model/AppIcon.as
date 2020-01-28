package de.dittner.appIconResizer.model {
import com.adobe.images.PNGEncoder;

import flash.display.BitmapData;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class AppIcon {
	public function AppIcon(name:String, size:Number) {
		this.name = name;
		this.size = size;
	}

	public var name:String = "";
	public var size:Number = 0;
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
