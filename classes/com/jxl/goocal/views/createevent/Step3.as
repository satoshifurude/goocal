import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.createevent.Step3 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step3";
	
	public static var EVENT_WHAT_CHANGE:String = "whatChange";
	public static var EVENT_WHERE_CHANGE:String = "whereChange";
	
	private var __what:String				= "";
	private var __whatDirty:Boolean 		= false;
	private var __where:String 				= ""
	private var __whereDirty:Boolean		= false;
	private var __changeCallback:Callback;
	
	private var __what_lbl:Label;
	private var __what_ti:UITextField;
	private var __where_lbl:Label;
	private var __where_ti:UITextField;
	
	public function get what():String { return __what; }
	public function set what(pVal:String):Void
	{
		__what = pVal;
		__whatDirty = true;
		invalidateProperties();
	}
	
	public function get where():String { return __where; }
	public function set where(val:String):Void
	{
		__where = val;
		__whereDirty = true;
		invalidateProperties();
	}
	
	public function Step3()
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
			__what_ti.setChangeCallback(this, onTextChanged); 
		}
		
		if(__where_lbl == null)
		{
			__where_lbl = Label(createComponent(Label, "__where_lbl"));
			__where_lbl.text = "Where";
		}
		
		if(__where_ti == null)
		{
			__where_ti = UITextField(createComponent(UITextField, "__where_ti"));
			__where_ti.type = UITextField.TYPE_INPUT;
			__where_ti.border = true;
			__where_ti.borderColor = 0x000000;
			__where_ti.background = true;
			__where_ti.backgroundColor = 0xFFFFFF;
			__where_ti.setChangeCallback(this, onTextChanged);
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
		
		if(__whereDirty == true)
		{
			__whereDirty = false;
			__where_ti.text = __where;
		}
	}
	
	private function size():Void
	{
		super.size();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__what_lbl.move(0, 0);
		__what_lbl.setSize(__width, __what_lbl.height);
		
		__what_ti.move(__what_lbl.x + margin, __what_lbl.y + __what_lbl.height + margin);
		__what_ti.setSize(__width - m2, __what_ti.height);
		
		__where_lbl.move(__what_lbl.x, __what_ti.y + __what_ti.height + margin);
		__where_lbl.setSize(__width, __where_lbl.height);
		
		__where_ti.move(__where_lbl.x + margin, __where_lbl.y + __where_lbl.height + margin);
		__where_ti.setSize(__width - m2, __where_ti.height);
	}
	
	private function onTextChanged(event:ShurikenEvent):Void
	{
		if(event.target == __what_ti)
		{
			__what = __what_ti.text;
			__changeCallback.dispatch(new Event(EVENT_WHAT_CHANGE, this));
		}
		else
		{
			__where = __where_ti.text;
			__changeCallback.dispatch(new Event(EVENT_WHERE_CHANGE, this));
		}
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		__changeCallback = new Callback(scope, func);
	}
	
}