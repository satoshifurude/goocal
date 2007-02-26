import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.DateEditor;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.goocal.views.createevent.Step1 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step1";
	
	private var __fromDate:Date;
	
	private var __from_lbl:TextField;
	private var __from_de:DateEditor;
	
	public function get fromDate():Date { return __fromDate; }
	
	public function set fromDate(pVal:Date):Void
	{
		if(pVal != __fromDate)
		{
			__fromDate = pVal;
			__from_de.currentDate = __fromDate;
		}
	}
	
	public function Step1()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__from_lbl == null)
		{
			__from_lbl = createLabel("__from_lbl");
			var tf:TextFormat = __from_lbl.getTextFormat();
			tf.bold = true;
			__from_lbl.setNewTextFormat(tf);
			__from_lbl.text = "From";
		}
		
		if(__from_de == null)
		{
			__from_de = DateEditor(createComponent(DateEditor, "__from_de"));
			__from_de.currentDate = __fromDate;
			__from_de.fieldType = DateEditor.FIELD_YEAR_MONTH_DAY_HOUR_MIN;
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__from_lbl.move(0, 0);
		__from_lbl.setSize(40, __from_lbl.height);
		
		__from_de.move(__from_lbl._x + __from_lbl._width + margin, __from_lbl._y);
		__from_de.setSize(__width, 40);
	}
}