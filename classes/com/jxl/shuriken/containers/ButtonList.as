import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

class com.jxl.shuriken.containers.ButtonList extends List
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.containers.ButtonList";
	
	public function get toggle():Boolean { return __toggle; }
	
	public function set toggle(pVal:Boolean):Void
	{
		__toggle = pVal;
		invalidate();
	}
	
	public function get selectedIndex():Number { return __selectedIndex; }
	
	public function set selectedIndex(pVal:Number):Void{
		
		__selectedIndex = pVal;
		if(__toggle == true)
		{
			setSelectedIndex(__selectedIndex);
		}
	}
	
	public function get selectedItem():Object 
	{ 
		return __selectedItem; 
	}
	
	public function set selectedItem(pVal:Object):Void
	{	
		__selectedItem = pVal;
		var i:Number = __dataProvider.getLength();
		while(i--)
		{
			var o:Object = __dataProvider[i];
			if(o == pVal)
			{	
				selectedIndex = i;
				return;
			}
		}
	}
	
	public function get selectedChild():Button { 
		return __selectedChild; 
	}

	public function set selectedChild(pVal:Button):Void
	{
		__selectedChild = pVal;
		
		var index:Number = getChildIndex(pVal);
		if(index != null && isNaN(index) == false) setSelectedIndex(index);
	}
	
	public function lastSelectedItem():Button
	{
		return __lastSelected;
	}
	
	
	private var __childClass:Function 				= Button;
	private var __toggle:Boolean					= true;
	private var __lastSelected:Button;
	private var __selectedIndex:Number				= -1;
	private var __selectedItem:Object;
	private var __selectedChild:Button;
	private var __itemSelectionChanged:Callback;
	private var __itemClickCallback:Callback;
	private var __itemRollOverCallback:Callback;
	
	// Called by draw
	private function setupChild(p_child:UIComponent):Void
	{
		if(p_child instanceof SimpleButton)
		{
			var simpleButton:SimpleButton = SimpleButton(p_child);
			simpleButton.setReleaseCallback(this, onListItemClicked);
		}
		// KLUDGE: need better enforcement, but interfaces are too heavy
		// and we can't demand people extend SimpleButton
		//else if(p_child.hasOwnProperty("setReleaseCallback") == true)
		// BUG: above is giving whack results... it traces out function,
		// apparently according to enumeration and hasOwnProperty, it does not
		// wtf...>!?!?!?
		else
		{
			// HACK: compiler hack
			p_child["setReleaseCallback"](this, onListItemClicked);
		}
		
		//simpleButton.addEventListener(ShurikenEvent.ROLL_OVER, Delegate.create(this, onListItemRollOver));
		if(p_child instanceof Button == true)
		{
			var button:Button = Button(p_child);
			if(__toggle == true)
			{
				button.setSelectionChangeCallback(this, onListItemSelectionChanged);
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
		__lastSelected.setSelectionChangeCallback();
		__lastSelected.selected = true;
		__lastSelected.setSelectionChangeCallback(this, onListItemSelectionChanged);
		
		var item = __dataProvider.getItemAt(p_index);
		__selectedItem = item;
		
		__selectedChild = __lastSelected;
		
		if(noEvent != true && isConstructing == false)
		{
			var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_SELECTION_CHANGED, this);
			event.lastSelected = lastSelectedChild;
			event.selected = __lastSelected;
			event.item = item;
			event.index = p_index;
			__itemSelectionChanged.dispatch(event);
		}
		
	}
	
	// Event listeners
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemClicked");
		//DebugWindow.debug("p_event: " + p_event);
		//DebugWindow.debug("p_event.target: " + p_event.target);
		//DebugWindow.debug("__dataProvider: " + __dataProvider);
		//DebugWindow.debug("UIComponent(p_event.target): " + UIComponent(p_event.target));
		//DebugWindow.debug("index: " + index);
		var index:Number = getChildIndex(UIComponent(p_event.target));
		var item:Object = __dataProvider.getItemAt(index);
		setSelectedIndex(index);	
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = item;
		event.index = index;
		//DebugWindow.debug("item: " + item);
		//DebugWindow.debug("index: " + index);
		__itemClickCallback.dispatch(event);
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
		__itemRollOverCallback.dispatch(event);
	}
	
	private function onListItemSelectionChanged(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::onListItemSelectionChanged");
		setSelectedIndex(getChildIndex(UIComponent(p_event.target)), true);
	}
	
	public function setItemSelectionChangedCallback(scope:Object, func:Function):Void
	{
		__itemSelectionChanged = new Callback(scope, func);
	}
	
	public function setItemClickCallback(scope:Object, func:Function):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ButtonList::setItemClickCallback, scope: " + scope + ", func: " + func);
		__itemClickCallback = new Callback(scope, func);
		//DebugWindow.debug("__itemClickCallback: " + __itemClickCallback);
	}
	
	public function setItemRollOverCallback(scope:Object, func:Function):Void
	{
		__itemRollOverCallback = new Callback(scope, func);
	}
	
}