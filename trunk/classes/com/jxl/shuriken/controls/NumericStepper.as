import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;
import com.jxl.shuriken.utils.DrawUtils;

class com.jxl.shuriken.controls.NumericStepper extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.NumericStepper";
	
	private var __value:Number 							= 0;
	private var __valueDirty:Boolean					= false;
	// minimum has to be positive and less than the maximum
	private var __minimum:Number 						= 0;
	private var __minimumDirty:Boolean					= false;
	// maximum has to be positive and more than the minimum
	private var __maximum:Number 						= 10;
	private var __maximumDirty:Boolean					= false;
	// increments are only allowed to be positive
	private var __incrementAmount:Number 				= 1;
	private var __incrementAmountDirty:Boolean			= false;
	private var __changeCallback:Callback;
	
	private var __valueField:TextField;
	private var __upArrow:SimpleButton;
	private var __downArrow:SimpleButton;
	
	public function get value():Number { return __value; }
	public function set value(p_val:Number):Void
	{
		setValue(p_val);
		invalidateProperties();
	}
	
	public function get minimum():Number { return __minimum; }
	public function set minimum(p_val:Number):Void
	{
		if(p_val <= 0 || p_val >= __maximum) return;
		__minimum = p_val;
		__minimumDirty = true;
		invalidateProperties();
	}
	
	public function get maximum():Number { return __maximum; }
	public function set maximum(p_val:Number):Void
	{
		if(p_val <= 0 || p_val <= __maximum) return;
		__maximum = p_val;
		__maximumDirty = true;
		invalidateProperties();
	}
	
	public function get incrementAmount():Number { return __incrementAmount; }
	public function set incrementAmount(p_val:Number):Void
	{
		if(p_val <= 0) return;
		__incrementAmount = p_val;
		__incrementAmountDirty = true;
		invalidateProperties();
	}
	
	public function NumericStepper()
	{
	}
	
	
	public function setMinMax(min:Number, max:Number):Void
	{
		__minimum = min;
		__maximum = max;
		__minimumDirty = true;
		__maximumDirty = true;
		invalidateProperties();
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__valueField == null)
		{
			createTextField("__valueField", getNextHighestDepth(), 0, 0, 18, 18);
			__valueField.background = true;
			__valueField.backgroundColor = 0xFFFFFF;
			__valueField.border = true;
			__valueField.borderColor = 0x000000;
			__valueField.multiline = false;
			__valueField.wordWrap = false;
			var fmt:TextFormat = new TextFormat();
			fmt.font = "_sans";
			fmt.size = 11;
			fmt.color = 0x000000;
			__valueField.setTextFormat(fmt);
			__valueField.setNewTextFormat(fmt);
			__valueField.type = "input";
			__valueField.onChanged = Delegate.create(this, onFieldChanged);
			__valueField.text = String(__value);
			__valueField.variable = "__valueField_var";
			//fscommand2("SetInputTextType", _target + ":" + __valueField.variable, "Numeric");
		}
		
		setupButtons();
		
	}
	
	private function setupButtons():Void
	{
		if(__upArrow == null)
		{
			__upArrow = SimpleButton(createComponent(SimpleButton, "__upArrow"));
			__upArrow.setReleaseCallback(this, increment);
			// magic numberz 4 t3h w1n!
			__upArrow.setSize(12, 9);
		}
		
		if(__downArrow == null)
		{
			__downArrow = SimpleButton(createComponent(SimpleButton, "__downArrow"));
			__downArrow.setReleaseCallback(this, decrement);
			__downArrow.setSize(12, 9);
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__valueDirty == true)
		{
			__valueDirty = false;
			__valueField.text = String(__value);
		}
	}
	
	private function size():Void
	{
		super.size();
		
		__valueField._x = __valueField._y = 0;
		__valueField._width = __width - Math.max(__upArrow.width, __downArrow.width);
		__valueField._height = __height;
		
		__upArrow.move(__valueField._x + __valueField._width, 0);
		__downArrow.move(__upArrow.x, __upArrow.y + __upArrow.height);
		
		// draws the buttons n' triangles
		__upArrow.clear()
		__upArrow.lineStyle(0, 0x333333)
		__upArrow.beginFill(0xCCCCCC);
		DrawUtils.drawBox(__upArrow, 0, 0, __upArrow.width - 1, __upArrow.height)
		var centerX:Number = __upArrow.width / 2;
		var centerY:Number = __upArrow.height / 2;
		var tW:Number = 5;
		var tH:Number = 3;
		var xTarget:Number = Math.round(centerX - (tW / 2));
		var yTarget:Number = Math.round(centerY + (tH / 2));
		DrawUtils.drawTriangle(__upArrow, xTarget, yTarget, tW, tH);
		__upArrow.beginFill(0x333333);
		DrawUtils.drawTriangle(__upArrow, xTarget, yTarget, tW, tH);
		__upArrow.endFill();
		
		__downArrow.clear();
		__downArrow.lineStyle(0, 0x333333);
		__downArrow.beginFill(0xCCCCCC);
		yTarget = Math.round(centerY / 2);
		DrawUtils.drawBox(__downArrow, 0, 0, __downArrow.width - 1, __downArrow.height);
		DrawUtils.drawTriangle(__downArrow, xTarget, yTarget, tW, tH, 180);
		__downArrow.beginFill(0x333333);
		DrawUtils.drawTriangle(__downArrow, xTarget, yTarget, tW, tH, 180);
		__downArrow.endFill();
	}
	
	private function setValue(p_val:Number, noEvent:Boolean):Void
	{
		var oldVal:Number = __value;
		__value = p_val;
		__valueDirty = true;
		if(noEvent == true) return;
		if(oldVal != __value)
		{
			var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.CHANGE, this);
			event.oldValue = oldVal;
			event.value = __value;
			__changeCallback.dispatch(event);
		}
	}
	
	private function onFieldChanged():Void
	{
		var val:Number = parseInt(__valueField.text);
		if(isNaN(val) == false) setValue(val, true);
	}
	
	public function increment():Void
	{
		if(__value + __incrementAmount <= __maximum) value = __value + __incrementAmount;
	}
	
	public function decrement():Void
	{
		if(__value - __incrementAmount >= __minimum) value = __value - __incrementAmount;
	}
	
	public function setChangeCallback(scope:Object, func:Function):Void
	{
		__changeCallback = new Callback(scope, func);
	}
}