import com.jxl.shuriken.events.IEventDispatcher;
import com.jxl.shuriken.vo.MovieClipBuilderTicketVO;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.managers.MovieClipBuilderGroup implements IEventDispatcher
{
	
	private var __isWatched:Boolean = false;
	private var __queue:Array;
	
	public function get isWatched():Boolean { return __isWatched; }
	public function set isWatched(p_val:Boolean):Void
	{
		__isWatched = p_val;
		checkCompletion();
	}
	
	public function MovieClipBuilderGroup()
	{
	}
	
	public function addTicket(p_mcbtVO:MovieClipBuilderTicketVO):Void
	{
		if(__queue == null) __queue = [];
		p_mcbtVO.addEventListener(ShurikenEvent.MOVIE_CLIP_CREATED, Delegate.create(this, onMCCreated));
		var len:Number = __queue.push(p_mcbtVO);
		p_mcbtVO.index = len - 1;
	}
	
	private function onMCCreated(p_event:ShurikenEvent):Void
	{
		var mcbtVO:MovieClipBuilderTicketVO = MovieClipBuilderTicketVO(p_event.target);
		__queue.splice(mcbtVO.index, 1);
		delete mcbtVO.index;
		checkCompletion();
	}
	
	private function checkCompletion():Void
	{
		if(__isWatched == true)
		{
			if(__queue.length < 1)
			{
				delete __queue;
				dispatchEvent(new ShurikenEvent(ShurikenEvent.MOVIE_CLIPS_CREATED, this));
			}
		}
	}
	
	
	
	// overwritten by mixin (EventDispatcher)
	public function addEventListener(p_type:String, p_list:Object):Void{}
	public function dispatchEvent(p_event:Event):Void{}
	public function removeEventListener(p_type:String, p_list:Object):Void{}
	
	private static var __makeEventDispatcherMixin = EventDispatcher.initialize(com.jxl.shuriken.managers.MovieClipBuilderGroup.prototype);
}