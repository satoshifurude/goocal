
import mx.utils.Delegate;

import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.controls.LinkButton;

import com.jxl.goocal.views.LoginForm;
import com.jxl.goocal.views.CalendarList;
import com.jxl.goocal.views.DayView;
import com.jxl.goocal.views.MonthView;
import com.jxl.goocal.views.EntryView;
import com.jxl.goocal.views.CreateEvent;
import com.jxl.goocal.views.SettingsScreen;



import com.jxl.goocal.controller.CommandRegistry;
import com.jxl.goocal.events.LoginEvent;

import com.jxl.goocal.callbacks.LoginCallback;

import com.jxl.goocal.events.GetCalendarsEvent;
import com.jxl.goocal.events.SelectCalendarEvent;
import com.jxl.goocal.events.GetCalendarEventsEvent;
import com.jxl.goocal.events.GetEntryEvent;

import com.jxl.goocal.callbacks.SetCurrentDateCallback;
import com.jxl.goocal.events.SetCurrentDateEvent;

import com.jxl.goocal.events.CreateEventEvent;

import com.jxl.goocal.events.CheckForUpdatesEvent;
import com.jxl.goocal.callbacks.CheckForUpdatesCallback;

import com.jxl.goocal.model.ModelLocator;

import com.jxl.goocal.vo.CalendarVO;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;

		
class GoogleCalendar extends UIComponent
{
	public static var loop_mc:MovieClip;
	
	private static var VIEW_DAY:Number 			= 0;
	private static var VIEW_MONTH:Number 		= 1;
	
	//private var __debug:DebugWindow;
	
	private var __loop_mc:MovieClip;
	
	private static var SYMBOL_ACTIVITY:String = "BlueLoadingAnimation";
	
	private var __activity_mc:MovieClip;
	private var __login_mc:LoginForm;
	private var __loggingIn_lbl:TextField;
	private var __calendarList:CalendarList;
	private var __dayView:DayView;
	private var __monthView:MonthView;
	private var __entryView:EntryView;
	private var __createEvent:CreateEvent;
	private var __settingsView:SettingsScreen;
	private var __update_txt:TextField;
	private var __or_txt:TextField;
	private var __settings_lb:LinkButton;
	
	private var __eventDate:Date;
	private var __soList:Object;
	private var __upList:Object;
	private var __lastView:Number;
	
	public var username:String;
	public var password:String;
	public var updateSOName:String = "GooCalUpdate";
	
	public function GoogleCalendar()
	{
		super();
		
		__width = 176;
		__height = 208;
		
		_global.phpURL = "http://www.jessewarden.com/goocal/php/com/jxl/goocal/controller/FrontController.php";
		
		var lv:LoadVars = new LoadVars();
		lv.owner = this;
		lv.onLoad = function(success)
		{
			if(success == true)
			{
				if(this.owner.__login_mc != null)
				{
					this.owner.__login_mc.username = lv.username;
					this.owner.__login_mc.password = lv.password;
				}
				else
				{
					this.owner.username = lv.username;
					this.owner.password = lv.password;
				}
			}
		};
		lv.load("config.txt");
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
			__login_mc.setSubmitCallback(this, onLogin);
			if(username != null)
			{
				__login_mc.username = username;
				__login_mc.password = password;
				delete username;
				delete password;
			}
			__login_mc.move(8, 56);
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
		if(p_callback.isLoggedIn == LoginCallback.LOGGED_IN_SUCCESS)
		{
			getCalendars();
		}
		else if(p_callback.isLoggedIn == LoginCallback.LOGGED_IN_FAILED_ATTEMPT)
		{
			showActivity(p_callback.progress);
			__loggingIn_lbl.color = 0xCC0000;
		}
		else if(p_callback.isLoggedIn == LoginCallback.LOGGED_IN_FAILED)
		{
			showActivity("Login Failed.");
			__loggingIn_lbl.color = 0xCC0000;
			
			hideActivity();
		}
	}
	
