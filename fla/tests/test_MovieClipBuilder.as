import com.jxl.shuriken.managers.MovieClipBuilder;
import com.jxl.shuriken.vo.MovieClipBuilderTicketVO;
import mx.utils.Delegate;
import com.jxl.shuriken.events.ShurikenEvent;

class test_MovieClipBuilder extends MovieClip
{
	private static var inst:test_MovieClipBuilder;
	
	private var root:MovieClip;
	private var counter:Number;
	
	public static function getInstance(p_root:MovieClip):test_MovieClipBuilder
	{
		if(inst == null) inst = new test_MovieClipBuilder(p_root);
		return inst;
	}
	
	public function test_MovieClipBuilder(p_root)
	{
		root = p_root;
	}
	
	public function init():Void
	{
		//trace("----------------");
		//trace("test_MovieClipBuilder::init");
		
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		//fscommand2("FullScreen", true);
		
		var d:Number = root.getNextHighestDepth();
		trace("d: " + d);
		var ref:MovieClip = root.createEmptyMovieClip("movieClipBuilder_mc", d);
		//trace("ref: " + ref);
		var mcb:MovieClipBuilder = MovieClipBuilder.getInstance();
		var ticket1:MovieClipBuilderTicketVO = mcb.attachMovieDeferred(root, "BoundingBox", "test1", 1);
		var ticket2:MovieClipBuilderTicketVO = mcb.attachMovieDeferred(root, "BoundingBox", "test2", 2);
		var ticket3:MovieClipBuilderTicketVO = mcb.attachMovieDeferred(root, "BoundingBox", "test3", 3);
		var ticket4:MovieClipBuilderTicketVO = mcb.attachMovieDeferred(root, "BoundingBox", "test4", 4);
		
		var onCreatedDelegate:Function = Delegate.create(this, onCreated);
		ticket1.addEventListener(ShurikenEvent.MOVIE_CLIP_CREATED, onCreatedDelegate);
		ticket2.addEventListener(ShurikenEvent.MOVIE_CLIP_CREATED, onCreatedDelegate);
		ticket3.addEventListener(ShurikenEvent.MOVIE_CLIP_CREATED, onCreatedDelegate);
		ticket4.addEventListener(ShurikenEvent.MOVIE_CLIP_CREATED, onCreatedDelegate);
		
		counter = 0;
	}
	
	private function onCreated(p_event:ShurikenEvent):Void
	{
		trace("p_event.type: " + p_event.type)
		counter++;
		trace("counter: " + counter);
		if(counter == 2)
		{
			MovieClipBuilder.getInstance().removeAll();
		}
	}
}