﻿import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.controls.SimpleButton extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.SimpleButton";
	
	private var __mouseListener:Object;
	private var __pressCallback:Callback;
	private var __releaseCallback:Callback;
	private var __releaseOutsideCallback;
	private var __rollOverCallback:Callback;
	private var __rollOutCallback:Callback;
	private var __mouseDownOutsideCallback:Callback;
	
	
	public function SimpleButton()
	{
	}
	
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
	
	private function size():Void
	{
		super.size();
		
		clear();
		lineStyle(0, 0x999999); // uncomment if debugging, draw's an outline for you
		beginFill(0xCCCCCC); // change alpha to 90 when debugging
		DrawUtils.drawRoundRect(this, 0, 0, width, height, 6);
		endFill();
	}
	
	private function onPress():Void
	{
		__pressCallback.dispatch(new ShurikenEvent(ShurikenEvent.PRESS, this));
		
	}
	
	private function onRelease():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("SimpleButton::onRelease");
		//DebugWindow.debug("__releaseCallback: " + __releaseCallback);
		__releaseCallback.dispatch(new ShurikenEvent(ShurikenEvent.RELEASE, this));
	}
	
	private function onReleaseOutside():Void
	{
		__releaseOutsideCallback.dispatch(new ShurikenEvent(ShurikenEvent.RELEASE_OUTSIDE, this));
	}
	
	private function onRollOver():Void
	{
		__rollOverCallback.dispatch(new ShurikenEvent(ShurikenEvent.ROLL_OVER, this));
	}
	
	private function onRollOut():Void
	{
		__rollOutCallback.dispatch(new ShurikenEvent(ShurikenEvent.ROLL_OUT, this));
	}
	
	
	private function onMouseDownSomewhere():Void
	{
		var p:Object = {};
		p.x = _xmouse;
		p.y = _ymouse;
		
		localToGlobal(p);
		
		if (hitTest(p.x, p.y) == false)
		{
			__mouseDownOutsideCallback.dispatch(new ShurikenEvent(ShurikenEvent.MOUSE_DOWN_OUTSIDE, this));
		}
	}
	
	public function toString():String
	{
		return "[object com.jxl.shuriken.controls.SimpleButton]";
	}
	
	public function setPressCallback(scope:Object, func:Function):Void
	{
		__pressCallback = new Callback(scope, func);
	}
	
	public function setReleaseCallback(scope:Object, func:Function):Void
	{
		if(scope == null)
		{
			delete __releaseCallback;
			return;
		}
		__releaseCallback = new Callback(scope, func);
	}
	
	public function setReleaseOutsideOutside(scope:Object, func:Function):Void
	{
		__releaseOutsideCallback = new Callback(scope, func);
	}
	
	public function setRollOverCallback(scope:Object, func:Function):Void
	{
		__rollOverCallback = new Callback(scope, func);
	}
	
	public function setRollOutCallback(scope:Object, func:Function):Void
	{
		__rollOutCallback = new Callback(scope, func);
	}
	
	public function setMouseDownOutsideCallback(scope:Object, func:Function):Void
	{
		__mouseDownOutsideCallback = new Callback(scope, func);
	}
	
	
}