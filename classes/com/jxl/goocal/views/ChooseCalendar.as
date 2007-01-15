import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.controls.CheckBox;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;


class com.jxl.goocal.views.ChooseCalendar extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.ChooseCalendar";
	
	public static var EVENT_SUBMIT:String = "com.jxl.goocal.views.ChooseCalendar.submit";
	
	public function get calendars():ICollection { return __calendars; }
	public function set calendars(p_val:ICollection):Void
	{
		__calendars = p_val;
		__calendarsDirty = true;
		invalidateProperties();
	}
	
	public function get autoChoose():Boolean { return __autoChoose; }
	public function set autoChoose(p_val:Boolean):Void
	{
		__autoChoose = p_val;
		__autoChooseDirty = true;
		invalidateProperties();
	}
	
	private var __calendars:ICollection;
	private var __calendarsDirty:Boolean 		= false;
	private var __autoChoose:Boolean				= false;
	private var __autoChooseDirty:Boolean			= false;
	
	private var __calendar_cb:ComboBox;
	private var __autoChoose_ch:CheckBox;
	private var __submit_pb:Button;
	
	
	public function ChooseCalendar()
	{
	}
	
	private function onInitialized():Void
	{
		super.onInitialized();
		
		__submit_pb.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onSubmit));
		__calendar_cb.direction = ComboBox.DIRECTION_BELOW;
		
		__calendarsDirty 		= true;
		__autoChooseDirty 			= true;
		commitProperties();
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__calendarsDirty == true)
		{
			__calendarsDirty = false;
			__calendar_cb.dataProvider = __calendars;
		}
		
		if(__autoChooseDirty == true)
		{
			__autoChooseDirty = false;
			__autoChoose_ch.selected = __autoChoose;
		}
	}
	
	private function onSubmit(p_event:ShurikenEvent):Void
	{
		dispatchEvent(new Event(EVENT_SUBMIT, this));
	}
}