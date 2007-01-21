import com.jxl.shuriken.vo.MovieClipBuilderTicketVO;
import mx.utils.Delegate;
import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import mx.events.EventDispatcher;

class com.jxl.shuriken.managers.MovieClipBuilder implements ICollection
{
	
	public static function getInstance():MovieClipBuilder
	{
		if(__inst == null) __inst = new MovieClipBuilder();
		return __inst;
	}
	
	public function init(p_process_mc:MovieClip):Void
	{
		__process_mc = p_process_mc;
		__buildDelegate = Delegate.create(this, buildQueue);
		__queue = [];
		processNext();
	}
	
	public function attachMovieDeferred(p_listener:MovieClip,
										p_linkage:String,
										p_name:String,
										p_depth:Number,
										p_initObj:Object):MovieClipBuilderTicketVO
	{
		var mcbtVO:MovieClipBuilderTicketVO = new MovieClipBuilderTicketVO(p_listener,
																		   p_linkage,
																		   p_name,
																		   p_depth,
																		   p_initObj);
		addItem(mcbtVO);
		return mcbtVO;
	}
	
	public function addItem(p_item:Object):Void
	{
		var mcbtVO:MovieClipBuilderTicketVO = MovieClipBuilderTicketVO(p_item);
		__queue.push(mcbtVO);
		processNext();
	}
	
	public function addItemAt(p_item:Object, p_index:Number):Void
	{
		var mcbtVO:MovieClipBuilderTicketVO = MovieClipBuilderTicketVO(p_item);
		__queue.splice(p_index, 0, mcbtVO);
		processNext();
	}
	
	public function getItemAt(p_index:Number):Object
	{
		return __queue[p_index];
	}
	
	public function getItemIndex(p_item:Object):Number
	{
		var i:Number = __queue.length;
		while(i--)
		{
			var o = __queue[i];
			if(o == p_item)
			{
				return i;
			}
		}
		return -1;
	}
	
	public function itemUpdated(p_item:Object, p_propName:String, p_oldVal:Object, p_newVal:Object ):Void 
	{
		p_item[p_propName] = p_newVal;
	}
	
	public function removeAll():Void
	{
		__queue.splice(0);
		stopProcessing();
	}
	
	public function removeItemAt(p_index:Number):Object
	{
		var removedItems:Array = __queue.splice(p_index, 1);
		processNext();
		return removedItems[0];
	}
	
	public function setItemAt(p_item:Object, p_index:Number):Object
	{
		var removedItems:Array = __queue.splice(p_index, 1, p_item);
		processNext();
		return removedItems[0];
	}
	
	public function getLength():Number
	{
		return __queue.length;
	}
	
	private function processNext():Void
	{
		if(__isProcessing == false)
		{
			if(__queue.length > 0)
			{
				__isProcessing = true;
				var ref:MovieClip = __process_mc.createEmptyMovieClip(__processClipName, __processClipDepth);
				ref.onEnterFrame = __buildDelegate;
			}
		}
	}
	
	private function stopProcessing():Void
	{
		__isProcessing = false;
		delete __process_mc[__processClipName].onEnterFrame;
		__process_mc[__processClipName].removeMovieClip();
	}
	
	private function buildQueue():Void
	{
		if(__queue.length > 0)
		{
			var currentQueue:MovieClipBuilderTicketVO = MovieClipBuilderTicketVO(__queue[0]);
			var parent:MovieClip = currentQueue.target;
			var newClip:MovieClip = parent.attachMovie(currentQueue.linkage,
													   currentQueue.name,
													   currentQueue.depth,
													   currentQueue.initObject);
			currentQueue.newClip = newClip;
			currentQueue.complete();
			__queue.splice(0, 1);
		}
		else
		{
			if(__queue.length < 1)
			{
				//trace("no more queues left.");
				stopProcessing();
			}
		}
	}
	
	private var __process_mc:MovieClip;
	private var __queue:Array;
	private var __buildDelegate:Function;
	private var __processClipName:String = "processor";
	private var __processClipDepth:Number = 0;
	private var __isProcessing:Boolean = false;
	
	// Not used for now
	public function addEventListener(p_type:String, p_list:Object):Void{}
	public function dispatchEvent(p_event:Event):Void{}
	public function removeEventListener(p_type:String, p_list:Object):Void{}
	
	private static var makeEventDispatcher = EventDispatcher.initialize(com.jxl.shuriken.managers.MovieClipBuilder.prototype);
	
	private static var __inst:MovieClipBuilder;
}