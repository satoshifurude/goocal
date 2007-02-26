import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.containers.ButtonList;
import com.jxl.shuriken.controls.LinkButton;
import com.jxl.shuriken.core.Collection;


class com.jxl.goocal.views.CalendarList extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.CalendarList";
	
	private var __title_lbl:TextField;
	private var __calendars_list:ButtonList;
	
	public function get calendarsCollection():Collection { return __calendars_list.dataProvider; }
	public function set calendarsCollection(p_val:Collection):Void
	{
		__calendars_list.dataProvider = p_val;
	}
	
	public function CalendarList()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__title_lbl == null)
		{
			__title_lbl = createLabel("__title_lbl");
			var titleFMT:TextFormat = __title_lbl.getTextFormat();
			titleFMT.font ="Courier New";
			titleFMT.size = 16;
			titleFMT.color = 0x333333;
			titleFMT.bold = true;
			__title_lbl.setTextFormat(titleFMT);
			__title_lbl.setNewTextFormat(titleFMT);
			__title_lbl.text = "Calendar List";
		}
		
		//DebugWindow.debug("__title_lbl: " + __title_lbl);
		
		if(__calendars_list == null)
		{
			__calendars_list = ButtonList(createComponent(ButtonList, "__calendars_list"));
			__calendars_list.childClass				= LinkButton;
			__calendars_list.childSetValueFunction 	= refreshCalendarItem;
			__calendars_list.childSetValueScope		= this;
			
			// NOTE: hi-jacking the setupChild function.  While I could use the event,
			// profiling shows that it is a major performance killer dispatching
			// that event each time; so I use the old-skool way for performance
			//__calendars_list.setupChild				= Delegate.create(this, onCalendarListChildSetup);
		}
		
		//DebugWindow.debug("__calendars_list: " + __calendars_list);
		
		//DebugWindow.debug("__createNew_link: " + __createNew_link);
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		__title_lbl.setSize(__width, __title_lbl._height);
		__calendars_list.move(0, __title_lbl._y + __title_lbl._height + 4);
	}
	
	private function refreshCalendarItem(p_child:UIComponent, p_index:Number, p_item:Object):Void
	{
		var lb:LinkButton = LinkButton(p_child);
		var tf:TextFormat = lb.textField.getTextFormat();
		tf.color = 0x0066CC;
		tf.size = 14;
		tf.bold = false;
		lb.textField.setNewTextFormat(tf);
		lb.label = p_item.toString();
	}
	
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		__calendars_list.setItemClickCallback(scope, func);
	}
	
}