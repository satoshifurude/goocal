import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.createevent.Step4 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step4";
	
	public static var EVENT_DESCRIPTION_CHANGE:String = "descriptionChange";
	public static var EVENT_CALENDAR_CHANGE:String = "calendarChange";
	
	private var __calendars:Collection;
	private var __calendar:String;
	private var __description:String						= "";
	private var __changeCallback:Callback;
	
	private var __calendar_lbl:TextField;
	private var __calendars_cb:ComboBox;
	private var __description_lbl:TextField;
	private var __description_txt:TextField;
	
	public function get calendars():Collection { return __calendars; }
	public function set calendars(p_val:Collection):Void
	{
		__calendars = p_val;
		__calendars_cb.dataProvider = p_val;
	}
	
	public function get selectedCalendar():Object
	{
		return __calendar;
	}
	
	public function get description():String { return __description; }
	public function set description(p_val:String):Void
	{
		__description = p_val;
		__description_txt.text = p_val;
	}
	
	public function get calendar():String { return __calendar; }
	public function set calendar(val:String):Void
	{
		__calendar = val;
		__calendars_cb.selectedItem = __calendar;
	}
	
	public function Step4()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__description_lbl == null)
		{
			__description_lbl = createLabel("__description_lbl");
			__description_lbl.text = "Description";
		}
		
		if(__description_txt == null)
		{
			__description_txt = createLabel("__description_txt");
			__description_txt.type = TextField.TYPE_INPUT;
			__description_txt.border = true;
			__description_txt.borderColor = 0x000000;
			__description_txt.background = true;
			__description_txt.backgroundColor = 0xFFFFFF;
			__description_txt.onChanged = Delegate.create(this, onDescChanged);
		}
		
		if(__calendar_lbl == null)
		{
			__calendar_lbl = createLabel("__calendar_lbl");
			__calendar_lbl.text = "Calendar";
		}
		
		if(__calendars_cb == null)
		{
			__calendars_cb = ComboBox(createComponent(ComboBox, "__calendars_cb"));
			__calendars_cb.direction = ComboBox.DIRECTION_BELOW;
			__calendars_cb.dataProvider = __calendars;
			__calendars_cb.setItemSelectionChangedCallback(this, onChooseCalendar);
			__calendars_cb.prompt = "-- select calendar --";
			if(__calendar != null && __calendar != "") __calendars_cb.selectedItem = __calendar;
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var margin:Number = 2;
		
		__calendar_lbl.move(0, 0);
		__calendar_lbl.setSize(60, 16);
		
		__calendars_cb.move(margin, __calendar_lbl._y + __calendar_lbl._height + margin);
		__calendars_cb.setSize(__width - (margin * 2), __calendars_cb.height);
		
		__description_lbl.move(__calendar_lbl._x, __calendars_cb.y + __calendars_cb.height + margin);
		__description_lbl.setSize(__width, __description_lbl._height);
		
		__description_txt.move(__calendars_cb.x, __description_lbl._y + __description_lbl._height + margin);
		__description_txt.setSize(__calendars_cb.width, __height - __description_txt._y);
	}
	
	private function onDescChanged():Void
	{
		__description = __description_txt.text;
		__changeCallback.dispatch(new Event(EVENT_DESCRIPTION_CHANGE, this));
	}
	
	private function onChooseCalendar(event:ShurikenEvent):Void
	{
		__calendar = String(event.item);
		__changeCallback.dispatch(new Event(EVENT_CALENDAR_CHANGE, this));
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		__changeCallback = new Callback(scope, func);
	}
}