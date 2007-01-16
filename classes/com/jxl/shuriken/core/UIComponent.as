﻿import mx.events.EventDispatcher;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.core.IUIComponent;
//import com.jxl.shuriken.managers.MovieClipBuilder;
//import com.jxl.shuriken.vo.MovieClipBuilderTicketVO;

class com.jxl.shuriken.core.UIComponent extends MovieClip implements IUIComponent
{
	
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.core.UIComponent";
	public static var SYMBOL_OWNER:Object = com.jxl.shuriken.core.UIComponent;
	
	public static var EVENT_SIZE:String = "com.jxl.shuriken.core.UIComponent.size";
	
	// Abstract variable; set it to whatever you want.
	public var data:Object;
	
	// overwritten by mixin (EventDispatcher)
	public function addEventListener(p_type:String, p_list:Object):Void{}
	public function dispatchEvent(p_event:Event):Void{}
	public function removeEventListener(p_type:String, p_list:Object):Void{}
	
	private var __calledOnLoad:Boolean;
	
	public function get width():Number
	{
		return __width;
	}
	
	public function get height():Number
	{
		return __height;
	}
	
	public function get x():Number
	{
		return _x;
	}
	
	public function get y():Number
	{
		return _y;
	}
	
	public function get visible():Boolean
	{
		return _visible;
	}
	
	public function set visible(val:Boolean):Void
	{
		_visible = val;
	}
	
	public function UIComponent()
	{
		constructObject();
	}
	
	public function getSymbolName():String
	{
		return SYMBOL_NAME;
	}
	
	public function init():Void
	{
		__width 		= _width;
		__height 		= _height;
		
		_xscale 		= 100;
		_yscale 		= 100;
		
		__boundingBox_mc._visible = false;
		__boundingBox_mc._width = __boundingBox_mc._height = 0;
		
		__calledOnLoad = false;
		
		watch("enabled", enabledChanged);

		// special case for enable since it isn't getter/setter
		// all components assume enabled unless set to disabled
		if(enabled == false)
		{
			setEnabled(false);
		}
	}
	
	public function move(p_x:Number, p_y:Number):Void
	{
		_x 			= p_x;
		_y 			= p_y;
	}
	
	public function setSize(p_width:Number, p_height:Number):Void
	{
		__width 		= p_width;
		__height 		= p_height;
		
		size();
	}
	
	private function enabledChanged(pID:String, pOldValue:Boolean, pNewValue:Boolean):Boolean
	{
		setEnabled(pNewValue);
		return pNewValue;
	}
	
	private function setEnabled(p_enabled:Boolean):Void
	{
		invalidate();
	}
	
	/*
	public function contains(pX:Number, pY:Number):Boolean{
		var bReturn:Boolean = false
		
		pX = Math.round(pX)
		pY = Math.round(pY)
		
		if (((pX >= x) && (pX  <=  x + width)) && ( (pY >= y) && (pY <= y + height))){
			bReturn = true
		}
			
		return bReturn		
	}
	*/
	
	
	public function invalidateProperties():Void
	{
		callLater(this, commitProperties);
	}
	
	public function invalidateDraw():Void
	{
		callLater(this, draw);
	}
	
	public function invalidateSize():Void
	{
		callLater(this, size);
	}
	
	// TODO: prevent the methods above from getting called since
	// we're about to invalidate everything anyway
	public function invalidate():Void
	{
		callLater(this, refresh);
	}
	
	// LIMITATION: you cannot add the same scope & function to a callLater
	public function callLater(p_scope:Object, p_func:Function, p_args:Array):Void
	{
		if(__arrayMethodTable == null)
		{
			__arrayMethodTable = [];
		}
		else
		{
			var i:Number = __arrayMethodTable.length;
			while(i--)
			{
				var o:Object = __arrayMethodTable[i];
				if(o.s == p_scope && o.f == p_func)
				{
					return;
				}
			}
		}
		__arrayMethodTable.push({s: p_scope, f: p_func, a: p_args});
		onEnterFrame = callLaterDispatcher;
	}
	
