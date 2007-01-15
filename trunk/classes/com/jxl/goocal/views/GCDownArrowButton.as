﻿import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.goocal.views.GCDownArrowButton extends Button
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.GCDownArrowButton";
	
	private var __icon:String = "GCDownArrowButtonGraphic";
	private var __iconDirty:Boolean = true;
	private var __alignIcon:String = ALIGN_ICON_CENTER;
	
	public function GCDownArrowButton()
	{
	}
	
	private function size():Void
	{
		super.size();
		
		clear();
		lineStyle(0, 0x808080);
		beginFill(0xC3D9FF);
		DrawUtils.drawBox(this, 0, 0, __width, __height);
		endFill();
	}
	
}