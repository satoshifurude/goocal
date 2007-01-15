import org.osflash.arp.controller.ArpEvent;

class com.jxl.goocal.events.GetCalendarsEvent extends ArpEvent
{
	public static var GET_CALENDARS:String = "getCalendars";
	
	public function GetCalendarsEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}