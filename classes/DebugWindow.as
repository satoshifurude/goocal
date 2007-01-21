class DebugWindow extends MovieClip
{
	
	private static var inst:DebugWindow;
	
	private var __text:TextField;
	
	public function DebugWindow()
	{
		inst = this;
	}
	
	public static function debug(o):Void
	{
		trace(o);
		inst.__text.text += o + "\n";
		inst.__text.scroll++;
	}
	
	public static function debugHeader():Void
	{
		debug("----------------");
	}
	
	public static function debugProps(o):Void
	{
		var s:String = "";
		for(var p:String in o)
		{
			s += p + ": " + o[p] + "\n";
		}
		debug(s);
	}
}