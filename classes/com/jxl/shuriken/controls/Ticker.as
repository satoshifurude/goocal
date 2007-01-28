// TODO: This class needs an overhaul.  It should
// support both horizontal AND vertical scrolling
// as well as the new event callback structure.

import mx.effects.Tween;
import mx.utils.Delegate;
import mx.transitions.easing.Strong;

import com.jxl.shuriken.utils.DrawUtils

import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.managers.TweenManager;
import com.jxl.shuriken.core.DataSelectorTemplate;
import com.jxl.shuriken.core.UIComponent;

class com.jxl.shuriken.controls.Ticker extends DataSelectorTemplate {

	public static var symbolName:String = "com.jxl.shuriken.controls.Ticker";
	public static var symbolOwner:Object = com.jxl.shuriken.controls.Ticker;
	
	public var className:String = "Ticker";
	
	[Inspectable(type="Number", defaultValue=1000, name="Scroll Speed")]
	public var scrollSpeed=1000; // milliseconds
	[Inspectable(type="Number", defaultValue=3000, name="Rotate Speed")]
	public var rotateSpeed=3000; // milliseconds
	

	
	private static var outY:Number = -20
	private static var inY:Number =  20	
	
	private var __mcItem1:Button
	private var __mcItem2:Button
	
	private var __mcTopItem:Button	
	private var __mcBottomItem:Button
	
	private var __tweenMove1:Tween
	private var __tweenMove2:Tween
	
	private var __mcLastSelected:Button
	private var __mcNotLastSelected:Button
	
	private var __mcMask:MovieClip
	
	private var __RotateID:Number
	
	private var __bOutDone:Boolean  
	private var __bInDone:Boolean 
	private var __bPause:Boolean
	
	private var currentIndex:Number	
	
	public static var EVENT_TICKER_CLICK:String = "EventTickerClick"
	
	public static var EVENT_ROLL_OVER:String = "onTweenMoveOutUpdate";

	// property definitions
	
	private var __font:String;
	private var __fontDirty:Boolean = false;
	private var __bold:Boolean;
	private var __boldDirty:Boolean = false;	
	private var __textSize:Number;
	private var __textSizeDirty:Boolean = false;		
	private var __color:Number	= 0xFFFFFF;
	private var __colorDirty:Boolean = false;
	
	
	
	// getter / setter
	public function get font():String { return __font; }
	
	public function set font(pVal:String):Void
	{
		if(pVal != __font)
		{
			__font = pVal;
			__fontDirty = true;
			invalidateProperties();
		}
	}
	
	// getter / setter
	public function get bold():Boolean { return __bold; }
	
	public function set bold(pVal:Boolean):Void
	{
		if(pVal != __bold)
		{
			__bold = pVal;
			__boldDirty = true;
			invalidateProperties();
		}
	}

	// getter / setter
	public function get textSize():Number { return __textSize; }
	
	public function set textSize(pVal:Number):Void
	{
		if(pVal != __textSize)
		{
			__textSize = pVal;
			__textSizeDirty = true;
			invalidateProperties();
		}
	}

	[Inspectable(defaultValue="#000000", type="Color")]
	public function get color():Number { return __color; }
	
	public function set color(pVal:Number):Void
	{

		if(pVal != __color)
		{
			__color = pVal;
			__colorDirty = true;
			invalidateProperties();
		}
	}

	
	public function init():Void{
		super.init();	
		__bOutDone = true 
		__bInDone = true 	
		__bPause = false	
		currentIndex = 0
	}
	
	private function onInitialized():Void{
		super.onInitialized();	
	}	

	private function createChildren():Void
	{
		var fOnTickerItemClicked:Function
		var fOnTickerItemRollOver:Function
		var fOnTickerItemRollOut:Function
		
		super.createChildren();
		
		// TOOD: refactor this to be easier to extend
		__mcItem1 = Button(attachMovie(Button.symbolName,"__mcItem1", getNextHighestDepth()) )	
		__mcItem2 = Button(attachMovie(Button.symbolName,"__mcItem2", getNextHighestDepth()) )	
		__mcItem2.move(0, inY)
			
	
		// reusable delegate 
		fOnTickerItemClicked =  Delegate.create(this,onTickerItemClicked)
		fOnTickerItemRollOver =  Delegate.create(this,onTickerItemRollOver)
		fOnTickerItemRollOut =  Delegate.create(this,onTickerItemRollOut)		
		
		__mcItem1.addEventListener(Button.EVENT_PRESS,fOnTickerItemClicked)		
		__mcItem2.addEventListener(Button.EVENT_PRESS, fOnTickerItemClicked)	
		
		__mcItem1.addEventListener(Button.EVENT_ROLL_OVER,fOnTickerItemRollOver)		
		__mcItem2.addEventListener(Button.EVENT_ROLL_OVER,fOnTickerItemRollOver)		

		__mcItem1.addEventListener(Button.EVENT_ROLL_OUT,fOnTickerItemRollOut)		
		__mcItem2.addEventListener(Button.EVENT_ROLL_OUT,fOnTickerItemRollOut)	
	
		__mcLastSelected = __mcItem1
		__mcNotLastSelected  = __mcItem2
		
		__mcMask =  createEmptyMovieClip("__mcMask", getNextHighestDepth());	
		setMask(__mcMask);

	}
		
