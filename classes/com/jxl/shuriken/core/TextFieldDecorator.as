﻿class com.jxl.shuriken.core.TextFieldDecorator
{
	
	public static function decorateTextField():Void
	{
		var p = TextField.prototype;
		p.setSize = function(w:Number, h:Number):Void
		{
			this._width = w;
			this._height = h;
		};
		p.move = function(x:Number, y:Number):Void
		{
			this._x = x;
			this._y = y;
		};
		
		TextField.ALIGN_LEFT			= "left";
		TextField.ALIGN_CENTER 			= "center";
		TextField.ALIGN_RIGHT 			= "right";
		
		TextField.TYPE_DYNAMIC 			= "dynamic";
		TextField.TYPE_INPUT 			= "input";
	}
	
}