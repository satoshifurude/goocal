﻿class com.jxl.shuriken.events.Event
{
	
	public var type:String;
	public var target:Object;
	
	public function Event(p_type:String, p_target:Object)
	{
		type		= p_type;
		target		= p_target;
	}
	
	public function toString():String
	{
		return "[Event type='" + type + "' target=" + target + "]";	
	}
	
	// WARNING: gets a reference to target
	public function clone():Event
	{
		return new Event(type, target);	
	}
}