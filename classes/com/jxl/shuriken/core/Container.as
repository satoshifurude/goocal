import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.IUIComponent;
import com.jxl.shuriken.core.IContainer;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.vo.MovieClipBuilderTicketVO;

class com.jxl.shuriken.core.Container extends UIComponent implements IContainer
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.core.Container";
	
	private static var DEPTH_RESERVED:Number = 6;
	private static var DEPTH_MASK:Number = 5;
	
	public function get numChildren():Number { return __aChild.length; }
	
	public function get clipContent():Boolean { return __clipContent; }
	
	public function set clipContent(val:Boolean):Void
	{
		__clipContent = val;
		__clipContentDirty = true;
		invalidateProperties();
	}
	
	private var __numChildren:Number;
	private var __aChild:Array;
	private var __clipContent:Boolean;
	
	private var __clipContentDirty:Boolean;
	
	// We sometimes have the need to put stuff under all the children, what I call "ghost children".
	// For most use-cases, you could just use Composition, and instead of extending a Container
	// based class, you'd instead just make a class that attaches this class inside it, and puts the GUI
	// elements it needs underneath.  This seperation allows this class to remain clean but requires
	// more code.
	// However, in the case of masking, we need to have some reserved bottom depths.
	// Therefore, all depth calls will start from the __reservedDepth.  We do this by
	// creating a reserved MovieClip at the specified depth.  Therefore, all getNextHighestDepth
	// calls will start from that depth + 1
	private var __mcReservedDepth:MovieClip;
	private var __mcMask:MovieClip;
	
	//Constructor
	public function Container()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		__numChildren = 0;
		__aChild = [];
		__clipContent = false;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		__mcReservedDepth = createEmptyMovieClip("__mcReservedDepth", DEPTH_RESERVED);
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__clipContentDirty == true)
		{
			__clipContentDirty = false;
			__mcMask.removeMovieClip();
			if(__clipContent == true)
			{
				__mcMask.removeMovieClip();
				__mcMask = createEmptyMovieClip("__mcMask", DEPTH_MASK);
				__mcMask.beginFill(0x00FF00, 50);
				__mcMask.lineTo(width, 0);
				__mcMask.lineTo(width, height);
				__mcMask.lineTo(0, height);
				__mcMask.lineTo(0, 0);
				__mcMask.endFill();
				setMask(__mcMask);
				invalidateSize();
			}
		}
	}
	
	private function size():Void
	{
		super.size();
		
		__mcMask._width = width;
		__mcMask._height = height;
	}
	
	public function createChild(p_class:Function, 
								p_name:String, 
								p_initObj:Object):IUIComponent
	{
		return createChildAt(__aChild.length, p_class, p_name, p_initObj);
	}
	
	public function createChildAt(p_index:Number, 
								  p_class:Function, 
								  p_name:String, 
								  p_initObj:Object):IUIComponent
	{
		if(p_class == null)
		{
			// FIXME
			//trace("Container::createChildAt, p_class is null.");
			return;
		}
		
		var d:Number = getNextHighestDepth();
		if(p_name == null) p_name = "child" + p_index + "_" + d;
		
		var linkageName:String;
		if(p_class.hasOwnProperty("SYMBOL_NAME") == true)
		{
			linkageName = p_class["SYMBOL_NAME"];	
		}
		else
		{
			linkageName = p_class.toString();
		}
		
		//var st:Number = getTimer();
		var mc = attachMovie(linkageName, p_name, d, p_initObj);
		//var ct:Number = getTimer();
		//var et:Number = ct - st;
		//trace("et: " + et);
		//var mcbtVO:MovieClipBuilderTicketVO = attachMovieDeferred(this, linkageName, p_name, d, p_initObj);
		//return mcbtVO;
		
		// FIXME: casting is failing, fix later
		var ref = mc;
		if(ref != null) __aChild.splice(p_index, 0, ref);
		dispatchEvent(new ShurikenEvent(ShurikenEvent.CHILD_CREATED, this, ref, p_index));
		return ref;
	}
	
	public function getChildAt(p_index:Number):IUIComponent
	{
		return __aChild[p_index];
	}
	
	public function getChildIndex(p_child:IUIComponent):Number
	{
		var i:Number = __aChild.length;
		while(i--)
		{
			if(__aChild[i] == p_child)
			{
				return i;
			}
		}
		return -1;
	}
	
	public function setChildIndex(p_child:IUIComponent, p_index:Number):Boolean
	{
		var currentIndex:Number = getChildIndex(p_child);
		if(currentIndex == p_index) return false;
		// if higher, remove first to prevent index from getting confused
		if(currentIndex > p_index)
		{
			__aChild.splice(currentIndex, 1);
			__aChild.splice(p_index, 0, p_child);
		}
		// otherwise, it's lower, can't get confused
		else
		{
			__aChild.splice(p_index, 0, p_child);
			__aChild.splice(currentIndex, 1);
		}
		
		var ce:ShurikenEvent = new ShurikenEvent(ShurikenEvent.CHILD_INDEX_CHANGED, this);
		ce.child = p_child;
		ce.oldIndex = currentIndex;
		ce.newIndex = p_index;
		dispatchEvent(ce);
	}
	
	public function removeChildAt(p_index:Number):Void
	{
		var child:UIComponent = __aChild[p_index];
		if(child != null)
		{
			var ce:ShurikenEvent = new ShurikenEvent(ShurikenEvent.CHILD_BEFORE_REMOVED, this);
			ce.child = child;
			ce.index = p_index;
			dispatchEvent(ce);
			
			removeAndCleanup_child(child, p_index);
			
			var cer:ShurikenEvent = new ShurikenEvent(ShurikenEvent.CHILD_REMOVED, this);
			cer.child = child;
			cer.index = p_index;
			dispatchEvent(cer);
		}
	}
	
	public function removeChild(p_child:IUIComponent):Void
	{
		var childIndex:Number = getChildIndex(p_child);
		removeChildAt(childIndex);
	}
	
	public function removeAllChildren():Void
	{
		dispatchEvent(new ShurikenEvent(ShurikenEvent.BEFORE_ALL_CHILDREN_REMOVED, this));
		var i:Number = __aChild.length;
		while(i--)
		{
			removeAndCleanup_child(__aChild[i], i);
		}
		__aChild = [];
		dispatchEvent(new ShurikenEvent(ShurikenEvent.ALL_CHILDREN_REMOVED, this));
	}
	
	private function removeAndCleanup_child(p_child:UIComponent, p_index:Number):Void
	{
		p_child.removeMovieClip();
		__aChild.splice(p_index, 1);
	}
	
	private function getNextNonChildDepth():Number
	{
		for(var i:Number = 0; i<DEPTH_MASK; i++)
		{
			var mc:MovieClip = getInstanceAtDepth(i);
			if(mc == undefined) return i;
		}
		return -1;
	}
	
	// IContainer Implementation
	public function getNumChildren():Number { return __aChild.length; }
	
	
	
	
}