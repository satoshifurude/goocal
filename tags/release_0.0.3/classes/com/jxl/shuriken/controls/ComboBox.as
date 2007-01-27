import mx.effects.Tween;
import mx.transitions.easing.Strong;
import mx.utils.Delegate;

import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.containers.ScrollableList;
import com.jxl.shuriken.containers.ButtonBar;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.controls.LinkButton;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;

[InspectableList("scrollSpeed", "direction", "rowHeight", "showScrollButtons", "visibleRowCount", "columnWidth", "closeWhenSelected", "MaskOverlap" )]
class com.jxl.shuriken.controls.ComboBox extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.ComboBox";
	
	public static var DIRECTION_ABOVE:String = "above";
	public static var DIRECTION_BELOW:String = "below";

	public static var EVENT_ITEM_CLICKED:String = "itemClicked";

	[Inspectable(type="Number", defaultValue=500, name="Scroll Speed")]
	public function get scrollSpeed():Number { return __scrollSpeed; }
	
	public function set scrollSpeed(pScrollSpeed:Number):Void
	{
		__scrollSpeed = pScrollSpeed;
		invalidateProperties();
	}

	
	public function get childClass():Function { return __childClass; }
	
	public function set childClass(p_class:Function):Void
	{	
		__childClass = p_class;
		__childClassDirty = true;
		invalidateProperties();
	}
	
	public function get childSetValueFunction():Function { return __childSetValueFunction; }
	
	public function set childSetValueFunction(pFunc:Function):Void
	{
		__childSetValueFunction = pFunc;
		__childSetValueFunctionDirty = true;
		invalidateProperties();
	}
	
	public function get childSetValueScope():Object { return __childSetValueScope; }
	
	public function set childSetValueScope(pScope:Object):Void
	{
		__childSetValueScope = pScope;
		__childSetValueScopeDirty = true;
		invalidateProperties();
	}
	
	private var __childSetValueScope:Object;
	private var __childSetValueScopeDirty:Boolean 			= false;
	private var __childSetValueFunction:Function;
	private var __childSetValueFunctionDirty:Boolean 		= false;
	
	
	public function get dataProvider():Collection
	{
		return __dataProvider;
	}
	
	public function set dataProvider(p_val:Collection):Void
	{
		__dataProvider = p_val;
		__dataProviderDirty = true;
		if(__dataProvider != null)
		{
			if(__dataProvider.getLength() < __visibleRowCount)
			{	__visibleRowCount = __dataProvider.getLength();
				__visibleRowCountDirty = true;
			}
		}
		invalidateProperties();
	}
	
	[Inspectable(type="List", enumeration="above,below", defaultValue="above", name="Direction")]
	public function get direction():String { return __direction; }
	
	public function set direction(p_val:String):Void
	{
		__direction = p_val;
		__directionDirty = true;
		invalidateProperties();
	}
	
	private var __rowHeight:Number=3;
	
	[Inspectable(defaultValue="", type="Number", name="rowHeight", defaultValue=3) ]
	public function get rowHeight():Number { return __rowHeight; }
	
	//No need to invalidate properties, since mcList does it anyway.
	public function set rowHeight(pVal:Number):Void
	{
		if(pVal != __rowHeight)
		{
			__rowHeight = pVal;
			__mcList.rowHeight = pVal;
		}
	}
	
	[Inspectable(type="Boolean", defaultValue=true, name="Show Scroll Buttons")]
	public function get showScrollButtons():Boolean { return __showScrollButtons; }
	
	public function set showScrollButtons(p_val:Boolean):Void
	{
		__showScrollButtons = p_val;
		__showScrollButtonsDirty = true;
		invalidateProperties();
	}
	
	[Inspectable(type="Number", defaultValue=5, name="Row Count")]
	public function get visibleRowCount():Number { return __visibleRowCount; }
	
	public function set visibleRowCount(pVal:Number):Void
	{
		if (pVal != __visibleRowCount)
		{
			__visibleRowCount = pVal;
			__visibleRowCountDirty = true;
			invalidateProperties();
		}
	}
	
	public function get icon():String { return __icon; }
	
	public function set icon(pVal:String):Void
	{
		if(pVal != __icon)
		{
			__icon = pVal;
			__iconDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(type="String", defaultValue="") name="label" ]
	public function get label():String { return __label; }
	public function set label(pVal:String):Void
	{
		__label = pVal;
		__labelDirty = true;
		invalidateProperties();
	}
	
	[Inspectable(defaultValue=null, type="Number", name="Column Width")]
	public function get columnWidth():Number { return __columnWidth; }
	
	public function set columnWidth(pVal:Number):Void
	{
		if(pVal != __columnWidth)
		{
			__columnWidth = pVal;
			__columnWidthDirty = true;
			invalidateProperties();
		}
	}
	
	/* Public reference to Main Button on Combo Box */
	public function get mainButton ():SimpleButton {
		return __mcHitState;
	}
	
	public function get textField():UITextField
	{
		return __mcHitState.textField;
	}
	
	
	
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get closeWhenSelected():Boolean { return __closeWhenSelected; }
	
	public function set closeWhenSelected(pVal:Boolean):Void
	{
		if(pVal != __closeWhenSelected)
		{
			__closeWhenSelected = pVal;
			__closeWhenSelectedDirty = true;
			invalidateProperties();
		}
	}
	


	[Inspectable(defaultValue=3, type="Number")]
	public function get MaskOverlap():Number { return __MaskOverlap; }
	
	public function set MaskOverlap(pVal:Number):Void
	{
		if(pVal != __MaskOverlap)
		{
			__MaskOverlap = pVal;
			__MaskOverlapDirty = true;
			invalidateProperties();
		}	
	}
	
	public function get selectedIndex():Number { return __selectedIndex }	
	
	public function set selectedIndex(p_val:Number):Void
	{
		__selectedIndex = p_val;
		__selectedIndexDirty = true;
		invalidateProperties();
	}	
		
	private var __childClass:Function						= Button;
	private var __childClassDirty:Boolean					= false;
	private var __dataProvider:Collection;
	private var __dataProviderDirty:Boolean					= false;
	private var __direction:String							= "above";
	private var __directionDirty:Boolean					= false;
	private var __isOpen:Boolean							= false;
	private var __tweenScroll:Tween;
	private var __showScrollButtons:Boolean					= true;
	private var __showScrollButtonsDirty:Boolean;
	private var __visibleRowCount:Number 					= 5;
	private var __visibleRowCountDirty:Boolean				= false;
	private var __icon:String;
	private var __iconDirty:Boolean							= false;
	private var __label:String								= "";
	private var __labelDirty:Boolean						= false;
	private var __columnWidth:Number 						= 100;
	private var __columnWidthDirty:Boolean 					= false;
	private var __closeWhenSelected:Boolean 				= true;
	private var __closeWhenSelectedDirty:Boolean 			= false;
	private var __selectedIndex:Number;
	private var __selectedIndexDirty:Boolean				= false;
	
	private var __MaskOverlap:Number 						= 3;
	private var __MaskOverlapDirty:Boolean = false;
		
	private var __scrollSpeed:Number 						= 500;	

	private var openPosition:Number;
	
	private var __mcLabel:UITextField;
	private var __mcHitState:Button;
	private var __mcList:ScrollableList;
	private var __mcListMask:MovieClip;
	

	public function ComboBox()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
		
	}
	
	private function createChildren():Void
	{
		super.createChildren();	
		setupList();
		setupLabel();
		
		__mcListMask = createEmptyMovieClip("__mcListMask", getNextHighestDepth());
		com.jxl.shuriken.utils.DrawUtils.drawMask(__mcListMask, 0, 0, 100, 100);
		__mcList.setMask(__mcListMask);
		__mcList.tabChildren = false;
		__mcList.visible = false;
		
		setupHitState();
	}
	
	/*
	* Called on each child before its setValue function
	* allows a subclass of list to set up a child without using the setValue function.
	*/
	private function onSetupChild(pEvent:Object)
	{
	}
	
	private function setupHitState():Void
	{
		__mcHitState = Button(attachMovie(Button.SYMBOL_NAME, "__mcHitState", getNextHighestDepth()));
		__mcHitState.addEventListener(ShurikenEvent.PRESS, Delegate.create(this, onComboBoxClick));
		__mcHitState.addEventListener(ShurikenEvent.MOUSE_DOWN_OUTSIDE, Delegate.create(this, onComboBoxClickOutside));
	}
	
	private function setupList():Void
	{
		__mcList = ScrollableList(attachMovie(ScrollableList.SYMBOL_NAME, "__mcList", getNextHighestDepth()));
		__mcList.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onListItemClicked));
		__mcList.direction = List.DIRECTION_VERTICAL;
		__mcList.childClass = __childClass;
			
		__mcList.addEventListener(List.EVENT_SETUP_CHILD, Delegate.create(this, onSetupChild));
	}		
	
	private function setupLabel():Void{
		__mcLabel = UITextField(attachMovie(UITextField.SYMBOL_NAME, "__mcLabel", getNextHighestDepth()));
		__mcLabel.multiline 	= false;
		__mcLabel.wordWrap 	= false;
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__childSetValueFunctionDirty == true)
		{
			__childSetValueFunctionDirty = false;	
			__mcList.childSetValueFunction = __childSetValueFunction;
		}
		
		if(__childSetValueScopeDirty == true)
		{
			__childSetValueScopeDirty = false;
			__mcList.childSetValueScope = __childSetValueScope;
		}
		
		if(__dataProviderDirty == true)
		{
			__dataProviderDirty = false;		
			__mcList.dataProvider = __dataProvider;
			invalidateSize();
		}
		
		if (__directionDirty == true)
		{
			__directionDirty = false;
			invalidateSize();
		}
		
		if (__showScrollButtonsDirty == true)
		{
			__showScrollButtonsDirty = false;
			__mcList.showButtons = __showScrollButtons;
			invalidateSize();
		}
		
		if (__visibleRowCountDirty == true)
		{
			__visibleRowCountDirty = false;
			invalidateSize();
		}
		
		if(__iconDirty == true)
		{
			__iconDirty = false;
			__mcHitState.icon = __icon;
		}
		
		if(__labelDirty == true)
		{
			__labelDirty = false;
			__mcHitState.label = __label;
		}
		
		if(__columnWidthDirty == true)
		{
			__columnWidthDirty = false;
			__mcList.columnWidth = __columnWidth;
		}
		
	
		if(__MaskOverlapDirty == true)
		{
			__MaskOverlapDirty = false;
			invalidateSize()
		}
		
		if(__childClassDirty == true)
		{
			__childClassDirty = false;
			__mcList.childClass = __childClass;
		}
		
		if(__selectedIndexDirty == true)
		{
			__selectedIndexDirty = false;
			__mcList.selectedIndex = __selectedIndex;
		}

	}
	
	private function size():Void
	{
		super.size();
			
		__mcLabel.setSize(width, height);						
		__mcHitState.setSize(width, height);
		
		if(__dataProvider != null && __dataProvider.getLength() > 0)
		{
			var listHeight : Number = __mcList.getPreferredHeight(__visibleRowCount);
			if (!isNaN(listHeight)){
				__mcList.columnWidth = width;
				__mcList.setSize(width, listHeight);
						
			} else {
				// FIXME
			}
		}
		
		__mcListMask._width = __mcList.width;
		__mcListMask._height = __mcList.height + __MaskOverlap;
		//DrawUtils.drawMask(__mcListMask, 0, 0, __mcList.width, __mcList.height + __MaskOverlap);
		//__mcList.setMask(__mcListMask);

		if (__direction == ComboBox.DIRECTION_ABOVE)
		{
			__mcList.move(__mcList.x, __mcHitState.y);
			__mcListMask._x = __mcList.x;
			__mcListMask._y = __mcList.y - __mcList.height;
		}
		else if(__direction == ComboBox.DIRECTION_BELOW)
		{
			__mcList.move(__mcList.x, __mcHitState.y - __mcList.height);
			__mcListMask._x = __mcList.x;
			__mcListMask._y = __mcHitState.y + __mcHitState.height;
		}
		
		
		//__mcHitState.swapDepths(getNextHighestDepth());
		
		
	}
	
	private function onComboBoxClick(p_event:ShurikenEvent):Void
	{
		
		if (__isOpen == false){
			openList();		
		} else {
			closeList();
		}
	}
	
	private function onComboBoxClickOutside(p_event:ShurikenEvent):Void
	{
		var p:Object = { x: _xmouse, y: _ymouse };
		this.localToGlobal(p);
		
		if (__isOpen && hitTest(p.x, p.y) == false)
		{
		
			closeList();
		
		}
	}
	
	private function onTweenVScrollUpdate(pVal:Number):Void{
		
		if(!(__isOpen && pVal == 0) && !(!__isOpen && pVal == openPosition)){  //HACK ATTACK!!!! This eliminates the flicker!
			__mcList.move(__mcList.x, pVal);
		}
		
	}
	
	private function onTweenVScrollOpenEnd(pVal:Number):Void
	{
		onTweenVScrollUpdate(pVal);
		__mcList.tabChildren = true;
	}

	private function onTweenVScrollCloseEnd(pVal:Number):Void
	{
		onTweenVScrollUpdate(pVal);

		if (!__isOpen)
		{
			__mcList.tabChildren = false;
			__mcList.visible = false;
		}
	}
	
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = p_event.item;
		event.index = p_event.index;
		dispatchEvent(event);
		
		label = __dataProvider.getItemAt(event.index).toString();
		
		if(__closeWhenSelected)
		{
			closeList();
		}
	}
	
	public function openList():Void
	{
		__isOpen = true;
		
		var startY  : Number = 0;
		var finishY : Number = 0;
		
		if (__direction == ComboBox.DIRECTION_ABOVE)
		{
			startY  = __mcHitState.y;
			finishY = __mcHitState.y - __mcList.height;
		}
		else if (__direction == ComboBox.DIRECTION_BELOW)
		{
			startY  = (__mcHitState.y + __mcHitState.height) - __mcList.height;
			finishY = __mcHitState.y + __mcHitState.height;
		}
		
		openPosition = finishY;
		
		__tweenScroll.endTween();
		
		delete __tweenScroll;
		
		__tweenScroll = new Tween(this, __mcList.y, finishY, __scrollSpeed);
		__tweenScroll.easingEquation = Strong.easeOut;
		__tweenScroll.setTweenHandlers("onTweenVScrollUpdate", "onTweenVScrollOpenEnd");
		
		__mcList.visible = true;
	}
	
	
	
	public function closeList():Void
	{
		__isOpen = false;
		
		// KLUDGE: should remove the focus of the item instead
		// of forcing rid of the yellow focus rect this way
		Selection.setFocus(null);
		
		var finishY : Number = 0;
			
		if (__direction == ComboBox.DIRECTION_ABOVE)
		{
			finishY = __mcHitState.y;
		}
		else
		{
			finishY = (__mcHitState.y + __mcHitState.height) - __mcList.height;
		}
		
		
		__tweenScroll.endTween();
		
		delete __tweenScroll;
		
		__tweenScroll = new Tween(this, __mcList.y, finishY, __scrollSpeed);
		__tweenScroll.easingEquation = Strong.easeOut;
		__tweenScroll.setTweenHandlers("onTweenVScrollUpdate", "onTweenVScrollCloseEnd");
	}
}