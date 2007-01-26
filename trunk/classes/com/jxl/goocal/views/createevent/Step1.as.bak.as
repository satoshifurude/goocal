import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.utils.LoopUtils;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.goocal.views.createevent.Step1 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step1";
	
	private var __what:String				= "";
	private var __whatDirty:Boolean 		= false;
	private var __fromDate:Date;
	private var __fromDateDirty:Boolean 	= false;
	private var __toDate:Date;
	private var __toDateDirty:Boolean 		= false;
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
	private var __fromDate_ti:UITextField;
	private var __fromTime_ti:UITextField;
	private var __to_lbl:Label;
	private var __toDate_ti:UITextField;
	private var __toTime_ti:UITextField;
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
	
	public function set toDate(pVal:Date):Void
	{
		if(pVal != __toDate)
		{
			__toDate = pVal;
			__toDateDirty = true;
			invalidateProperties();
		}
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
		
		var tabInc:Number = 1;
		
		var txtFunc:Function = Delegate.create(this, onTextChanged);
		
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
			__what_ti.tabIndex = tabInc++;
			__what_ti.addEventListener(ShurikenEvent.CHANGE, txtFunc); 
		}
		
		if(__from_lbl == null)
		{
			__from_lbl = Label(createComponent(Label, "__from_lbl"));
			__from_lbl.text = "From";
		}
		
		if(__fromDate_ti == null)
		{
			__fromDate_ti = UITextField(createComponent(UITextField, "__fromDate_ti"));
			__fromDate_ti.type = UITextField.TYPE_INPUT;
			__fromDate_ti.border = true;
			__fromDate_ti.borderColor = 0x000000;
			__fromDate_ti.background = true;
			__fromDate_ti.backgroundColor = 0xFFFFFF;
			__fromDate_ti.tabIndex = tabInc++;
			__fromDate_ti.addEventListener(ShurikenEvent.CHANGE, txtFunc);
		}
		
		if(__fromTime_ti == null)
		{
			__fromTime_ti = UITextField(createComponent(UITextField, "__fromTime_ti"));
			__fromTime_ti.type = UITextField.TYPE_INPUT;
			__fromTime_ti.border = true;
			__fromTime_ti.borderColor = 0x000000;
			__fromTime_ti.background = true;
			__fromTime_ti.backgroundColor = 0xFFFFFF;
			__fromTime_ti.tabIndex = tabInc++;
			__fromTime_ti.addEventListener(ShurikenEvent.CHANGE, txtFunc);
		}
		
		if(__to_lbl == null)
		{
			__to_lbl = Label(createComponent(Label, "__to_lbl"));
			__to_lbl.text = "To";
		}
		
		if(__toDate_ti == null)
		{
			__toDate_ti = UITextField(createComponent(UITextField, "__toDate_ti"));
			__toDate_ti.type = UITextField.TYPE_INPUT;
			__toDate_ti.border = true;
			__toDate_ti.borderColor = 0x000000;
			__toDate_ti.background = true;
			__toDate_ti.backgroundColor = 0xFFFFFF;
			__toDate_ti.tabIndex = tabInc++;
			__toDate_ti.addEventListener(ShurikenEvent.CHANGE, txtFunc);
		}
		
		if(__toTime_ti == null)
		{
			__toTime_ti = UITextField(createComponent(UITextField, "__toTime_ti"));
			__toTime_ti.type = UITextField.TYPE_INPUT;
			__toTime_ti.border = true;
			__toTime_ti.borderColor = 0x000000;
			__toTime_ti.background = true;
			__toTime_ti.backgroundColor = 0xFFFFFF;
			__toTime_ti.tabIndex = tabInc++;
			__toTime_ti.addEventListener(ShurikenEvent.CHANGE, txtFunc);
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
			__fromDate_ti.text = DateUtils.format(__fromDate, DateUtils.MONTH_DAY_YEAR);
			__fromTime_ti.text = DateUtils.format(__fromDate, DateUtils.HOUR_MIN_AM_PM);
		}
		
		if(__toDateDirty == true)
		{
			__toDateDirty = false;
			__toDate_ti.text = DateUtils.format(__toDate, DateUtils.MONTH_DAY_YEAR);
			__toTime_ti.text = DateUtils.format(__toDate, DateUtils.HOUR_MIN_AM_PM);
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
		
		var halfWidth:Number = (__width / 2) - (margin * 2);
		
		__fromDate_ti.move(__from_lbl.x, __from_lbl.y + __from_lbl.height + margin);
		__fromDate_ti.setSize(halfWidth, __fromDate_ti.height);
		
		__fromTime_ti.move(__fromDate_ti.x + __fromDate_ti.width + (margin * 2), __fromDate_ti.y);
		__fromTime_ti.setSize(halfWidth, __fromTime_ti.height);
		
		__to_lbl.move(__fromDate_ti.x, __fromDate_ti.y + __fromDate_ti.height);
		__to_lbl.setSize(__width, __to_lbl.height);
		
		__toDate_ti.move(__to_lbl.x, __to_lbl.y + __to_lbl.height);
		__toDate_ti.setSize(halfWidth, __toDate_ti.height);
		
		__toTime_ti.move(__toDate_ti.x + __toDate_ti.width + (margin * 2), __toDate_ti.y);
		__toTime_ti.setSize(halfWidth, __toTime_ti.height);
		
		__repeats_lbl.move(__toDate_ti.x, __toDate_ti.y + __toDate_ti.height + margin);
		__repeats_lbl.setSize(__width, __repeats_lbl.height);
		
		__repeats_cb.move(__repeats_lbl.x, __repeats_lbl.y + __repeats_lbl.height + margin);
		__repeats_cb.setSize(__width, __repeats_cb.height);
	}
	
	private function onTextChanged(p_event:ShurikenEvent):Void
	{
		switch(p_event.target)
		{
			case __what_ti:
				__what = __what_ti.text;
				break;
				
			case __fromDate_ti:
				//var parsedDate:Date = DateUtils.parseDate(__fromDate, DateUtils.MONTH_DAY_YEAR);
				//__fromDate.setMonth(parsedDate.getMonth());
				//__fromDate.setDate(parsedDate.getDate());
				//__fromDate.setFullYear(parsedDate.getFullYear());
				break;
			
			case __fromTime_ti:
				//__fromTime = DateUtils.parseDate(DateUtils.MONTH_DAY_YEAR);
				break;
			
			case __toDate_ti:
			
			case __toTime_ti:
			
			
		}
	}
	
	private function onRepeatItemClicked(p_event:ShurikenEvent):Void
	{
		
	}
}