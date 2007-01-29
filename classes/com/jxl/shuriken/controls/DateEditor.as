import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.NumericStepper;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.controls.Label;
//import com.jxl.shuriken.controls.SimpleButton;
//import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.shuriken.controls.DateEditor extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.DateEditor";
	
	public static var FIELD_YEAR:Number 						= 1;
	public static var FIELD_YEAR_MONTH:Number 					= 2;
	public static var FIELD_YEAR_MONTH_DAY:Number 				= 3;
	public static var FIELD_YEAR_MONTH_DAY_HOUR:Number 			= 4;
	public static var FIELD_YEAR_MONTH_DAY_HOUR_MIN:Number 		= 5;
	public static var FIELD_DAY_HOUR_MIN:Number 				= 6;
	
	private var __currentDate:Date;
	private var __currentDateDirty:Boolean						= false;
	private var __fieldType:Number 								= 3;
	
	private var __year_lbl:Label;
	private var __year_nms:NumericStepper;
	private var __month_lbl:Label;
	private var __month_nms:NumericStepper;
	private var __day_lbl:Label;
	private var __day_nms:NumericStepper;
	private var __hour_lbl:Label;
	private var __hour_nms:NumericStepper;
	private var __min_lbl:Label;
	private var __min_nms:NumericStepper;
	
	public function get fieldType():Number { return __fieldType; }
	public function set fieldType(p_val:Number):Void
	{
		__fieldType = p_val;
		invalidateDraw();
	}
	
	public function get currentDate():Date { return __currentDate; }
	public function set currentDate(p_val:Date):Void
	{
		__currentDate = p_val;
		__currentDateDirty = true;
		invalidateProperties();
	}
	
	public function DateEditor()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__isConstructing == false)
		{
			var clipArray:Array = ["__year_lbl",
								   "__year_nms",
								   "__month_lbl",
								   "__month_nms",
								   "__day_lbl",
								   "__day_nms",
								   "__hour_lbl",
								   "__hour_nms",
								   "__min_lbl",
								   "__min_nms"];
			var i:Number = clipArray.length;
			while(i--)
			{
				this[clipArray[i]].removeMovieClip();
				delete this[clipArray[i]];
			}
		}
		
		if(__fieldType != FIELD_DAY_HOUR_MIN)
		{
		
			if(__year_lbl == null)
			{
				__year_lbl = Label(createComponent(Label, "__year_lbl"));
				__year_lbl.text = "Year";
			}
			
			if(__year_nms == null)
			{
				__year_nms = NumericStepper(createComponent(NumericStepper, "__year_nms"));
				__year_nms.setChangeCallback(this, onValueChange);
				__year_nms.setMinMax(1000, 9999);
			}
			
			if(__fieldType == FIELD_YEAR) return;
			
			if(__month_lbl == null)
			{
				__month_lbl = Label(createComponent(Label, "__month_lbl"));
				__month_lbl.text = "Month";
			}
			
			if(__month_nms == null)
			{
				__month_nms = NumericStepper(createComponent(NumericStepper, "__month_nms"));
				__month_nms.setChangeCallback(this, onValueChange);
				__month_nms.setMinMax(1, 12);
			}
			
			if(__fieldType == FIELD_YEAR_MONTH) return;
			
			if(__day_lbl == null)
			{
				__day_lbl = Label(createComponent(Label, "__day_lbl"));
				__day_lbl.text = "Day";
			}
			
			if(__day_nms == null)
			{
				__day_nms = NumericStepper(createComponent(NumericStepper, "__day_nms"));
				__day_nms.setChangeCallback(this, onValueChange);
				// TODO: this should keep track of the month instead of being hardcoded
				// to 31; some months have 28 and 30 days, not 31
				__day_nms.setMinMax(1, 31);
			}
			
			if(__fieldType == FIELD_YEAR_MONTH_DAY) return;
			
			if(__hour_lbl == null)
			{
				__hour_lbl = Label(createComponent(Label, "__hour_lbl"));
				__hour_lbl.text = "Hour";
			}
			
			if(__hour_nms == null)
			{
				__hour_nms = NumericStepper(createComponent(NumericStepper, "__hour_nms"));
				__hour_nms.setChangeCallback(this, onValueChange);
				__hour_nms.setMinMax(0, 23);
			}
			
			if(__fieldType == FIELD_YEAR_MONTH_DAY_HOUR) return;
			
			if(__min_lbl == null)
			{
				__min_lbl = Label(createComponent(Label, "__min_lbl"));
				__min_lbl.text = "Minute";
			}
			
			if(__min_nms == null)
			{
				__min_nms = NumericStepper(createComponent(NumericStepper, "__min_nms"));
				__min_nms.setChangeCallback(this, onValueChange);
				__min_nms.setMinMax(0, 59);
			}
		}
		else
		{
			// KLUDGE: for now, assumes __fieldType is FIELD_DAY_HOUR_MIN
			if(__day_lbl == null)
			{
				__day_lbl = Label(createComponent(Label, "__day_lbl"));
				__day_lbl.text = "Day";
			}
			
			if(__day_nms == null)
			{
				__day_nms = NumericStepper(createComponent(NumericStepper, "__day_nms"));
				__day_nms.setChangeCallback(this, onValueChange);
				// TODO: this should keep track of the month instead of being hardcoded
				// to 31; some months have 28 and 30 days, not 31
				__day_nms.setMinMax(1, 31);
			}
			
			if(__hour_lbl == null)
			{
				__hour_lbl = Label(createComponent(Label, "__hour_lbl"));
				__hour_lbl.text = "Hour";
			}
			
			if(__hour_nms == null)
			{
				__hour_nms = NumericStepper(createComponent(NumericStepper, "__hour_nms"));
				__hour_nms.setChangeCallback(this, onValueChange);
				__hour_nms.setMinMax(0, 23);
			}
			
			if(__min_lbl == null)
			{
				__min_lbl = Label(createComponent(Label, "__min_lbl"));
				__min_lbl.text = "Minute";
			}
			
			if(__min_nms == null)
			{
				__min_nms = NumericStepper(createComponent(NumericStepper, "__min_nms"));
				__min_nms.setChangeCallback(this, onValueChange);
				__min_nms.setMinMax(0, 59);
			}
		}
		
		
	}
	
	private function onInitialized():Void
	{
		super.onInitialized();
		
		if(__currentDate == null)
		{
			__currentDate = new Date();
			__currentDateDirty = true;
			commitProperties();
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__currentDateDirty == true)
		{
			__currentDateDirty = false;
			
			__year_nms.value 		= __currentDate.getFullYear();
			__month_nms.value 		= __currentDate.getMonth() + 1;
			__day_nms.value 		= __currentDate.getDate();
			__hour_nms.value 		= __currentDate.getHours();
			__min_nms.value 		= __currentDate.getMinutes();
		}
	}
	
	private function size():Void
	{
		super.size();
		
		var margin:Number = 2;
	
		__year_lbl.move(0, 0);
		__year_lbl.setSize(40, 16);
		__year_nms.move(__year_lbl.x, __year_lbl.y + __year_lbl.height + 2);
		__year_nms.setSize(40, __year_nms.height);
		
		__month_lbl.move(__year_lbl.x + __year_lbl.width + margin, __year_lbl.y);
		__month_lbl.setSize(40, 16);
		__month_nms.move(__month_lbl.x, __month_lbl.y + __month_lbl.height + 2);
		
		__day_lbl.move(__month_lbl.x + __month_lbl.width + margin, __month_lbl.y);
		__day_lbl.setSize(40, 16);
		__day_nms.move(__day_lbl.x, __day_lbl.y + __day_lbl.height + margin);
		
		__hour_lbl.move(__year_nms.x, __year_nms.y + __year_nms.height + margin);
		__hour_lbl.setSize(40, 16);
		__hour_nms.move(__hour_lbl.x, __hour_lbl.y + __hour_lbl.height + margin);
		
		__min_lbl.move(__hour_lbl.x + __hour_lbl.width + margin, __hour_lbl.y);
		__min_lbl.setSize(40, 16);
		__min_nms.move(__min_lbl.x, __min_lbl.y + __min_lbl.height + margin);
	}
	
	private function onValueChange(p_event:ShurikenEvent):Void
	{
		switch(p_event.target)
		{
			case __year_nms:
				__currentDate.setFullYear(__year_nms.value);
				break;
			
			case __month_nms:
				__currentDate.setMonth(__month_nms.value - 1);
				break;
			
			case __day_nms:
				__currentDate.setDate(__day_nms.value);
				break;
			
			case __hour_nms:
				__currentDate.setHours(__hour_nms.value);
				break;
			
			case __min_nms:
				__currentDate.setMinutes(__min_nms.value);
				break;
		}
	}
	
	
}