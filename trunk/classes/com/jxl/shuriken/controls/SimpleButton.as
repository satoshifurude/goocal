import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.controls.SimpleButton extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.SimpleButton";
	
	private var __mouseListener:Object;
	
	public function SimpleButton()
	{
	}
	/*
	public function init():Void
	{
		super.init();
		
		if(__mouseListener == null)
		{
			__mouseListener = {};
			__mouseListener.onMouseDown = Delegate.create(this, onMouseDownSomewhere);
			Mouse.addListener(__mouseListener);
		}
	}
	*/
	private function size():Void
	{
		super.size();
		
		/*
		clear();
		lineStyle(0, 0x999999); // uncomment if debugging, draw's an outline for you
		beginFill(0xCCCCCC); // change alpha to 90 when debugging
		DrawUtils.drawRoundRect(this, 0, 0, width, height, 6);
		endFill();
		*/
	}
	
	private function onPress():Void
	{
		buttonPress();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.PRESS, this));
	}
	
	private function onRelease():Void
	{
		buttonRelease();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.RELEASE, this));
		//var o = {type: "com.jxl.shuriken.events.ShurikenEvent.release", target: this}
		//dispatchEvent(o);
	}
	
	private function onReleaseOutside():Void
	{
		buttonReleaseOutside();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.RELEASE_OUTSIDE, this));
	}
	
	private function onRollOver():Void
	{
		buttonRollOver();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.ROLL_OVER, this));
	}
	
	private function onRollOut():Void
	{
		buttonRollOut();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.ROLL_OUT, this));
	}
	
	/*
	private function onMouseDownSomewhere():Void
	{
		var p:Object = {};
		p.x = _xmouse;
		p.y = _ymouse;
		
		localToGlobal(p);
		
		if (hitTest(p.x, p.y) == false)
		{
			dispatchEvent(new ShurikenEvent(ShurikenEvent.MOUSE_DOWN_OUTSIDE, this));
		}
	}
	*/
	
	public function toString():String
	{
		return "[object com.jxl.shuriken.controls.SimpleButton]";
	}
	
	//BUTTON EVENTS/-------------------------------------------------
	
	//These functions are used by subclasses to process mouse events
	
	private function buttonPress():Void{}
	private function buttonRelease():Void{}
	private function buttonReleaseOutside():Void{}
	private function buttonRollOver():Void {}
	private function buttonRollOut():Void {}
	
	
}