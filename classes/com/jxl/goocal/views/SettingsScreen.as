import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.controls.LinkButton;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.SettingsScreen extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.SettingsScreen";
	
	public static var EVENT_VIEW_ANOTHER_CALENDAR:String 		= "viewAnotherCalendar";
	public static var EVENT_DELETE_LOGIN:String 				= "deleteLogin";
	public static var EVENT_CHECK_UPDATES:String 				= "checkUpdates";
	public static var EVENT_MONTH_VIEW:String 					= "monthView";
	
	private static var STATE_SETTINGS:Number 					= 0;
	private static var STATE_CONFIRM_DELETE:Number 				= 1;
	
	private var __viewCalCallback:Callback;
	private var __updateCallback:Callback;
	private var __deleteCallback:Callback;
	private var __monthCallback:Callback;
	
	private var __state:Number = 0;
	private var __cal:String;
	private var __ver:String;
	private var __up:Date;
	
	private var __title_txt:TextField;
	
	private var __cal_lb:LinkButton;
	private var __cal_txt:TextField;
	
	private var __del_lb:LinkButton;
	//private var __del_txt:TextField;
	
	private var __update_lb:LinkButton;
	private var __update_txt:TextField;
	private var __update2_txt:TextField;
	
	private var __back_txt:TextField;
	private var __back2_txt:TextField;
	private var __back_lb:LinkButton;
	
	private var __sure_txt:TextField;
	private var __delete_pb:Button;
	private var __cancel_lb:LinkButton;
	
	public function SettingsScreen()
	{
	}
	
	public function showSettingValues(calendar:String, version:String, lastUpdate:Date):Void
	{
		__cal = calendar;
		__ver = version;
		__up = lastUpdate;
		
		__cal_txt.text = "(currently viewing \n\"" + calendar + "\")";
		
		var str:String = "<font size='10' face='Verdana'>";
		str += "<b>Calendar Version " + version + "</b>\n";
		str += "Last checked for updates\n";
		if(lastUpdate != null)
		{
			str += DateUtils.format(lastUpdate, DateUtils.FORMAT_MONTH_DAY_FULLYEAR);
		}
		else
		{
			str += "Never.";
		}
		str += "</font>";
		__update2_txt.htmlText = str;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__state == STATE_SETTINGS)
		{
			// delete
			if(__sure_txt != null)
			{
				__sure_txt.removeTextField();
				delete __sure_txt;
			}
			
			if(__delete_pb != null)
			{
				__delete_pb.removeMovieClip();
				delete __delete_pb;
			}
			
			if(__cancel_lb != null)
			{
				__cancel_lb.removeMovieClip();
				delete __cancel_lb;
			}
			
			callLater(this, createTitle);
			
		}
		else if(__state == STATE_CONFIRM_DELETE)
		{
			// delete
			if(__title_txt != null)
			{
				__title_txt.removeTextField();
				delete __title_txt;
			}
			
			if(__cal_lb != null)
			{
				__cal_lb.removeMovieClip();
				delete __cal_lb;
			}
			
			if(__cal_txt != null)
			{
				__cal_txt.removeTextField();
				delete __cal_txt
			}
			
			if(__del_lb != null)
			{
				__del_lb.removeMovieClip();
				delete __del_lb
			}
			
			if(__update_lb != null)
			{
				__update_lb.removeMovieClip();
				delete __update_lb;
			}
			
			if(__update_txt != null)
			{
				__update_txt.removeTextField();
				delete __update_txt;
			}
			
			if(__update2_txt != null)
			{
				__update2_txt.removeTextField();
				delete __update2_txt;
			}
			
			if(__back_txt != null)
			{
				__back_txt.removeTextField();
				delete __back_txt;
			}
			
			if(__back2_txt != null)
			{
				__back2_txt.removeTextField();
				delete __back2_txt;
			}
			
			if(__back_lb != null)
			{
				__back_lb.removeMovieClip();
				delete __back_lb;
			}
			
			// Create
			if(__sure_txt == null)
			{
				__sure_txt = createLabel("__sure_txt");
				var tf:TextFormat = __sure_txt.getTextFormat();
				tf.align = TextField.ALIGN_CENTER;
				tf.bold = true;
				tf.size = 12;
				tf.font = "Verdana";
				tf.color = 0x333333;
				__sure_txt.setNewTextFormat(tf);
				__sure_txt.setTextFormat(tf);
				__sure_txt.wordWrap = true;
				__sure_txt.multiline = true;
				__sure_txt.text = "Are you sure you wish to delete your login information from this device?";
			}
			
			if(__delete_pb == null)
			{
				__delete_pb = Button(createComponent(Button, "__delete_pb"));
				__delete_pb.setReleaseCallback(this, onDelete);
				__delete_pb.label = "Delete";
			}
			
			if(__cancel_lb == null)
			{
				__cancel_lb = LinkButton(createComponent(LinkButton, "__cancel_lb"));
				__cancel_lb.setReleaseCallback(this, onCancel);
				__cancel_lb.setColor(0x0066CC);
				__cancel_lb.label = "Cancel";
			}
		}
	}
	
	private function createTitle():Void
	{
		if(__title_txt == null)
		{
			__title_txt = createLabel("__title_txt");
			var titleFMT:TextFormat = __title_txt.getTextFormat();
			titleFMT.font ="Courier New";
			titleFMT.size = 16;
			titleFMT.color = 0x333333;
			titleFMT.bold = true;
			__title_txt.setTextFormat(titleFMT);
			__title_txt.setNewTextFormat(titleFMT);
			__title_txt.text = "Settings";
		}
		
		if(__del_lb == null)
		{
			__del_lb = LinkButton(createComponent(LinkButton, "__del_lb"));
			__del_lb.setReleaseCallback(this, onDeleteLogin);
			__del_lb.textField.autoSize = "left";
			var delTF:TextFormat = __del_lb.textField.getTextFormat();
			delTF.bold = true;
			delTF.color = 0x0066CC;
			__del_lb.textField.setTextFormat(delTF);
			__del_lb.textField.setNewTextFormat(delTF);
			__del_lb.label = "Delete login info";
		}
		
		callLater(this, createCal);
	}
	
	private function createCal():Void
	{
		if(__cal_lb == null)
		{
			__cal_lb = LinkButton(createComponent(LinkButton, "__cal_lb"));
			__cal_lb.setReleaseCallback(this, onViewCalendar);
			var calTF:TextFormat = __cal_lb.textField.getTextFormat();
			calTF.bold = true;
			calTF.color = 0x0066CC;
			__cal_lb.textField.setTextFormat(calTF);
			__cal_lb.textField.setNewTextFormat(calTF);
			__cal_lb.label = "View another calendar";
		}
		
		if(__cal_txt == null)
		{
			__cal_txt = createLabel("__cal_txt");
			// create
			var boldTF:TextFormat = new TextFormat();
			boldTF.bold = true;
			boldTF.font = "Verdana";
			boldTF.size = 10;
			boldTF.color = 0x333333;
			__cal_txt.setTextFormat(boldTF);
			__cal_txt.setNewTextFormat(boldTF);
			__cal_txt.multiline = true;
			__cal_txt.wordWrap = false;
		}
		
		callLater(this, createUpdate);
	}
	
	private function createUpdate():Void
	{
		if(__update_lb == null)
		{
			__update_lb = LinkButton(createComponent(LinkButton, "__update_lb"));
			__update_lb.setReleaseCallback(this, onCheckUpdates);
			var updateTF:TextFormat = __update_lb.textField.getTextFormat();
			updateTF.bold = true;
			updateTF.color = 0x0066CC;
			__update_lb.textField.setTextFormat(updateTF);
			__update_lb.textField.setNewTextFormat(updateTF);
			__update_lb.label = "Check for updates";
		}
		
		if(__update_txt == null)
		{
			__update_txt = createLabel("__update_txt");
			// create
			var boldTF:TextFormat = new TextFormat();
			boldTF.bold = true;
			boldTF.font = "Verdana";
			boldTF.size = 10;
			boldTF.color = 0x333333;
			__update_txt.setTextFormat(boldTF);
			__update_txt.setNewTextFormat(boldTF);
			__update_txt.multiline = true;
			__update_txt.wordWrap = false;
		}
		
		if(__update2_txt == null)
		{
			__update2_txt = createLabel("__update2_txt");
			__update2_txt.html = true;
		}
		
		callLater(this, createBack);
	}
	
	private function createBack():Void
	{
		var backFMT:TextFormat = new TextFormat();
		backFMT.font ="Verdana";
		backFMT.size = 12;
		backFMT.color = 0x333333;
		
		if(__back_txt == null)
		{
			__back_txt = createLabel("__back_txt");
			__back_txt.autoSize = "left";
			__back_txt.setTextFormat(backFMT);
			__back_txt.setNewTextFormat(backFMT);
			__back_txt.text = "or back to";
		}
		
		if(__back2_txt == null)
		{
			__back2_txt = createLabel("__back2_txt");
			__back2_txt.setTextFormat(backFMT);
			__back2_txt.setNewTextFormat(backFMT);
			__back2_txt.text = "view...";
		}
		
		if(__back_lb == null)
		{
			__back_lb = LinkButton(createComponent(LinkButton, "__back_lb"));
			__back_lb.setReleaseCallback(this, onBackToMonthView);
			var backCalFMT:TextFormat = __back_lb.textField.getTextFormat();
			backCalFMT.font ="Verdana";
			backCalFMT.size = 12;
			backCalFMT.bold = true;
			backCalFMT.color = 0x0066CC;
			__back_lb.label = "Calendar";
			__back_lb.textField.setTextFormat(backCalFMT);
			__back_lb.textField.setNewTextFormat(backCalFMT);
		}
		
		showSettingValues(__cal, __ver, __up);
		invalidate();
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var textH:Number = 18;
		var margin:Number = 8;
		
		if(__state == STATE_SETTINGS)
		{
			__title_txt.setSize(__width, 20);
			
			__cal_lb.move(__title_txt._x, __title_txt._y + __title_txt._height);
			__cal_lb.setSize(133, textH);
			
			__cal_txt.move(__cal_lb.x, __cal_lb.y + __cal_lb.height);
			__cal_txt.setSize(__width, textH * 2);
			
			__del_lb.move(__cal_txt._x, __cal_txt._y + __cal_txt._height);
			__del_lb.setSize(92, textH);
			/*
			__del_txt.move(__del_lb.x + __del_lb.width, __del_lb.y + 1);
			__del_txt.setSize(__width - __del_txt._x, textH);
			*/
			__update_lb.move(__del_lb.x, __del_lb.y + __del_lb.height + margin);
			__update_lb.setSize(107, textH);
			
			__update_txt.move(__update_lb.x + __update_lb.width + 4, __update_lb.y);
			__update_txt.setSize(__width - __update_txt._x, textH);
			
			__update2_txt.move(__update_lb.x, __update_lb.y + __update_lb.height);
			__update2_txt.setSize(__width, 64);
			
			__back_txt.move(__update2_txt._x, __update2_txt._y + __update2_txt._height);
			__back_txt.setSize(52, textH);
			
			__back_lb.move(__back_txt._x + __back_txt._width, __back_txt._y -1);
			__back_lb.setSize(62, textH);
			
			__back2_txt.move(__back_lb.x + __back_lb.width, __back_lb.y);
			__back2_txt.setSize(47, textH);
		}
		else if(__state == STATE_CONFIRM_DELETE)
		{
			__sure_txt.move(0, 0);
			__sure_txt.setSize(__width, textH * 4);
			
			__delete_pb.setSize(60, textH);
			__delete_pb.move(20, __sure_txt._y + __sure_txt._height);
			
			__cancel_lb.setSize(60, textH);
			__cancel_lb.move(__delete_pb.x + __delete_pb.width + margin, __delete_pb.y);
		}
	}
	
	private function onViewCalendar(event:ShurikenEvent):Void
	{
		__viewCalCallback.dispatch(new Event(EVENT_VIEW_ANOTHER_CALENDAR, this));
	}
	
	private function onDeleteLogin(event:ShurikenEvent):Void
	{
		__state = STATE_CONFIRM_DELETE;
		callLater(this, createChildren);
		invalidate();
	}
	
	private function onCheckUpdates(event:ShurikenEvent):Void
	{
		__updateCallback.dispatch(new Event(EVENT_CHECK_UPDATES, this));
	}
	
	private function onDelete(event:ShurikenEvent):Void
	{
		onCancel();
		__deleteCallback.dispatch(new Event(EVENT_DELETE_LOGIN, this));
	}
	
	private function onCancel(event:ShurikenEvent):Void
	{
		__state = STATE_SETTINGS;
		callLater(this, createChildren);
		invalidate();
	}
	
	private function onBackToMonthView(event:ShurikenEvent):Void
	{
		__monthCallback.dispatch(new Event(EVENT_MONTH_VIEW, this));
	}
	
	
	public function setViewCalendarCallback(scope:Object, func:Function):Void
	{
		__viewCalCallback = new Callback(scope, func);
	}
	
	public function setDeleteLoginCallback(scope:Object, func:Function):Void
	{
		__deleteCallback = new Callback(scope, func);
	}
	
	public function setCheckUpdatesCallback(scope:Object, func:Function):Void
	{
		__updateCallback = new Callback(scope, func);
	}
	
	public function setBackToMonthViewCallback(scope:Object, func:Function):Void
	{
		__monthCallback = new Callback(scope, func);
	}
	
	
	
	
	
	
}
	