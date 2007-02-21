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

class com.jxl.goocal.events.CheckForUpdatesEvent extends ArpEvent
{
	public static var CHECK_FOR_UPDATES:String = "checkForUpdates";
	
	public function CheckForUpdatesEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}