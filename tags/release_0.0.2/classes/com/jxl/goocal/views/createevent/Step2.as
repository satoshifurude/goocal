import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.controls.ComboBox;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.core.ICollection;
import com.jxl.shuriken.core.Collection;

class com.jxl.goocal.views.createevent.Step2 extends UIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.createevent.Step2";
	
	private var __where:String 								= "";
	private var __whereDirty:Boolean 						= false;
	private var __calendars:ICollection;
	private var __calendarsDirty:Boolean					= false;
	private var __description:String						= "";
	private var __descriptionDirty:Boolean					= false;
	
	private var __where_lbl:Label;
	private var __where_ti:UITextField;
	private var __calendar_lbl:Label;
	private var __calendars_cb:ComboBox;
	private var __description_lbl:Label;
	private var __description_txt:UITextField;
	
	public function get where():String { return __where; }
	public function set where(p_val:String):Void
	{
		__where = p_val;
		__whereDirty = true;
		invalidateProperties();
	}
	
	public function get calendars():ICollection { return __calendars; }
	public function set calendars(p_val:ICollection):Void
	{
		__calendars = p_val;
		__calendarsDirty = true;
		invalidateProperties();
	}
	
	public function get description():String { return __description; }
	public function set description(p_val:String):Void
	{
		__description = p_val;
		__descriptionDirty = true;
		invalidateProperties();
	}
	
	public function Step2()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		focusEnabled		= true;
		tabEnabled			= false;
		tabChildren			= true;
	}
	
	private function onInitialized():Void
	{
		super.onInitialized();
		
		__whereDirty			= true;
		__calendarsDirty 		= true;
		__descriptionDirty 		= true;
		commitProperties();
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__whereDirty == true)
		{
			__whereDirty = false;
			__where_ti.text = __where;
		}
		
		if(__calendarsDirty == true)
		{
			__calendarsDirty = false;
			__calendars_cb.dataProvider = __calendars;
		}
		
		if(__descriptionDirty == true)
		{
			__descriptionDirty = false;
			__description_txt.text = __description;
		}
	}
	
}