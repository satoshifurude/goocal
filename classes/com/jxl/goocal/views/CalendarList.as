import mx.utils.Delegate;

import com.jxl.shuriken.core.IUIComponent;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.containers.ButtonList;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.core.ICollection;
import com.jxl.goocal.views.GCLinkButton;


class com.jxl.goocal.views.CalendarList extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.CalendarList";
	
	private var __title_lbl:Label;
	private var __calendars_list:ButtonList;
	private var __createNew_link:GCLinkButton;
	
	private var __calendars_collection:ICollection;
	private var __calendarsDirty:Boolean = false;
	
	public function get calendarsCollection():ICollection { return __calendars_collection; }
	public function set calendarsCollection(p_val:ICollection):Void
	{
		__calendars_collection = p_val;
		__calendarsDirty = true;
		invalidateProperties();
	}
	
	public function CalendarList()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__title_lbl == null)
		{
			__title_lbl = Label(createComponent(Label, "__title_lbl"));
			__title_lbl.text = "Calendar List";
			__title_lbl.font = "Courier New";
			__title_lbl.textSize = 16;
			__title_lbl.color = 0x333333;
			__title_lbl.bold = true;
		}
		
		//DebugWindow.debug("__title_lbl: " + __title_lbl);
		
		if(__calendars_list == null)
		{
			__calendars_list = ButtonList(createComponent(ButtonList, "__calendars_list"));
			__calendars_list.childClass				= GCLinkButton;
			__calendars_list.childSetValueFunction 	= refreshCalendarItem;
			__calendars_list.childSetValueScope		= this;
			__calendars_list.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onLinkButtonClicked));
			
			// NOTE: hi-jacking the setupChild function.  While I could use the event,
			// profiling shows that it is a major performance killer dispatching
			// that event each time; so I use the old-skool way for performance
			//__calendars_list.setupChild				= Delegate.create(this, onCalendarListChildSetup);
		}
		
		//DebugWindow.debug("__calendars_list: " + __calendars_list);
		
		if(__createNew_link == null)
		{
			__createNew_link = GCLinkButton(createComponent(GCLinkButton, "__createNew_link"));
			__createNew_link.label = "Create New...";
			__createNew_link.bold = true;
		}
		
		//DebugWindow.debug("__createNew_link: " + __createNew_link);
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__calendarsDirty == true)
		{
			__calendarsDirty = false;
			__calendars_list.dataProvider = __calendars_collection;
		}
	}
	
	private function size():Void
	{
		super.size();
		
		__title_lbl.setSize(width, __title_lbl.height);
		__calendars_list.move(0, __title_lbl.y + __title_lbl.height + 4);
		__createNew_link.move(0, __calendars_list.y + __calendars_list.height);
	}
	
	private function refreshCalendarItem(p_child:IUIComponent, p_index:Number, p_item:Object):Void
	{
		GCLinkButton(p_child).label = p_item.toString();
	}
	
	private function onLinkButtonClicked(p_event:ShurikenEvent):Void
	{
		//trace("-------------------");
		//trace("CalendarList::onLinkButtonClicked");
		// bubble it up
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.item = p_event.item;
		event.lastSelected = p_event.lastSelected;
		event.selected = p_event.selected;
		dispatchEvent(event);
	}
	
}