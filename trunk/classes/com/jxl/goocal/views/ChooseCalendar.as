import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.controls.CheckBox;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;


class com.jxl.goocal.views.ChooseCalendar extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.ChooseCalendar";
	
	public static var EVENT_SUBMIT:String = "com.jxl.goocal.views.ChooseCalendar.submit";
	
	public function get calendars():Collection { return __calendars; }
	public function set calendars(p_val:Collection):Void
	{
		__calendars = p_val;
		__calendar_cb.dataProvider = p_val;
	}
	
	public function get autoChoose():Boolean { return __autoChoose; }
	public function set autoChoose(p_val:Boolean):Void
	{
		__autoChoose = p_val;
		__autoChoose_ch.selected = p_val;
	}
	
	private var __calendars:Collection;
	private var __autoChoose:Boolean				= false;
	private var __submitCallback:Callback;
	
	private var __calendar_cb:ComboBox;
	private var __autoChoose_ch:CheckBox;
	private var __submit_pb:Button;
	
	
	public function ChooseCalendar()
	{
	}
	
	private function onLoad():Void
	{
		super.onLoad();
		
		__submit_pb.setReleaseCallback(this, onSubmit);
		__calendar_cb.direction = ComboBox.DIRECTION_BELOW;
		
		calendars = __calendars;
		autoChoose = __autoChoose;
	}
	
	private function onSubmit(p_event:ShurikenEvent):Void
	{
		__submitCallback.dispatch(new Event(EVENT_SUBMIT, this));
	}
	
	public function setSubmitCallback(scope:Object, func:Function):Void
	{
		__submitCallback = new Callback(scope, func);
	}
}