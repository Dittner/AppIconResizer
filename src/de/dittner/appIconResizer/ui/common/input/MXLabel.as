package de.dittner.appIconResizer.ui.common.input {
import de.dittner.appIconResizer.utils.FontName;
import de.dittner.appIconResizer.utils.TextFieldFactory;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import mx.core.UIComponent;

public class MXLabel extends UIComponent {
	public function MXLabel() {
		super();
	}

	private const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, _color, _isBold, null, null, null, null, _textAlign);
	private var titleTF:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  horPadding
	//--------------------------------------
	private var _horPadding:Number = 0;
	[Bindable("horPaddingChanged")]
	public function get horPadding():Number {return _horPadding;}
	public function set horPadding(value:Number):void {
		if (_horPadding != value) {
			_horPadding = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("horPaddingChanged"));
		}
	}

	//--------------------------------------
	//  verPadding
	//--------------------------------------
	private var _verPadding:Number = 0;
	[Bindable("verPaddingChanged")]
	public function get verPadding():Number {return _verPadding;}
	public function set verPadding(value:Number):void {
		if (_verPadding != value) {
			_verPadding = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("verPaddingChanged"));
		}
	}

	//--------------------------------------
	//  text
	//--------------------------------------
	private var _text:String = "";
	[Bindable("textChanged")]
	public function get text():String {return _text;}
	public function set text(value:String):void {
		if (_text != value) {
			_text = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("textChanged"));
		}
	}

	//--------------------------------------
	//  fontSize
	//--------------------------------------
	private var _fontSize:Number = 17;
	[Bindable("fontSizeChanged")]
	public function get fontSize():Number {return _fontSize;}
	public function set fontSize(value:Number):void {
		if (_fontSize != value) {
			_fontSize = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("fontSizeChanged"));
		}
	}

	//--------------------------------------
	//  textAlign
	//--------------------------------------
	private var _textAlign:String = TextAlign.LEFT;
	[Bindable("textAlignChanged")]
	public function get textAlign():String {return _textAlign;}
	public function set textAlign(value:String):void {
		if (_textAlign != value) {
			_textAlign = value;
			invalidateProperties();
			dispatchEvent(new Event("textAlignChanged"));
		}
	}

	//--------------------------------------
	//  isBold
	//--------------------------------------
	private var _isBold:Boolean = false;
	[Bindable("isBoldChanged")]
	public function get isBold():Boolean {return _isBold;}
	public function set isBold(value:Boolean):void {
		if (_isBold != value) {
			_isBold = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("isBoldChanged"));
		}
	}

	//--------------------------------------
	//  color
	//--------------------------------------
	private var _color:uint = 0x565656;
	[Bindable("colorChanged")]
	public function get color():uint {return _color;}
	public function set color(value:uint):void {
		if (_color != value) {
			_color = value;
			invalidateDisplayList();
			dispatchEvent(new Event("colorChanged"));
		}
	}

	//--------------------------------------
	//  multiline
	//--------------------------------------
	private var _multiline:Boolean = true;
	[Bindable("multilineChanged")]
	public function get multiline():Boolean {return _multiline;}
	public function set multiline(value:Boolean):void {
		if (_multiline != value) {
			_multiline = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("multilineChanged"));
		}
	}

	//--------------------------------------
	//  bgEnabled
	//--------------------------------------
	private var _bgEnabled:Boolean = false;
	[Bindable("bgEnabledChanged")]
	public function get bgEnabled():Boolean {return _bgEnabled;}
	public function set bgEnabled(value:Boolean):void {
		if (_bgEnabled != value) {
			_bgEnabled = value;
			invalidateProperties();
			dispatchEvent(new Event("bgEnabledChanged"));
		}
	}

	//--------------------------------------
	//  bgColor
	//--------------------------------------
	private var _bgColor:uint = 0;
	[Bindable("bgColorChanged")]
	public function get bgColor():uint {return _bgColor;}
	public function set bgColor(value:uint):void {
		if (_bgColor != value) {
			_bgColor = value;
			invalidateProperties();
			dispatchEvent(new Event("bgColorChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		if (!titleTF) {
			titleTF = TextFieldFactory.createMultiline(TITLE_FORMAT);
			titleTF.selectable = false;
			titleTF.mouseEnabled = false;
			mouseEnabled = false;
			addChild(titleTF);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		TITLE_FORMAT.size = fontSize;
		TITLE_FORMAT.bold = isBold;
		TITLE_FORMAT.color = color;
		TITLE_FORMAT.align = textAlign;
		titleTF.multiline = titleTF.wordWrap = multiline;
		titleTF.background = bgEnabled;
		titleTF.backgroundColor = bgColor;
		titleTF.defaultTextFormat = TITLE_FORMAT;
		titleTF.htmlText = text;
	}

	override protected function measure():void {
		super.measure();
		titleTF.width = multiline ? (width || 50) - 2 * horPadding : titleTF.textWidth + 5;
		measuredWidth = titleTF.textWidth + 5 + 2 * horPadding;
		measuredHeight = titleTF.textHeight + 5 + 2 * verPadding;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		titleTF.x = horPadding - 2;
		titleTF.y = verPadding - 2;
		titleTF.width = w - 2 * horPadding;
		titleTF.height = titleTF.textHeight + 5;

		if (titleTF.textHeight > (h - 2 * verPadding)) {
			invalidateSize();
			invalidateDisplayList();
		}
		else if (titleTF.textHeight < (h - 2 * verPadding - 30)) {
			invalidateSize();
			invalidateDisplayList();
		}
	}
}
}
