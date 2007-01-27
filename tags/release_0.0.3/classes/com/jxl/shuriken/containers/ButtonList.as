import mx.utils.Delegate;

import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.containers.ButtonList extends List
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.containers.ButtonList";
	
	public function get toggle():Boolean { return __toggle; }
	
	public function set toggle(pVal:Boolean):Void
	{
		__toggle = pVal;
		__toggleDirty = true;
		invalidateProperties();
	}
	
	public function get selectedIndex():Number { return __selectedIndex; }
	
	public function set selectedIndex(pVal:Number):Void{
		
		__selectedIndex = pVal;
		__selectedIndexDirty = true;
		invalidateProperties();
	}
	
	public function get selectedItem():Object { return __selectedItem; }
	
	public function set selectedItem(pVal:Object):Void
	{	
		__selectedItem = pVal;
		__selectedItemDirty = true;
		invalidateProperties();
	}
	
	public function get selectedChild():Button { return __selectedChild; }

	public function set selectedChild(pVal:Button):Void
	{
		__selectedChild = pVal;
		__selectedChildDirty = true;
		invalidateProperties();
	}
	
	public function lastSelectedItem():Button
	{
		return __lastSelected;
	}
	
	
	private var __childClass:Function 				= Button;
	private var __toggle:Boolean					= true;
	private var __toggleDirty:Boolean				= false;
	private var __lastSelected:Button;
	private var __selectedIndex:Number				= -1;
	private var __selectedIndexDirty:Boolean 		= false;
	private var __selectedItem:Object;
	private var __selectedItemDirty:Boolean			= false;
	private var __selectedChild:Button;
	private var __selectedChildDirty:Boolean		= false;
	private var __buttonSelectionDelegate:Function;
	
	private function commitProperties():Void
	{
		super.commitProperties();
		

		if(__toggleDirty == true)
		{
			__toggleDirty = false;
			invalidateDraw();
		}
		
		if(__selectedIndexDirty == true)
		{
			__selectedIndexDirty = false;
			if(__toggle == true)
			{			
				setSelectedIndex(__selectedIndex, true);
			}
		}
		
		if(__selectedItemDirty == true)
		{
			__selectedItemDirty = false;
			setSelectedItem(__selectedItem);
		}
		
		if(__selectedChildDirty == true)
		{
			__selectedChildDirty = false;
			setSelectedChild(__selectedChild);
		}
		
	}
	
	// Called by draw
	private function setupChild(p_child:UIComponent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::setupChild");
		var simpleButton:SimpleButton = SimpleButton(p_child);
		simpleButton.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onListItemClicked));
		//simpleButton.addEventListener(ShurikenEvent.ROLL_OVER, Delegate.create(this, onListItemRollOver));
		if(p_child instanceof Button == true)
		{
			var button:Button = Button(p_child);
			if(__toggle == true)
			{
				if(__buttonSelectionDelegate == null) Delegate.create(this, onListItemSelectionChanged);
				button.addEventListener(ShurikenEvent.SELECTION_CHANGED, __buttonSelectionDelegate);
				button.toggle = true;
				
				if(__selectedIndex > -1)
				{
					var index:Number = getChildIndex(button);
					if(__selectedIndex == index)
					{
						button.selected = true;
						__lastSelected = button;
						__selectedItem = __lastSelected;
						__selectedChild = button;
					}
				}
			}
		}
		
		super.setupChild(p_child);
		
	}
	
	private function setSelectedIndex(p_index:Number, noEvent:Boolean):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::setSelectedIndex");
		__selectedIndex = p_index;
		
		var lastSelectedChild:Button = __lastSelected;
		
		if(__lastSelected != null) __lastSelected.selected = false;
		
		__lastSelected = Button(getChildAt(p_index));
		__lastSelected.removeEventListener(ShurikenEvent.SELECTION_CHANGED, __buttonSelectionDelegate);
		__lastSelected.selected = true;
		__lastSelected.addEventListener(ShurikenEvent.SELECTION_CHANGED, __buttonSelectionDelegate);
		
		var item = __dataProvider.getItemAt(p_index);
		__selectedItem = item;
		
		__selectedChild = __lastSelected;
		
		if(noEvent != true && __isConstructing == false)
		{
			var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_SELECTION_CHANGED, this);
			event.lastSelected = lastSelectedChild;
			event.selected = __lastSelected;
			event.item = item;
			event.index = p_index;
			dispatchEvent(event);
		}
		
	}
	
	private function setSelectedItem(p_item:Object):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::setSelectedItem");
		var i:Number = __dataProvider.getLength();
		while(i--)
		{
			var o:Object = __dataProvider[i];
			if(o == p_item)
			{	
				setSelectedIndex(i);
				return;
			}
		}
	}
	
	private function setSelectedChild(p_child:Button):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::setSelectedChild");
		var index:Number = getChildIndex(p_child);
		if(index != null && isNaN(index) == false) setSelectedIndex(index);
	}
	
	// Event listeners
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemClicked");
		var index:Number = getChildIndex(UIComponent(p_event.target));
		var item:Object = __dataProvider.getItemAt(index);
		setSelectedIndex(index);	
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		dispatchEvent(event);
	}
	
	private function onListItemRollOver(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemRollOver");
		var index:Number = getChildIndex(UIComponent(p_event.target));
		var item:Object = __dataProvider.getItemAt(index);
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_ROLL_OVER, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		dispatchEvent(event);
	}
	
	private function onListItemSelectionChanged(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemSelectionChanged");
		setSelectedIndex(getChildIndex(UIComponent(p_event.target)), true);
	}
	
}