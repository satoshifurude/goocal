import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.goocal.views.GCLinkButton;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.EventItem extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.EventItem";
	
	private var __time_lbl:TextField;
	private var __name_link:GCLinkButton;
	
	private var __eventTime:String 				= "";
	private var __eventName:String 				= "";
	private var __nameLinkCallback:Callback;
	
	public function get eventTime():String { return __eventTime; }
	public function set eventTime(p_val:String):Void
	{
		__eventTime = p_val;
		__time_lbl.text = p_val;
	}
	
	public function get eventName():String { return __eventName; }
	public function set eventName(p_val:String):Void
	{
		__eventName = p_val;
		__name_link.label = p_val;
	}
	
	public function EventItem()
	{
	}
	
	private function createChildren():Void
	{
		if(__time_lbl == null)
		{
			__time_lbl = createLabel("__time_lbl");
			var tf:TextFormat = __time_lbl.getTextFormat();
			tf.bold = true;
			tf.size = 14;
			tf.color = 0x62AE62;
			__time_lbl.setNewTextFormat(tf);
		}
		
		if(__name_link == null)
		{
			__name_link = GCLinkButton(createComponent(GCLinkButton, "__name_link"));
			var fmt:TextFormat = __name_link.textField.getTextFormat();
			fmt.size = 14;
			__name_link.textField.setTextFormat(fmt);
			__name_link.textField.setNewTextFormat(fmt);
			__name_link.setReleaseCallback(this, onNameLinkClick);
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		__time_lbl.move(0, 2);
		__time_lbl.setSize(__width, 20);
		__name_link.move(0, __time_lbl._y + __time_lbl._height - 2);
		__name_link.setSize(__width, 20);
	}
	
	private function onNameLinkClick(p_event:ShurikenEvent):Void
	{
		p_event.target = this;
		__nameLinkCallback.dispatch(p_event);
	}
	
	public function setReleaseCallback(scope:Object, func:Function):Void
	{
		__nameLinkCallback = new Callback(scope, func);
	}
	
}