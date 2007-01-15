import com.jxl.shuriken.events.Event;

interface com.jxl.shuriken.core.ICollection
{
	public function addEventListener(p_type:String, p_list:Object):Void
	public function dispatchEvent(p_event:Event):Void
	public function removeEventListener(p_type:String, p_list:Object):Void
	
	public function addItem(p_item:Object):Void
	
	public function addItemAt(p_item:Object, p_index:Number):Void
	
	public function getItemAt(p_index:Number):Object
	
	public function getItemIndex(p_item:Object):Number
	
	public function itemUpdated(p_item:Object, p_propName:String, p_oldVal:Object, p_newVal:Object ):Void 

	public function removeAll():Void
	
	public function removeItemAt(p_index:Number):Object
	
	public function setItemAt(p_item:Object, p_index:Number):Object
	
	public function getLength():Number
}