import org.osflash.arp.controller.ArpEvent;

class com.jxl.goocal.events.GetCalendarEventsEvent extends ArpEvent
{
	public static var GET_EVENTS:String = "getCalendarEvents";
	
	public var calendarName:String;
	public var startDate:Date;
	public var endDate:Date;
	
	public function GetCalendarEventsEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}