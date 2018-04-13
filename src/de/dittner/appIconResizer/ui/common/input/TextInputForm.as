package de.dittner.appIconResizer.ui.common.input {
import flash.events.Event;

public class TextInputForm extends HistoryTextInput {
	public function TextInputForm() {
		super();
	}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			if (skin) skin.invalidateDisplayList();
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  showTitle
	//--------------------------------------
	private var _showTitle:Boolean = true;
	[Bindable("showTitleChanged")]
	public function get showTitle():Boolean {return _showTitle;}
	public function set showTitle(value:Boolean):void {
		if (_showTitle != value) {
			_showTitle = value;
			if (skin) {
				skin.invalidateSize();
				skin.invalidateDisplayList();
			}
			dispatchEvent(new Event("showTitleChanged"));
		}
	}

	//--------------------------------------
	//  isValidInput
	//--------------------------------------
	private var _isValidInput:Boolean = true;
	[Bindable("isValidInputChanged")]
	public function get isValidInput():Boolean {return _isValidInput;}
	public function set isValidInput(value:Boolean):void {
		if (_isValidInput != value) {
			_isValidInput = value;
			dispatchEvent(new Event("isValidInputChanged"));
			if (skin) skin.invalidateDisplayList();
		}
	}

	public function setInputInFocus():void {
		if (stage) stage.focus = this;
	}
}
}
