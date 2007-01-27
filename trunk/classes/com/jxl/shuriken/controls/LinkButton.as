import mx.utils.Delegate;

import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Button;

class com.jxl.shuriken.controls.LinkButton extends Button
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.LinkButton";
	
	private var __color:Number 						= 0x0000FF;
	private var __colorDirty:Boolean 				= true;
	private var __underline:Boolean 				= true;
	private var __underlineDirty:Boolean 			= true;
	
	public function LinkButton()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__mcLabel != null) __mcLabel.align = UITextField.ALIGN_LEFT;
	}
	
	// HACK: does not dispatch size event; if needed, fix here
	// don't want SimpleButton's background, so overwriting here
	private function size():Void
	{
	}
	
}