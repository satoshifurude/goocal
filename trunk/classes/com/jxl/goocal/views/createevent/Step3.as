import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.createevent.Step3 extends UIComponent
{
	
	public static var SYMBOL_NAME:String 				= "com.jxl.goocal.views.createevent.Step3";
	
	public static var EVENT_WHAT_CHANGE:String 			= "whatChange";
	public static var EVENT_WHERE_CHANGE:String 		= "whereChange";
	
	private var __changeCallback:Callback;
	
	private var __what_lbl:TextField;
	private var __what_ti:TextField;
	private var __where_lbl:TextField;
	private var __where_ti:TextField;
	
	public function get what():String { return __what_ti.text; }
	public function set what(val:String):Void
	{
		__what_ti.text = val;
	}
	
	public function get where():String { return __where_ti.text; }
	public function set where(val:String):Void
	{
		__where_ti.text = val;
	}
	
	public function Step3()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__what_lbl == null)
		{
			__what_lbl = createLabel("__what_lbl");
			var tf:TextFormat = __what_lbl.getTextFormat();
			tf.bold = true;
			__what_lbl.setNewTextFormat(tf);
			__what_lbl.text = "What (required)";
		}
		
		if(__what_ti == null)
		{
			__what_ti = createLabel("__what_ti");
			__what_ti.type = TextField.TYPE_INPUT;
			__what_ti.border = true;
			__what_ti.borderColor = 0xA5ACB2;
			__what_ti.background = true;
			__what_ti.backgroundColor = 0xFFFFFF;
			__what_ti.onChanged = Delegate.create(this, onWhatChanged); 
		}
		
		if(__where_lbl == null)
		{
			__where_lbl = createLabel("__where_lbl");
			var tf:TextFormat = __where_lbl.getTextFormat();
			tf.bold = true;
			__where_lbl.setNewTextFormat(tf);
			__where_lbl.text = "Where";
		}
		
		if(__where_ti == null)
		{
			__where_ti = createLabel("__where_ti");
			__where_ti.type = TextField.TYPE_INPUT;
			__where_ti.border = true;
			__where_ti.borderColor = 0xA5ACB2;
			__where_ti.background = true;
			__where_ti.backgroundColor = 0xFFFFFF;
			__where_ti.onChanged = Delegate.create(this, onWhereChanged);
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__what_lbl.move(margin, 0);
		__what_lbl.setSize(__width - m2, __what_lbl._height);
		
		__what_ti.move(__what_lbl._x, __what_lbl._y + __what_lbl._height + margin);
		__what_ti.setSize(__width - m2, __what_ti._height);
		
		__where_lbl.move(__what_lbl._x, __what_ti._y + __what_ti._height + margin);
		__where_lbl.setSize(__width - m2, __where_lbl._height);
		
		__where_ti.move(__where_lbl._x, __where_lbl._y + __where_lbl._height + margin);
		__where_ti.setSize(__width - m2, __where_ti._height);
		
		if(__what_ti.text == "")
		{
			__what_ti.borderColor = 0xCC0000;
		}
		else
		{
			__what_ti.borderColor = 0xA5ACB2;
		}
	}
	
	private function onWhatChanged():Void
	{
		if(__what_ti.text == "")
		{
			__what_ti.borderColor = 0xCC0000;
		}
		else
		{
			__what_ti.borderColor = 0xA5ACB2;
		}
		__changeCallback.dispatch(new Event(EVENT_WHAT_CHANGE, this));
	}
	
	private function onWhereChanged():Void
	{
		__changeCallback.dispatch(new Event(EVENT_WHERE_CHANGE, this));
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		__changeCallback = new Callback(scope, func);
	}
	
}