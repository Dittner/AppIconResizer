package de.dittner.appIconResizer.utils {
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;

public class TextFieldFactory {

	public static var useEmbedFonts:Boolean = true;

	public static function create(textFormat:TextFormat, thickness:Number = 10):TextField {
		var tf:TextField = new TextField();
		setUpTextField(tf, thickness);
		tf.defaultTextFormat = textFormat;
		return tf;
	}

	public static function createMultiline(textFormat:TextFormat, thickness:Number = 20):TextField {
		var tf:TextField = new TextField();
		setUpTextField(tf, thickness);
		tf.defaultTextFormat = textFormat;
		tf.multiline = true;
		tf.wordWrap = true;
		return tf;
	}

	private static function setUpTextField(tf:TextField, thickness:Number):void {
		tf.width = 100000;
		tf.height = 100000;
		tf.selectable = false;
		tf.multiline = false;
		tf.wordWrap = false;
		tf.mouseEnabled = false;
		tf.mouseWheelEnabled = false;
		tf.embedFonts = useEmbedFonts;
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.gridFitType = GridFitType.PIXEL;
		tf.sharpness = 0;
		tf.thickness = thickness;
	}

}
}
