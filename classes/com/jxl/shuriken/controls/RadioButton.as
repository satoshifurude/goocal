﻿import com.jxl.shuriken.controls.Button;

class com.jxl.shuriken.controls.RadioButton extends Button
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.RadioButton";
	
	private var __mcRadioButtonOutline:MovieClip;
	private var __mcRadioButtonCenter:MovieClip;
	
	public function RadioButton()
	{
		super();
		
		__toggle = true;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		// TODO: make the below factories so easier to extend
		__mcRadioButtonOutline = attachMovie("RadioButtonOutline", "__mcRadioButtonOutline", getNextHighestDepth());
		__mcRadioButtonCenter = attachMovie("RadioButtonCenter", "__mcRadioButtonCenter", getNextHighestDepth());
	}
	
	// Overwrite; do not call super
	private function draw():Void
	{
		switch (__currentState)
		{
				
			case DEFAULT_STATE:
				__mcRadioButtonCenter._visible = false;
				break;
				
			case SELECTED_STATE:
				__mcRadioButtonCenter._visible = true;
				break;
				
			case OVER_STATE:
				break;
		}
	}
	
	// Overwrite; do not call super
	private function size():Void
	{
		__mcRadioButtonOutline._x = 0;
		__mcRadioButtonOutline._y = 0;
		var centerBiggerThanOutline:Boolean;
		
		if(__mcRadioButtonOutline._width > __mcRadioButtonCenter._width && __mcRadioButtonOutline._height > __mcRadioButtonCenter._height)
		{
			__mcRadioButtonCenter._x = __mcRadioButtonOutline._x + (__mcRadioButtonOutline._width / 2) - (__mcRadioButtonCenter._width / 2);
			__mcRadioButtonCenter._y = __mcRadioButtonOutline._y + (__mcRadioButtonOutline._height / 2) - (__mcRadioButtonCenter._height / 2);
			centerBiggerThanOutline = false;
		}
		else
		{
			__mcRadioButtonCenter._x = 0;
			__mcRadioButtonCenter._y = 0;
			centerBiggerThanOutline = true;
		}
		
		var theLeft:Number;
		if(centerBiggerThanOutline == false)
		{
			theLeft = __mcRadioButtonOutline._x + __mcRadioButtonOutline._width;
		}
		else
		{
			theLeft = __mcRadioButtonCenter._x + __mcRadioButtonCenter._width;
		}
		
		var iconExists:Boolean;
		
		// icon doesn't exist, center label
		if(__mcIcon == null)
		{
			iconExists = false;
		}
		// icon exists, but his content is blank
		else if(__mcIcon.contentPath == null || __mcIcon.contentPath == "")
		{
			iconExists = false;
		}
		else
		{
			iconExists = true;
		}

		var textMargin:Number = 4;
		if(iconExists == false)
		{
			
			if (__mcLabel.height > __height)
			{
				// text field is bigger than container
			}
			
			__mcLabel.move(theLeft + textMargin, (__height / 2) - (__mcLabel.height / 2));
			__mcLabel.setSize(__width - __mcLabel.x, __mcLabel.height);
		}
		else
		{
			__mcIcon.move(theLeft + textMargin, 0);
			__mcLabel.move(__mcIcon.x + __mcIcon.width + textMargin, (__height / 2) - (__mcLabel.height / 2));
			__mcLabel.setSize(__width - __mcLabel.x, __mcLabel.height);
		}
		
	}
	
}