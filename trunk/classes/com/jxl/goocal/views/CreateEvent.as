import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.core.Collection;

import com.jxl.goocal.views.createevent.Step1;
import com.jxl.goocal.views.createevent.Step2;
import com.jxl.goocal.views.createevent.Step3;
import com.jxl.goocal.views.createevent.Step4;
import com.jxl.goocal.views.createevent.Step5;
import com.jxl.goocal.views.GCHeading;

class com.jxl.goocal.views.CreateEvent extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.CreateEvent";
	
	public static var EVENT_CANCEL:String = "cancel";
	
	private var __fromDate:Date;
	private var __toDate:Date;
	private var __what:String;
	private var __where:String;
	private var __calendar:String;
	private var __calendars:Collection
	private var __description:String;
	private var __repeats:String;
	
	// 1 based, not 0 based
	private var __currentStep:Number = 1;
	private var __maxSteps:Number = 5;
	private var __cancelCallback:Callback;
	private var __okCallback:Callback;
	
	private var __title_lbl:GCHeading;
	private var __step1:Step1;
	private var __step2:Step2;
	private var __step3:Step3;
	private var __step4:Step4;
	private var __step5:Step5;
	private var __cancel_pb:Button;
	private var __back_pb:Button;
	private var __next_pb:Button; // doubles as save button
	
	public function CreateEvent()
	{
		super();
		
		__fromDate 			= new Date();
		__toDate 			= new Date();
		__what				= "";
		__where				= "";
		__calendar			= "";
		__calendars			= new Collection();
		__description		= "";
		__repeats			= "";
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__title_lbl == null)
		{
			__title_lbl = GCHeading(createComponent(GCHeading, "__title_lbl"));
		}
		
		if(__cancel_pb == null)
		{
			__cancel_pb = Button(createComponent(Button, "__cancel_pb"));
			__cancel_pb.label = "Cancel";
			__cancel_pb.setReleaseCallback(this, onCancel);
		}
	}
	
	private function draw():Void
	{
		super.draw();
		
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
		
		switch(__currentStep)
		{
			case 1:
				if(__back_pb != null) __back_pb.removeMovieClip(); delete __back_pb;
				
				if(__step1 == null)
				{
					__step1 = Step1(createComponent(Step1, "__step1"));
					__step1.fromDate = __fromDate;
				}
				
				if(__next_pb == null)
				{
					__next_pb = Button(createComponent(Button, "__next_pb"));
					__next_pb.setReleaseCallback(this, nextStep);
					__next_pb.label = "Next";
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
					__step4.calendars = __calendars;
					__step4.description = __description;
					__step4.setChangeCallback(this, onChanged);
				}
				break;
				
			case 5:
				if(__step5 == null)
				{
					__step5 = Step5(createComponent(Step5, "__step5"));
					__step5.repeats = __repeats;
					__step5.setChangeCallback(this, onChanged);
				}
				break;
				
			
		}
		
		size();
	}
	
	private function size():Void
	{
		__title_lbl.setSize(__width, 16);
		
		if(__step1 != null)
		{
			__step1.move(0, __title_lbl.y + __title_lbl.height);
			__step1.setSize(__width, __step1.height);
		}
		
		if(__step2 != null)
		{
			__step2.move(0, __title_lbl.y + __title_lbl.height);
			__step2.setSize(__width, __step2.height);
		}
		
		if(__step3 != null)
		{
			__step3.move(0, __title_lbl.y + __title_lbl.height);
			__step3.setSize(__width, __step3.height);
		}
		
		if(__step4 != null)
		{
			__step4.move(0, __title_lbl.y + __title_lbl.height);
			__step4.setSize(__width, __step4.height);
		}
		
		if(__step5 != null)
		{
			__step5.move(0, __title_lbl.y + __title_lbl.height);
			__step5.setSize(__width, __step5.height);
		}
		
		__cancel_pb.setSize(50, 16);
		__cancel_pb.move(0, __height - __cancel_pb.height);
		
		if(__back_pb != null)
		{
			__back_pb.setSize(50, 16);
			__back_pb.move(__cancel_pb.x + __cancel_pb.width, __cancel_pb.y);
		}
		
		if(__next_pb != null)
		{
			__next_pb.setSize(50, 16);
			__next_pb.move(__width - __next_pb.width, __cancel_pb.y);
		}
	}
	
	public function nextStep():Void
	{
		if(__currentStep + 1 <= __maxSteps)
		{
			__currentStep++;
			invalidateDraw();
		}
	}
	
	public function previousStep():Void
	{
		if(__currentStep - 1 > 0)
		{
			__currentStep--;
			invalidateDraw();
		}
	}
	
	private function onCancel(event:ShurikenEvent):Void
	{
		__cancelCallback.dispatch(new Event(EVENT_CANCEL, this));
	}
	
	public function setupEvent(fromDate:Date,
							   toDate:Date,
							   what:String,
							   where:String,
							   calendars:Collection,
							   description:String,
							   repeats:String):Void
	{
		
		__fromDate 			= fromDate;
		__toDate			= toDate;
		__what				= what;
		__where				= where;
		__calendars			= calendars;
		__description 		= description;
		__repeats			= repeats;
		
		invalidateProperties();
	}
	
	private function onChanged(event:Event):Void
	{
		if(event.target == __step3)
		{
			__what = __step3.what;
			__where = __step3.where;
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