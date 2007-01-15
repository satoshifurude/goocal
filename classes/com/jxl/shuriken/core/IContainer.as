import com.jxl.shuriken.core.IUIComponent;

interface com.jxl.shuriken.core.IContainer extends IUIComponent
{
	public function getNumChildren():Number
	
	public function createChild(p_class:Function, 
								p_name:String, 
								p_initObj:Object):IUIComponent
	
	public function createChildAt(p_index:Number, 
								  p_class:Function, 
								  p_name:String, 
								  p_initObj:Object):IUIComponent
	
	public function getChildAt(p_index:Number):IUIComponent
	
	public function getChildIndex(p_child:IUIComponent):Number
	
	public function setChildIndex(p_child:IUIComponent, p_index:Number):Boolean
	
	public function removeChildAt(p_index:Number):Void
	
	public function removeChild(p_child:IUIComponent):Void
	
	public function removeAllChildren():Void
	
}