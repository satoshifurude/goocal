import com.jxl.shuriken.events.Event;

class com.jxl.shuriken.events.Callback
{
	public var scope:Object;
	public var callback:Function;
	
	public function Callback(p_scope:Object, p_callback:Function)
	{
		scope			= p_scope;
		callback		= p_callback;
	}
	
	public function dispatch(p_event:Event):Void
	{
		callback.call(scope, p_event);
	}
}