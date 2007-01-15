import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.calendarclasses.CalendarBase;

import com.jxl.goocal.views.GCLinkButton;

class com.jxl.goocal.views.MonthView extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.MonthView";
	
	private var __cal:CalendarBase;
	private var __createNew_link:GCLinkButton;
	private var __viewWeek_link:GCLinkButton;
	private var __or_txt:TextField;
	private var __changeSettings_link:GCLinkButton;
	
	public function MonthView()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__cal == null)
		{
			__cal = CalendarBase(createComponent(CalendarBase, "__cal"));
		}
		
		if(__createNew_link == null)
		{
			__createNew_link = GCLinkButton(createComponent(GCLinkButton, "__createNew_link"));
			__createNew_link.label = "Create New Event...";
		}
		
		if(__viewWeek_link == null)
		{
			__viewWeek_link = GCLinkButton(createComponent(GCLinkButton, "__viewWeek_link"));
			__viewWeek_link.label = "View Week";
		}
		
		if(__or_txt == null)
		{
			createTextField("__or_txt", getNextHighestDepth(), 0, 0, 22, 18);
			__or_txt.multiline = false;
			__or_txt.wordWrap = false;
			__or_txt.text = "or";
		}
		
		if(__changeSettings_link == null)
		{
			__changeSettings_link = GCLinkButton(createComponent(GCLinkButton, "__changeSettings_link"));
			__changeSettings_link.label = "Change Settings";
		}
	}
	
	private function size():Void
	{
		super.size();
		
		__cal.move(0, 0);
		__createNew_link.move(4, __cal.y + __cal.height + 2);
		__viewWeek_link.move(__createNew_link.x, __createNew_link.y + __createNew_link.height + 2);
		__or_txt._x = __viewWeek_link.x + __viewWeek_link.width;
		__or_txt._y = __viewWeek_link.y;
		__changeSettings_link.move(__or_txt._x + __or_txt._width, __or_txt._y);
	}

}