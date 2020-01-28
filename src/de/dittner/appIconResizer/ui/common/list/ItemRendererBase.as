package de.dittner.appIconResizer.ui.common.list {
import flash.events.MouseEvent;
import flash.text.TextFormat;

import mx.core.UIComponent;

import spark.components.IItemRenderer;

public class ItemRendererBase extends UIComponent implements IItemRenderer {

	public function ItemRendererBase() {
		super();
		percentWidth = 100;
	}

	//----------------------------------
	//  data
	//----------------------------------
	protected var dataChanged:Boolean = false;
	private var _data:Object;
	public function get data():Object {return _data;}
	public function set data(value:Object):void {
		if (_data != value) {
			_data = value;
			dataChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
	}

	//----------------------------------
	//  label
	//----------------------------------
	public function set label(value:String):void {}
	public function get label():String { return ""; }

	//----------------------------------
	//  itemIndex
	//----------------------------------
	private var _itemIndex:int;
	public function get itemIndex():int {return _itemIndex;}
	public function set itemIndex(value:int):void {
		_itemIndex = value;
	}

	//----------------------------------
	//  dragging
	//----------------------------------
	public function get dragging():Boolean {return false}
	public function set dragging(value:Boolean):void {}

	//----------------------------------
	//  showsCaret
	//----------------------------------
	public function get showsCaret():Boolean {return false}
	public function set showsCaret(value:Boolean):void {}

	//----------------------------------
	//  selected
	//----------------------------------
	private var _selected:Boolean = false;
	public function get selected():Boolean {return _selected;}
	public function set selected(value:Boolean):void {
		if (value != _selected) {
			_selected = value;
		}
	}

	//--------------------------------------
	//  downStateEnabled
	//--------------------------------------
	private var _downStateEnabled:Boolean = false;
	public function get downStateEnabled():Boolean {return _downStateEnabled;}
	public function set downStateEnabled(value:Boolean):void {
		if (_downStateEnabled != value) {
			_downStateEnabled = value;
			if (downStateEnabled) addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			else removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function createMultilineTextField(format:TextFormat):SmartTextField {
		var textField:SmartTextField = TextFieldFactory.createMultiline(format);
		return textField;
	}

	protected function createTextField(format:TextFormat):SmartTextField {
		var textField:SmartTextField = TextFieldFactory.create(format);
		return textField;
	}

	protected var isDown:Boolean = false;
	protected function mouseDownHandler(event:MouseEvent):void {
		isDown = true;
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
		invalidateDisplayList();
	}

	protected function mouseUpHandler(event:MouseEvent):void {
		isDown = false;
		removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
		invalidateDisplayList();
	}

}
}

