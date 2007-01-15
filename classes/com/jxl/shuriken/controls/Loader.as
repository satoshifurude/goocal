import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;


[Event("loadComplete")]
[Event("loadInit")]
class com.jxl.shuriken.controls.Loader extends UIComponent
{
	
	public static var symbolName:String = "com.jxl.shuriken.controls.Loader";
	public static var symbolOwner:Object = com.jxl.shuriken.controls.Loader;
	
	public static var EVENT_LOAD_COMPLETE:String = "loadComplete";
	public static var EVENT_LOAD_INIT:String = "loadInit";
		
	public var className:String = "Loader";
	
	public function get contentPath():String { return __contentPath; }
	
	public function get isLoading():Boolean { return __isLoading; }
	
	public function get content():MovieClip { return __content.holder; }
	
	[Inspectable(type="Booolean", defaultValue=false, name="Scale Content")]
	public function get scaleContent():Boolean { return __scaleContent; }
	
	public function set scaleContent(pbScale:Boolean):Void
	{
		__scaleContent = pbScale;
		__scaleContentDirty = true;
		invalidateProperties();
	}
	
	private var __scaleContent:Boolean				= false;
	private var __scaleContentDirty:Boolean			= false;
	
	private var __content:MovieClip;
	private var __loadWatcher:MovieClip;
	private var __isLoading:Boolean;
	private var __clipLoader:MovieClipLoader;
	private var __contentPath:String;
	
	public function load(pPath:String):Void
	{
		__contentPath = pPath;
		
		__clipLoader.removeListener(this);
		delete __clipLoader;
		
		__content.removeMovieClip();
		delete __content;
		
		__isLoading = true;
		
		// NOTE: Why holder?  MovieClip's can get corrupted.  Dynamic ones
		// can still be removed, but authortime cannot.  Out of paranoia, we shield ourselves
		// from infection by wrapping it with a clip that houses it.
		createEmptyMovieClip("__content", getNextHighestDepth());
		
		if(pPath.indexOf(".") != -1)
		{
			__content.createEmptyMovieClip("holder", 0);
			__clipLoader = new MovieClipLoader();
			__clipLoader.addListener(this);
			__clipLoader.loadClip(pPath, __content.holder);
		}
		else
		{
			
			__content.attachMovie(pPath, "holder", 0);
			onLoadComplete(__content.holder);
			callLater(this, _onLoadInit, __content.holder);
		}
		
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__scaleContentDirty == true)
		{
			__scaleContentDirty = true;
			invalidateSize();
		}
	}
	
	private function onLoadComplete(pmcTarget:MovieClip, pHTTPStatus:String):Void
	{
		__isLoading = false;
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.LOAD_COMPLETE, this);
		event.loaderTarget = pmcTarget;
		event.httpStatus = pHTTPStatus;
		dispatchEvent(event);
	}
	
	private function onLoadInit(pmcTarget:MovieClip):Void
	{		
		callLater(this, _onLoadInit)
	}
	
	private function _onLoadInit(pmcTarget:MovieClip):Void
	{
		if(__scaleContent == false)
		{	
			if(__content instanceof UIComponent)
			{
				setSize(__content.width,  __content.height);
			}
			else
			{
				setSize(__content._width, __content._height);
			}
		}
		else
		{
			if(__content instanceof UIComponent)
			{
				__content.setSize(width, height);
			}
			else
			{
				__content._width = width;
				__content._height = height;
			}
		}	
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.LOAD_INIT, this);
		event.loaderTarget = pmcTarget;
		dispatchEvent(event);	
	}
}