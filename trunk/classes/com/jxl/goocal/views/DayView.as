
import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;

import com.jxl.goocal.views.GCHeading;
import com.jxl.goocal.views.EventList;
import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.events.Event;

import com.jxl.goocal.views.GCLinkButton;

class com.jxl.goocal.views.DayView extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.DayView";
	
	public static var EVENT_BACK_TO_MONTH:String = "backToMonth";
	public static var EVENT_CREATE_NEW:String = "createNew";
	
	private var __events:ICollection;
	private var __eventsDirty:Boolean 			= false;
	private var __currentDate:Date;
	private var __currentDateDirty:Boolean		= false;
	
	private var __title_lbl:GCHeading;
	private var __event_list:EventList;
	private var __createNewEvent_link:GCLinkButton;
	private var __backToMonthView_link:GCLinkButton;
	
	public function get events():ICollection { return __events; }
	public function set events(p_val:ICollection):Void
	{
		__events = p_val;
		__eventsDirty = true;
		invalidateProperties();
	}
	
	public function get currentDate():Date { return __currentDate; }
	public function set currentDate(p_val:Date):Void
	{
		__currentDate = p_val;
		__currentDateDirty = true;
		invalidateProperties();
	}
	
	public function DayView()
	{
		super();
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__title_lbl == null)
		{
			__title_lbl = GCHeading(createComponent(GCHeading, "__title_lbl"));
			__title_lbl.textSize = 14;
			__title_lbl.bold = true;
		}
		
		if(__event_list == null)
		{
			__event_list = EventList(createComponent(EventList, "__event_list"));
			__event_list.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onEventItemClicked));
		}
		
		if(__createNewEvent_link == null)
		{
			__createNewEvent_link = GCLinkButton(createComponent(GCLinkButton, "__createNewEvent_link"));
			__createNewEvent_link.label = "Create New Event...";
			__createNewEvent_link.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onCreateNew));
		}
		
		if(__backToMonthView_link == null)
		{
			__backToMonthView_link = GCLinkButton(createComponent(GCLinkButton, "__backToMonthView_link"));
			__backToMonthView_link.label = "Back to Month view...";
			__backToMonthView_link.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onBackToMonthView));
		}
		
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__currentDateDirty == true)
		{
			__currentDateDirty = false;
			__title_lbl.text = DateUtils.format(__currentDate, DateUtils.FORMAT_TIME_MONTH_DAY_FULLYEAR);
		}
	}
	
	private function size():Void
	{
		super.size();
		
		var leftSide:Number = 0;
		
		__title_lbl.move(leftSide, 0);
		__title_lbl.setSize(__width - __title_lbl.x, 20);
		
		__backToMonthView_link.setSize(__width - leftSide, 20);
		__backToMonthView_link.move(__title_lbl.x, __height - __backToMonthView_link.height);
		
		__createNewEvent_link.setSize(__width - leftSide, 20);
		__createNewEvent_link.move(__backToMonthView_link.x, __backToMonthView_link.y - __createNewEvent_link.height);
		
		__event_list.move(__title_lbl.x, __title_lbl.y + __title_lbl.height);
		__event_list.setSize(__width - leftSide, __height - __event_list.y - (__height - __createNewEvent_link.y));
		
		
		beginFill(0xD2D2D2);
		var lineSize:Number = 2;
		DrawUtils.drawBox(this, 0, __event_list.y - lineSize, __width, lineSize);
		DrawUtils.drawBox(this, 0, __event_list.y, __width, lineSize);
		beginFill(0xF0F0F0);
		DrawUtils.drawBox(this, 
						  0, __event_list.y, 
						  __width, __event_list.height);
		endFill();
	}
	
	private function onEventItemClicked(p_event:ShurikenEvent):Void
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = p_event.child;
		event.item = p_event.item;
		event.index = p_event.index;
		dispatchEvent(event);
	}
	
	private function onCreateNew(p_event:ShurikenEvent):Void
	{
		dispatchEvent(new Event(EVENT_CREATE_NEW, this));
	}
	
	private function onBackToMonthView(p_event:ShurikenEvent):Void
	{
		dispatchEvent(new Event(EVENT_BACK_TO_MONTH, this));
	}
	
}