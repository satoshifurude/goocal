import com.jxl.shuriken.core.UIComponent;
import com.jxl.goocal.views.GCTimeHeading;
import com.jxl.goocal.views.GCLinkButton;

class com.jxl.goocal.views.EventItem extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.EventItem";
	
	private var __time_lbl:GCTimeHeading;
	private var __name_link:GCLinkButton;
	
	private var __eventTime:String 				= "";
	private var __eventTimeDirty:Boolean		= false;
	private var __eventName:String 				= "";
	private var __eventNameDirty:Boolean 		= false;
	
	public function get eventTime():String { return __eventTime; }
	public function set eventTime(p_val:String):Void
	{
		__eventTime = p_val;
		__eventTimeDirty = true;
		invalidateProperties();
	}
	
	public function get eventName():String { return __eventName; }
	public function set eventName(p_val:String):Void
	{
		__eventName = p_val;
		__eventNameDirty = true;
		invalidateProperties();
	}
	
	public function EventItem()
	{
	}
	
	private function createChildren():Void
	{
		if(__time_lbl == null)
		{
			__time_lbl = GCTimeHeading(createComponent(GCTimeHeading, "__time_lbl"));
		}
		
		if(__name_link == null)
		{
			__name_link = GCLinkButton(createComponent(GCLinkButton, "__name_link"));
			__name_link.textSize = 14;
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__eventTimeDirty == true)
		{
			__eventTimeDirty = false;
			__time_lbl.text = __eventTime;
		}
		
		if(__eventNameDirty == true)
		{
			__eventNameDirty = false;
			__name_link.label = __eventName;
		}
	}
	
	private function size():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("EventItem::size, __width: " + __width);
		super.size();
		
		__time_lbl.setSize(__width, 20);
		__name_link.move(0, __time_lbl.y + __time_lbl.height);
		__name_link.setSize(__width, 20);
	}
	
}