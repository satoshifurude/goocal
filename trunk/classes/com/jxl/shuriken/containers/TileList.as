// TODO: class needs an overhaul

import mx.utils.Delegate;

import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.containers.TileList extends List
{
	
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.containers.TileList";
	
	public static var EVENT_ITEM_CLICKED:String ="EventItemClicked"
	
	public var className:String = "TileList";
	
	public function TileList()
	{
	}
	
	// Overwritten - ignoring the HorizontalList' drawing routine,
	// using our own grid based one - jrw 8.16.2006
	private function size():Void{
		var howManyChildren:Number = numChildren;

		var origX:Number = 0;
		var origY:Number = 0;
		var cols:Number = __horizontalPageSize;
		var rows:Number = Math.ceil(howManyChildren / __horizontalPageSize);
		var counter:Number = 0;
		if(__align == ALIGN_LEFT){
			for(var r:Number = 0; r<rows; r++){
				for(var c:Number = 0; c<cols; c++){
					var child:UIComponent = getChildAt(counter++);
					child.move(origX, origY);
					origX += __columnWidth + __childHorizontalMargin;
				}
				origX = 0;
				origY += __rowHeight + __childVerticalMargin;
			}
		}
	}
	
	private function setupChild(pChild:UIComponent):Void{
		
		var simpleButton:SimpleButton = SimpleButton(pChild);
		simpleButton.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onListItemClicked));		
		super.setupChild(pChild);
	}
	
	// Event listeners
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{		

		var index = getChildIndex(UIComponent(p_event.target));
		var item = __dataProvider[index];
		
		// FIXME: huh?  List doesn't have this method...
		//setSelectedIndex(index);	
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		dispatchEvent(event);
	}
	
}