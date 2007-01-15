
import mx.utils.Delegate;

import com.jxl.shuriken.core.ICollection;
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

import com.jxl.goocal.controller.CommandRegistry;
import com.jxl.goocal.events.LoginEvent;
import com.jxl.goocal.callbacks.LoginCallback;

import com.jxl.goocal.events.GetCalendarsEvent;
import com.jxl.goocal.events.SelectCalendarEvent;
import com.jxl.goocal.events.GetCalendarEventsEvent;

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
			__login_mc.move(0, 40);
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
		__login_mc.removeMovieClip();
		delete __login_mc;
		
		if(__loggingIn_lbl == null)
		{
			attachMovie(Label.SYMBOL_NAME, "__loggingIn_lbl", getNextHighestDepth());
			__loggingIn_lbl.text = "Logging In...";
			__loggingIn_lbl.textSize = 16;
			__loggingIn_lbl.color = 0x339933;
			__loggingIn_lbl.setSize(176, 26);
			__loggingIn_lbl.move(0, (__height / 2) - (__loggingIn_lbl._height / 2));
		}
		
		showActivity();
		
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
			__loggingIn_lbl.text = "Getting Calendars...";
			
			var event:GetCalendarsEvent = new GetCalendarsEvent(GetCalendarsEvent.GET_CALENDARS, 
																this, 
																onGetCalendars);
			CommandRegistry.getInstance().dispatchEvent(event);
			
		}
		else
		{
			__loggingIn_lbl.text = "Login Failed...";
			__loggingIn_lbl.color = 0xCC0000;
			
			hideActivity();
		}
	}
	
	private function onGetCalendars(p_result:Object):Void
	{
		if(p_result == true)
		{
			__loggingIn_lbl.removeMovieClip();
			delete __loggingIn_lbl;
			
			hideActivity();
			
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
		// TODO: refactor into global "loading" component
		if(__loggingIn_lbl == null)
		{
			attachMovie(Label.SYMBOL_NAME, "__loggingIn_lbl", getNextHighestDepth());
			__loggingIn_lbl.text = "Logging In...";
			__loggingIn_lbl.textSize = 16;
			__loggingIn_lbl.color = 0x339933;
			__loggingIn_lbl.setSize(176, 26);
			__loggingIn_lbl.move(0, (__height / 2) - (__loggingIn_lbl._height / 2));
		}
		
		__loggingIn_lbl.text = "Getting Calendar Events...";
		
		showActivity();
		
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
		//DebugWindow.debug("GoogleCalendar::showTodayView, p_bool: " + p_bool);
		
		if(p_boolOrMsg == true)
		{
			__loggingIn_lbl.removeMovieClip();
			delete __loggingIn_lbl;
			
			hideActivity();
			
			if(__dayView == null)
			{
				__dayView = DayView(createComponent(DayView, "__dayView"));
				__dayView.addEventListener(DayView.EVENT_BACK_TO_MONTH, Delegate.create(this, showMonthView));
				__dayView.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onDayEventClicked));
				__dayView.move(0, 40);
				__dayView.setSize(__width, __height - 40);
				var today:Date = new Date();
				__dayView.currentDate = today;
				
				var currentEvents:ICollection = new Collection();
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
				
				if(currentEvents.getLength() > 0) __dayView.events = currentEvents;
			}
		}
		else
		{
			__loggingIn_lbl.text = String(p_boolOrMsg);
		}
	}
	
	private function onDayEventClicked(p_event:ShurikenEvent):Void
	{
		var entryVO:EntryVO = EntryVO(p_event.item);
		
	}
	
	private function showMonthView():Void
	{
		if(__loggingIn_lbl != null)
		{
		   __loggingIn_lbl.removeMovieClip();
			delete __loggingIn_lbl;
		}
		
		if(__dayView != null)
		{
			__dayView.removeMovieClip();
			delete __dayView;
		}
		
		if(__monthView == null)
		{
			__monthView = MonthView(createComponent(MonthView, "__monthView"));
			__monthView.move(0, 40);
		}
	}
	
	private function showActivity():Void
	{
		if(__activity_mc == null)
		{
			__activity_mc = attachMovie(SYMBOL_ACTIVITY, "__activity_mc", getNextHighestDepth());
			__activity_mc._x = __width - __activity_mc._width
			__activity_mc._y = 0;
		}
	}
	
	private function hideActivity():Void
	{
		if(__activity_mc != null)
		{
			__activity_mc.removeMovieClip();
			delete __activity_mc;
		}
	}
	
	
}