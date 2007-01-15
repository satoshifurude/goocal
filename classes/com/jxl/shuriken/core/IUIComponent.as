import com.jxl.shuriken.events.IEventDispatcher;

interface com.jxl.shuriken.core.IUIComponent extends IEventDispatcher
{
	
	public function getX():Number
	public function getY():Number
	
	public function getWidth():Number
	public function getHeight():Number
	
	public function getVisible():Boolean
	
	public function move(p_x:Number, p_y:Number):Void
	
	public function setSize(p_width:Number, p_height:Number):Void
	
	public function getEnabled():Boolean
	
	public function invalidate():Void
	public function invalidateProperties():Void
	public function invalidateDraw():Void
	public function invalidateSize():Void
	
	public function callLater(p_scope:Object, p_func:Function, p_args:Array):Void
	
	public function getFocus():Object
	public function setFocus():Void
	
	public function getData():Object
	public function setData(p_val:Object):Void
	
	public function getSymbolName():String
	
	public function createComponent(p_class:IUIComponent, p_name:String):MovieClip
}