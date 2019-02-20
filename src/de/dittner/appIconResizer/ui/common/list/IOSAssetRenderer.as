package de.dittner.appIconResizer.ui.common.list {
import de.dittner.appIconResizer.model.IOSAsset;
import de.dittner.appIconResizer.utils.FontName;

import flash.display.Graphics;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFormat;

public class IOSAssetRenderer extends ItemRendererBase {
	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function IOSAssetRenderer() {
		super();
		downStateEnabled = true;
	}

	public static const HEIGHT:uint = 50;
	public static const ICON_SIZE:int = 40;
	private static const GAP:uint = 20;
	private static const PAD:uint = 20;

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var mc:MovieClip;
	private var nameTF:TextField;
	private var sizeTF:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  asset
	//--------------------------------------
	protected var assetChanged:Boolean = false;
	public function get asset():IOSAsset {return data as IOSAsset;}
	override public function set data(value:Object):void {
		if (data != value) {
			if (mc && mc.parent) mc.parent.removeChild(mc);
			super.data = value;
			assetChanged = true;
			invalidateDisplayList();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();

		nameTF = createTextField(new TextFormat(FontName.MYRIAD_MX, 20, 0x333333));
		addChild(nameTF);

		sizeTF = createTextField(new TextFormat(FontName.MYRIAD_MX, 20, 0x888888));
		addChild(sizeTF);
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = 500;
		measuredMinHeight = measuredHeight = HEIGHT;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (!asset) return;
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0xd9d9d9);
		g.drawRect(PAD, h - 1, w - 2 * PAD, 1);
		g.endFill();

		parseData();

		if (mc && mc.parent != this) {
			if (mc.parent) mc.parent.removeChild(mc);
			var sc:Number = Math.min(ICON_SIZE / asset.width, ICON_SIZE / asset.height);
			if (sc > 1) sc = 1;
			mc.width = asset.width;
			mc.height = asset.height;
			mc.scaleX = mc.scaleY = sc;
			addChild(mc);
		}

		mc.x = PAD + Math.ceil(mc.width / 2);
		mc.y = (h - mc.height >> 1) + Math.ceil(mc.height / 2);

		setTextSize(nameTF, w - ICON_SIZE - 2 * GAP - 2 * PAD - sizeTF.textWidth);
		nameTF.x = ICON_SIZE + GAP + PAD;
		nameTF.y = h - nameTF.textHeight >> 1;

		sizeTF.x = w - sizeTF.textWidth - PAD;
		sizeTF.y = h - sizeTF.textHeight >> 1;
	}

	private function parseData():void {
		mc = asset.mc;
		nameTF.text = asset.name;
		sizeTF.text = Math.ceil(asset.width) + "x" + Math.ceil(asset.height) + "px";
	}

	private function setTextSize(tf:TextField, wid:Number, hei:Number = NaN):void {
		tf.width = wid;
		tf.height = isNaN(hei) ? tf.textHeight + 10 : hei;
	}
}
}