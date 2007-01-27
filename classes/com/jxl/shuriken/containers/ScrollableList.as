import mx.effects.Tween;
import mx.transitions.easing.Strong;
import mx.utils.Delegate;

import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.core.Container;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.containers.ButtonList;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.managers.TweenManager;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;

[InspectableList("scrollSpeed", "direction", "showButtons")]
class com.jxl.shuriken.containers.ScrollableList extends Container
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.containers.ScrollableList";
	
	private static var DEPTH_PREV_SCROLL_BUTTON:Number = 3;
	private static var DEPTH_NEXT_SCROLL_BUTTON:Number = 4;
	
	[Inspectable(type="Number", defaultValue=500, name="Scroll Speed")]
	public var scrollSpeed:Number = 500; // milliseconds
	
	[Inspectable(type="List", enumeration="horizontal,vertical", name="Direction")]
	public function get direction():String { return __direction; }
	
	public function set direction(pVal:String):Void
	{
		if(pVal != __direction)
		{
			__direction = pVal;
			__directionDirty = true;
			invalidateProperties();
		}
	}
	
	public function get horizontalPageSize():Number { return __horizontalPageSize; }
	
	public function get verticalPageSize():Number { return __verticalPageSize; }
	
	public function get childClass():Function { return __childClass; }
	
	public function set childClass(pClass:Function):Void
	{
		__childClass = pClass;
		__childClassDirty = true;
		invalidateProperties();
	}

	public function get childSetValueScope():Object { return __childSetValueScope; }
	
	public function set childSetValueScope(pScope:Object):Void
	{
		__childSetValueScope = pScope;
		__childSetValueScopeDirty = true;
		invalidateProperties();
	}
	
	public function get childSetValueFunction():Function { return __childSetValueFunction; }
	
	public function set childSetValueFunction(pFunc:Function):Void
	{
		__childSetValueFunction = pFunc;
		__childSetValueFunctionDirty = true;
		invalidateProperties();
	}
	
	public function get columnWidth():Number { return __mcList.columnWidth; }
	
	public function set columnWidth(pVal:Number):Void
	{
		if(pVal != __columnWidth)
		{
			__columnWidth = pVal;
			__columnWidthDirty = true;
			invalidateProperties();
		}
	}
	
	public function get rowHeight():Number { return __mcList.rowHeight; }	
	
	public function set rowHeight(pVal:Number):Void
	{
		if(pVal != __rowHeight)
		{
			__rowHeight = pVal;
			__rowHeightDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(type="List", enumeration="left,center", defaultValue="left"]
	public function get align():String
	{
		return __align;
	}
	
	public function set align(pAlign:String):Void
	{
		__align = pAlign;
		__alignDirty = true;
		invalidateProperties();
	}
	
	[Inspectable(type="Number", defaultValue=0, name="Horizontal Margin")]
	public function get childHorizontalMargin():Number { return __childHorizontalMargin; }
	
	public function set childHorizontalMargin(pVal:Number):Void
	{
		__childHorizontalMargin = pVal;
		__childHorizontalMarginDirty = true;
		invalidateProperties();
	}
	
	[Inspectable(type="Number", defaultValue=0, name="Vertical Margin")]
	public function get childVerticalMargin():Number { return __childVerticalMargin; }
	
	public function set childVerticalMargin(pVal:Number):Void
	{	
		__childVerticalMargin = pVal;
		__childVerticalMarginDirty = true;
		invalidateProperties();
	}
	
	public function get autoSizeToChildren():Boolean { return __autoSizeToChildren; }
	
	public function set autoSizeToChildren(pVal:Boolean):Void
	{
		__autoSizeToChildren = pVal;
		__autoSizeToChildrenDirty = true;
		invalidateProperties();
	}
	
	public function get dataProvider():Collection
	{
		return __dataProvider;
	}
	
	public function set dataProvider(p_val:Collection):Void
	{
		__dataProvider = p_val;
		__dataProviderDirty = true;
		invalidateProperties();
	}
	
	public function get toggle():Boolean { return __toggle }	
	
	public function set toggle(pBoolean:Boolean):Void
	{
		if(pBoolean != __toggle)
		{
			__toggle = pBoolean;
			__toggleDirty = true;
			invalidateProperties();
		}
	}
	
	public function get selectedIndex():Number { return __selectedIndex }	
	
	public function set selectedIndex(pVal:Number):Void
	{
		if(pVal != __selectedIndex)
		{
			__selectedIndex = pVal;
			__selectedIndexDirty = true;
			invalidateProperties();
		}
	}	
	
	
	
	[Inspectable(type="Boolean", defaultValue=true, name="Show Buttons")]
	public function get showButtons():Boolean { return __showButtons; }
	
	public function set showButtons(pVal:Boolean):Void
	{
		if(pVal != __showButtons)
		{
			__showButtons = pVal;
			__showButtonsDirty = true;
			invalidateProperties();
		}
	}
	
	public function get pageTotal():Number{	
		
		var pageSize = (__mcList.direction == List.DIRECTION_HORIZONTAL) ? __mcList.horizontalPageSize : __mcList.verticalPageSize;
		var lastPage : Number = Math.ceil(__dataProvider.getLength() / pageSize);
		
		return lastPage;
	}
	
	public function get pageCurrent():Number{return pageIndex+1; }
	
	
	private var __childSetValueScope:Object;
	private var __childClass:Function						= SimpleButton;
	private var __childClassDirty:Boolean					= false;
	private var __childSetValueFunction:Function;
	private var __childSetValueFunctionDirty:Boolean		= false;
	private var __childSetValueScopeDirty:Boolean			= false;
	private var __dataProvider:Collection;
	private var __dataProviderDirty:Boolean					= false;
	private var __direction:String;
	private var __directionDirty:Boolean					= false;
	private var __horizontalPageSize:Number					= 0;
	private var __verticalPageSize:Number					= 0;
	private var __align:String								= "left";
	private var __alignDirty:Boolean						= false;
	private var __childHorizontalMargin:Number				= 0;
	private var __childHorizontalMarginDirty:Boolean		= false;
	private var __childVerticalMargin:Number				= 0;
	private var __childVerticalMarginDirty:Boolean			= false;
	private var __autoSizeToChildren:Boolean				= true;
	private var __autoSizeToChildrenDirty:Boolean			= false;
	private var __showButtons:Boolean 						= false;
	private var __showButtonsDirty:Boolean 					= false;
	private var __tweenScroll:Tween;
	private var __columnWidth:Number						= 0;
	private var __columnWidthDirty:Boolean 					= false;
	private var __rowHeight:Number 							= 0;
	private var __rowHeightDirty:Boolean					= false;
	private var __toggle:Boolean 							= false
	private var __toggleDirty 								= false;
	private var __selectedIndex:Number 						= -1
	private var __selectedIndexDirty 						= false;
	
	private var __mcList:ButtonList;
	private var __mcScrollPrevious:SimpleButton;
	private var __mcScrollNext:SimpleButton;
	private var __mcListMask:MovieClip;

	private var pageIndex:Number = 0;
	
	public function ScrollableList()
	{
	}
	
	public function getPreferredHeight(visibleRowCount:Number):Number
	{
		var preferredHeight:Number = 0;

		if (__showButtons == true)
		{
			preferredHeight = __mcList.getPreferredHeight(visibleRowCount) + __mcScrollPrevious.height + __mcScrollNext.height;
		}
		else
		{
			preferredHeight = __mcList.getPreferredHeight(visibleRowCount);
		}
		
		return preferredHeight;
	}
	
	public function getPreferredWidth(visibleColCount:Number):Number
	{
		var preferredWidth:Number = 0;

		if (__showButtons == true)
		{
			preferredWidth = __mcList.getPreferredWidth(visibleColCount) + __mcScrollPrevious.width + __mcScrollNext.width;
		}
		else
		{
			preferredWidth  = __mcList.getPreferredWidth(visibleColCount);
		}
			
		return preferredWidth;
	}
	
	private function createChildren():Void
	{
		super.createChildren();		

		setupList();
		setupButtons();
		
		__mcListMask = createEmptyMovieClip("__mcListMask", getNextHighestDepth());
		__mcList.setMask(__mcListMask);
	}
	
	// Exposed for a child class
	private function setupList():Void
	{
		__mcList = ButtonList(attachMovie(ButtonList.SYMBOL_NAME, "__mcList", getNextHighestDepth()));

		__mcList.addEventListener(ShurikenEvent.SETUP_CHILD, Delegate.create(this, onSetupChild));
		//__mcList.setupChild = Delegate.create(this, onSetupChild);
		__mcList.addEventListener(ShurikenEvent.COLUMN_WIDTH_CHANGED, Delegate.create(this, onColumnWidthChanged));
		__mcList.addEventListener(ShurikenEvent.ROW_HEIGHT_CHANGED, Delegate.create(this, onRowHeightChanged));		

		__mcList.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onItemClicked))
		__mcList.addEventListener(ShurikenEvent.ITEM_SELECTION_CHANGED, Delegate.create(this, onItemSelectionChanged))
	
		__mcList.childClass = __childClass;
	}
	
	private function setupButtons():Void
	{
		__mcScrollPrevious = SimpleButton(attachMovie(SimpleButton.SYMBOL_NAME, "__mcScrollPrevious", getNextHighestDepth()));
		__mcScrollPrevious.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onScrollPrevious));
		__mcScrollPrevious.setSize(__width, 4);
		
		__mcScrollNext = SimpleButton(attachMovie(SimpleButton.SYMBOL_NAME, "__mcScrollNext", getNextHighestDepth()));
		__mcScrollNext.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onScrollNext));		
		__mcScrollNext.setSize(__width, 4);
	}
	
	// proxy event
	private function onSetupChild(p_event:ShurikenEvent):Void
	{	
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.SETUP_CHILD, this);
		event.child = p_event.child;
		event.list = p_event.list;
		dispatchEvent(event);
	}
	
	private function onItemClicked(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ScrollableList::onItemClicked");
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.child = p_event.child;
		event.item = p_event.item;
		event.index = p_event.index;
		dispatchEvent(event);	
	}
	
	private function onItemSelectionChanged(p_event:ShurikenEvent):Void
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_SELECTION_CHANGED, this);
		event.lastSelected = p_event.lastSelected;
		event.selected = p_event.selected;
		event.item = p_event.item;
		event.index = p_event.index;
		dispatchEvent(event);
	}
	
	private function commitProperties():Void
	{
		if(__mcList.isBuilding == true) return;
		
		super.commitProperties();
		
		if(__childSetValueFunctionDirty == true)
		{
			__mcList.childSetValueFunction = __childSetValueFunction;
			__childSetValueFunctionDirty = false;
		}
		
		if(__childSetValueScopeDirty == true)
		{
			__childSetValueScopeDirty = false;
			__mcList.childSetValueScope = __childSetValueScope;	
		}
		
		if(__childClassDirty == true)
		{
			__childClassDirty = false;
			__mcList.childClass = __childClass;
		}
		
		if(__dataProviderDirty == true)
		{			

			__dataProviderDirty = false;
			
			__mcList.dataProvider = __dataProvider;
			pageIndex = 0;
		}
		
		if(__directionDirty == true)
		{
			__directionDirty = false;
			__mcList.direction = __direction;
			invalidateSize();
		}
		
		if (__showButtonsDirty == true)
		{
			__showButtonsDirty = false;
			invalidateSize();
		}
		
		if(__columnWidthDirty == true)
		{
			__columnWidthDirty = false;
			__mcList.columnWidth = __columnWidth;
		}
		
		if(__rowHeightDirty == true)
		{
			__rowHeightDirty = false;
			__mcList.rowHeight = __rowHeight;
		}
		
		if (__toggleDirty == true){
			__toggleDirty = false
			__mcList.toggle = __toggle
		}
		
		if (__selectedIndexDirty == true){
			__selectedIndexDirty = false
			__mcList.selectedIndex = __selectedIndex
		}
	}
	
	private function draw():Void
	{
		if(__mcList.isBuilding == true) return;
		
		super.draw();
	}
	
	private function size():Void
	{
		if(__mcList.isBuilding == true) return;
		
		//DebugWindow.debugHeader();
		//DebugWindow.debug("ScrollableList::size, __width: " + __width + ", __columnWidth: " + __columnWidth);
		
		super.size();
		
		if (__showButtons == true)
		{	
			__mcScrollPrevious.move(0, 0);
			
			if(__mcList.direction == List.DIRECTION_HORIZONTAL)
			{
				var listWidth:Number = width - __mcScrollPrevious.width - __mcScrollNext.width;
				listWidth = Math.max(0, listWidth)
				
				__mcList.setSize(listWidth, height);
				
				__mcList.move(__mcScrollPrevious.x + __mcScrollPrevious.width, 0);
				__mcScrollNext.move(__mcList.x + __mcList.width, 0);
			}
			else
			{
				
				var listHeight:Number = Math.max(0, height - __mcScrollPrevious.height - __mcScrollNext.height);
				__mcList.setSize(width, listHeight);
				__mcList.move(0, __mcScrollPrevious.y + __mcScrollPrevious.height);
				__mcScrollNext.move(0, __mcList.y + __mcList.height);
				__mcScrollNext.swapDepths(Math.max(__mcScrollNext.getDepth(), 9999));
			}
			
			__mcScrollPrevious.setSize(__width, __mcScrollPrevious.height);
			__mcScrollNext.setSize(__width, __mcScrollNext.height);
			
			__mcScrollPrevious.clear()
			__mcScrollPrevious.lineStyle(0, 0x333333)
			__mcScrollPrevious.beginFill(0xCCCCCC);
			DrawUtils.drawBox(__mcScrollPrevious, 0, 0, __mcScrollPrevious.width - 1, __mcScrollPrevious.height)
			var centerX:Number = __width / 2;
			var tW:Number = 6;
			var tH:Number = 4;
			DrawUtils.drawTriangle(__mcScrollPrevious, centerX - (tW / 2), tH, tW, tH);
			__mcScrollPrevious.beginFill(0x333333);
			DrawUtils.drawTriangle(__mcScrollPrevious, centerX - (tW / 2), tH, tW, tH);
			__mcScrollPrevious.endFill();
		
			__mcScrollNext.clear();
			__mcScrollNext.lineStyle(0, 0x333333);
			__mcScrollNext.beginFill(0xCCCCCC);
			DrawUtils.drawBox(__mcScrollNext, 0, 0, __mcScrollNext.width - 1, __mcScrollNext.height);
			DrawUtils.drawTriangle(__mcScrollNext, centerX - (tW / 2), 0, tW, tH, 180);
			__mcScrollNext.beginFill(0x333333);
			DrawUtils.drawTriangle(__mcScrollNext, centerX - (tW / 2), 0, tW, tH, 180);
			__mcScrollNext.endFill()
			
			__mcScrollPrevious.visible = true;
			__mcScrollNext.visible = true;			
		}
		else
		{
			__mcScrollPrevious.visible = false;
			__mcScrollNext.visible = false;
			
			__mcScrollPrevious.move(0, 0);
			__mcScrollNext.move(0, 0);
			
			__mcList.setSize(width, height);
			__mcList.move(0, 0);
			
			//__mcScrollPrevious.setSize(0, 0) 
			//__mcScrollNext.setSize(0, 0) 
		}
		
		__mcListMask._x = __mcList.x;
		__mcListMask._y = __mcList.y;

		com.jxl.shuriken.utils.DrawUtils.drawMask(__mcListMask, 0, 0, __mcList.width, __mcList.height);	
		
		/*
		clear();
		lineStyle(0, 0x666666);
		DrawUtils.drawDashLineBox(this, 0, 0, width, height, 3, 3);
		endFill();
		*/
	}
	
	public function onScrollPrevious(event:Object):Void
	{
		if(__mcList.isBuilding == true) return;
		var pageSize = (__mcList.direction == List.DIRECTION_HORIZONTAL) ? __mcList.horizontalPageSize : __mcList.verticalPageSize;	
		var lastPage : Number = Math.ceil(__dataProvider.getLength() / pageSize);
	
		if(pageIndex - 1 > -1){
			pageIndex--;
			scrollToNewPosition();
		}
		
	}
	
	public function onScrollNext(event:Object):Void
	{
		if(__mcList.isBuilding == true) return;
		var pageSize = (__mcList.direction == List.DIRECTION_HORIZONTAL) ? __mcList.horizontalPageSize : __mcList.verticalPageSize;
		var lastPage : Number = Math.ceil(__dataProvider.getLength() / pageSize);

		if (pageIndex + 1 < lastPage){
			pageIndex++;
			scrollToNewPosition();
		}
	}
	
	private function scrollToNewPosition():Void
	{
		if(__tweenScroll != null) TweenManager.abortTween(__tweenScroll);
		
		if(__mcList.direction == List.DIRECTION_HORIZONTAL)
		{			
			if(__mcList.horizontalPageSize == null || __mcList.horizontalPageSize == 0) return;
			
			var newIndex:Number = Math.min( pageIndex * __mcList.horizontalPageSize, (__dataProvider.getLength() - __mcList.horizontalPageSize))
			
			
			
			if(newIndex + __mcList.horizontalPageSize > __dataProvider.getLength()){
				newIndex = __dataProvider.getLength() - (newIndex + __mcList.horizontalPageSize);
			}
						
			var targetX:Number =  newIndex * (__mcList.columnWidth + __mcList.childHorizontalMargin);
			targetX -= __mcList.childHorizontalMargin;
			targetX -= __mcScrollPrevious.x + __mcScrollPrevious.width - __mcList.childHorizontalMargin;
					
			targetX = -targetX;
			
			__tweenScroll = new Tween(this, __mcList.x, targetX, scrollSpeed);
			__tweenScroll.easingEquation = Strong.easeOut;
			__tweenScroll.setTweenHandlers("onTweenHScrollUpdate", "onTweenHScrollEnd");
		}
		else
		{
			if(__mcList.verticalPageSize == null || __mcList.verticalPageSize == 0) return;
			
			var newIndex:Number = Math.min( pageIndex * __mcList.verticalPageSize, (__dataProvider.getLength() - __mcList.verticalPageSize))
			
			if(newIndex + __mcList.verticalPageSize > __dataProvider.getLength())
			{
				newIndex = __dataProvider.getLength() - (newIndex + __mcList.verticalPageSize);
			}
			
			var targetY:Number = newIndex * (__mcList.rowHeight + __mcList.childVerticalMargin);
			targetY -= __mcList.childVerticalMargin;
			targetY -= __mcScrollPrevious.y + __mcScrollPrevious.height - __mcList.childVerticalMargin;
			targetY = -targetY;
			
			__tweenScroll = new Tween(this, __mcList.y, targetY, scrollSpeed);
			__tweenScroll.easingEquation = Strong.easeOut;
			__tweenScroll.setTweenHandlers("onTweenVScrollUpdate", "onTweenVScrollEnd");
		}
	}
	
	private function onColumnWidthChanged(p_event:ShurikenEvent):Void
	{
		dispatchEvent(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
	}
	
	private function onRowHeightChanged(p_event:ShurikenEvent):Void
	{	
		dispatchEvent(new ShurikenEvent(ShurikenEvent.ROW_HEIGHT_CHANGED, this));	
	}
	
	private function onTweenHScrollUpdate(pVal:Number):Void
	{
		__mcList.move(pVal, __mcList.y);
	}
	
	private function onTweenHScrollEnd(pVal:Number):Void
	{
		onTweenHScrollUpdate(pVal);
	}
	
	private function onTweenVScrollUpdate(pVal:Number):Void
	{
		__mcList.move(__mcList.x, pVal);
	}
	
	private function onTweenVScrollEnd(pVal:Number):Void
	{
		onTweenVScrollUpdate(pVal);
	}
	
	// Collection implementation
	public function addItem(p_item:Object):Void
	{
		__dataProvider.addItem(p_item);
	}
	
	public function addItemAt(p_item:Object, p_index:Number):Void
	{
		__dataProvider.addItemAt(p_item, p_index);	
	}
	
	public function getItemAt(p_index:Number):Object
	{
		return __dataProvider.getItemAt(p_index);
	}
	
	public function getItemIndex(p_item:Object):Number
	{
		return __dataProvider.getItemIndex(p_item);	
	}
	
	public function itemUpdated(p_item:Object, p_propName:String, p_oldVal:Object, p_newVal:Object ):Void
	{
		__dataProvider.itemUpdated(p_item, p_propName, p_oldVal, p_newVal);
	}

	public function removeAll():Void
	{
		__dataProvider.removeAll();
	}
	
	public function removeItemAt(p_index:Number):Object
	{
		return __dataProvider.removeItemAt(p_index);
	}
	
	public function setItemAt(p_item:Object, p_index:Number):Object
	{
		return __dataProvider.setItemAt(p_item, p_index);
	}
	
	public function getLength():Number
	{
		return __dataProvider.getLength();
	}
	
	// IList implementation
	public function setDirection(p_direction:String):Void { direction = p_direction; }
	public function getDirection():String { return __direction; }
	
	public function getHorizontalPageSize():Number { return __horizontalPageSize; }
	public function getVerticalPageSize():Number { return __verticalPageSize; }
	
	public function getChildClass():Function { return __childClass; }
	public function setChildClass(p_class:Function):Void { childClass = p_class; }
	
	public function getChildSetValueFunction():Function
	{
		return __childSetValueFunction;
	}
	public function setChildSetValueFunction(p_function:Function):Void { childSetValueFunction = p_function; }
	
	public function getChildSetValueScope():Object { return __childSetValueScope; }
	public function setChildSetValueScope(p_val:Object):Void { childSetValueScope = p_val; }
	
	public function getColumnWidth():Number { return __columnWidth; }
	public function setColumnWidth(p_val:Number):Void { columnWidth = p_val; }
	
	public function getRowHeight():Number { return __rowHeight; }
	public function setRowHeight(p_val:Number):Void	{ rowHeight = p_val; }
	
	public function getAlign():String { return __align; }
	public function setAlign(p_val:String):Void { align = p_val; }
	
	public function getChildHorizontalMargin():Number { return __childHorizontalMargin; }
	public function setChildHorizontalMargin(p_val:Number):Void { childHorizontalMargin = p_val; }
	
	public function getChildVerticalMargin():Number { return __childVerticalMargin; }
	public function setChildVerticalMargin(p_val:Number):Void { childVerticalMargin = p_val; }
	
	public function getAutoSizeToChildren():Boolean { return __autoSizeToChildren; }
	public function setAutoSizeToChildren(p_val:Boolean):Void { autoSizeToChildren = p_val; }
	
	public function getDataProvider():Collection { return __dataProvider; }
	public function setDataProvider(p_val:Collection):Void { dataProvider = p_val; }
	
}