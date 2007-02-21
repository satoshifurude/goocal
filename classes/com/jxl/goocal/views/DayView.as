
import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;

import com.jxl.goocal.views.EventList;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.Callback;
import com.jxl.shuriken.controls.LinkButton;

class com.jxl.goocal.views.DayView extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.DayView";
	
	public static var EVENT_BACK_TO_MONTH:String = "backToMonth";
	public static var EVENT_CREATE_NEW:String = "createNew";
	
	private var __events:Collection;
	private var __currentDate:Date;
	private var __createNewCallback:Callback;
	private var __monthViewCallback:Callback;
	private var __elS:Object;
	private var __elF:Function;
	
	private var __title_lbl:TextField;
	private var __none_txt:TextField;
	private var __event_list:EventList;
	private var __createNewEvent_link:LinkButton;
	private var __backToMonthView_link:LinkButton;
	
	public function get events():Collection { return __events; }
	public function set events(p_val:Collection):Void
	{
		__events = p_val;
		if(__events != null && __events.getLength() > 0)
		{
			if(__none_txt != null)
			{
				__none_txt.removeTextField();
				delete __none_txt;
			}
			if(__event_list == null) __event_list = EventList(createComponent(EventList, "__event_list"));
			__event_list.setItemClickCallback(__elS, __elF);
			__event_list.dataProvider = p_val;
			invalidate();
		}
		else
		{
			
			__event_list.removeMovieClip();
			delete __event_list;
			callLater(this, createNoneTXT);
			invalidate();
		}
	}
	
	public function get currentDate():Date { return __currentDate; }
	public function set currentDate(p_val:Date):Void
	{
		__currentDate = p_val;
		__title_lbl.text = DateUtils.format(__currentDate, DateUtils.FORMAT_TIME_MONTH_DAY_FULLYEAR);
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
			__title_lbl = createLabel("__title_lbl");
			var titleFMT:TextFormat = __title_lbl.getTextFormat();
			titleFMT.size = 14;
			titleFMT.bold = true;
			titleFMT.color = 0x333333;
			__title_lbl.setTextFormat(titleFMT);
			__title_lbl.setNewTextFormat(titleFMT);
		}
		
		createNoneTXT();
		
		if(__createNewEvent_link == null)
		{
			__createNewEvent_link = LinkButton(createComponent(LinkButton, "__createNewEvent_link"));
			var ctf:TextFormat = __createNewEvent_link.textField.getTextFormat();
			ctf.color = 0x0066CC;
			__createNewEvent_link.textField.setNewTextFormat(ctf);
			__createNewEvent_link.label = "Create New Event...";
			__createNewEvent_link.setReleaseCallback(this, onCreateNew);
		}
		
		if(__backToMonthView_link == null)
		{
			__backToMonthView_link = LinkButton(createComponent(LinkButton, "__backToMonthView_link"));
			var btf:TextFormat = __backToMonthView_link.textField.getTextFormat();
			btf.color = 0x0066CC;
			__backToMonthView_link.textField.setNewTextFormat(btf);
			__backToMonthView_link.label = "Back to Month view...";
			__backToMonthView_link.setReleaseCallback(this, onBackToMonthView);
		}
		
	}
	
	private function createNoneTXT():Void
	{
		if(__none_txt == null)
		{
			__none_txt = createLabel("__none_txt");
			var noneTF:TextFormat = __none_txt.getTextFormat();
			noneTF.align = TextField.ALIGN_CENTER;
			noneTF.size = 14;
			noneTF.font = "Courier New";
			noneTF.color = 0x339933;
			__none_txt.autoSize = "left";
			__none_txt.setNewTextFormat(noneTF);
			__none_txt.setTextFormat(noneTF);
			__none_txt.text = "No events to show.";
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var leftSide:Number = 0;
		
		__title_lbl.move(leftSide, 0);
		__title_lbl.setSize(__width - __title_lbl._x, 20);
		
		__backToMonthView_link.setSize(__width - leftSide, 20);
		__backToMonthView_link.move(__title_lbl._x, __height - __backToMonthView_link.height);
		
		__createNewEvent_link.setSize(__width - leftSide, 20);
		__createNewEvent_link.move(__backToMonthView_link.x, __backToMonthView_link.y - __createNewEvent_link.height);
		
		if(__event_list != null)
		{
			__event_list.move(__title_lbl._x, __title_lbl._y + __title_lbl._height);
			__event_list.setSize(__width - leftSide, __height - __event_list.y - (__height - __createNewEvent_link.y));
		}
		
		if(__none_txt != null)
		{
			__none_txt.move(0, (__height / 2) - (__none_txt._height / 2));
		}
		
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
	
	private function onCreateNew(p_event:ShurikenEvent):Void
	{
		__createNewCallback.dispatch(new Event(EVENT_CREATE_NEW, this));
	}
	
	private function onBackToMonthView(p_event:ShurikenEvent):Void
	{
		__monthViewCallback.dispatch(new Event(EVENT_BACK_TO_MONTH, this));
	}
	
	public function setCreateNewCallback(scope:Object, func:Function):Void
	{
		__createNewCallback = new Callback(scope, func);
	}
	
	public function setMonthViewCallback(scope:Object, func:Function):Void
	{
		__monthViewCallback = new Callback(scope, func);
	}
	
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("setItemClickCallback, scope: " + scope + ", func: " + func);
		//DebugWindow.debug("__event_list: " + __event_list);
		__elS = scope;
		__elF = func;
		if(__event_list != null)
		{
			__event_list.setItemClickCallback(scope, func);
		}
	}
	
	
}