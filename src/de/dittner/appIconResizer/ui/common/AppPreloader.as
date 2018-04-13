package de.dittner.appIconResizer.ui.common {

import de.dittner.async.AsyncCallbacksLib;

import flash.events.Event;

import mx.preloaders.SparkDownloadProgressBar;

public class AppPreloader extends SparkDownloadProgressBar {

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function AppPreloader() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		backgroundColor = 0xf8f7f4;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var preloadingComplete:Boolean;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function addedToStage(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		AsyncCallbacksLib.fps = 30;
		AsyncCallbacksLib.stage = stage;
	}

	override protected function initCompleteHandler(event:Event):void {
		preloadingComplete = true;
		dispatchEvent(new Event(Event.COMPLETE));
	}

	override protected function createChildren():void {}

	override protected function initProgressHandler(event:Event):void {}
	override protected function setInitProgress(completed:Number, total:Number):void {}
	override protected function setDownloadProgress(completed:Number, total:Number):void {}

}
}