	private function size():Void{
		super.size();	
			
		__mcItem1.setSize(350,18)	
		__mcItem2.setSize(350,18)				

		__mcMask.beginFill(0x0000FF, 50);		
		// MASK COVERS top and bottom items  
		DrawUtils.drawMask(__mcMask, 0,0, __mcItem2.width, __mcItem2.height)
		__mcMask.endFill();

	}
	
	private function commitProperties():Void{
		super.commitProperties();

		if(__fontDirty == true){
			__fontDirty = false;
		
			__mcItem1.embedFonts = true
			__mcItem2.embedFonts = true
				
			__mcItem1.font = __font
			__mcItem2.font = __font
				
		}
		
		if(__boldDirty == true){
			__boldDirty = false;
			__mcItem1.bold = bold
			__mcItem2.bold = bold	
		}		
			

		if(__textSizeDirty == true){
			__textSizeDirty = false
			__mcItem1.textSize = __textSize
			__mcItem2.textSize = __textSize	
		}
		
		
		if(__colorDirty==true){
			__colorDirty = false
			__mcItem1.color = __color
			__mcItem2.color = __color	
		}

	}

	private function onTickerItemClicked(pEvent:Object):Void
	{		
		dispatchEvent({type:EVENT_TICKER_CLICK, target: this, currentIndex:currentIndex});			
	}
	
	private function onTickerItemRollOver(pEvent:Object):Void{
		__bPause = true		
	}
	
	private function onTickerItemRollOut(pEvent:Object):Void{
		__bPause = false
	}
	
	public function setTickerData(pArray:Array):Void{
		dataProvider = pArray
		currentIndex = 0
		
		// Ticker assumes min of 1 item.
		
			
		__mcItem1.label = NewsTickerVO(dataProvider[currentIndex]).label
		
		if (dataProvider.length > 1){ 
			currentIndex ++			
			__mcItem2.label = NewsTickerVO(dataProvider[currentIndex]).label	
		} else {
			__mcItem2.label = __mcItem1.label
		}
		
		
		clearInterval(__RotateID);
		__RotateID = setInterval(this, "next", rotateSpeed)
	}
	
		//OUT	
	private function onTweenMoveOutEnd(pVal:Number):Void
	{
		onTweenMoveOutUpdate(pVal);
		__bOutDone = true
		TweensComplete()
	}
	
	private function onTweenMoveOutUpdate(pVal:Number):Void{
		__mcLastSelected.move(__mcLastSelected.x, pVal)
	}
	
	private function moveItemOut():Void{
		__bOutDone= false 
		__tweenMove1 = new Tween(this , 0, outY, scrollSpeed);
		__tweenMove1.easingEquation = Strong.easeOut;
		__tweenMove1.setTweenHandlers("onTweenMoveOutUpdate", "onTweenMoveOutEnd");		
	}
	
	// IN 
	private function onTweenMoveInEnd(pVal:Number):Void
	{			
		onTweenMoveInUpdate(pVal);
		__bInDone = true
		TweensComplete()
	}
	
	private function onTweenMoveInUpdate(pVal:Number):Void{		
		__mcNotLastSelected.move(__mcNotLastSelected.x, pVal)	
	}
	
	
	private function moveItemIn():Void{
		__bInDone = false 
			
		__tweenMove2= new Tween(this, inY, 0,  scrollSpeed);			
		__tweenMove2.easingEquation = Strong.easeOut;
		__tweenMove2.setTweenHandlers("onTweenMoveInUpdate", "onTweenMoveInEnd");		
		
	}

	private function TweensComplete():Void{
			var oTemp:Button
		
			if (__bInDone && __bOutDone){
				// Move __mcLastSelected
				__mcLastSelected.move(__mcLastSelected.x, inY)
				__mcLastSelected.label = NewsTickerVO(dataProvider[currentIndex]).label
				
				// Swap LastSelected and NotLastSelected							
				oTemp  = __mcLastSelected 
				__mcLastSelected = __mcNotLastSelected
				__mcNotLastSelected = oTemp											
			}
	
	}

	private function next():Void
	{	
			
		if(__bInDone && __bOutDone && (dataProvider.length > 1) && (__bPause==false)){					
			moveItemIn()
			moveItemOut()	
							
			if (currentIndex+1 < dataProvider.length){
				currentIndex++
			} else {
				currentIndex = 0	
			}
			

		}
			
	}
	
	
}
