import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
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
	private var __calendarsDirty:Boolean					= false;
	private var __calendar:Object;
	private var __description:String						= "";
	private var __descriptionDirty:Boolean					= false;
	private var __changeCallback:Callback;
	
	private var __calendar_lbl:Label;
	private var __calendars_cb:ComboBox;
	private var __description_lbl:Label;
	private var __description_txt:UITextField;
	
	public function get calendars():Collection { return __calendars; }
	public function set calendars(p_val:Collection):Void
	{
		__calendars = p_val;
		__calendarsDirty = true;
		invalidateProperties();
	}
	
	public function get selectedCalendar():Object
	{
		return __calendar;
	}
	
	public function get description():String { return __description; }
	public function set description(p_val:String):Void
	{
		__description = p_val;
		__descriptionDirty = true;
		invalidateProperties();
	}
	
	public function Step4()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__calendar_lbl == null)
		{
			__calendar_lbl = Label(createComponent(Label, "__calendar_lbl"));
			__calendar_lbl.text = "Calendar";
		}
		
		if(__calendars_cb == null)
		{
			__calendars_cb = ComboBox(createComponent(ComboBox, "__calendars_cb"));
			__calendars_cb.dataProvider = __calendars;
			__calendars_cb.setItemSelectionChangedCallback(this, onChooseCalendar);
		}
		
		if(__description_lbl == null)
		{
			__description_lbl = Label(createComponent(Label, "__description_lbl"));
			__description_lbl.text = "Description";
		}
		
		if(__description_txt == null)
		{
			__description_txt = UITextField(createComponent(UITextField, "__description_txt"));
			__description_txt.type = UITextField.TYPE_INPUT;
			__description_txt.border = true;
			__description_txt.borderColor = 0x000000;
			__description_txt.background = true;
			__description_txt.backgroundColor = 0xFFFFFF;
			__description_txt.setChangeCallback(this, onTextChanged);
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__calendarsDirty == true)
		{
			__calendarsDirty = false;
			__calendars_cb.dataProvider = __calendars;
		}
		
		if(__descriptionDirty == true)
		{
			__descriptionDirty = false;
			__description_txt.text = __description;
		}
	}
	
	private function onTextChanged(event:ShurikenEvent):Void
	{
		__description = __description_txt.text;
		__changeCallback.dispatch(new Event(EVENT_DESCRIPTION_CHANGE, this));
	}
	
	private function onChooseCalendar(event:ShurikenEvent):Void
	{
		__calendar = event.item;
		__changeCallback.dispatch(new Event(EVENT_CALENDAR_CHANGE, this));
	}
}