import org.osflash.arp.controller.ArpEvent;

class com.jxl.goocal.events.SelectCalendarEvent extends ArpEvent
{
	public static var SELECT:String = "selectCalendar";
	
	public var selectedCalendar:String;
	
	public function SelectCalendarEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}