	private function getCalendars():Void
	{
		if(_currentframe == 1)
		{
			gotoAndPlay("main");
		}
		else
		{
			gotoAndStop("logo");
		}
		destroyViews();
		showActivity("Getting Calendars...");
		var event:GetCalendarsEvent = new GetCalendarsEvent(GetCalendarsEvent.GET_CALENDARS, 
															this, 
															onGetCalendars);
		CommandRegistry.getInstance().dispatchEvent(event);
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
				__calendarList.setItemClickCallback(this, onCalendarSelected);
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
																	  showDayView);
		event.calendarName = ModelLocator.getInstance().selectedCalendar;
		var today:Date = new Date();
		event.startDate = today;
		event.endDate = today;
		CommandRegistry.getInstance().dispatchEvent(event);
	}
	
	private function showDayView(p_boolOrMsg):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::showDayView, p_boolOrMsg: " + p_boolOrMsg);
		
		if(p_boolOrMsg == true || p_boolOrMsg instanceof Date)
		{
			hideActivity(true);
			
			if(__dayView == null)
			{
				__dayView = DayView(createComponent(DayView, "__dayView"));
				__dayView.setMonthViewCallback(this, showMonthView);
				__dayView.setCreateNewCallback(this, showCreateEvent);
				__dayView.setItemClickCallback(this, onDayEventClicked);
				__dayView.move(0, 40);
				__dayView.setSize(__width, __height - 40);
				__lastView = VIEW_DAY;
				var today:Date = new Date();
				
				var currentEvents:Collection = new Collection();
				var events:Array = ModelLocator.getInstance().entries_array;
				var i:Number = events.length;
				trace("--------------");
				trace("GoogleCalendar::showDayView");
				trace("len: " + i);
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
			
			if(p_boolOrMsg instanceof Date)
			{
				__dayView.currentDate = p_boolOrMsg;
			}
			else
			{
				__dayView.currentDate = today;
			}
		}
		else
		{
			showActivity(String(p_boolOrMsg));
		}
	}
	
	private function onDayEventClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GoogleCalendar::onDayEventClicked");
		//DebugWindow.debug("p_event.item: " + p_event.item);
		//DebugWindow.debugProps(p_event.item);
		
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
			__entryView.setMonthCallback(this, showMonthView);
		}
		
		__entryView.entry = ModelLocator.getInstance().currentEntry;
	}
	
	private function showMonthView():Void
	{
		destroyViews();
		gotoAndStop("hide");
		
		if(__monthView == null)
		{
			__monthView = MonthView(createComponent(MonthView, "__monthView"));
			__monthView.setDateSelectedCallback(this, onDateClicked);
			__monthView.setSettingsCallback(this, showSettings);
			__monthView.setCreateNewCallback(this, showCreateEvent);
			__lastView = VIEW_MONTH;
		}
		else
		{
			__monthView.onNonIdle();
		}
	}
	
	private function onDateClicked(p_event:Event):Void
	{
		trace("----------------");
		trace("GoogleCalendar::onDateClicked");
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
		//trace("-----------------");
		//trace("GoogleCalendar::onGotEventsForDateSelected");
		//trace("p_boolOrMsg: " + p_boolOrMsg);
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
		
		gotoAndStop("hide");
		
		if(__createEvent == null)
		{
			__createEvent = CreateEvent(createComponent(CreateEvent, "__createEvent"));
			__createEvent.move(0, 0);
			__createEvent.setCancelCallback(this, onCancelCreateEvent);
			__createEvent.setSaveCallback(this, onSaveCreateEvent);
			
			var fromDate:Date;
			if(ModelLocator.getInstance().currentDate == null)
			{
				fromDate = new Date();
			}
			else
			{
				fromDate = ModelLocator.getInstance().currentDate;
			}
			
			var toDate:Date = DateUtils.clone(fromDate);
			toDate.setHours(toDate.getHours() + 1);
			
			// KLUDGE: 'Does not repeat' is a magic string
			__createEvent.setupEvent(fromDate,
									 toDate,
									 "",
									 "",
									 ModelLocator.getInstance().calendars,
									 ModelLocator.getInstance().selectedCalendar,
									 "",
									 "Does not repeat",
									 "");
		}
	}
	
	private function onCancelCreateEvent(event:Event):Void
	{
		//trace("-----------------");
		//trace("GoogleCalendar::onCancelCreateEvent");
		destroyViews();
		if(__lastView == null || __lastView == VIEW_DAY)
		{
			delete __lastView;
			// HACK: !!! Not following ARP, bad bad bad
			if(ModelLocator.getInstance().currentDate == null)
			{
				ModelLocator.getInstance().currentDate = new Date();
			}
			onGotEventsForDateSelected(true);
		}
		else if(__lastView == VIEW_MONTH)
		{
			delete __lastView;
			showMonthView();
		}
	}
	
	private function onSaveCreateEvent(event:Event):Void
	{
		var cee:CreateEventEvent = new CreateEventEvent(CreateEventEvent.CREATE_EVENT,
														  this,
														  onCreatedEvent);
		cee.startDate 		= __createEvent.fromDate;
		cee.endDate			= __createEvent.toDate;
		cee.title			= __createEvent.what;
		cee.description		= __createEvent.description;
		cee.where			= __createEvent.where;
		cee.calendar		= __createEvent.calendar;
		
		__eventDate = __createEvent.fromDate;
		
		destroyViews();
		showActivity("Creating Event...");
		
		CommandRegistry.getInstance().dispatchEvent(cee);
	}
	
	private function onCreatedEvent(success:Boolean):Void
	{
		if(success == true)
		{
			hideActivity();
			showDayView(__eventDate);
		}
		else
		{
			showActivity("Failed to create event.");
		}
		
		delete __eventDate;
	}
	
	private function showSettings():Void
	{
		destroyViews();
		
		if(__settingsView == null)
		{
			__settingsView = SettingsScreen(createComponent(SettingsScreen, "__settingsView"));
			__settingsView.setViewCalendarCallback(this, getCalendars);
			__settingsView.setDeleteLoginCallback(this, onDeleteLogin);
			__settingsView.setCheckUpdatesCallback(this, onCheckUpdates);
			__settingsView.setBackToMonthViewCallback(this, showMonthView);
			__settingsView.showSettingValues(ModelLocator.getInstance().selectedCalendar, 
										 ModelLocator.getInstance().currentVersion,
										 null);
		}
		
		if(System.capabilities.isDebugger == false)
		{
			if(__upList == null) __upList = Delegate.create(this, onReadUpdateSO);
			SharedObject.addEventListener(updateSOName, __upList);
			var so:SharedObject = SharedObject.getLocal(updateSOName);
		}
		else
		{
			var so:SharedObject = SharedObject.getLocal(updateSOName);
			onReadUpdateSO(so);
		}
	}
	
	private function onReadUpdateSO(so:SharedObject):Void
	{
		SharedObject.removeListener(updateSOName);
		delete __upList;
		__settingsView.showSettingValues(ModelLocator.getInstance().selectedCalendar, 
										 ModelLocator.getInstance().currentVersion,
										 __upList.data.update);
	}
	
	private function onDeleteLogin(event:Event):Void
	{
		if(System.capabilities.isDebugger == false)
		{
			if(__soList == null) __soList = Delegate.create(this, onLoginSOReady);
			SharedObject.addListener(LoginForm.prototype.soName, __soList);
			var so:SharedObject = SharedObject.getLocal(LoginForm.prototype.soName);
		}
		else
		{
			var so:SharedObject = SharedObject.getLocal(LoginForm.prototype.soName);
			onLoginSOReady(so);
		}
	}
	
	private function onLoginSOReady(so:SharedObject):Void
	{
		so.clear();
		SharedObject.removeListener(LoginForm.prototype.soName);
		delete __soList;
	}
	
	private function onCheckUpdates(event:Event):Void
	{
		destroyViews();
		showActivity("Checking for updates...");
		if(System.capabilities.isDebugger == false)
		{
			if(__upList == null) __upList = Delegate.create(this, onUpdateSO);
			SharedObject.addEventListener(updateSOName, __upList);
			var so:SharedObject = SharedObject.getLocal(updateSOName);
		}
		else
		{
			var so:SharedObject = SharedObject.getLocal(updateSOName);
			onUpdateSO(so);
		}
	}
	
	private function onUpdateSO(so:SharedObject):Void
	{
		so.data.update = new Date();
		SharedObject.removeListener(updateSOName);
		delete __upList;
		
		var ue:CheckForUpdatesEvent = new CheckForUpdatesEvent(CheckForUpdatesEvent.CHECK_FOR_UPDATES,
															   this,
															   onUpdatesChecked);
		CommandRegistry.getInstance().dispatchEvent(ue);
	}
	
	private function onUpdatesChecked(callback:CheckForUpdatesCallback):Void
	{
		hideActivity(true);
		if(__update_txt == null)
		{
			__update_txt = createLabel("__update_txt");
			__update_txt.multiline = true;
			__update_txt.wordWrap = true;
			__update_txt.setSize(__width, 60);
			__update_txt.move(0, (__height / 2) - 40);
		}
		
		var tf:TextFormat = __update_txt.getTextFormat();
		tf.align = TextField.ALIGN_CENTER;
		tf.bold = true;
		tf.font = "Verdana";
		tf.size = 12;
		tf.color = 0x333333;
		
		if(callback.failed == false)
		{
			if(callback.newerVersionAvailable == false)
			{
				__update_txt.setNewTextFormat(tf);
				__update_txt.setTextFormat(tf);
				__update_txt.text = "No update available.\nYou have the\nlatest version.";
			}
			else
			{
				var str:String = "";
				str += "<font align='center'><b>";
				str += "An update is available!\nPlease visit:\n\n";
				str += callback.updateURL;
				str += "</b></font>";
				__update_txt.html = true;
				__update_txt.htmlText = str;
			}
		}
		else
		{
			__update_txt.setNewTextFormat(tf);
			__update_txt.setTextFormat(tf);
			__update_txt.text = "The update server is not responding.\nPlease try again later.";
		}
			
		
		if(callback.failed == false)
		{
			if(callback.newerVersionAvailable == true)
			{
				if(__or_txt == null)
				{
					__or_txt = createLabel("__or_txt");
					__or_txt.text = "or";
					__or_txt._width = 20;
					__or_txt._height = 20;
					__or_txt._x = 20;
					__or_txt._y = __update_txt._y + __update_txt._height;
				}
			}
		}
		
		if(__settings_lb == null)
		{
			__settings_lb = LinkButton(createComponent(LinkButton, "__settings_lb"));
			__settings_lb.setReleaseCallback(this, showSettings);
			__settings_lb.textField.autoSize = "left";
			__settings_lb.textField.textColor = 0x0033CC;
			//__settings_lb.setSize(86, __settings_lb.height);
			if(callback.failed == false && callback.newerVersionAvailable == true)
			{
				__settings_lb.label = "back to settings";
				__settings_lb.move(__or_txt._x + __or_txt._width, __or_txt._y);
			}
			else
			{
				__settings_lb.label = "Return to settings";
				__settings_lb.move((__width / 2) - (__settings_lb.width / 2), __update_txt._y + __update_txt._height);
			}
		}
	}
	
	private function showActivity(p_msg:String):Void
	{
		if(__activity_mc == null)
		{
			__activity_mc = attachMovie(SYMBOL_ACTIVITY, "__activity_mc", getNextHighestDepth());
			__activity_mc._x = __width - __activity_mc._width;
			__activity_mc._y = 0;
		}
		
		if(p_msg != null)
		{
			if(__loggingIn_lbl == null)
			{
				__loggingIn_lbl = createLabel("__loggingIn_lbl");
				var fmt:TextFormat = __loggingIn_lbl.getTextFormat();
				fmt.align = TextField.ALIGN_CENTER;
				fmt.size = 16;
				fmt.color = 0x339933;
				fmt.font = "_sans";
				__loggingIn_lbl.autoSize = "center";
				__loggingIn_lbl.wordWrap = true;
				__loggingIn_lbl.multiline = true;
				__loggingIn_lbl.setTextFormat(fmt);
				__loggingIn_lbl.setNewTextFormat(fmt);
				__loggingIn_lbl._width = 176;
			}
			
			__loggingIn_lbl.text = p_msg;
			__loggingIn_lbl.move(0, (__height / 2) - (__loggingIn_lbl._height / 2));
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
				__loggingIn_lbl.removeTextField();
				delete __loggingIn_lbl;
			}
		}
	}
	
	private function destroyViews():Void
	{
		if(__login_mc != null)
		{
			__login_mc.removeMovieClip();
			delete __login_mc;
		}
		if(__calendarList != null)
		{
			__calendarList.removeMovieClip();
			delete __calendarList;
		}
		if(__dayView != null)
		{
			__dayView.removeMovieClip();
			delete __dayView;
		}
		if(__monthView != null)
		{
			//__monthView.removeMovieClip();
			//delete __monthView;
			__monthView.onIdle();
		}
		if(__entryView != null)
		{
			__entryView.removeMovieClip();
			delete __entryView;
		}
		if(__createEvent != null)
		{
			__createEvent.removeMovieClip();
			delete __createEvent;
		}
		
		if(__settingsView != null)
		{
			__settingsView.removeMovieClip();
			delete __settingsView;
		}
		
		if(__update_txt != null)
		{
			__update_txt.removeTextField();
			delete __update_txt;
		}
		
		if(__or_txt != null)
		{
			__or_txt.removeTextField();
			delete __or_txt;
		}
		
		if(__settings_lb != null)
		{
			__settings_lb.removeMovieClip();
			delete __settings_lb;
		}
	}
	
	
}