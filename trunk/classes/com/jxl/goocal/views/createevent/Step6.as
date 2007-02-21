import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.createevent.Step6 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step6";
	
	public static var EVENT_CHANGE:String = "change";
	
	private var __changeCallback:Callback;
	
	private var __instructions_txt:TextField;
	private var __emails_txt:TextField;
	
	public function get emails():String { return __emails_txt.text; }
	public function set emails(val:String):Void
	{
		__emails_txt.text = val;
	}
	
	public function Step6()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__instructions_txt == null)
		{
			__instructions_txt = createLabel("__instructions_txt");
			__instructions_txt.multiline 	= true;
			__instructions_txt.wordWrap 	= true;
			__instructions_txt.text 		= "Enter the email addresses of guests, seperated by commas.";
		}
		
		if(__emails_txt == null)
		{
			__emails_txt = createLabel("__emails_txt");
			__emails_txt.border 			= true;
			__emails_txt.borderColor 		= 0x000000;
			__emails_txt.background 		= true;
			__emails_txt.backgroundColor 	= 0xFFFFFF;
			__emails_txt.onChanged 			= Delegate.create(this, onEmailChange);
		}
		
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__instructions_txt.move(0, 0);
		__instructions_txt.setSize(__width, 36);
		
		__emails_txt.move(0, __instructions_txt._height + 2);
		__emails_txt.setSize(__width, __height - __emails_txt._y);
	}
	
	private function onEmailChange():Void
	{
		__changeCallback.dispatch(new Event(EVENT_CHANGE, this));
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		__changeCallback = new Callback(scope, func);
	}
}