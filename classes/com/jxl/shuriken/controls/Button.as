import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Loader;
import com.jxl.shuriken.events.ShurikenEvent;
import mx.utils.Delegate;

[InspectableList("alignIcon", "background", "backgroundColor", "bold", "border", "borderColor", "embedFonts", "label", "color", "textSize", "multiline", "wordWrap", "font", "password", "selectable", "restrict", "maxChars", "toggle", "selected")]
class com.jxl.shuriken.controls.Button extends SimpleButton
{
	//REQUIRED INFO/------------------------------------------
	
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.Button";
	
	public static var EVENT_SELECTION_CHANGED:String = "selectionChanged";
	
	public static var ALIGN_ICON_LEFT:String = "alignIconLeft";
	public static var ALIGN_ICON_CENTER:String = "alignIconCenter";
	public static var ALIGN_ICON_RIGHT:String = "alignIconRight";
	
	public static var SELECTED_STATE:String = "selected";
	public static var DEFAULT_STATE:String = "default";
	public static var OVER_STATE:String = "over";
	
	public var className:String = "Button";
	
	//PUBILC PROPERTIES/--------------------------------------
	
	/**
	* Text on Button's label
	*/
	[Inspectable(type="String", defaultValue="", name="Label")]
	public function get label():String { return __label; }
	public function set label(pVal:String):Void
	{
		if(pVal != __label)
		{
			__label = pVal;
			__labelDirty = true;
			invalidateProperties();
		}
	}
	
	/**
	* A Boolean that indicates whether toggling is enabled.
	* 
	* Setting this to true will make the button's selected state toggle,
	* when it is clicked.
	*/
	[Inspectable(type="Boolean", defaultValue=false, name="Toggle")]
	public function get toggle ():Boolean { return __toggle; }
	public function set toggle (value:Boolean):Void 
	{
		if(value != __toggle)
		{
			__toggle = value;
			__toggleDirty = true;
			invalidateProperties();
		}
	}
	
	/**
	* A Boolean that indicates whether the button is in its selected state
	* 
	* This property is only updated (and is only relevant) when toggle is set to true.
	* 
	*/
	[Inspectable(type="Boolean", defaultValue=false, name="Selected")]
	public function get selected ():Boolean {return __selected;}
	
	public function set selected (value:Boolean):Void
	{
		if(value != __selected && __toggle == true)
		{
			__selected = value;
			__selectedDirty = true;
			
			if (__selected == true)
			{
				setState(SELECTED_STATE);
			}
			else
			{
				setState(DEFAULT_STATE);
			}
			dispatchEvent(new ShurikenEvent(ShurikenEvent.SELECTION_CHANGED, this));
			invalidateProperties();
		}
		
	}
	
	public function get icon():String { return __icon; }
	
	public function set icon(pVal:String):Void
	{
		if(pVal != __icon)
		{
			__icon = pVal;
			__iconDirty = true;
			invalidateProperties();
		}
	}
	
	
	// Proxying styles from 
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get background():Boolean
	{
		return __mcLabel.background;
	}
	
