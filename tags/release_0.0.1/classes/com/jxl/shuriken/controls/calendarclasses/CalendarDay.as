import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.controls.calendarclasses.CalendarDay extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.calendarclasses.CalendarDay";
	
	private var __selected:Boolean			= false;
	private var __isToday:Boolean 			= false;
	private var __background:Boolean		= false;
	private var __label:String				= "";
	private var __labelDirty:Boolean		= false;
	private var __backgroundColor:Number;
	private var __border_mc:MovieClip;
	private var __txt:TextField;
	
	
	
	public function get isToday():Boolean { return __isToday; }
	public function set isToday(p_val:Boolean):Void
	{
		__isToday = p_val;
		invalidateDraw();
	}
	
	public function get selected():Boolean { return __selected; }
	public function set selected(p_val:Boolean):Void
	{
		setSelectedNoEvent(p_val);
		dispatchEvent(new ShurikenEvent(ShurikenEvent.SELECTION_CHANGED, this));
	}
	
	public function setSelectedNoEvent(p_val:Boolean):Void
	{
		__selected = p_val;
		invalidateDraw();
	}
	
	public function get background():Boolean { return __background; }
	public function set background(p_val:Boolean):Void
	{
		__background = p_val;
		invalidateDraw();
	}
	
	public function get backgroundColor():Number { return __backgroundColor; }
	public function set backgroundColor(p_val:Number):Void
	{
		__backgroundColor = p_val;
		invalidateDraw();
	}
	
	public function get label():String { return __label; }
	public function set label(p_val:String):Void
	{
		__label = p_val;
		__labelDirty = true;
		invalidateProperties();
	}
	
	public function CalendarDay()
	{
		super();
		
		tabEnabled = true;
		focusEnabled = true;
		tabChildren = false;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__txt == null)
		{
			createTextField("__txt", getNextHighestDepth(), 0, 0, 0, 100, 100);
			__txt.multiline = false;
			__txt.wordWrap = false;
			__txt.selectable = false;
			var _fmt:TextFormat = new TextFormat();
			_fmt.font = "_sans";
			_fmt.size = 11;
			__txt.setTextFormat(_fmt);
			__txt.setNewTextFormat(_fmt);
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__labelDirty == true)
		{
			__labelDirty = false;
			__txt.text = __label;
		}
	}
	
	private function draw():Void
	{
		super.draw();
		
		if(__isToday == true)
		{
			if(__border_mc == null) __border_mc = createEmptyMovieClip("__border_mc", getNextHighestDepth());
			__border_mc.lineStyle(2, 0x660000);
			DrawUtils.drawBox(__border_mc, 0, 0, __width, __height);
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
		   
		if(__selected == true)
		{
			__txt.border = true;
			__txt.borderColor = 0x224466;
		}
		else
		{
			__txt.border = false;
		}
		
		if(__background == true)
		{
			__txt.background = true;
			__txt.backgroundColor = __backgroundColor;
		}
		else
		{
			__txt.background = false;
		}
			
	}
	
	private function size():Void
	{
		super.size();
		
		__txt._width = __width;
		__txt._height = __height;
	}
	
}