import org.osflash.arp.controller.ArpEvent;

class com.jxl.goocal.events.LoginEvent extends ArpEvent
{
	public static var LOGIN:String = "login";
	
	public var username:String;
	public var password:String;
	
	public function LoginEvent(p_type:String, p_target:Object, p_callback:Function)
	{
		super(p_type, p_target, p_callback);
	}
}