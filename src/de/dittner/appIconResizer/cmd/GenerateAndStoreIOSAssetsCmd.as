package de.dittner.appIconResizer.cmd {
import com.adobe.images.PNGEncoder;

import de.dittner.appIconResizer.model.IOSAsset;
import de.dittner.async.ProgressCommand;
import de.dittner.async.utils.invalidateOf;

import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class GenerateAndStoreIOSAssetsCmd extends ProgressCommand {
	public function GenerateAndStoreIOSAssetsCmd(state:GenerateIconsState) {
		super();
		this.state = state;
	}

	private var state:GenerateIconsState;

	override public function execute():void {
		generateNext();
	}

	private var curInd:int = -1;
	private var curAsset:IOSAsset;
	private function generateNext():void {
		curInd++;
		if (curInd < state.assets.length) {
			curAsset = state.assets[curInd];
			setProgress(curInd / state.assets.length);
			store(getBitmapData(curAsset, 1), curAsset.name, state.assetsDir);
			store(getBitmapData(curAsset, 2), curAsset.name + "@2x", state.assetsDir);
			store(getBitmapData(curAsset, 3), curAsset.name + "@3x", state.assetsDir);
			invalidateOf(generateNext);
		}
		else {
			setProgress(1);
			dispatchSuccess();
		}
	}

	private var cont:Sprite = new Sprite();
	private function getBitmapData(asset:IOSAsset, factor:uint):BitmapData {
		var mc:MovieClip = asset.mc;
		var curClipParent:DisplayObjectContainer = mc.parent;
		var curClipX:Number = mc.x;
		var curClipY:Number = mc.y;
		var curClipScale:Number = mc.scaleX;

		mc.width = asset.width;
		mc.height = asset.height;
		mc.scaleX = mc.scaleY = factor;
		mc.x = mc.width / 2;
		mc.y = mc.height / 2;

		if(curClipParent) curClipParent.removeChild(mc);
		cont.addChild(mc);
		var bd:BitmapData = new BitmapData(Math.ceil(mc.width), Math.ceil(mc.height), true, 0x00000000);
		bd.drawWithQuality(cont, null, null, null, null, true, StageQuality.BEST);
		cont.removeChild(mc);

		if(curClipParent) {
			mc.width = asset.width;
			mc.height = asset.height;
			mc.scaleX = mc.scaleY = curClipScale;
			mc.x = curClipX;
			mc.y = curClipY;
			curClipParent.addChild(mc);
		}
		return bd;
	}

	private function store(bd:BitmapData, name:String, destDir:File):void {
		var png:ByteArray = PNGEncoder.encode(bd);
		var fileStream:FileStream = new FileStream();
		var file:File = new File(destDir.nativePath + File.separator + name + ".png");
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(png, 0, png.length);
		fileStream.close();
		png.clear();
	}
}
}