package de.dittner.appIconResizer.ui.common.input {
import flash.events.KeyboardEvent;

import spark.components.TextInput;
import spark.events.TextOperationEvent;

public class HistoryTextInput extends TextInput {
	public function HistoryTextInput() {
		super();
		history.capacity = 1000;
	}

	private var history:TextHistory = new TextHistory();
	private var isHistoryKeysPressed:Boolean = false;

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance == textDisplay) {
			addEventListener(TextOperationEvent.CHANGING, textChanging);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance == textDisplay) {
			removeEventListener(TextOperationEvent.CHANGING, textChanging);
			removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
	}

	[Bindable("change")]
	[Bindable("textChanged")]
	[CollapseWhiteSpace]
	override public function set text(value:String):void {
		if (text != value) {
			super.text = value;
			history.clear();
			history.push(text, 0);
		}
	}

	private function keyDown(event:KeyboardEvent):void {
		if (event.controlKey || event.commandKey) {
			if (isZ(event.charCode)) {
				isHistoryKeysPressed = true;
				undoText();
			}
			if (isY(event.charCode)) {
				isHistoryKeysPressed = true;
				redoText();
			}
		}
	}

	private function isZ(charCode:uint):Boolean {
		return charCode == 122 || charCode == 26;//z,я
	}

	private function isY(charCode:uint):Boolean {
		return charCode == 121 || charCode == 25;//y,н
	}

	private function keyUp(event:KeyboardEvent):void {
		isHistoryKeysPressed = (event.controlKey || event.commandKey) && (isZ(event.charCode) || isY(event.charCode));
		history.push(text, textDisplay.selectionAnchorPosition);
	}

	private function textChanging(event:TextOperationEvent):void {
		if (isHistoryKeysPressed) event.preventDefault();
	}

	private function undoText():void {
		history.undo();
		updateTextFromHistory();
	}

	private function redoText():void {
		history.redo();
		updateTextFromHistory();
	}

	private function updateTextFromHistory():void {
		super.text = history.row;
		setCursorTo(history.cursorPos);
		dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
	}

	private function setCursorTo(pos:int):void {
		if (textDisplay) textDisplay.selectRange(pos, pos);
	}
}
}
