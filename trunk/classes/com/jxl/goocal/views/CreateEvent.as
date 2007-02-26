import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.core.Collection;
import com.jxl.shuriken.controls.LinkButton;

import com.jxl.goocal.views.createevent.Step1;
import com.jxl.goocal.views.createevent.Step2;
import com.jxl.goocal.views.createevent.Step3;
import com.jxl.goocal.views.createevent.Step4;
import com.jxl.goocal.views.createevent.Step5;
import com.jxl.goocal.views.createevent.Step6;

class com.jxl.goocal.views.CreateEvent extends UIComponent
{
	public static var SYMBOL_NAME:String 		= "com.jxl.goocal.views.CreateEvent";
	
	public static var EVENT_CANCEL:String 		= "cancel";
	public static var EVENT_SAVE:String 		= "save";
	
	public static var STATE_CREATE:Number 		= 0;
	public static var STATE_EDIT:Number 		= 1;
	
	private var __fromDate:Date;
	private var __toDate:Date;
	private var __what:String;
	private var __where:String;
	private var __calendar:String;
	private var __calendars:Collection;
	private var __description:String;
	private var __repeats:String;
	private var __emails:String;
	
	private var __state:Number 					= 0;
	
	public function get fromDate():Date { return __fromDate; }
	public function set fromDate(val:Date):Void
	{
		__fromDate = val;
		invalidate();
	}
	
	public function get toDate():Date { return __toDate; }
	public function set toDate(val:Date):Void
	{
		__toDate = val;
		invalidate();
	}
	
	public function get what():String { return __what; }
	public function set what(val:String):Void
	{
		__what = val;
		invalidate();
	}
	
	public function get where():String { return __where; }
	public function set where(val:String):Void
	{
		__where = val;
		invalidate();
	}
	
	public function get calendar():String { return __calendar; }
	public function set calendar(val:String):Void
	{
		__calendar = val;
		invalidate();
	}
	
	public function get calendars():Collection { return __calendars; }
	public function set calendars(val:Collection):Void
	{
		__calendars = val;
		invalidate();
	}
	
	public function get description():String { return __description; }
	public function set description(val:String):Void
	{
		__description = val;
		invalidate();
	}
	
	public function get repeats():String { return __repeats; }
	public function set repeats(val:String):Void
	{
		__repeats = val;
		invalidate();
	}
	
	public function get emails():String { return __emails; }
	public function set emails(val:String):Void
	{
		__emails = val;
		invalidate();
	}
	
	// 1 based, not 0 based
	private var __currentStep:Number = 1;
	private var __maxSteps:Number = 6;
	private var __cancelCallback:Callback;
	private var __okCallback:Callback;
	
