package de.dittner.appIconResizer.ui.common.list {
import flash.text.TextField;

public class SmartTextField extends TextField {
	public function SmartTextField() {
		super();
	}

	//--------------------------------------
	//  truncationEnabled
	//--------------------------------------
	private var _truncationEnabled:Boolean = false;
	public function get truncationEnabled():Boolean {return _truncationEnabled;}
	public function set truncationEnabled(value:Boolean):void {
		if (_truncationEnabled != value) {
			_truncationEnabled = value;
			if (truncationEnabled) truncateText();
			else text = originalText;
		}
	}

	private var explicitWidth:Number = NaN;
	override public function get width():Number {return explicitWidth ? explicitWidth : textWidth + 10;}
	override public function set width(value:Number):void {
		super.width = value;
		super.height = height;
		if (explicitWidth != value) {
			explicitWidth = value;
			if (truncationEnabled) truncateText();
		}
	}

	private var explicitHeight:Number = NaN;
	override public function get height():Number {return explicitHeight ? explicitHeight : textHeight + 10;}
	override public function set height(value:Number):void {
		super.width = width;
		super.height = value;
		if (explicitHeight != value) {
			explicitHeight = value;
			if (truncationEnabled) truncateText();
		}
	}

	private var originalText:String = "";
	override public function set text(value:String):void {
		if (originalText != value) {
			super.text = originalText = value || "";
			super.width = width;
			super.height = height;
			if (truncationEnabled) truncateText();
		}
		else {
			super.text = text;//need to update textFormat changes
			super.width = width;
			super.height = height;
		}
	}

	override public function set htmlText(value:String):void {
		if (super.htmlText != value) {
			super.htmlText = value || "";
			super.width = width;
			super.height = height;
			if (truncationEnabled) truncateText();
		}
	}

	private function truncateText():void {
		super.text = originalText;
		if (text && explicitHeight && explicitWidth) {
			if (text.length > 6) {
				if (multiline) {
					while (textHeight > explicitHeight)
						super.text = text.substr(0, -6) + "...";
				}
				else {
					while (textWidth > explicitWidth)
						super.text = text.substr(0, -6) + "...";
				}
			}
			else {
				super.text = text;
			}
		}
	}

}
}
