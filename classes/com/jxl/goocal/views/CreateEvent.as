import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.events.ShurikenEvent;

import com.jxl.goocal.views.createevent.Step1;
import com.jxl.goocal.views.createevent.Step2;
import com.jxl.goocal.views.createevent.Step3;
import com.jxl.goocal.views.createevent.Step4;
import com.jxl.goocal.views.GCHeading;

class com.jxl.goocal.views.CreateEvent extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.CreateEvent";
	
	// 1 based, not 0 based
	private var __currentStep:Number = 1;
	private var __maxSteps:Number = 4;
	
	private var __title_lbl:GCHeading;
	private var __step1:Step1;
	private var __step2:Step2;
	private var __step3:Step3;
	private var __step4:Step4;
	private var __cancel_pb:Button;
	private var __back_pb:Button;
	private var __next_pb:Button; // doubles as save button
	
	public function CreateEvent()
	{
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
		
		switch(__currentStep)
		{
			case 1:
				if(__back_pb != null) __back_pb.removeMovieClip(); delete __back_pb;
				
				if(__step1 == null) __step1 = Step1(createComponent(Step1, "__step1"));
				if(__next_pb == null)
				{
					__next_pb = Button(createComponent(Button, "__next_pb"));
					__next_pb.setReleaseCallback(this, nextStep);
					__next_pb.label = "Next";
				}
				break;
				
			case 2:
				if(__step2 == null) __step2 = Step2(createComponent(Step2, "__step2"));
				if(__back_pb == null)
				{
					__back_pb = Button(createComponent(Button, "__back_pb"));
					__back_pb.setReleaseCallback(this, previousStep);
					__back_pb.label = "Back";
				}
				break;
				
			case 3:
				if(__step3 == null) __step3 = Step3(createComponent(Step3, "__step3"));
				break;
				
			case 4:
				if(__step4 == null) __step4 = Step4(createComponent(Step4, "__step4"));
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
}