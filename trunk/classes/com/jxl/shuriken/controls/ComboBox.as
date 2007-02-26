import mx.effects.Tween;
import mx.transitions.easing.Strong;
import mx.utils.Delegate;

import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.containers.ScrollableList;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.controls.LinkButton;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

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
	}

	
	public function get childClass():Function { return __childClass; }
	
	public function set childClass(p_class:Function):Void
	{	
		__childClass = p_class;
		__mcList.childClass = p_class;
	}
	
	public function get childSetValueFunction():Function { return __childSetValueFunction; }
	
	public function set childSetValueFunction(pFunc:Function):Void
	{
		__childSetValueFunction = pFunc;
		__mcList.childSetValueFunction = pFunc;
	}
	
	public function get childSetValueScope():Object { return __childSetValueScope; }
	
	public function set childSetValueScope(pScope:Object):Void
	{
		__childSetValueScope = pScope;
		__mcList.childSetValueScope = pScope;
	}
	
	private var __childSetValueScope:Object;
	private var __childSetValueFunction:Function;
	
	
	public function get dataProvider():Collection
	{
		return __dataProvider;
	}
	
	public function set dataProvider(p_val:Collection):Void
	{
		__dataProvider = p_val;
		if(__dataProvider != null)
		{
			if(__dataProvider.getLength() < __visibleRowCount)
			{	
				__visibleRowCount = __dataProvider.getLength();
			}
		}
		__mcList.dataProvider = p_val;
		invalidate();
	}
	
	[Inspectable(type="List", enumeration="above,below", defaultValue="above", name="Direction")]
	public function get direction():String { return __direction; }
	
	public function set direction(p_val:String):Void
	{
		__direction = p_val;
		invalidate();
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
		__mcList.showButtons = __showScrollButtons;
	}
	
	[Inspectable(type="Number", defaultValue=5, name="Row Count")]
	public function get visibleRowCount():Number { return __visibleRowCount; }
	
	public function set visibleRowCount(pVal:Number):Void
	{
		if (pVal != __visibleRowCount)
		{
			__visibleRowCount = pVal;
			invalidate();
		}
	}
	
	public function get icon():String { return __icon; }
	
	public function set icon(pVal:String):Void
	{
		if(pVal != __icon)
		{
			__icon = pVal;
			__mcHitState.icon = pVal;
		}
	}
	
	[Inspectable(type="String", defaultValue="", name="label")]
	public function get label():String { return __label; }
	public function set label(pVal:String):Void
	{
		__label = pVal;
		__mcHitState.label = pVal;
	}
	
	[Inspectable(defaultValue=null, type="Number", name="Column Width")]
	public function get columnWidth():Number { return __columnWidth; }
	
	public function set columnWidth(pVal:Number):Void
	{
		if(pVal != __columnWidth)
		{
			__columnWidth = pVal;
			__mcList.columnWidth = pVal;
		}
	}
	
	/* Public reference to Main Button on Combo Box */
	public function get mainButton ():SimpleButton {
		return __mcHitState;
	}
	
	public function get textField():TextField
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
		}
	}
	


	[Inspectable(defaultValue=3, type="Number")]
	public function get MaskOverlap():Number { return __MaskOverlap; }
	
	public function set MaskOverlap(pVal:Number):Void
	{
		if(pVal != __MaskOverlap)
		{
			__MaskOverlap = pVal;
			invalidate();
		}	
	}
	
	public function get selectedIndex():Number { return __mcList.selectedIndex; }	
	
	public function set selectedIndex(val:Number):Void
	{
		__mcList.selectedIndex = val;
	}
	
	public function get selectedItem():Object { return __mcList.selectedItem; }
	public function set selectedItem(val:Object):Void
	{
		//trace("------------------");
		//trace("ComboBox::selectedItem setter, val: " + val);
		//trace("__mcList: " + __mcList);
		//trace("__mcList.selectedItem: " + __mcList.selectedItem);
		__mcList.selectedItem = val;
		//trace("__mcList.selectedItem: " + __mcList.selectedItem);
	}
	
	public function get prompt():String { return __prompt; }
	public function set prompt(p_val:String):Void
	{
		__prompt = p_val;
		if(__label == "" || __label == null)
		{
			__label = __prompt;
			__mcHitState.label = __label;
		}
	}
		
	private var __childClass:Function						= Button;
	private var __dataProvider:Collection;
	private var __direction:String							= "above";
	private var __isOpen:Boolean							= false;
	private var __tweenScroll:Tween;
	private var __showScrollButtons:Boolean					= true;
	private var __visibleRowCount:Number 					= 5;
	private var __icon:String;
	private var __label:String								= "";
	private var __prompt:String 							= "";
	private var __columnWidth:Number 						= 100;
	private var __closeWhenSelected:Boolean 				= true;
	
	private var __MaskOverlap:Number 						= 3;
		
	private var __scrollSpeed:Number 						= 500;
	
	private var __itemClickedCallback:Callback;
	private var __itemSelectionChangedCallack:Callback;

	private var openPosition:Number;
	
	private var __mcHitState:Button;
	private var __mcList:ScrollableList;
	private var __mcListMask:MovieClip;
	

	public function ComboBox()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();	
		setupList();
		
		__mcListMask = createEmptyMovieClip("__mcListMask", getNextHighestDepth());
		com.jxl.shuriken.utils.DrawUtils.drawMask(__mcListMask, 0, 0, 100, 100);
		__mcList.setMask(__mcListMask);
		__mcList.tabChildren = false;
		__mcList._visible = false;
		
		setupHitState();
	}
	
	private function setupHitState():Void
	{
		__mcHitState = Button(attachMovie(Button.SYMBOL_NAME, "__mcHitState", getNextHighestDepth()));
		__mcHitState.setPressCallback(this, onComboBoxClick);
		__mcHitState.setMouseDownOutsideCallback(this, onComboBoxClickOutside);
		__mcHitState.drawButton = ComboBox.prototype.drawButton;
		var tf:TextFormat = __mcHitState.textField.getTextFormat();
		tf.align = TextField.ALIGN_LEFT;
		__mcHitState.textField.setNewTextFormat(tf);
		__mcHitState.textField.setTextFormat(tf);
	}
	
	// NOTE: Scoped to Hit State
	private function drawButton():Void
	{
		clear();
		
		lineStyle(0, 0xA5ACB2);
		beginFill(0xFFFFFF);
		DrawUtils.drawBox(this, 0, 0, __width, __height);
		
		lineStyle(0, 0x5B6665);
		var fil:String = "linear";
		var clrs:Array = [0xFFFFFF, 0xCFD1E3];
		var alph:Array = [100, 100];
		var rati:Array = [90, 255];
		var mat:Object = { matrixType:"box", x:0, y:0, w:__width, h:__height, r:(90/180)*Math.PI };
		beginGradientFill(fil, clrs, alph, rati, mat);
		DrawUtils.drawRoundRect(this, __width - 19, 2, 17, 18, 1);
		endFill();
		
		var tarX:Number = (__width) - 18 + 4;
		var tarY:Number = 10;
		moveTo(tarX, tarY);
		lineStyle(2, 0x202020);
		lineTo(tarX + 4, tarY + 4);
		lineTo(tarX + 8, tarY);
		
		endFill();
	}
	
	// Note: Scoped to List Child Button
	private function drawChild():Void
	{
		// KLUDGE: Compiler doesn't know our scope change here,
		// so we just cast a local variable to make him happy
		var o = this;
		var btn:Button = o;
		btn.clear();
		if(btn.currentState == Button.DEFAULT_STATE)
		{
			
			btn.beginFill(0xFFFFFF);
		}
		else
		{
			btn.beginFill(0xB2B4BF);
		}
		btn.lineTo(btn.width, 0);
		btn.lineTo(btn.width, btn.height);
		btn.lineTo(0, btn.height);
		btn.lineTo(0, 0);
		btn.endFill();
	}
	
	private function setupList():Void
	{
		__mcList = ScrollableList(attachMovie(ScrollableList.SYMBOL_NAME, "__mcList", getNextHighestDepth()));
		__mcList.setItemClickCallback(this, onListItemClicked);
		__mcList.setItemSelectionChangedCallback(this, onListItemChanged);
		__mcList.setSetupChildCallback(this, onSetupListChild);
		__mcList.direction = List.DIRECTION_VERTICAL;
		__mcList.childClass = __childClass;
		__mcList.toggle = true;
	}		
	
	private function onSetupListChild(event:ShurikenEvent):Void
	{
		var btn:Button = Button(event.child);
		btn.drawButton = ComboBox.prototype.drawChild;
		btn.textField.align = TextField.ALIGN_LEFT;
		var tf:TextFormat = btn.textField.getTextFormat();
		tf.align = TextField.ALIGN_LEFT;
		btn.textField.setNewTextFormat(tf);
		btn.textField.setTextFormat(tf);
	}
	
	private function redraw():Void
	{
		super.redraw();
		
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
			__mcList._visible = false;
		}
	}
	
	public function setItemClickedCallback(scope:Object, func:Function):Void
	{
		__itemClickedCallback = new Callback(scope, func);
	}
	
	private function onListItemClicked(p_event:ShurikenEvent):Void
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = UIComponent(p_event.target);
		event.item = p_event.item;
		event.index = p_event.index;
		__itemClickedCallback.dispatch(event);
		
		label = __dataProvider.getItemAt(event.index).toString();
		
		if(__closeWhenSelected)
		{
			closeList();
		}
	}
	
	private function onListItemChanged(p_event:ShurikenEvent):Void
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_SELECTION_CHANGED, this);
		event.child = UIComponent(p_event.target);
		event.item = p_event.item;
		event.index = p_event.index;
		
		label = __dataProvider.getItemAt(event.index).toString();
		
		__itemSelectionChangedCallack.dispatch(event);
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
		
		__mcList._visible = true;
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
	
	public function setItemSelectionChangedCallback(scope:Object, func:Function):Void
	{
		__itemSelectionChangedCallack = new Callback(scope, func);
	}
	
}