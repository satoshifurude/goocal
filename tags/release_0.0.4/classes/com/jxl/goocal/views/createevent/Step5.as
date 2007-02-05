import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.utils.LoopUtils;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.events.Callback;

class com.jxl.goocal.views.createevent.Step5 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step5";
	
	public static var EVENT_REPEAT_CHANGE:String = "repeats";
	
	private var __repeats:String			= "Does not repeat";
	private var __repeatsDirty:Boolean 		= false;
	private var __repeat_array:Array 		= ["Does not repeat",
												"Daily",
												"Every weekday (Mon-Fri)",
												"Every Mon., Wed., and Fri.",
												"Every Tues., and Thurs.",
												"Weekly",
												"Monthly",
												"Yearly"];
	
	private var __repeats_lbl:TextField;
	private var __repeats_cb:ComboBox;
	
	private var __repeat_lu:LoopUtils;
	private var __changeCallback:Callback;
	
	public function get repeats():String { return __repeats; }
	
	public function set repeats(p_val:String):Void
	{
		__repeats = p_val;
		if(__repeat_lu != null)
		{
			__repeat_lu.destroy();
			delete __repeat_lu;
		}
		__repeat_lu = new LoopUtils(this);
		__repeat_lu.forLoop(0,
							__repeat_array.length,
							1,
							this,
							onIfSelectedRepeat,
							onIfSelectedRepeatDone);
	}
	
	public function Step5()
	{
		super();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__repeats_lbl == null)
		{
			__repeats_lbl = createLabel("__repeats_lbl");
			__repeats_lbl.text = "Repeats";
		}
		
		if(__repeats_cb == null)
		{
			__repeats_cb = ComboBox(createComponent(ComboBox, "__repeats_cb"));
			__repeats_cb.dataProvider = new Collection(__repeat_array);
			__repeats_cb.setItemSelectionChangedCallback(this, onRepeatItemClicked);
			__repeats_cb.selectedIndex = 0;
			__repeats_cb.direction = ComboBox.DIRECTION_BELOW;
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
	
	private function redraw():Void
	{
		super.redraw();
		
		var margin:Number = 2;
		var m2:Number = margin * 2;
		
		__repeats_lbl.move(0, 0);
		__repeats_lbl.setSize(__width, __repeats_lbl._height);
		
		__repeats_cb.setSize(__width - m2, __repeats_cb.height);
		__repeats_cb.move(__repeats_lbl._x + margin, __repeats_lbl._y + __repeats_lbl._height + margin);
	}
	
	private function onRepeatItemClicked(p_event:ShurikenEvent):Void
	{
		__repeats = __repeat_array[__repeats_cb.selectedIndex];
		__changeCallback.dispatch(new Event(EVENT_REPEAT_CHANGE, this));
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		__changeCallback = new Callback(scope, func);
	}
}