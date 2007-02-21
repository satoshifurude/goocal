import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Calendar;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.controls.LinkButton;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.MonthView extends UIComponent
{
	public static var SYMBOL_NAME:String				= "com.jxl.goocal.views.MonthView";
	
	public static var EVENT_DATE_SELECTED:String		= "dateSelected";
	public static var EVENT_CHANGE_SETTINGS:String 		= "changeSettings";
	public static var EVENT_CREATE:String				= "create";
	
	private var __selectedDate:Date;
	private var __dateSelectedCallback:Callback;
	private var __settingsCallback:Callback;
	private var __createCallback:Callback;
	
	private var __cal:Calendar;
	private var __createNew_link:LinkButton;
	private var __changeSettings_link:LinkButton;
	private var __or_txt:TextField;
	
	public function get selectedDate():Date { return __selectedDate; }
	
	public function MonthView()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__cal == null)
		{
			__cal = Calendar(createComponent(Calendar, "__cal"));
			__cal.setItemClickCallback(this, onDayClicked);
		}
		
		if(__createNew_link == null)
		{
			__createNew_link = LinkButton(createComponent(LinkButton, "__createNew_link"));
			__createNew_link.setReleaseCallback(this, onCreateNew);
			__createNew_link.textField.autoSize = "left";
			var ctf:TextFormat = __createNew_link.textField.getTextFormat();
			ctf.color = 0x0066CC;
			ctf.font = "Verdana";
			ctf.size = 12;
			ctf.bold = true;
			__createNew_link.textField.setNewTextFormat(ctf);
			__createNew_link.textField.setTextFormat(ctf);
			__createNew_link.label = "Create New Event...";
		}
		
		if(__or_txt == null)
		{
			__or_txt = createLabel("__or_txt");
			__or_txt.autoSize = "left";
			__or_txt.text = "or";
		}
		
		if(__changeSettings_link == null)
		{
			__changeSettings_link = LinkButton(createComponent(LinkButton, "__changeSettings_link"));
			__changeSettings_link.setReleaseCallback(this, onChangeSettings);
			__changeSettings_link.textField.autoSize = "left";
			var stf:TextFormat = __changeSettings_link.textField.getTextFormat();
			stf.color = 0x0066CC;
			stf.font = "Verdana";
			stf.size = 10;
			stf.bold = true;
			__changeSettings_link.textField.setNewTextFormat(stf);
			__changeSettings_link.textField.setTextFormat(stf);
			__changeSettings_link.label = "Change Settings";
		}
		
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		__cal.move(0, 0);
		__createNew_link.move(2, __cal.y + __cal.height + 2);
		__createNew_link.setSize(__width, __createNew_link.height);
		__or_txt.move(__createNew_link.x, __createNew_link.y + __createNew_link.height + 2);
		__changeSettings_link.move(__or_txt._x + __or_txt._width, __or_txt._y + 1);
	}
	
	private function onDayClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("MonthView::onDayClicked");
		//DebugWindow.debug("p_event.item: " + p_event.item);
		// HACK: compiler hack, cannot cast to Date in AS2
		var o = p_event.item;
		__selectedDate = o;
		__dateSelectedCallback.dispatch(new Event(EVENT_DATE_SELECTED, this));
	}
	
	private function onChangeSettings(event:ShurikenEvent):Void
	{
		__settingsCallback.dispatch(new Event(EVENT_CHANGE_SETTINGS, this));
	}
	
	private function onCreateNew(event:ShurikenEvent):Void
	{
		__createCallback.dispatch(new Event(EVENT_CREATE, this));
	}
	
	public function onIdle():Void
	{
		_visible = false;
		
		__createNew_link.removeMovieClip();
		delete __createNew_link;
		
		__or_txt.removeTextField();
		delete __or_txt;
		
		__changeSettings_link.removeMovieClip();
		delete __changeSettings_link;
		
		__cal.onIdle();
	}
	
	public function onNonIdle():Void
	{
		_visible = true;
		__cal.onNonIdle();
		createChildren();
		invalidate();
	}
	
	public function setDateSelectedCallback(scope:Object, func:Function):Void
	{
		__dateSelectedCallback = new Callback(scope, func);
	}
	
	public function setSettingsCallback(scope:Object, func:Function):Void
	{
		__settingsCallback = new Callback(scope, func);
	}
	
	public function setCreateNewCallback(scope:Object, func:Function):Void
	{
		__createCallback = new Callback(scope, func);
	}
}