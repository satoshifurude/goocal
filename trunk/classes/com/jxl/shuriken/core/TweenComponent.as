import mx.effects.Tween;
import mx.transitions.easing.Strong;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.managers.TweenManager;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.core.TweenComponent extends UIComponent
{
	
	public static var symbolName:String = "com.jxl.shuriken.core.TweenComponent";
	public static var symbolOwner:Object = com.jxl.shuriken.core.TweenComponent;
	
	public static var EVENT_EFFECT_MOVE_START:String = "effectMoveStart";
	public static var EVENT_EFFECT_MOVE_END:String = "effectMoveEnd";
	public static var EVENT_EFFECT_SIZE_START:String = "effectSizeStart";
	public static var EVENT_EFFECT_SIZE_END:String = "effectSizeEnd";
	
	public var className:String = "Component";
	public var moveSpeed:Number = 300;
	public var sizeSpeed:Number = 500;
	
	public function get oldX():Number { return __oldX; }
	public function get oldY():Number { return __oldY; }
	
	
	private var __oldX:Number;
	private var __oldY:Number;
	private var __targetX:Number;
	private var __targetY:Number;
	private var __oldWidth:Number;
	private var __oldHeight:Number;
	private var __targetWidth:Number;
	private var __targetHeight:Number;
	private var __tweenMove:Tween;
	private var __tweenSize:Tween;
	
	// Override
	public function move(pX:Number, pY:Number, pQuickMove:Boolean):Void
	{
		__oldX 		= _x;
		__oldY 		= _y;
		if(pQuickMove != true)
		{
			if(__oldX != pX || __oldY != pY)
			{
				__targetX = pX;
				__targetY = pY;
				moveToTargets();
			}
			else
			{
				super.move(pX, pY);
			}
		}
		else
		{
			super.move(pX, pY);
		}
	}
	
	// Override
	public function setSize(pWidth:Number, pHeight:Number, pImmediate:Boolean):Void
	{
		__oldWidth 		= __width;
		__oldHeight 	= __height;	

		if(pImmediate != true)
		{
			if(__oldWidth != pWidth || __oldHeight != pHeight){
				__targetWidth = pWidth;
				__targetHeight = pHeight;
				sizeToTargets();
			} else {
				removeSizeTween();
				super.setSize(pWidth, pHeight);
			}
		}
		else
		{
				removeSizeTween();
				super.setSize(pWidth, pHeight);
		}
	}
	
	private function moveToTargets():Void
	{
		removeMoveTween();
		
		// BUG: tried to ensure the animation would complete without problems from user
		// interaction, but this causes an invalidate, and thus an infinite loop
		//enabled = false;
		
		dispatchEvent(new ShurikenEvent(ShurikenEvent.EFFECT_MOVE_START, this));
		
		__tweenMove = new Tween(this, [__oldX, __oldY], [__targetX, __targetY], moveSpeed);
		__tweenMove.easingEquation = Strong.easeOut;
		__tweenMove.setTweenHandlers("onTweenMoveUpdate", "onTweenMoveEnd");
	}
	
	private function removeMoveTween():Void
	{
		if(__tweenMove != null)
		{
			TweenManager.abortTween(__tweenMove);
			delete __tweenMove;
		}
	}
	
	private function onTweenMoveUpdate(pVal:Array):Void
	{
		__oldX 		= _x;
		__oldY 		= _y;
		super.move(pVal[0], pVal[1]);
	}
	
	private function onTweenMoveEnd(pVal:Array):Void
	{
		onTweenMoveUpdate(pVal);
		delete __tweenMove;
		//enabled = true
		dispatchEvent(new ShurikenEvent(ShurikenEvent.EFFECT_MOVE_START, this));
	}
	
	private function sizeToTargets():Void
	{
		removeSizeTween();
		
		//enabled = false
		
		dispatchEvent(new ShurikenEvent(ShurikenEvent.EFFECT_MOVE_START, this));
		
		__tweenSize = new Tween(this, [__oldWidth, __oldHeight], [__targetWidth, __targetHeight], sizeSpeed);
		__tweenSize.easingEquation = Strong.easeOut;
		__tweenSize.setTweenHandlers("onTweenSizeUpdate", "onTweenSizeEnd");
	}
	
	private function onTweenSizeUpdate(pVal:Array):Void
	{
		__oldWidth		= __width;
		__oldHeight		= __height;
		super.setSize(pVal[0], pVal[1]);
	}
	
	private function onTweenSizeEnd(pVal:Array):Void
	{
		onTweenSizeUpdate(pVal);
		delete __tweenSize;	
		//enabled = true			
		dispatchEvent(new ShurikenEvent(ShurikenEvent.EFFECT_MOVE_START, this));
	}
	
	private function removeSizeTween():Void
	{
		if(__tweenSize != null)
		{
			TweenManager.abortTween(__tweenSize);
			delete __tweenSize;
		}
	}
}