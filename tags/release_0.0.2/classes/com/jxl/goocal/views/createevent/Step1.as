import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.controls.DateEditor;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.utils.LoopUtils;
import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.core.Collection;

class com.jxl.goocal.views.createevent.Step1 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step1";
	
	private var __what:String				= "";
	private var __whatDirty:Boolean 		= false;
	private var __fromDate:Date;
	private var __fromDateDirty:Boolean 	= false;
	private var __toDate:Date;
	private var __toDateDirty:Boolean		= false;
	private var __repeats:String			= "Does not repeat";
	private var __repeatsDirty:Boolean 		= false;
	private var __repeat_array:Array = ["Does not repeat",
										"Daily",
										"Every weekday (Mon-Fri)",
										"Every Mon., Wed., and Fri.",
										"Every Tues., and Thurs.",
										"Weekly",
										"Monthly",
										"Yearly"];
	
	private var __what_lbl:Label;
	private var __what_ti:UITextField;
	private var __from_lbl:Label;
	private var __from_de:DateEditor;
	private var __to_lbl:Label;
	private var __to_de:DateEditor;
	private var __repeats_lbl:UITextField;
	private var __repeats_cb:ComboBox;
	
	private var __repeat_lu:LoopUtils;
	
	public function get what():String { return __what; }
	
	public function set what(pVal:String):Void
	{
		if(pVal != __what)
		{
			__what = pVal;
			__whatDirty = true;
			invalidateProperties();
		}
	}
	
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
	
	public function get toDate():Date { return __toDate; }
	public function set toDate(p_val:Date):Void
	{
		__toDate = p_val;
		__toDateDirty = true;
		invalidateProperties();
	}
	
	public function get repeats():String { return __repeats; }
	
	public function set repeats(p_val:String):Void
	{
		if(p_val != __repeats)
		{
			__repeats = p_val;
			__repeatsDirty = true;
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
		
		if(__what_lbl == null)
		{
			__what_lbl = Label(createComponent(Label, "__what_lbl"));
			__what_lbl.text = "What";
		}
		
		if(__what_ti == null)
		{
			__what_ti = UITextField(createComponent(UITextField, "__what_ti"));
			__what_ti.type = UITextField.TYPE_INPUT;
			__what_ti.border = true;
			__what_ti.borderColor = 0x000000;
			__what_ti.background = true;
			__what_ti.backgroundColor = 0xFFFFFF;
			__what_ti.addEventListener(ShurikenEvent.CHANGE, Delegate.create(this, onTextChanged)); 
		}
		
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
		/*
		if(__to_lbl == null)
		{
			__to_lbl = Label(createComponent(Label, "__to_lbl"));
			__to_lbl.text = "To";
		}
		
		if(__to_de == null)
		{
			__to_de = DateEditor(createComponent(DateEditor, "__to_de"));
			__to_de.currentDate = __toDate; 
		}
		
		if(__repeats_lbl == null)
		{
			__repeats_lbl = UITextField(createComponent(UITextField, "__repeats_lbl"));
			__repeats_lbl.text = "Repeats";
		}
		
		if(__repeats_cb == null)
		{
			__repeats_cb = ComboBox(createComponent(ComboBox, "__repeats_cb"));
			__repeats_cb.dataProvider = new Collection(__repeat_array);
			__repeats_cb.showScrollButtons = true;
			__repeats_cb.addEventListener(ShurikenEvent.ITEM_CLICKED, Delegate.create(this, onRepeatItemClicked));
		}
		*/
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
	
		if(__whatDirty == true)
		{
			__whatDirty = false;
			__what_ti.text = __what;
		}
		
		if(__fromDateDirty == true)
		{
			__fromDateDirty = false;
			__from_de.currentDate = __fromDate;
		}
		
		if(__toDateDirty == true)
		{
			__toDateDirty = false;
			__to_de.currentDate = __toDate;
		}
		
		if(__repeatsDirty == true)
		{
			__repeatsDirty = false;
			__repeat_lu = new LoopUtils(this);
			__repeat_lu.forLoop(0,
								__repeat_array.length,
								1,
								this,
								onIfSelectedRepeat,
								onIfSelectedRepeatDone);
		}
	}
	
	private function onIfSelectedRepeat(p_index:Number):Void
	{
		var val:String = __repeat_array[p_index];
		if(val.toLowerCase() == __repeats.toLowerCase())
		{
			__repeats_cb.selectedIndex = p_index;
			onIfSelectedRepeatDone();
		}
	}
	
	private function onIfSelectedRepeatDone():Void
	{
		__repeat_lu.stopProcessing();
		__repeat_lu.destroy();
		delete __repeat_lu;
	}
	
	private function size():Void
	{
		super.size();
		
		var margin:Number = 2;
		
		__what_lbl.move(0, 0);
		__what_lbl.setSize(__width, __what_lbl.height);
		
		__what_ti.move(__what_lbl.x, __what_lbl.y + __what_lbl.height + margin);
		__what_ti.setSize(__width, __what_ti.height);
		
		__from_lbl.move(__what_ti.x, __what_ti.y + __what_ti.height + margin);
		__from_lbl.setSize(__width, __from_lbl.height);
		
		__from_de.move(__from_lbl.x, __from_lbl.y + __from_lbl.height + margin);
		__from_de.setSize(__width, 40);
		
		__to_lbl.move(__from_de.x, __from_de.y + __from_de.height + margin);
		__to_lbl.setSize(__width, __to_lbl.height);
		
		__to_de.move(__to_lbl.x, __to_lbl.y + __to_lbl.height + margin);
		__to_de.setSize(__width, 40);
		
		__repeats_lbl.move(__to_de.x, __to_de.y + __to_de.height + margin);
		__repeats_lbl.setSize(__width, __repeats_lbl.height);
		
		__repeats_cb.move(__repeats_lbl.x, __repeats_lbl.y + __repeats_lbl.height + margin);
		__repeats_cb.setSize(__width, __repeats_cb.height);
	}
	
	private function onTextChanged(p_event:ShurikenEvent):Void
	{
		__what = __what_ti.text;
	}
	
	private function onRepeatItemClicked(p_event:ShurikenEvent):Void
	{
		
	}
}