import com.jxl.shuriken.events.Event;

interface com.jxl.shuriken.events.IEventDispatcher
{
	public function addEventListener(p_type:String, p_listener:Object):Void
	public function dispatchEvent(p_event:Event):Void
	public function removeEventListener(p_type:String, p_listener:Object):Void
	
}