	private var __title_lbl:TextField;
	private var __step1:Step1;
	private var __step2:Step2;
	private var __step3:Step3;
	private var __step4:Step4;
	private var __step5:Step5;
	private var __step6:Step6;
	private var __cancel_pb:Button;
	private var __back_pb:Button;
	private var __next_pb:Button;
	private var __save_pb:Button;
	private var __or_txt:TextField;
	private var __reminder_lb:LinkButton;
	private var __guests_lb:LinkButton;
	
	
	public function CreateEvent()
	{
		super();
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		__fromDate 			= new Date();
		__toDate 			= new Date();
		__what				= "";
		__where				= "";
		__calendar			= "";
		__calendars			= new Collection();
		__description		= "";
		__repeats			= "";
		__emails			= "";
		
		if(__title_lbl == null)
		{
			__title_lbl = createLabel("__title_lbl");
			var tf:TextFormat = __title_lbl.getTextFormat();
			tf.font = "Courier New";
			tf.size = 14;
			tf.bold = true;
			tf.color = 0x333333;
			__title_lbl.setNewTextFormat(tf);
			__title_lbl.setTextFormat(tf);
		}
		
		if(__cancel_pb == null)
		{
			__cancel_pb = Button(createComponent(Button, "__cancel_pb"));
			__cancel_pb.label = "Cancel";
			__cancel_pb.setReleaseCallback(this, onCancel);
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		__title_lbl.text = "Create Event Step " + __currentStep;
		
		if(__step1 != null)
		{
			__step1.removeMovieClip();
			delete __step1;
		}
		if(__step2 != null)
		{
			__step2.removeMovieClip();
			delete __step2;
		}
		if(__step3 != null)
		{
			__step3.removeMovieClip();
			delete __step3;
		}
		if(__step4 != null)
		{
			__step4.removeMovieClip();
			delete __step4;
		}
		if(__step5 != null)
		{
			__step5.removeMovieClip();
			delete __step5;
		}
		
		if(__step6 != null)
		{
			__step6.removeMovieClip();
			delete __step6;
		}
		
		if(__or_txt != null)
		{
			__or_txt.removeTextField();
			delete __or_txt;
		}
		
		if(__reminder_lb != null)
		{
			__reminder_lb.removeMovieClip();
			delete __reminder_lb;
		}
		
		if(__guests_lb != null)
		{
			__guests_lb.removeMovieClip();
			delete __guests_lb;
		}
		
		if(__currentStep < 4)
		{
			if(__save_pb != null)
			{
				__save_pb.removeMovieClip();
				delete __save_pb;
			}
			
			if(__next_pb == null)
			{
				__next_pb = Button(createComponent(Button, "__next_pb"));
				__next_pb.setReleaseCallback(this, nextStep);
				__next_pb.label = "Next";
			}
		}
		else
		{
			if(__next_pb != null)
			{
				__next_pb.removeMovieClip();
				delete __next_pb;
			}
			
			if(__save_pb == null)
			{
				__save_pb = Button(createComponent(Button, "__save_pb"));
				__save_pb.setReleaseCallback(this, onSave);
				__save_pb.label = "SAVE";
				var txt:TextField = __save_pb.textField;
				var fmt:TextFormat = txt.getTextFormat();
				fmt.bold = true;
				fmt.color = 0x0066CC;
				fmt.font = "Verdana";
				fmt.size = 12;
				txt.setTextFormat(fmt);
				txt.setNewTextFormat(fmt);
			}
		}
		
		switch(__currentStep)
		{
			case 1:
				if(__back_pb != null)
				{
					__back_pb.removeMovieClip();
					delete __back_pb;
				}
				
				if(__step1 == null)
				{
					__step1 = Step1(createComponent(Step1, "__step1"));
					__step1.fromDate = __fromDate;
				}
				
				break;
				
			case 2:
				if(__step2 == null)
				{
					__step2 = Step2(createComponent(Step2, "__step2"));
					__step2.toDate = __toDate;
				}
				if(__back_pb == null)
				{
					__back_pb = Button(createComponent(Button, "__back_pb"));
					__back_pb.setReleaseCallback(this, previousStep);
					__back_pb.label = "Back";
				}
				break;
				
			case 3:
				if(__step3 == null)
				{
					__step3 = Step3(createComponent(Step3, "__step3"));
					__step3.what = __what;
					__step3.where = __where;
					__step3.setChangeCallback(this, onChanged);
				}
				
				break;
				
			case 4:
				if(__step4 == null)
				{
					__step4 = Step4(createComponent(Step4, "__step4"));
					__step4.calendar = __calendar;
					__step4.calendars = __calendars;
					__step4.description = __description;
					__step4.setChangeCallback(this, onChanged);
				}
				
				if(__or_txt == null)
				{
					__or_txt = createLabel("__or_txt");
					__or_txt.text = "or";
				}
				
				if(__reminder_lb == null)
				{
					__reminder_lb = LinkButton(createComponent(LinkButton, "__reminder_lb"));
					__reminder_lb.setReleaseCallback(this, nextStep);
					__reminder_lb.label = "add a reminder";
				}
				
				break;
				
			case 5:
				if(__step5 == null)
				{
					__step5 = Step5(createComponent(Step5, "__step5"));
					__step5.repeats = __repeats;
					__step5.setChangeCallback(this, onChanged);
				}
				
				if(__or_txt == null)
				{
					__or_txt = createLabel("__or_txt");
					__or_txt.text = "or";
				}
				
				if(__guests_lb == null)
				{
					__guests_lb = LinkButton(createComponent(LinkButton, "__guests_lb"));
					__guests_lb.setReleaseCallback(this, nextStep);
					__guests_lb.label = "add guests";
				}
				
				break;
			
			case 6:
				if(__step6 == null)
				{
					__step6 = Step6(createComponent(Step6, "__step6"));
					__step6.emails = __emails;
					__step6.setChangeCallback(this, onChanged);
				}
				
				break;
				
			
		}
		
		__title_lbl.setSize(__width, 20);
		
		if(__step1 != null)
		{
			__step1.move(0, __title_lbl._y + __title_lbl._height);
			__step1.setSize(__width, __step1.height);
		}
		
		if(__step2 != null)
		{
			__step2.move(0, __title_lbl._y + __title_lbl._height);
			__step2.setSize(__width, __step2.height);
		}
		
		if(__step3 != null)
		{
			__step3.move(0, __title_lbl._y + __title_lbl._height);
			__step3.setSize(__width, __step3.height);
		}
		
		if(__step4 != null)
		{
			__step4.move(0, __title_lbl._y + __title_lbl._height);
			__step4.setSize(__width, __step4.height);
		}
		
		if(__step5 != null)
		{
			__step5.move(0, __title_lbl._y + __title_lbl._height);
			__step5.setSize(__width, __step5.height);
		}
		
		if(__step6 != null)
		{
			__step6.move(0, __title_lbl._y + __title_lbl._height);
			__step6.setSize(__width, __step6.height);
		}
		
		// button margin width
		var bmW:Number = 4;
		
		__cancel_pb.setSize(50, 16);
		__cancel_pb.move(0, __height - __cancel_pb.height - 20);
		
		if(__back_pb != null)
		{
			__back_pb.setSize(50, 16);
			__back_pb.move(__cancel_pb.x + __cancel_pb.width + bmW, __cancel_pb.y);
		}
		
		if(__next_pb != null)
		{
			__next_pb.setSize(50, 16);
			__next_pb.move(__width - __next_pb.width, __cancel_pb.y);
		}
		
		if(__currentStep >= 3)
		{
			if(__what == null || __what == "")
			{
				__next_pb._visible = false;
			}
			else
			{
				__next_pb._visible = true;
			}
		}
		
		if(__save_pb != null)
		{
			__save_pb.setSize(50, 16);
			__save_pb.move(__width - __save_pb.width, __cancel_pb.y);
		}
		
		if(__or_txt != null)
		{
			__or_txt.setSize(16, 18);
			__or_txt.move(0, __height - __or_txt._height);
		}
		
		if(__reminder_lb != null)
		{
			__reminder_lb.setSize(77, 18);
			__reminder_lb.move(__or_txt._x + __or_txt._width + 2, __or_txt._y);
		}
		
		if(__guests_lb != null)
		{
			__guests_lb.setSize(77, 18);
			__guests_lb.move(__or_txt._x + __or_txt._width + 2, __or_txt._y);
		}
	}
	
	public function nextStep():Void
	{
		if(__currentStep + 1 <= __maxSteps)
		{
			__currentStep++;
			invalidate();
		}
	}
	
	public function previousStep():Void
	{
		if(__currentStep - 1 > 0)
		{
			__currentStep--;
			invalidate();
		}
	}
	
	private function onCancel(event:ShurikenEvent):Void
	{
		__cancelCallback.dispatch(new Event(EVENT_CANCEL, this));
	}
	
	private function onSave(event:ShurikenEvent):Void
	{
		__okCallback.dispatch(new Event(EVENT_SAVE, this));
	}
	
	public function setupEvent(fromDate:Date,
							   toDate:Date,
							   what:String,
							   where:String,
							   calendars:Collection,
							   calendar:String,
							   description:String,
							   repeats:String,
							   emails:String,
							   state:Number):Void
	{
		
		__fromDate 			= fromDate;
		__toDate			= toDate;
		__what				= what;
		__where				= where;
		__calendars			= calendars;
		if(calendar != null) __calendar = calendar;
		__description 		= description;
		__repeats			= repeats;
		__emails			= emails;
		__state				= state;
		
		if(__repeats == null && __emails == null)
		{
			if(__state == STATE_EDIT)
			{
				__maxSteps = 4;
			}
		}
		
		invalidate();
	}
	
	private function onChanged(event:Event):Void
	{
		if(event.target == __step3)
		{
			__what = __step3.what;
			__where = __step3.where;
			
			if(__currentStep >= 3)
			{
				if(__what == null || __what == "")
				{
					__next_pb._visible = false;
				}
				else
				{
					__next_pb._visible = true;
				}
			}
		}
		else if(event.target == __step4)
		{
			__calendar = String(__step4.calendar);
			__description = __step4.description;
		}
		else if(event.target == __step5)
		{
			__repeats = __step5.repeats;
		}
		else if(event.target == __step6)
		{
			__emails = __step6.emails;
		}
	}
	
	public function setCancelCallback(scope:Object, func:Function):Void
	{
		__cancelCallback = new Callback(scope, func);
	}
	
	public function setSaveCallback(scope:Object, func:Function):Void
	{
		__okCallback = new Callback(scope, func);
	}
}