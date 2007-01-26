import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.core.IContainer;
import com.jxl.shuriken.core.IUIComponent;

interface com.jxl.shuriken.core.IList extends IContainer
{
	
	public function setDirection(p_direction:String):Void
	public function getDirection():String
	
	public function getHorizontalPageSize():Number
	public function getVerticalPageSize():Number
	
	public function getChildClass():Function
	public function setChildClass(p_class:Function):Void
	
	public function getChildSetValueFunction():Function
	public function setChildSetValueFunction(p_function:Function):Void
	
	public function getChildSetValueScope():Object
	public function setChildSetValueScope(p_val:Object):Void
	
	public function getColumnWidth():Number
	public function setColumnWidth(p_val:Number):Void
	
	public function getRowHeight():Number
	public function setRowHeight(p_val:Number):Void
	
	public function getAlign():String
	public function setAlign(p_val:String):Void
	
	public function getChildHorizontalMargin():Number
	public function setChildHorizontalMargin(p_val:Number):Void
	
	public function getChildVerticalMargin():Number
	public function setChildVerticalMargin(p_val:Number):Void
	
	public function getAutoSizeToChildren():Boolean
	public function setAutoSizeToChildren(p_val:Boolean):Void
	
	public function getDataProvider():ICollection
	public function setDataProvider(p_val:ICollection):Void
	
}