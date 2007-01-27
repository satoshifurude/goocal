
import mx.utils.Delegate;

import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.utils.DateUtils;

import com.jxl.goocal.views.LoginForm;
import com.jxl.goocal.views.CalendarList;
import com.jxl.goocal.views.DayView;
import com.jxl.goocal.views.MonthView;
import com.jxl.goocal.views.EntryView;
import com.jxl.goocal.views.CreateEvent;

import com.jxl.goocal.controller.CommandRegistry;
import com.jxl.goocal.events.LoginEvent;

import com.jxl.goocal.callbacks.LoginCallback;

import com.jxl.goocal.events.GetCalendarsEvent;
import com.jxl.goocal.events.SelectCalendarEvent;
import com.jxl.goocal.events.GetCalendarEventsEvent;
import com.jxl.goocal.events.GetEntryEvent;

import com.jxl.goocal.callbacks.SetCurrentDateCallback;
import com.jxl.goocal.events.SetCurrentDateEvent;

import com.jxl.goocal.model.ModelLocator;

import com.jxl.goocal.vo.CalendarVO;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;

		
class GoogleCalendar extends UIComponent
{
	public static var loop_mc:MovieClip;
	
	private var __debug:DebugWindow;
	
	private var __loop_mc:MovieClip;
	
	private static var SYMBOL_ACTIVITY:String = "BlueLoadingAnimation";
	
	private var __activity_mc:MovieClip;
	private var __login_mc:LoginForm;
	private var __loggingIn_lbl:Label;
	private var __calendarList:CalendarList;
	private var __dayView:DayView;
	private var __monthView:MonthView;
	private var __entryView:EntryView;
	private var __createEvent:CreateEvent;
	
