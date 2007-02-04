﻿import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.goocal.views.GCUpArrowButton extends Button
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.GCUpArrowButton";
	
	private var __alignIcon:String = ALIGN_ICON_CENTER;
	
	public function GCUpArrowButton()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		icon = "GCUpArrowButtonGraphic";
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		clear();
		lineStyle(0, 0x808080);
		beginFill(0xC3D9FF);
		DrawUtils.drawBox(this, 0, 0, __width, __height);
		endFill();
	}
	
}