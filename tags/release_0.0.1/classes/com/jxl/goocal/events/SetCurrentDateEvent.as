
import org.osflash.arp.controller.ArpEvent;

class com.jxl.goocal.events.SetCurrentDateEvent extends ArpEvent
{
	public static var SET_CURRENT_DATE:String = "setCurrentDate";
	
	public var currentDate:Date;
	
	public function SetCurrentDateEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}