	public function set background(pVal:Boolean):Void
	{		
		if(pVal != __background)
		{
			__background = pVal;
			__backgroundDirty = true;
			invalidateProperties();
		}
		
	}	
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="#FFFFFF", type="Color")]
	public function get backgroundColor():Number
	{
		return __mcLabel.backgroundColor;
	}
	
	public function set backgroundColor(p_val:Number):Void
	{
		__backgroundColor = p_val;
		__backgroundColorDirty = true;
		invalidateProperties();
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get bold():Boolean
	{
		return __mcLabel.bold;
	}
	
	public function set bold(pVal:Boolean):Void
	{		
		if(pVal != __bold)
		{
			__bold = pVal;
			__boldDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get border():Boolean
	{
		return __mcLabel.border;
	}
	
	public function set border(pVal:Boolean):Void
	{		
		if(pVal != __border)
		{
			__border = pVal;
			__borderDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="#000000", type="Color")]
	public function get borderColor():Number
	{
		return __mcLabel.borderColor;
	}
	
	public function set borderColor(pVal:Number):Void
	{		
		if(pVal != __borderColor)
		{
			__borderColor = pVal;
			__borderColorDirty = true;
			invalidateProperties();
		}
		
	}


	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get embedFonts():Boolean
	{
		return __mcLabel.embedFonts;
	}
	
	public function set embedFonts(pVal:Boolean):Void
	{		
		if(pVal != __embedFonts)
		{
			__embedFonts = pVal;
			__embedFontsDirty = true;
			invalidateProperties();
		}
	
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="#000000", type="Color")]
	public function get color():Number
	{
		return __mcLabel.color;
	}
	
	public function set color(pVal:Number):Void
	{		
		if(pVal != __color)
		{
			__color = pVal;
			__colorDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=12, type="Number")]
	public function get textSize():Number
	{
		return __mcLabel.textSize;
	}
	
	public function set textSize(pVal:Number):Void
	{		
		if(pVal != __textSize)
		{
			__textSize = pVal;
			__textSizeDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get multiline():Boolean
	{
		return __mcLabel.multiline;
	}
	
	public function set multiline(pVal:Boolean):Void
	{		
		if(pVal != __multiline)
		{
			__multiline = pVal;
			__multilineDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get wordWrap():Boolean
	{
		return __mcLabel.wordWrap;
	}
	
	public function set wordWrap(pVal:Boolean):Void
	{		
		if(pVal != __wordWrap)
		{
			__wordWrap = pVal;
			__wordWrapDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue="_sans", type="Font Name")]
	public function get font():String
	{
		return __mcLabel.font;
	}
	
	public function set font(pVal:String):Void
	{		
		if(pVal != __font)
		{
			__font = pVal;
			__fontDirty = true;
			invalidateProperties();
		}
	
	}
	
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=undefined, type="Boolean")]
	public function get password():Boolean
	{
		return __mcLabel.password;
	}
	
	public function set password(pVal:Boolean):Void
	{		
		if(pVal != __password)
		{
			__password = pVal;
			__passwordDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get selectable():Boolean
	{
		return __mcLabel.selectable;
	}
	
	public function set selectable(pVal:Boolean):Void
	{		
		if(pVal != __selectable)
		{
			__selectable = pVal;
			__selectableDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(type="String")]
	public function get restrict():String
	{
		return __mcLabel.restrict;
	}
	
	public function set restrict(pVal:String):Void
	{		
		if(pVal != __restrict)
		{
			__restrict = pVal;
			__restrictDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=null, type="Number")]
	public function get maxChars():Number
	{
		return __mcLabel.maxChars;
	}
	
	public function set maxChars(pVal:Number):Void
	{		
		if(pVal != __maxChars)
		{
			__maxChars = pVal;
			__maxCharsDirty = true;
			invalidateProperties();
		}
		
	}
	
	// ----------------------------------------------------------------------------------------
	[Inspectable(defaultValue=alignIconLeft, type="List", enumeration="alignIconLeft,alignIconCenter,alignIconRight") )]
	public function get alignIcon():String { return __alignIcon; }
	
	public function set alignIcon(pVal:String):Void
	{
		if(pVal != __alignIcon)
		{
			__alignIcon = pVal;
			__alignIconDirty = true;
			invalidateProperties();
		}
	}
	
	public function get underline():Boolean { return __underline; }
	
	public function set underline(p_val:Boolean):Void
	{
		__underline = p_val;
		__underlineDirty = true;
		invalidateProperties();
	}
	
	public function get currentState():String { return __currentState; }
	
	
	/**
	* Draws basic states for debug purposes
	*/
	public var debug:Boolean = false;
	
	
	//PRIVATE VARS/---------------------------------------
		
	private var __label:String;
	private var __labelDirty:Boolean;
	
	private var __selected:Boolean						= false;
	private var __selectedDirty:Boolean;
	
	private var __toggle:Boolean;
	private var __toggleDirty:Boolean;
	
	private var __currentState:String 					= "default";
	private var __lastState:String 						= "";
	
	private var __icon:String;
	private var __iconDirty:Boolean;
	
	private var __loadInitDelegate:Function;
	
	private var __backgroundDirty:Boolean 				= false;
	private var __background:Boolean					= false;
	
	private var __backgroundColorDirty:Boolean			= false;
	private var __backgroundColor:Number
	
	private var __boldDirty:Boolean 					= false;
	private var __bold:Boolean							= false;

	private var __borderDirty:Boolean 					= false;
	private var __border:Boolean
	
	private var __borderColorDirty:Boolean				= false;
	private var __borderColor:Number		
	
	private var __embedFontsDirty:Boolean 				= false;
	private var __embedFonts:Boolean;
	
	private var __colorDirty:Boolean 					= false;
	private var __color:Number
	
	private var __textSizeDirty:Boolean 				= false;
	private var __textSize:Number	
	
	private var __multilineDirty:Boolean 				= false;
	private var __multiline:Boolean	

	private var __wordWrapDirty:Boolean 				= false;
	private var __wordWrap:Boolean		

	private var __fontDirty:Boolean 					= false;
	private var __font:String
	
	private var __passwordDirty:Boolean 				= false;
	private var __password:Boolean
	
	private var __selectableDirty:Boolean 				= false;
	private var __selectable:Boolean					= false;

	private var __restrictDirty:Boolean					= false;
	private var __restrict:String		
	
	private var __maxCharsDirty:Boolean 				= false;
	private var __maxChars:Number;
	
	private var __alignIcon:String						= "alignIconLeft";
	private var __alignIconDirty:Boolean 				= false;
	
	private var __underline:Boolean						= false;
	private var __underlineDirty:Boolean				= false;
	
	//ASSETS/------------------------------------------------
	private var __mcLabel:UITextField;
	private var __mcIcon:Loader;
	
	//MOUSE EVENT HANDLERS/----------------------------------
	
	private function buttonRelease():Void {
		super.buttonRelease();
		if (__toggle == true)
		{
			selected = !selected;
		}
	}
	
	private function buttonRollOver():Void {
		super.buttonRollOver();
		setState(OVER_STATE);
		invalidateDraw();
	}
	
	private function buttonRollOut():Void {
		super.buttonRollOut();
		if (__selected) {
			setState(SELECTED_STATE);
		} else {
			setState(DEFAULT_STATE);
		}
		invalidateDraw();
	}
	
	public function get textField():UITextField
	{
		return __mcLabel;
	}
	
	//CORE METHODS/------------------------------------------
	
	//Constructor
	public function Button()
	{
	}
	
	public function init():Void
	{
		super.init();		
		
		__loadInitDelegate = Delegate.create(this, onIconLoaded);
		
		focusEnabled		= true;
		tabEnabled			= true;
		tabChildren			= false;
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		__mcLabel = UITextField(attachMovie(UITextField.SYMBOL_NAME, "__mcLabel", getNextHighestDepth()));
		__mcLabel.align 		= UITextField.ALIGN_CENTER;
		__mcLabel.bold			= __bold;
		__mcLabel.multiline 	= __multiline;
		__mcLabel.wordWrap 		= __wordWrap;
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__labelDirty == true)
		{
			__labelDirty = false;
			__mcLabel.text = __label;
		}
		
		if(__backgroundDirty == true)
		{
			__backgroundDirty = false;
			__mcLabel.background = __background;
		}
		
		//trace("---------------");
		//trace("__backgroundColorDirty: " + __backgroundColorDirty);
		//trace("__mcLabel.backgroundColor: " + __mcLabel.backgroundColor);
		//trace("__mcLabel.background: " + __mcLabel.background);
		//trace("__mcLabel: " + __mcLabel);
		if(__backgroundColorDirty == true)
		{
			__backgroundColorDirty = false;
			//trace("__mcLabel.backgroundColor: " + __mcLabel.backgroundColor);
			__mcLabel.backgroundColor = __backgroundColor;
		}
		
		if(__boldDirty == true)
		{
			__boldDirty = false;
			__mcLabel.bold = __bold;
		}
		
		if(__borderDirty == true)
		{
			__borderDirty = false;
			__mcLabel.border = __border;
		}	
			
		if(__borderColorDirty == true)
		{
			__borderColorDirty = false;
			__mcLabel.borderColor = __borderColor;
		}	
		
		if(__colorDirty == true)
		{
			__colorDirty = false;
			__mcLabel.color = __color;
		}			
		
		if(__embedFontsDirty == true)
		{
			__embedFontsDirty = false;
			__mcLabel.embedFonts = __embedFonts;
		}	
			
		if(__textSizeDirty == true)
		{
			__textSizeDirty = false;
			__mcLabel.textSize = __textSize;
		}
		
		if(__multilineDirty == true)
		{
			__multilineDirty = false;
			__mcLabel.multiline = __multiline;
		}	
					
		if(__wordWrapDirty == true)
		{
			__wordWrapDirty = false;
			__mcLabel.wordWrap = __wordWrap;
		}	
		
		if(__fontDirty == true)
		{
			__fontDirty = false;
			__mcLabel.font = __font;
		}	
		
		if(__passwordDirty == true)
		{
			__passwordDirty = false;
			__mcLabel.password = __password;
		}	

		if(__selectableDirty == true)
		{
			__selectableDirty = false;
			__mcLabel.selectable = __selectable;
		}	
		
		if(__restrictDirty == true)
		{
			__restrictDirty = false;
			__mcLabel.restrict = __restrict;
		}	

		if(__maxCharsDirty == true)
		{
			__maxCharsDirty = false;
			__mcLabel.maxChars = __maxChars;
		}
		
		if(__underlineDirty == true)
		{
			__underlineDirty = false;
			__mcLabel.underline = __underline;
		}
		
		if(__selectedDirty == true)
		{
			__selectedDirty = false;
			invalidateDraw();
		}
		
		if(__toggleDirty == true)
		{
			__toggleDirty = false;
			invalidateDraw();
		}
		
		if(__iconDirty == true)
		{
			__iconDirty = false;
			if(__icon != null && __icon != "")
			{
				if(__mcIcon == null) __mcIcon = Loader(attachMovie(Loader.symbolName, "__mcIcon", getNextHighestDepth()));
				__mcIcon.scaleContent = false;
				__mcIcon.load(__icon);
				__mcIcon.addEventListener(ShurikenEvent.LOAD_INIT, __loadInitDelegate);
			}
			else
			{
				__mcIcon.removeEventListener(ShurikenEvent.LOAD_INIT, __loadInitDelegate);
				__mcIcon.removeMovieClip();
				delete __mcIcon;
			}
		}
		
		if(__alignIconDirty == true)
		{
			__alignIconDirty = false;
			invalidateSize();
		}
	}
	
	//Override this function to draw your own states
	private function draw():Void
	{
		//trace("Button::draw");
		super.draw();
		
		
		if (debug) {
			
			var currentColor:Number;
			
			switch (__currentState) {
				
				case DEFAULT_STATE:
					currentColor = 0x666666;
					break;
					
				case SELECTED_STATE:
					currentColor = 0xFF0000;
					break;
					
				case OVER_STATE:
					currentColor = 0xAAAAAA;
					break;
				
			}
			
			
			
			clear();
			
			beginFill(currentColor, 100);
			moveTo(0,0);
			lineTo(width,0);
			lineTo(width,height);
			lineTo(0,height);
			lineTo(0,0);
			endFill();
			
		}
		
	}

	private function size():Void
	{
		super.size();
		
		var iconExists:Boolean;
		
		var label_x:Number
		

		if(__mcIcon == null)
		{
			iconExists = false;
		}
		else if(__mcIcon.contentPath == null || __mcIcon.contentPath == "")
		{
			iconExists = false;
		}
		else
		{
			iconExists = true;
		}
		
		// icon doesn't exist, center label
		if(iconExists == false)
		{
			
			// TODO: supporting centering, both horizontal and vertical
			if (__mcLabel.height > __height)
			{
					// text field is larger than container
					// FIXME
			}
						
			var targetY:Number = Math.max((__height / 2) - (__mcLabel.height / 2), 0);
			__mcLabel.move(0, targetY);
			__mcLabel.setSize(__width, __height);
		}
		else
		{

				
			if(__alignIcon == ALIGN_ICON_LEFT)
			{	
				__mcIcon.move(0, 0);
				label_x =__mcIcon.width

				
			}
			else if(__alignIcon == ALIGN_ICON_CENTER)
			{
				__mcIcon.move(Math.round((__width / 2) - (__mcIcon.width / 2)), 
							  Math.round((__height / 2) - (__mcIcon.height / 2)));
			}
			else if(__alignIcon == ALIGN_ICON_RIGHT)
			{
				__mcIcon.move(width - __mcIcon.width, 0);
				__mcLabel.align = UITextField.ALIGN_RIGHT
				label_x = __mcLabel.x
			}
			
			__mcLabel.move(label_x, (__height / 2) - (__mcIcon.height / 2));
			__mcLabel.setSize(__width-__mcIcon.width, __height);
		}
		
		/*
		clear();
		lineStyle(0, 0x999999);
		beginFill(0xCCCCCC, 90);
		com.jxl.shuriken.utils.DrawUtils.drawBox(this, 0, 0, width, height);
		endFill();
		*/
	}
	
	public function measureText():Object
	{
		return __mcLabel.measureText();
	}
	
	private function onIconLoaded(pEvent:Object):Void
	{
		invalidateSize();
	}
	
	private function setState(pState:String):Void
	{
		//trace("-----------------------");
		//trace("Button::setState, pState: " + pState);
		__lastState = __currentState;
		__currentState = pState;
	}
	
	public function toString():String
	{
		return "[object com.jxl.shuriken.controls.Button]";
	}
}