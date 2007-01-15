 import com.jxl.shuriken.core.UIComponent;
 import com.jxl.shuriken.core.UITextField;
 
import mx.utils.Delegate;

class com.jxl.shuriken.controls.Panel extends UIComponent
{

	public static var symbolName:String = "com.jxl.shuriken.controls.Panel";
	public static var symbolOwner:Object = com.jxl.shuriken.controls.Panel;
	
	private var __sHeader:String	
	private var __mcHeader:UITextField
	
	
	public function init():Void{
		super.init();		
	}
	
	private function onInitialized():Void{
		super.onInitialized();
		
	}	

	private function createChildren():Void{
		super.createChildren();
	}
	
	private function commitProperties():Void{	
		__mcHeader.text = __sHeader;	
	}	
			
	private function size():Void{
		super.size();
	}
	
	public function setHeader(pHeader:String):Void{
		__sHeader = pHeader;
		invalidateProperties();
	}
	
}
