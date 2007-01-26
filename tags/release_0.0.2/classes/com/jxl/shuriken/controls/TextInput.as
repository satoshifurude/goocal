import com.jxl.shuriken.core.UITextField

class com.jxl.shuriken.controls.TextInput extends UITextField
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.TextInput";
	
	private var __multiline:Boolean 				= false;
	private var __wordWrap:Boolean 					= false;
	private var __selectable:Boolean				= true;
	private var __type:String 						= "input";
	private var __border:Boolean					= true;
	private var __borderColor:Number				= 0x000000;
	private var __background:Boolean 				= true;
	private var __backgroundColor:Number			= 0xFFFFFF;
	
	public function TextInput()
	{
	}
}