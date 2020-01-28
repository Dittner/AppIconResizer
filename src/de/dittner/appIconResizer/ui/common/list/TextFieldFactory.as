package de.dittner.appIconResizer.ui.common.list {
import flash.text.TextFormat;

public class TextFieldFactory {
	public function TextFieldFactory() {}

	public static var useEmbedFonts:Boolean = true;

	public static function create(textFormat:TextFormat):SmartTextField {
		var textField:SmartTextField = new SmartTextField();
		textField.selectable = false;
		textField.multiline = false;
		textField.wordWrap = false;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		textField.embedFonts = useEmbedFonts;
		textField.defaultTextFormat = textFormat;
		return textField;
	}

	public static function createMultiline(textFormat:TextFormat):SmartTextField {
		var textField:SmartTextField = create(textFormat);
		textField.multiline = true;
		textField.wordWrap = true;
		return textField;
	}

}
}