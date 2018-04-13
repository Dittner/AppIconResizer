package de.dittner.appIconResizer.utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.StageQuality;
import flash.geom.Matrix;

public class BitmapUtils {
	public function BitmapUtils() {}

	public static function scaleToSize(src:BitmapData, size:int):BitmapData {
		var sc:Number = size / Math.max(src.width, src.height);
		var res:BitmapData = new BitmapData(src.width * sc, src.height * sc, false, 0);
		var bitmap:Bitmap = new Bitmap(src, PixelSnapping.NEVER, true);

		var matr:Matrix = new Matrix();
		matr.scale(sc, sc);

		res.drawWithQuality(bitmap, matr, null, null, null, true, StageQuality.BEST);
		return res;
	}

	public static function resample(bitmapData:BitmapData, newWidth:uint, newHeight:uint):BitmapData {
		var finalScale:Number = Math.max(newWidth / bitmapData.width, newHeight / bitmapData.height);

		var finalData:BitmapData = bitmapData;

		if (finalScale > 1) {
			finalData = new BitmapData(bitmapData.width * finalScale, bitmapData.height * finalScale, true, 0);

			finalData.draw(bitmapData, new Matrix(finalScale, 0, 0, finalScale), null, null, null, true);

			return finalData;
		}

		var drop:Number = .5;
		var initialScale:Number = finalScale;

		while (initialScale / drop < 1)
			initialScale /= drop;

		var w:Number = Math.floor(bitmapData.width * initialScale);
		var h:Number = Math.floor(bitmapData.height * initialScale);
		var bd:BitmapData = new BitmapData(w, h, bitmapData.transparent, 0);

		bd.draw(finalData, new Matrix(initialScale, 0, 0, initialScale), null, null, null, true);
		finalData = bd;

		for (var scale:Number = initialScale * drop; Math.round(scale * 1000) >= Math.round(finalScale * 1000); scale *= drop) {
			w = Math.floor(bitmapData.width * scale);
			h = Math.floor(bitmapData.height * scale);
			bd = new BitmapData(w, h, bitmapData.transparent, 0);

			bd.draw(finalData, new Matrix(drop, 0, 0, drop), null, null, null, true);
			finalData.dispose();
			finalData = bd;
		}

		return finalData;
	}
}
}
