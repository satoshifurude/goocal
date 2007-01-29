import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.controls.DateEditor;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.goocal.views.createevent.Step1 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step1";
	
	private var __fromDate:Date;
	private var __fromDateDirty:Boolean 	= false;
	
	private var __from_lbl:Label;
	private var __from_de:DateEditor;
	
	public function get fromDate():Date { return __fromDate; }
	
	public function set fromDate(pVal:Date):Void
	{
		if(pVal != __fromDate)
		{
			__fromDate = pVal;
			__fromDateDirty = true;
			invalidateProperties();
		}
	}
	
	public function Step1()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__from_lbl == null)
		{
			__from_lbl = Label(createComponent(Label, "__from_lbl"));
			__from_lbl.text = "From";
		}
		
		if(__from_de == null)
		{
			__from_de = DateEditor(createComponent(DateEditor, "__from_de"));
			__from_de.currentDate = __fromDate;
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__fromDateDirty == true)
		{
			__fromDateDirty = false;
			__from_de.currentDate = __fromDate;
		}
	}
	
	private function size():Void
	{
		super.size();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__from_lbl.move(0, 0);
		__from_lbl.setSize(40, __from_lbl.height);
		
		__from_de.move(__from_lbl.x + __from_lbl.width + margin, __from_lbl.y);
		__from_de.setSize(__width, 40);
	}
}