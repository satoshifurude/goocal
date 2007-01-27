import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.containers.ScrollableList;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.controls.Button;

import com.jxl.goocal.views.EventItem;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.views.GCUpArrowButton;
import com.jxl.goocal.views.GCDownArrowButton;


class com.jxl.goocal.views.EventList extends ScrollableList
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.EventList";
	
	private var __childClass:Function 					= EventItem;
	private var __childClassDirty:Boolean = true;
	private var __childSetValueFunction:Function		= refreshEventItem;
	private var __childSetValueFunctionDirty:Boolean = true;
	private var __mcScrollPrevious:GCUpArrowButton;
	private var __mcScrollNext:GCDownArrowButton;
	private var __showButtons:Boolean = true;
	private var __childVerticalMargin:Number = 12;
			
	public function EventList()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		__childSetValueScope = this;
	}
	
	private function setupList():Void
	{
		super.setupList();
		__mcList.rowHeight = 40;
	}
	
	private function setupButtons():Void
	{
		__mcScrollPrevious = GCUpArrowButton(createComponent(GCUpArrowButton, "__mcScrollPrevious"));
		__mcScrollPrevious.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onScrollPrevious));
		
		__mcScrollNext = GCDownArrowButton(createComponent(GCDownArrowButton, "__mcScrollNext"));
		__mcScrollNext.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onScrollNext));		
	}
	
	public function onSetupChild(p_event:ShurikenEvent):Void
	{
		super.onSetupChild(p_event);
		EventItem(p_event.child).addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onEventItemClicked));
	}
	
	public function setSize(p_width:Number, p_height:Number):Void
	{
		__columnWidth = p_width;
		__mcList.setColumnWidthNoRedraw(__columnWidth);
		super.setSize(p_width, p_height);
	}
	
	private function size():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("EventList::size, __width: " + __width + ", __columnWidth: " + __columnWidth);
		
		__columnWidth = __width;
		__mcList.setColumnWidthNoRedraw(__columnWidth);
		super.size();
		
		__mcScrollPrevious.setSize(width, __mcScrollPrevious.height);
		__mcScrollNext.setSize(width, __mcScrollNext.height);
	}
	
	private function refreshEventItem(p_child:UIComponent, p_index:Number, p_item:Object):Void
	{
		var vo:EntryVO = EntryVO(p_item);
		EventItem(p_child).eventTime = vo.toHourString();
		EventItem(p_child).eventName = vo.title;
	}
	
	private function onEventItemClicked(p_event:ShurikenEvent):Void
	{
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.ITEM_CLICKED, this);
		event.lastSelected = null; // TODO: fix this
		event.selected = UIComponent(p_event.target);
		var childIndex:Number = __mcList.getChildIndex(UIComponent(p_event.target));
		event.item = __dataProvider.getItemAt(childIndex);
		dispatchEvent(event);
	}
	
}