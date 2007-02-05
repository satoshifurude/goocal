import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.core.Collection;
		
class test_List extends MovieClip
{
	private static var inst:test_List;
	
	private var root:MovieClip;
	private var a:Collection;
	private var mc:List;
	
	public static function getInstance(p_root:MovieClip):test_List
	{
		if(inst == null) inst = new test_List(p_root);
		return inst;
	}
	
	public function test_List(p_root)
	{
		root = p_root;
	}
	
	public function init():Void
	{
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		//fscommand2("FullScreen", true);
		
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
		
		mc = List(root.attachMovie(List.SYMBOL_NAME, "mc", 0));
		mc.dataProvider = a;
		
		
	}
}