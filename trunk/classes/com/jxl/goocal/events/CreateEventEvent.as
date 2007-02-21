/*
	EventTemplate
	
	Template for a ARP Event class.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/
import org.osflash.arp.controller.ArpEvent;

class com.jxl.goocal.events.CreateEventEvent extends ArpEvent
{
	public static var CREATE_EVENT:String = "CreateEvent";
	
	public var startDate:Date;
	public var endDate:Date;
	public var title:String;
	public var description:String;
	public var where:String;
	public var calendar:String;
	
	public function CreateEventEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}