package de.dittner.appIconResizer.model {
import flash.display.MovieClip;

public class IOSAsset {
	public function IOSAsset(mc:MovieClip, name:String) {
		_mc = mc;
		_width = mc.width;
		_height = mc.height;
		_name = name;
	}

	//--------------------------------------
	//  mc
	//--------------------------------------
	private var _mc:MovieClip;
	public function get mc():MovieClip {return _mc;}

	//--------------------------------------
	//  width
	//--------------------------------------
	private var _width:Number = 0;
	public function get width():Number {return _width;}

	//--------------------------------------
	//  height
	//--------------------------------------
	private var _height:Number = 0;
	public function get height():Number {return _height;}

	//--------------------------------------
	//  name
	//--------------------------------------
	private var _name:String = "";
	public function get name():String {return _name;}

}
}