	public function GoogleCalendar()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		__width = 176;
		__height = 208;
	}
	
	public function createChildren():Void
	{
		//if(__debug == null)
		//{
			//__debug = DebugWindow(attachMovie("DebugWindow", "__debug", getNextHighestDepth()));
			
		//}
		
		if(__loop_mc == null)
		{
			createEmptyMovieClip("__loop_mc", getNextHighestDepth());
			GoogleCalendar.loop_mc = __loop_mc;
		}
		
		if(__login_mc == null)
		{
			__login_mc = LoginForm(attachMovie(LoginForm.SYMBOL_NAME, "__login_mc", getNextHighestDepth()));
			__login_mc.addEventListener(LoginForm.EVENT_SUBMIT, Delegate.create(this, onLogin));
			__login_mc.move(0, 56);
		}
	}
	
	private function onLogin(p_event:Event):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::onLogin");
		
		var event:LoginEvent = new LoginEvent(LoginEvent.LOGIN, this, onLoggedIn);
		event.username = __login_mc.username;
		event.password = __login_mc.password;
		//DebugWindow.debug("__login_mc.username: " + __login_mc.username + ", __login_mc.password: " + __login_mc.password);
		
		destroyViews();
		showActivity("Logging In...");
		
		CommandRegistry.getInstance().dispatchEvent(event);
	}
	
	private function onLoggedIn(p_callback:LoginCallback):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::onLoggedIn");
		//DebugWindow.debug("p_callback.isLoggedIn: " + p_callback.isLoggedIn);
		if(p_callback.isLoggedIn == true)
		{
			gotoAndPlay("main");
			showActivity("Getting Calendars...");
			
			var event:GetCalendarsEvent = new GetCalendarsEvent(GetCalendarsEvent.GET_CALENDARS, 
																this, 
																onGetCalendars);
			CommandRegistry.getInstance().dispatchEvent(event);
			
		}
		else
		{
			showActivity("Login Failed.");
			__loggingIn_lbl.color = 0xCC0000;
			
			hideActivity();
		}
	}
	
	private function onGetCalendars(p_result:Object):Void
	{
		if(p_result == true)
		{
			hideActivity(true);
			
			if(__calendarList == null)
			{
				__calendarList = CalendarList(createComponent(CalendarList, "__calendarList"));
				__calendarList.move(0, 40);
				__calendarList.setSize(width, __calendarList.height);
				__calendarList.calendarsCollection = ModelLocator.getInstance().calendars;
				__calendarList.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onCalendarSelected));
			}
		}
	}
	
	private function onCalendarSelected(p_event:ShurikenEvent):Void
	{	
		__calendarList.removeMovieClip();
		delete __calendarList;
		
		var event:SelectCalendarEvent = new SelectCalendarEvent(SelectCalendarEvent.SELECT,
																this,
																onCalendarNameSelected);
		event.selectedCalendar = String(p_event.item);
		CommandRegistry.getInstance().dispatchEvent(event);
	}
	
	private function onCalendarNameSelected(p_event:ShurikenEvent):Void
	{
		showActivity("Getting Calendar Events...");
		
		var event:GetCalendarEventsEvent = new GetCalendarEventsEvent(GetCalendarEventsEvent.GET_EVENTS,
																	  this,
																	  showTodayView);
		event.calendarName = ModelLocator.getInstance().selectedCalendar;
		var today:Date = new Date();
		event.startDate = today;
		event.endDate = today;
		CommandRegistry.getInstance().dispatchEvent(event);
	}
	
	private function showTodayView(p_boolOrMsg:Object):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::showTodayView, p_boolOrMsg: " + p_boolOrMsg);
		
		if(p_boolOrMsg == true)
		{
			hideActivity(true);
			
			if(__dayView == null)
			{
				__dayView = DayView(createComponent(DayView, "__dayView"));
				__dayView.addEventListener(DayView.EVENT_BACK_TO_MONTH, Delegate.create(this, showMonthView));
				__dayView.addEventListener(DayView.EVENT_CREATE_NEW, Delegate.create(this, showCreateEvent));
				__dayView.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onDayEventClicked));
				__dayView.move(0, 40);
				__dayView.setSize(__width, __height - 40);
				var today:Date = new Date();
				__dayView.currentDate = today;
				
				var currentEvents:Collection = new Collection();
				var events:Array = ModelLocator.getInstance().entries_array;
				var i:Number = events.length;
				while(i--)
				{
					var entryVO:EntryVO = events[i];
					//DebugWindow.debug(entryVO.toVerboseString());
					var whenVO:WhenVO = entryVO.whenVO;
					var aMatch:Boolean = DateUtils.isEqualByDate(today,
																 whenVO.startTime);
					//if(aMatch == true) currentEvents.addItem(entryVO);
					currentEvents.addItem(entryVO);
				}
				//DebugWindow.debug("currentEvents: " + currentEvents);
				//DebugWindow.debug("currentEvents.getLength(): " + currentEvents.getLength());
				if(currentEvents.getLength() > 0) __dayView.events = currentEvents;
			}
		}
		else
		{
			showActivity(String(p_boolOrMsg));
		}
	}
	
	private function showDayView(p_date:Date):Void
	{
		if(__dayView == null)
		{
			__dayView = DayView(createComponent(DayView, "__dayView"));
			__dayView.addEventListener(DayView.EVENT_BACK_TO_MONTH, Delegate.create(this, showMonthView));
			__dayView.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onDayEventClicked));
			__dayView.move(0, 40);
			__dayView.setSize(__width, __height - 40);
			
			var currentEvents:Collection = new Collection();
			var events:Array = ModelLocator.getInstance().entries_array;
			var i:Number = events.length;
			while(i--)
			{
				var entryVO:EntryVO = events[i];
				//DebugWindow.debug(entryVO.toVerboseString());
				var whenVO:WhenVO = entryVO.whenVO;
				var aMatch:Boolean = DateUtils.isEqualByDate(p_date,
															 whenVO.startTime);
				//if(aMatch == true) currentEvents.addItem(entryVO);
				currentEvents.addItem(entryVO);
			}
			//DebugWindow.debug("currentEvents: " + currentEvents);
			//DebugWindow.debug("currentEvents.getLength(): " + currentEvents.getLength());
			if(currentEvents.getLength() > 0) __dayView.events = currentEvents;
		}
		
		__dayView.currentDate = p_date;
	}
	
	private function onDayEventClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::onDayEventClicked");
		showActivity("Getting Event Details...");
		
		destroyViews();
		
		// TODO: get the full entry, and show it in the EntryView
		var entryVO:EntryVO = EntryVO(p_event.item);
		//DebugWindow.debug("entryVO.id: " + entryVO.id);
		
		var event:GetEntryEvent = new GetEntryEvent(GetEntryEvent.GET_ENTRY,
																	  this,
																	  showEntryView);
		event.entryVO = entryVO;
		CommandRegistry.getInstance().dispatchEvent(event);
	}
	
	private function showEntryView():Void
	{
		hideActivity(true);
		
		destroyViews();
		
		if(__entryView == null)
		{
			__entryView = EntryView(createComponent(EntryView, "__entryView"));
			__entryView.move(0, 40);
			__entryView.setSize(__width, __height - 40);
			__entryView.addEventListener(EntryView.EVENT_BACK_TO_MONTH, Delegate.create(this, showMonthView));
		}
		
		__entryView.entry = ModelLocator.getInstance().currentEntry;
	}
	
	private function showMonthView():Void
	{
		destroyViews();
		
		if(__monthView == null)
		{
			__monthView = MonthView(createComponent(MonthView, "__monthView"));
			__monthView.addEventListener(MonthView.EVENT_DATE_SELECTED, Delegate.create(this, onDateClicked));
			__monthView.move(0, 40);
		}
	}
	
	private function showActivity(p_msg:String):Void
	{
		if(__activity_mc == null)
		{
			__activity_mc = attachMovie(SYMBOL_ACTIVITY, "__activity_mc", getNextHighestDepth());
			__activity_mc._x = __width - __activity_mc._width
			__activity_mc._y = 0;
		}
		
		if(p_msg != null)
		{
			if(__loggingIn_lbl == null)
			{
				attachMovie(Label.SYMBOL_NAME, "__loggingIn_lbl", getNextHighestDepth());
				__loggingIn_lbl.textSize = 16;
				__loggingIn_lbl.color = 0x339933;
				__loggingIn_lbl.setSize(176, 26);
				__loggingIn_lbl.move(0, (__height / 2) - (__loggingIn_lbl._height / 2));
			}
			
			__loggingIn_lbl.text = p_msg;
		}
	}
	
	private function hideActivity(p_removeMsg:Boolean):Void
	{
		if(__activity_mc != null)
		{
			__activity_mc.removeMovieClip();
			delete __activity_mc;
		}
		
		if(p_removeMsg == true)
		{
			if(__loggingIn_lbl != null)
			{
				__loggingIn_lbl.removeMovieClip();
				delete __loggingIn_lbl;
			}
		}
	}
	
	private function onDateClicked(p_event:Event):Void
	{
		// first, set the current date to what was selected on the calendar
		var event:SetCurrentDateEvent = new SetCurrentDateEvent(SetCurrentDateEvent.SET_CURRENT_DATE,
																this,
																onSetCurrentDate);
		event.currentDate = __monthView.selectedDate;
		
		destroyViews();
		
		CommandRegistry.getInstance().dispatchEvent(event);
	}
	
	private function onSetCurrentDate(p_callback:SetCurrentDateCallback):Void
	{
		if(p_callback.success == true)
		{
			// second, get the entries for the current day
			showActivity("Getting Entries...");
			
			var event:GetCalendarEventsEvent = new GetCalendarEventsEvent(GetCalendarEventsEvent.GET_EVENTS,
																		  this,
																		  onGotEventsForDateSelected);
			event.calendarName 		= ModelLocator.getInstance().selectedCalendar;
			var theDate:Date 		= ModelLocator.getInstance().currentDate;
			event.startDate 		= theDate;
			event.endDate 			= theDate;
			CommandRegistry.getInstance().dispatchEvent(event);
		}
	}
	
	// TODO: need callback for result vs. boolean & status
	private function onGotEventsForDateSelected(p_boolOrMsg):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::onGotEventsForDateSelected");
		//DebugWindow.debug("p_event: " + p_boolOrMsg);
		if(p_boolOrMsg == true)
		{
			// third, show the date selected entries in in the DayView
			hideActivity(true);
			showDayView(ModelLocator.getInstance().currentDate);
		}
		else
		{
			showActivity(String(p_boolOrMsg));
		}
	}
	
	private function showCreateEvent():Void
	{
		destroyViews();
		
		if(__createEvent == null)
		{
			__createEvent = CreateEvent(createComponent(CreateEvent, "__createEvent"));
			__createEvent.move(0, 0);
		}
	}
	
	private function destroyViews():Void
	{
		if(__login_mc != null) __login_mc.removeMovieClip(); delete __login_mc;
		if(__calendarList != null) __calendarList.removeMovieClip(); delete __calendarList;
		if(__dayView != null) __dayView.removeMovieClip(); delete __dayView;
		if(__monthView != null) __monthView.removeMovieClip(); delete __monthView;
		if(__entryView != null) __entryView.removeMovieClip(); delete __entryView;
		if(__createEvent != null) __createEvent.removeMovieClip(); delete __createEvent;
	}
	
	
}