	private function callLaterDispatcher():Void
	{
		//trace("----------------------");
		//trace("UIComponent::callLaterDispatcher");
		//trace("before onEnterFrame: " + onEnterFrame);
		delete onEnterFrame;
		//trace("after onEnterFrame: " + onEnterFrame);
		
		// make a copy of the methodtable so methods called can requeue themselves w/o putting
		// us in an infinite loop
		var __methodTable:Array = __arrayMethodTable;
		// new doLater calls will be pushed here
		__arrayMethodTable = [];

		// now do everything else
		if (__methodTable.length > 0)
		{
			var m:Object;
			while((m = __methodTable.shift()) != undefined)
			{
				m.f.apply(m.s, m.a);
			}
		}
	}
	
	public function cancelAllCallLaters():Void
	{
		__arrayMethodTable.splice(0);
		delete onEnterFrame;
	}
	
	// called 1 frame after movieclip loads
	public function onLoad():Void
	{	
		if(__calledOnLoad == false)
		{
			__calledOnLoad = true;
			onInitialized();
		}
	}
	
	// Abstract methods - override these
	// Abstract
	private function createChildren():Void
	{
	}
	
	// Abstract
	// check your dirty flags, and call redraw / resize methods
	public function commitProperties():Void
	{
	}
	
	// Abstract
	// redraw your component
	private function draw():Void
	{
	}
	
	// Abstract
	// resize your component
	private function size():Void
	{
		/*
		clear();
		lineStyle(0, 0x000000);
		beginFill(0xCCCCCC);
		lineTo(width, 0);
		lineTo(width, height);
		lineTo(0, height);
		lineTo(0, 0);
		endFill();
		*/
		//trace("-----------------");
		//trace("UIComponent::size");
		dispatchEvent(new ShurikenEvent(ShurikenEvent.SIZE, this));
	}
	
	// Abstract
	// used for initializing authortime content
	private function onInitialized():Void
	{
	}
	
	public function setFocus():Void
	{
		Selection.setFocus(this);
	}
	
	public function getFocus():Object
	{
		return Selection.getFocus();
	}
	
	// Internals
	private function constructObject():Void
	{
		// this gets called when being defined as the prototype
		// don't do anything, just return.
		if (_name == undefined)
		{
			return;
		}
		
		__isConstructing = true;
		init();
		createChildren();
		refresh();
		__isConstructing = false;
	}
	
	// redraws everything; used in default invalidate
	private function refresh():Void
	{
		commitProperties();
		draw();
		size();
	}
	
	public function createComponent(p_class:IUIComponent, p_name:String):MovieClip
	{
		// HACK: compiler hack; can't put static functions or properties in interfaces
		var theClass = p_class;
		var ref:MovieClip = attachMovie(theClass.SYMBOL_NAME, p_name, getNextHighestDepth());
		return ref;
	}
	
	public function toString():String
	{
		return "[object com.jxl.shuriken.core.UIComponent]";
	}
	
	// IUIComponent implementation
	public function getEnabled():Boolean { return enabled; }
	public function getVisible():Boolean { return _visible; }
	public function getWidth():Number { return __width; }
	public function getHeight():Number { return __height; }
	public function getX():Number { return _x; }
	public function getY():Number { return _y; }
	public function getData():Object { return data; }
	public function setData(p_val:Object):Void { data = p_val; }
	
	// defferred instantantiationasdfljakljksjdfkjalkjsdf
	
	//public function attachMovieDeferred(p_parent:MovieClip, p_linkage:String, p_name:String, p_depth:Number, p_initObj:Object):MovieClipBuilderTicketVO
	//{
		//var mcb:MovieClipBuilder = MovieClipBuilder.getInstance();
		//var mcbtVO:MovieClipBuilderTicketVO = mcb.attachMovieDeferred(p_parent, p_linkage, p_name, p_depth, p_initObj);
		//return mcbtVO;
	//}
	
	//private static function frameworkInit():Void
	//{
		//var d:Number = _root.getNextHighestDepth();
		///var ref:MovieClip = _root.createEmptyMovieClip("Shuriken_Framework_do_not_remove", d);
		//MovieClipBuilder.getInstance().init(ref);
	//}
	
	
	private static var __makeEventDispatcher = EventDispatcher.initialize(com.jxl.shuriken.core.UIComponent.prototype);
	//private static var __frameworkInit = frameworkInit();
	
	private var __isConstructing:Boolean;
	private var __width:Number;
	private var __height:Number;
	private var __boundingBox_mc:MovieClip;
	private var __arrayMethodTable:Array;
	
	
}