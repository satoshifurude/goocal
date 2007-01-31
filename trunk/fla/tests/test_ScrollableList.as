import com.jxl.shuriken.containers.ScrollableList;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.controls.Button;
import mx.utils.Delegate;
import com.jxl.shuriken.events.ShurikenEvent;
		
class test_ScrollableList extends MovieClip
{
	private static var inst:test_ScrollableList;
	
	private var root:MovieClip;
	private var a:Collection;
	private var mc:ScrollableList;
	
	public static function getInstance(p_root:MovieClip):test_ScrollableList
	{
		if(inst == null) inst = new test_ScrollableList(p_root);
		return inst;
	}
	
	public function test_ScrollableList(p_root)
	{
		root = p_root;
	}
	
	public function init():Void
	{
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		//fscommand2("FullScreen", true);
		
		//var asdf:SimpleButton = SimpleButton(root.attachMovie(SimpleButton.SYMBOL_NAME, "asdf", 4));
		//asdf.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onReleased));
		
		//return;
		
		a = new Collection();
		a.addItem("Personal");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		a.addItem("Cow");
		
		mc = ScrollableList(root.attachMovie(ScrollableList.SYMBOL_NAME, "mc", 0));
		mc.dataProvider = a;
		mc.showButtons = true;
		mc.childClass = Button;
		
		
	}
	
	private function onReleased(p_event:ShurikenEvent):Void
	{
		trace("----------------------");
		trace("test_ScrollableList::onReleased");
	}
}