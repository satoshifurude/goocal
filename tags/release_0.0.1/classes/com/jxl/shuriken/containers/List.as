import mx.utils.Delegate;

import com.jxl.shuriken.core.Container;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.core.IUIComponent;
import com.jxl.shuriken.core.IList;
import com.jxl.shuriken.events.ShurikenEvent;

[InspectableList("direction", "columnWidth", "rowHeight", "align", "childHorizontalMargin", "childVerticalMargin")]
class com.jxl.shuriken.containers.List extends Container implements ICollection, IList
{
	public static var SYMBOL_NAME:String 					= "com.jxl.shuriken.containers.List";
	
	public static var ALIGN_LEFT:String 					= "left";
	public static var ALIGN_CENTER:String 					= "center";
	
	public static var EVENT_COL_WIDTH_CHANGED:String 		= "columnWidthChanged";
	public static var EVENT_ROW_HEIGHT_CHANGED:String 		= "rowWidthChanged";
	public static var EVENT_SETUP_CHILD:String 				= "childSetup";
	
	public static var DIRECTION_HORIZONTAL:String 			= "horizontal";
	public static var DIRECTION_VERTICAL:String 			= "vertical";
	
	[Inspectable(type="List", enumeration="horizontal,vertical", defaultValue="horizontal")]
	public function get direction():String { return __direction; }
	
	public function set direction(pVal:String):Void
	{
		__direction = pVal;
		__directionDirty = true;
		invalidateProperties();
	}
	
	public function get horizontalPageSize():Number { return __horizontalPageSize; }
	
	public function get verticalPageSize():Number { return __verticalPageSize; }
	
	public function get childClass():Function { return __childClass; }
	
	public function set childClass(p_class:Function):Void
	{
		__childClass = p_class;
		invalidateDraw();
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
	
	[Inspectable(defaultValue=null, type="Number", name="Column Width")]
	public function get columnWidth():Number { return __columnWidth; }
	
	public function set columnWidth(p_val:Number):Void
	{
		__columnWidth = p_val;
		calculateHorizontalPageSize();
		__columnWidthDirty = true;
		__autoSizeToChildren = false;
		__autoSizeToChildrenDirty = true;
		invalidateProperties();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
	}
	
	[Inspectable(defaultValue=null, type="Number", name="Row Height")]
	public function get rowHeight():Number { return __rowHeight; }
	
	public function set rowHeight(pVal:Number):Void
	{
		__rowHeight = pVal;
		calculateVerticalPageSize();
		__rowHeightDirty = true;
		__autoSizeToChildren = false;
		__autoSizeToChildrenDirty = true;
		invalidateProperties();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.ROW_HEIGHT_CHANGED, this));
		size();
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
	
	public function get dataProvider():ICollection { return __dataProvider; }
	
