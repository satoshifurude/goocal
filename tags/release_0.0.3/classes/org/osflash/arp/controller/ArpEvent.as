import com.jxl.shuriken.events.Event;

class org.osflash.arp.controller.ArpEvent extends Event
{
	
	public var callback:Function;
	
	public function ArpEvent(p_type:String, p_target:Object, p_resultFunction:Function)
	{
		super(p_type, p_target);
		
		callback = p_resultFunction;
	}
}