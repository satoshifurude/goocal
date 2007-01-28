import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.shuriken.controls.Label extends UITextField
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.Label";
	
	public var className:String = "Label";
	
	public function Label()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		multiline 		= false;
		wordWrap 		= false;
		focusEnabled	= false;
		tabEnabled		= false;
		tabChildren		= false;
	}
	
}