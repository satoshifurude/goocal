//import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.controls.Button;

class com.jxl.shuriken.controls.calendarclasses.CalendarDay extends Button
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.calendarclasses.CalendarDay";
	
	private var __toggle:Boolean 			= true;
	private var __isToday:Boolean 			= false;
	private var __border_mc:MovieClip;
	
	public function get isToday():Boolean { return __isToday; }
	public function set isToday(p_val:Boolean):Void
	{
		__isToday = p_val;
		invalidateDraw();
	}
	
	public function CalendarDay()
	{
	}
	
	private function draw():Void
	{
		super.draw();
		
		//trace("---------------");
		//trace("CalendarDay::draw");
		//trace("this: " + this);
		//trace("selected: " + selected);
		if(__isToday == true)
		{
			if(__border_mc == null) __border_mc = createEmptyMovieClip("__border_mc", getNextHighestDepth());
			__border_mc.lineStyle(2, 0x660000);
			com.jxl.shuriken.utils.DrawUtils.drawBox(__border_mc, 0, 0, __width, __height);
			__border_mc.endFill();
		}
		else
		{
			if(__border_mc != null)
			{
				__border_mc.removeMovieClip();
				delete __border_mc;
			}
		}
		   
		   
		border = false;
		
		switch (__currentState)
		{
			
			case DEFAULT_STATE:
				break;
				
			case SELECTED_STATE:
				/*
				lineStyle(0, 0x224466);
				lineTo(width, 0);
				moveTo(0, 1);
				lineTo(0, height);
				lineStyle(0, 0x99BBDD);
				moveTo(width, 0);
				lineTo(width, height);
				lineTo(0, height);
				beginFill(0x557799);
				endFill();
				*/
				border = true;
				borderColor = 0x224466;
				background = true;
				backgroundColor = 0x557799;
				break;
				
			case OVER_STATE:
				break;
			
		}
	}
	
}