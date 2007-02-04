import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.DateEditor;

class com.jxl.goocal.views.createevent.Step2 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step2";
	
	private var __toDate:Date;
	
	private var __to_lbl:TextField;
	private var __to_de:DateEditor;
	
	public function get toDate():Date { return __toDate; }
	public function set toDate(p_val:Date):Void
	{
		__toDate = p_val;
		__to_de.currentDate = __toDate;
	}
	
	public function Step2()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__to_lbl == null)
		{
			__to_lbl = createLabel("__to_lbl");
			__to_lbl.text = "To";
		}
		
		if(__to_de == null)
		{
			__to_de = DateEditor(createComponent(DateEditor, "__to_de"));
			__to_de.currentDate = __toDate; 
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__to_lbl.move(0, 0);
		__to_lbl.setSize(40, __to_lbl.height);
		
		__to_de.move(__to_lbl._x + __to_lbl._width + margin, __to_lbl._y);
		__to_de.setSize(__width, 40);
	}
}