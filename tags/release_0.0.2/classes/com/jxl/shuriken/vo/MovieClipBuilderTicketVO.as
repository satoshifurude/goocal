import com.jxl.shuriken.vo.IValueObject;
import com.jxl.shuriken.events.IEventDispatcher;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import mx.events.EventDispatcher;

class com.jxl.shuriken.vo.MovieClipBuilderTicketVO implements IValueObject, IEventDispatcher
{
	
	public var linkage:String;
	public var name:String;
	public var depth:Number;
	public var initObject:Object;
	public var target:MovieClip;
	public var newClip:MovieClip	= null;
	public var index:Number;
	
	public function MovieClipBuilderTicketVO(p_target:MovieClip,
											 p_linkage:String,
											 p_name:String,
											 p_depth:Number,
											 p_initObject:Object)
	{
		target 			= p_target;
		linkage			= p_linkage;
		name			= p_name;
		depth			= p_depth;
		initObject		= p_initObject;
	}
	
	public function complete():Void
	{
		dispatchEvent(new ShurikenEvent(ShurikenEvent.MOVIE_CLIP_CREATED, this));
	}
	
	public function clone():IValueObject
	{
		var mcbtVO:MovieClipBuilderTicketVO = new MovieClipBuilderTicketVO(target,
																		   linkage,
																		   name,
																		   depth,
																		   initObject);
		mcbtVO.newClip = newClip;
		return mcbtVO;
	}
	
	// overwritten by mixin (EventDispatcher)
	public function addEventListener(p_type:String, p_list:Object):Void{}
	public function dispatchEvent(p_event:Event):Void{}
	public function removeEventListener(p_type:String, p_list:Object):Void{}
	
	private static var __makeEventDispatcherMixin = EventDispatcher.initialize(com.jxl.shuriken.vo.MovieClipBuilderTicketVO.prototype);
}