	public function set dataProvider(p_val:ICollection):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("List::dataProvider::setter, p_val: " + p_val);
		__isBuilding = true;
		if(__dataProvider != null)
		{
			var oldDP:ICollection = __dataProvider;
			if(__collectionDelegate != null)
			{
				__dataProvider.removeEventListener(ShurikenEvent.COLLECTION_CHANGED, __collectionDelegate);
			}
		}
		if(__collectionDelegate == null) __collectionDelegate = Delegate.create(this, onCollectionChanged);
		__dataProvider = p_val;
		if(__dataProvider == oldDP) __dataProvider.removeEventListener(ShurikenEvent.COLLECTION_CHANGED, __collectionDelegate);
		__dataProvider.addEventListener(ShurikenEvent.COLLECTION_CHANGED, __collectionDelegate);
		__dataProviderDirty = true;
		invalidateProperties();
	}
	
	public function get isBuilding():Boolean { return __isBuilding; }
	
	private var __isBuilding:Boolean							= false;
	private var __childClass:Function							= Label;
	private var __childSetValueFunction:Function				= refreshSetValue;
	private var __childSetValueScope:Object;
	

	private var __align:String									= "left";
	
	private var __childHorizontalMargin:Number					= 0;
	private var __horizontalPageSize:Number						= 0;
	private var __rowHeight:Number								= 18;
	private var __rowHeightDirty:Boolean;
		
	private var __childVerticalMargin:Number					= 0;
	private var __verticalPageSize:Number						= 0;
	private var __columnWidth:Number							= 100;	
	private var __columnWidthDirty:Boolean;	
	
	private var __direction:String								= "vertical";
	private var __autoSizeToChildren:Boolean					= true;
	
	private var __childSetValueFunctionDirty:Boolean;
	private var __childSetValueScopeDirty:Boolean;
	private var __alignDirty:Boolean;
	private var __childHorizontalMarginDirty:Boolean;
	private var __childVerticalMarginDirty:Boolean;
	private var __directionDirty:Boolean;
	private var __autoSizeToChildrenDirty:Boolean;
	
	private var __highestChildDepth:Number;
	
	private var __dataProvider:ICollection;
	private var __dataProviderDirty:Boolean						= false;
	private var __collectionDelegate:Function;
	
	public function List()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		__childSetValueScope = this;
	}
	
	// Overriding
	public function setSize(p_width:Number, p_height:Number):Void
	{
		super.setSize(p_width, p_height);
		
		calculateHorizontalPageSize();
		calculateVerticalPageSize();
	}
	
	public function refreshSetValues():Void
	{
		var i:Number = __dataProvider.getLength();
		while(i--)
		{
			var item:Object = __dataProvider.getItemAt(i);
			var child:IUIComponent = getChildAt(i);
			//trace("getChildAt(i): " + getChildAt(i));
			//trace("child: " + child);
			__childSetValueFunction.call(__childSetValueScope, child, i, item);
		}
	}
	
	// Should be set via outside class, by default is to look for data setter
	public function refreshSetValue(p_child:IUIComponent, p_index:Number, p_item:Object):Void
	{
		//trace("refreshSetValue, p_child: " + p_child + ", p_index: " + p_index + ", p_item: " + p_item);
		if(p_child instanceof Label)
		{
		//	trace("label");
			Label(p_child).text = p_item.toString();
		}
		else if(p_child instanceof Button)
		{
			//trace("button");
			// FIXME: Dependency; could possibly re-factor to ensure
			// this class isn't included in the SWF if the developer
			// doesn't want it to be
			Button(p_child).label = p_item.toString();
		}
		else if(p_child instanceof SimpleButton)
		{
			//trace("simple button");
		}
		else if(p_child instanceof IUIComponent)
		{
			//trace("IUIComponent");
			p_child.setData(p_item.toString());
		}
	}
	
	// Called on each child before its setValue function
	// allows a subclass of list to set up a child without using the setValue function.
	
	public function setupChild(p_child:IUIComponent)
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.SETUP_CHILD, this);
		event.child = p_child;
		event.list = this;
		dispatchEvent(event);
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__childSetValueFunctionDirty == true || __childSetValueScopeDirty == true)
		{
			__childSetValueFunctionDirty = false;
			__childSetValueScopeDirty = false;
			refreshSetValues();
		}
		
		if(__columnWidthDirty == true)
		{
			__columnWidthDirty = false;
			invalidateSize();
		}
		
		if(__alignDirty == true)
		{
			__alignDirty = false;
			invalidateSize();
		}
		
		if(__childHorizontalMarginDirty == true)
		{
			__childHorizontalMarginDirty = false;
			invalidateSize();
		}
		
		if(__childVerticalMarginDirty == true)
		{
			__childVerticalMarginDirty = false;
			invalidateSize();
		}
		
		if(__directionDirty == true)
		{
			__directionDirty = false;
			invalidateDraw();
		}
		
		if(__autoSizeToChildrenDirty == true)
		{
			__autoSizeToChildrenDirty = false;
			invalidateDraw();
		}
		
		if(__dataProviderDirty == true)
		{
			__dataProviderDirty = false;
			invalidateDraw();
		}
	}
	
	public function getPreferredHeight(p_visibleRowCount:Number):Number
	{
		var preferredHeight:Number = (p_visibleRowCount * (__rowHeight  + __childVerticalMargin)) - __childVerticalMargin;
		return preferredHeight;
	}
	
	public function getPreferredWidth(p_visibleColCount:Number):Number
	{
		var preferredWidth:Number = (p_visibleColCount * (__columnWidth * __childHorizontalMargin)) - __childHorizontalMargin;
		return preferredWidth;
	}
	
	private var __currentDrawIndex:Number = -1;
	
	private function draw():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("List::draw");
		
		removeAllChildren();
		var len:Number = __dataProvider.getLength();
		
		//DebugWindow.debug("__dataProvider: " + __dataProvider);
		//DebugWindow.debug("__dataProvider.getLength: " + __dataProvider.getLength);
		//DebugWindow.debug("len: " + len);
		
		if (len < 1 || len == undefined) return

		// we do the first one out of the loop.  That way, if the developer
		// hasn't set a column width (columnWidth), we'll just grab the first child
		// and assume the rest are the same width.
		var i:Number = 0;
		var item:Object = __dataProvider.getItemAt(i);
		var child:IUIComponent = createChildAt(i, __childClass);
		
		//trace("__childClass: " + __childClass);
		//trace("child: " + child);
		
		__childSetValueFunction.call(__childSetValueScope, child, i, item);
		
		if(__autoSizeToChildren == true)
		{
			__columnWidth = child.getWidth();
			calculateHorizontalPageSize();
			dispatchEvent(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
		
			__rowHeight = child.getHeight();
			calculateVerticalPageSize();
			dispatchEvent(new ShurikenEvent(ShurikenEvent.ROW_HEIGHT_CHANGED, this));
		}
		
		setupChild(child);
		
		/*
		// now do the rest
		for(i = 1; i<len; i++)
		{
			item = __dataProvider.getItemAt(i);
			child = createChildAt(i, __childClass);
			//trace("child2: " + child);
			//gives one the opportunity to set up a child,
			//before the childSetValueFunction is called
			setupChild(child);
			
			__childSetValueFunction.call(__childSetValueScope, child, i, item);
		}
		
		size();
		*/
		
		if(len > 1)
		{
			__currentDrawIndex = 0;
			callLater(this, drawNext);
		}
	}
	
	private function drawNext():Void
	{
		//trace("-----------------");
		//trace("List::drawNext");
		//trace("__currentDrawIndex: " + __currentDrawIndex);
		if(__currentDrawIndex + 1 < __dataProvider.getLength())
		{
			__currentDrawIndex++;
			var item:Object = __dataProvider.getItemAt(__currentDrawIndex);
			var child:IUIComponent = createChildAt(__currentDrawIndex, __childClass);
			setupChild(child);
			__childSetValueFunction.call(__childSetValueScope, child, __currentDrawIndex, item);
			callLater(this, drawNext);
		}
		else
		{
			callLater(this, size);
		}
	}
	
	private function size():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("List::size, __width: " + __width + ", __columnWidth: " + __columnWidth);
		super.size();
		
		var howManyChildren:Number = numChildren;
		
		if(__direction == DIRECTION_HORIZONTAL)
		{
			if(__align == ALIGN_LEFT)
            {
				var origX:Number = 0;
				for(var i:Number = 0; i<howManyChildren; i++)
				{
					var child:IUIComponent = getChildAt(i);
					child.move(origX, 0);
					child.setSize(__columnWidth, __rowHeight);
					origX += __columnWidth + __childHorizontalMargin;
				}
			}
			else if(__align == ALIGN_CENTER)
			{
				var totalMenuItemsWidth:Number = (howManyChildren * __columnWidth) + ( (howManyChildren - 1) * __childHorizontalMargin);
				var startX:Number = (width / 2) - (totalMenuItemsWidth / 2);
				for(var i:Number = 0; i<howManyChildren; i++)
				{
					var child:IUIComponent = getChildAt(i);
					child.move(startX, 0);
					child.setSize(__columnWidth, __rowHeight);
					startX += __columnWidth + __childHorizontalMargin;
				}
			}
		}
		else
		{
			var origY:Number = 0;
			for(var i:Number = 0; i<howManyChildren; i++)
			{			
				var child:IUIComponent = getChildAt(i);
				child.move(0, origY);
				//DebugWindow.debug("w: " + __columnWidth + ", h: " + __rowHeight);
				child.setSize(__columnWidth, __rowHeight);
				origY += __rowHeight + __childVerticalMargin;				
			}
		}
		
		__isBuilding = false;
		callLater(this, onDoneBuilding);
	}
	
	public function onDoneBuilding():Void
	{
	}
	
	public function setColumnWidthNoRedraw(p_val:Number):Void
	{
		__columnWidth = p_val;
		calculateHorizontalPageSize();
		dispatchEvent(new ShurikenEvent(ShurikenEvent.COLUMN_WIDTH_CHANGED, this));
	}
	
	// # items that fit in 1 page 
	private function calculateHorizontalPageSize():Void
	{
		var iWidth:Number = __columnWidth + __childHorizontalMargin;
		if (iWidth == undefined || iWidth ==0) iWidth = 1;
		
		__horizontalPageSize = Math.max(Math.floor(__width /iWidth), 1);

		// special case to handle the situation where the final margin pushed us into a new page
		if ( (__horizontalPageSize > 1) && (__width % iWidth == __columnWidth) )
			__horizontalPageSize++;
	}
	
	// # items that fit in 1 page 
	private function calculateVerticalPageSize():Void
	{
		var iHeight:Number = iHeight = __rowHeight + __childVerticalMargin;
		if (iHeight == undefined || iHeight ==0) iHeight = 1;
		
		__verticalPageSize = Math.max(Math.floor(__height / iHeight), 1);

		// special case to handle the situation where the final margin pushed us into a new page
		if ( (__verticalPageSize > 1) && (__height % iHeight == __rowHeight) )
			__verticalPageSize++;
	}
	
	// ICollection implementation
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
	
	public function getDataProvider():ICollection { return __dataProvider; }
	public function setDataProvider(p_val:ICollection):Void { dataProvider = p_val; }
	
	private function onCollectionChanged(p_event:ShurikenEvent):Void
	{
		//trace("-----------------");
		//trace("List::onCollectionChanged");
		//trace("p_event.operation: " + p_event.operation);
		// TODO: add invalidation later, for now, draws are immediate
		
		switch(p_event.operation)
		{
			case ShurikenEvent.REMOVE:
				removeChildAt(p_event.index);
				size();
				break;
			
			case ShurikenEvent.ADD:
				//trace("p_event.index: " + p_event.index);
				var newItem:Object = __dataProvider.getItemAt(p_event.index);
				var addedChild:IUIComponent = createChildAt(p_event.index, 
														   __childClass);
				setupChild(addedChild);
				__childSetValueFunction.call(__childSetValueScope, 
											 addedChild, 
											 p_event.index, 
											 newItem);
				size();
				//trace("newItem: " + newItem);
				//trace("addedChild: " + addedChild);
				break;
				
			case ShurikenEvent.REPLACE:
			case ShurikenEvent.UPDATE:
				var updatedChild:IUIComponent = getChildAt(p_event.index);
				var updatedItem:Object = __dataProvider.getItemAt(p_event.index);
				__childSetValueFunction.call(__childSetValueScope, 
											 updatedChild, 
											 p_event.index, 
											 updatedItem);
				break;
			
			case ShurikenEvent.REMOVE_ALL:
			case ShurikenEvent.UPDATE_ALL:
				draw();
				break;
			
		}
	}
	
}