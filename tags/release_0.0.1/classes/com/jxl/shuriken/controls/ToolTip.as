import com.jxl.shuriken.core.UIComponent;

class com.jxl.shuriken.controls.ToolTip extends UIComponent
{
	public static var symbolName:String = "com.jxl.shuriken.controls.ToolTip";
	public static var symbolOwner:Object = com.jxl.shuriken.controls.ToolTip;
	
	public var className:String = "ToolTip";
	
	public function get text():String
	{
		return __text;
	}
	
	public function set text(pText:String):Void
	{
		__text = pText;
		__txtText.text = __text;
	}
	
	public function get backgroundColor():Number
	{
		return __backgroundColor;
	}
	
	public function set backgroundColor(pVal:Number):Void
	{
		__backgroundColor = pVal;
		draw();
	}
	
	public function get borderColor():Number
	{
		return __borderColor;
	}
	
	public function set borderColor(pVal:Number):Void
	{
		__borderColor = pVal;
		draw();
	}
	
	private var __backgroundColor:Number;
	private var __borderColor:Number;
	
	private var __mcBackground:MovieClip;
	private var __txtText:TextField;
	private var __text:String;
	
	public function ToolTip()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		tabEnabled = false;
		tabChildren = false;
		focusEnabled = false;
		
		__backgroundColor = 0xCCCCCC;
		__borderColor = 0x000000;
	}
	
	
	private function createChildren():Void
	{
		super.createChildren();
		
		createEmptyMovieClip("__mcBackground", getNextHighestDepth());
		
		createTextField("__txtText", getNextHighestDepth(), 0, 0, 100, 100);
		__txtText.multiline = true;
		__txtText.selectable = false;
		__txtText.wordWrap = true;
		__txtText.text = __text;
	}
	
	private function draw():Void
	{
		super.draw();
		
		__mcBackground.clear();
		__mcBackground.lineStyle(0, __borderColor); 
		__mcBackground.beginFill(__backgroundColor);
		__mcBackground.lineTo(width, 0);
		__mcBackground.lineTo(width, height);
		__mcBackground.lineTo(0, height);
		__mcBackground.lineTo(0, 0);
		__mcBackground.endFill();
		
		size();
	}
	
	private function size():Void
	{
		super.size();
		
		__mcBackground._width = width;
		__mcBackground._height = height;
		
		__txtText._width = width;
		__txtText._height = height;
	}
	
}