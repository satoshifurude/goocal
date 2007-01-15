import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.events.ShurikenEvent;

[InspectableList("align", "background", "backgroundColor", "bold", "border", "borderColor", "embedFonts", "html", "htmlText", "text", "color", "textSize", "multiline", "wordWrap", "font", "password", "selectable", "restrict", "maxChars", "type")]
class com.jxl.shuriken.core.UITextField extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.core.UITextField";
	
	public static var ALIGN_LEFT:String 	= "left"
	public static var ALIGN_CENTER:String 	= "center"
	public static var ALIGN_RIGHT:String 	= "right";
	
	public static var TYPE_DYNAMIC:String 	= "dynamic";
	public static var TYPE_INPUT:String 	= "input";
	
	public function get textField():TextField { return __txtLabel; }
	
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get background():Boolean { return __background; }
	
	public function set background(pVal:Boolean):Void
	{
		if(pVal != __background)
		{
			__background = pVal;
			__backgroundDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue="#FFFFFF", type="Color")]
	public function get backgroundColor():Number { return __backgroundColor; }
	
	public function set backgroundColor(pVal:Number):Void
	{
		if(pVal != __backgroundColor)
		{
			__backgroundColor = pVal;
			__backgroundColorDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get border():Boolean { return __border; }
	
	public function set border(pVal:Boolean):Void
	{
		if(pVal != __border)
		{
			__border = pVal;
			__borderDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(type="Color")]
	public function get borderColor():Number { return __borderColor; }
	
	public function set borderColor(pVal:Number):Void
	{
		if(pVal != __borderColor)
		{
			__borderColor = pVal;
			__borderColorDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get embedFonts():Boolean { return __embedFonts; }
	
	public function set embedFonts(pVal:Boolean):Void
	{
		if(pVal != __embedFonts)
		{
			__embedFonts = pVal;
			__embedFontsDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=false, type="Boolean")]
	public function get html():Boolean { return __html; }
	
	public function set html(pVal:Boolean):Void
	{
		if(pVal != __html)
		{
			__html = pVal;
			__htmlDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue="", type="String")]
	public function get htmlText():String { return __htmlText; }
	
	public function set htmlText(pVal:String):Void
	{
		if(pVal != __htmlText)
		{
			__htmlText = pVal;
			__htmlTextDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=null, type="Number")]
	public function get maxChars():Number { return __maxChars; }
	
	public function set maxChars(pVal:Number):Void
	{
		if(pVal != __maxChars)
		{
			__maxChars = pVal;
			__maxCharsDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get multiline():Boolean { return __multiline; }
	
	public function set multiline(pVal:Boolean):Void
	{
		if(pVal != __multiline)
		{
			__multiline = pVal;
			__multilineDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=undefined, type="Boolean")]
	public function get password():Boolean { return __password; }
	
	public function set password(pVal:Boolean):Void
	{
		if(pVal != __password)
		{
			__password = pVal;
			__passwordDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(type="String")]
	public function get restrict():String { return __restrict; }
	
	public function set restrict(pVal:String):Void
	{
		if(pVal != __restrict)
		{
			__restrict = pVal;
			__restrictDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get selectable():Boolean { return __selectable; }
	
	public function set selectable(pVal:Boolean):Void
	{
		if(pVal != __selectable)
		{
			__selectable = pVal;
			__selectableDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue="", type="String")]
	public function get text():String { return __text; }
	
	public function set text(pVal:String):Void
	{
		__text = pVal;
		__textDirty = true;
		invalidateProperties();
	}
	
	[Inspectable(defaultValue=true, type="Boolean")]
	public function get wordWrap():Boolean { return __wordWrap; }
	
	public function set wordWrap(pVal:Boolean):Void
	{
		if(pVal != __wordWrap)
		{
			__wordWrap = pVal;
			__wordWrapDirty = true;
			invalidateProperties();
		}
	}
	
	// TextFormat props
	[Inspectable(defaultValue="left", type="List", enumeration="left,center,right")]
	public function get align():String { return __align; }
	
	public function set align(pVal:String):Void
	{
		if(pVal != __align)
		{
			__align = pVal;
			__alignDirty = true;
			invalidateProperties();
		}
	}
	
	public function get blockIndent():Number { return __blockIndent; }
	
	public function set blockIndent(pVal:Number):Void
	{
		if(pVal != __blockIndent)
		{
			__blockIndent = pVal;
			__blockIndentDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=false, type="Boolean")]
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
	
	[Inspectable(defaultValue="#000000", type="Color")]
	public function get color():Number { return __color; }
	
	public function set color(pVal:Number):Void
	{
		__color = pVal;
		__colorDirty = true;
		invalidateProperties();
	}
	
	public function get font():String { return __font; }
	
	[Inspectable(defaultValue="_sans", type="Font Name")]
	public function set font(pVal:String):Void
	{
		if(pVal != __font)
		{
			__font = pVal;
			__fontDirty = true;
			invalidateProperties();
		}
	}
	
	public function get indent():Number { return __indent; }
	
	public function set indent(pVal:Number):Void
	{
		if(pVal != __indent)
		{
			__indent = pVal;
			__indentDirty = true;
			invalidateProperties();
		}
	}
	
	public function get italic():Boolean { return __italic; }
	
	public function set italic(pVal:Boolean):Void
	{
		if(pVal != __italic)
		{
			__italic = pVal;
			__italicDirty = true;
			invalidateProperties();
		}
	}
	
	public function get leading():Number { return __leading; }
	
	public function set leading(pVal:Number):Void
	{
		if(pVal != __leading)
		{
			__leading = pVal;
			__leadingDirty = true;
			invalidateProperties();
		}
	}
	
	public function get leftMargin():Number { return __leftMargin; }
	
	public function set leftMargin(pVal:Number):Void
	{
		if(pVal != __leftMargin)
		{
			__leftMargin = pVal;
			__leftMarginDirty = true;
			invalidateProperties();
		}
	}
	
	public function get rightMargin():Number { return __rightMargin; }
	
	public function set rightMargin(pVal:Number):Void
	{
		if(pVal != __rightMargin)
		{
			__rightMargin = pVal;
			__rightMarginDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue=12, type="Number")]
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
	
	public function get tabStops():Array { return __tabStops; }
	
	public function set tabStops(pVal:Array):Void
	{
		__tabStops = pVal;
		__tabStopsDirty = true;
		invalidateProperties();
	}
	
	public function get target():String { return __target; }
	
	public function set target(pVal:String):Void
	{
		if(pVal != __target)
		{
			__target = pVal;
			__targetDirty = true;
			invalidateProperties();
		}
	}
	
	[Inspectable(defaultValue="dynamic", type="List", enumeration="dynamic,input")]
	public function get type():String { return __type; }
	
	public function set type(p_val:String):Void
	{
		if(p_val != __type)
		{
			__type = p_val;
			__typeDirty = true;
			invalidateProperties();
		}
	}
	
	public function get underline():Boolean { return __underline; }
	
	public function set underline(pVal:Boolean):Void
	{
		if(pVal != __underline)
		{
			__underline = pVal;
			__underlineDirty = true;
			invalidateProperties();
		}
	}
	
	public function get url():String { return __url; }
	
	public function set url(pVal:String):Void
	{
		if(pVal != __url)
		{
			__url = pVal;
			__urlDirty = true;
			invalidateProperties();
		}
	}
	
	
	private var __txtLabel:TextField;
	private var __tf:TextFormat;
	private var __calledCommitProperties:Boolean;
	
	
	private var __background:Boolean;
	private var __backgroundColor:Number;
	private var __border:Boolean;
	private var __borderColor:Number;
	private var __embedFonts:Boolean					= false;
	private var __html:Boolean							= false;
	private var __htmlText:String = "";
	private var __maxChars:Number;
	private var __multiline:Boolean;
	private var __password:Boolean;
	private var __restrict:String;
	private var __selectable:Boolean		= true;
	private var __text:String = "" ;
	private var __wordWrap:Boolean;
	
	
	private var __align:String				= "left";
	private var __blockIndent:Number		= 0;
	private var __bold:Boolean				= false;
	private var __color:Number				= 0x000000;
	private var __font:String				= "_sans";
	private var __indent:Number				= 0;
	private var __italic:Boolean			= false;
	private var __leading:Number			= 0;
	private var __leftMargin:Number			= 0;
	private var __rightMargin:Number		= 0;
	private var __textSize:Number			= 11;
	private var __tabStops:Array;
	private var __target:String;
	private var __type:String				= "dynamic";
	private var __underline:Boolean;
	private var __url:String;
	
	private var __backgroundDirty:Boolean;
	private var __backgroundColorDirty:Boolean;
	private var __borderDirty:Boolean;
	private var __borderColorDirty:Boolean;
	private var __embedFontsDirty:Boolean;
	private var __htmlDirty:Boolean;
	private var __htmlTextDirty:Boolean;
	private var __maxCharsDirty:Boolean;
	private var __multilineDirty:Boolean;
	private var __passwordDirty:Boolean;
	private var __restrictDirty:Boolean;
	private var __selectableDirty:Boolean;
	private var __textDirty:Boolean;
	private var __wordWrapDirty:Boolean;
	
	private var __alignDirty:Boolean;
	private var __blockIndentDirty:Boolean;
	private var __boldDirty:Boolean;
	private var __colorDirty:Boolean;
	private var __fontDirty:Boolean;
	private var __indentDirty:Boolean;
	private var __italicDirty:Boolean;
	private var __leadingDirty:Boolean;
	private var __leftMarginDirty:Boolean;
	private var __rightMarginDirty:Boolean;
	private var __textSizeDirty:Boolean;
	private var __tabStopsDirty:Boolean;
	private var __targetDirty:Boolean;
	private var __typeDirty:Boolean;
	private var __underlineDirty:Boolean;
	private var __urlDirty:Boolean;
	
	public function UITextField()
	{
	}
	
	public function init():Void
	{
		super.init();
		
		focusEnabled = true;
		tabEnabled = false;
		tabChildren = true;
		
		__calledCommitProperties 	= false;
		
		__backgroundDirty			= true;
		__backgroundColorDirty		= true;
		__borderDirty				= true;
		__borderColorDirty			= true;
		__embedFontsDirty			= true;
		__htmlDirty					= true;
		__htmlTextDirty				= true;
		__maxCharsDirty				= true;
		__multilineDirty			= true;
		__passwordDirty				= true;
		__restrictDirty				= true;
		__selectableDirty			= true;
		__textDirty					= true;
		__wordWrapDirty				= true;
		
		__alignDirty				= true;
		__blockIndentDirty			= true;
		__boldDirty					= true;
		__colorDirty				= true;
		__fontDirty					= true;
		__indentDirty				= true;
		__italicDirty				= true;
		__leadingDirty				= true;
		__leftMarginDirty			= true;
		__rightMarginDirty			= true;
		__textSizeDirty				= true;
		__tabStopsDirty				= true;
		__targetDirty				= true;
		__typeDirty					= true;
		__underlineDirty			= true;
		__urlDirty					= true;
		
		__tf						= new TextFormat();
		
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		createTextField("__txtLabel", getNextHighestDepth(), 0, 0, 100, 100);
		__txtLabel.addListener(this);
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__backgroundDirty == true)
		{
			__backgroundDirty = false;
			__txtLabel.background = __background;
		}
		
		if(__backgroundColorDirty == true)
		{
			__backgroundColorDirty = false;
			__txtLabel.backgroundColor = __backgroundColor;
		}
		
		if(__borderDirty == true)
		{
			__borderDirty = false;
			__txtLabel.border = __border;
		}
		
		if(__borderColorDirty == true)
		{
			__borderColorDirty = false;
			__txtLabel.borderColor = __borderColor;
		}

	
		if(__embedFontsDirty == true)
		{
			__embedFontsDirty = false;
			__txtLabel.embedFonts = __embedFonts;
		}
		
		if(__htmlDirty == true)
		{
			__htmlDirty = false;
			__txtLabel.html = __html;
		}
		
		if(__maxCharsDirty == true)
		{
			__maxCharsDirty = false;
			__txtLabel.maxChars = __maxChars;
		}
		
		if(__multilineDirty == true)
		{
			__multilineDirty = false;
			__txtLabel.multiline = __multiline;
		}
		
		if(__passwordDirty == true)
		{
			__passwordDirty = false;
			__txtLabel.password = __password;
		}
		
		if(__restrictDirty == true)
		{
			__restrictDirty = false;
			__txtLabel.restrict = __restrict;
		}
		
		if(__selectableDirty == true)
		{
			__selectableDirty = false;
			__txtLabel.selectable = __selectable;
		}
		
		if(__wordWrapDirty == true)
		{
			__wordWrapDirty = false;
			__txtLabel.wordWrap = __wordWrap;
		}
		
		var tfDirty:Boolean = false;
		
		if(__alignDirty == true)
		{
			__alignDirty = false;
			__tf.align = __align;
			tfDirty = true;
		}
		
		if(__blockIndentDirty == true)
		{
			__blockIndentDirty = false;
			__tf.blockIndent = __blockIndent;
			tfDirty = true;
		}
		
		if(__boldDirty == true)
		{
			__boldDirty = false;
			__tf.bold = __bold;
			tfDirty = true;
		}
		
		if(__colorDirty == true)
		{		
			__colorDirty = false;
			__tf.color = __color;
			
			tfDirty = true;
		}
		
		if(__fontDirty == true)
		{
			__fontDirty = false;
			__tf.font = __font;
			tfDirty = true;
		}
		
		if(__indentDirty == true)
		{
			__indentDirty = false;
			__tf.indent = __indent;
			tfDirty = true;
		}
		
		if(__italicDirty == true)
		{
			__italicDirty = false;
			__tf.italic = __italic;
			tfDirty = true;
		}
		
		if(__leadingDirty == true)
		{
			__leadingDirty = false;
			__tf.leading = __leading;
			tfDirty = true;
		}
		
		if(__leftMarginDirty == true)
		{
			__leftMarginDirty = false;
			__tf.leftMargin = __leftMargin;
			tfDirty = true;
		}
		
		if(__rightMarginDirty == true)
		{
			__rightMarginDirty = false;
			__tf.rightMargin = __rightMargin;
			tfDirty = true;
		}
		
		if(__textSizeDirty == true)
		{
			__textSizeDirty = false;
			__tf.size = __textSize;
			tfDirty = true;
		}
		
		if(__tabStopsDirty == true)
		{
			__tabStopsDirty = false;
			__tf.tabStops = __tabStops;
			tfDirty = true;
		}
		
		if(__targetDirty == true)
		{
			__targetDirty = false;
			__tf.target = __target;
			tfDirty = true;
		}
		
		if(__underlineDirty == true)
		{
			__underlineDirty = false;
			__tf.underline = __underline;
			tfDirty = true;
		}
		
		if(__urlDirty == true)
		{
			__urlDirty = false;
			__tf.url = __url;
			tfDirty = true;
		}
		
		if(__calledCommitProperties == false)
		{
			// this is our first time through
			__calledCommitProperties = true;
			if(__htmlText.length > 0 && __html == true)
			{
				__txtLabel.htmlText = __htmlText;
			}
			else
			{
				__txtLabel.text = __text;
			}
			__textDirty = false;
			__htmlTextDirty = false;
		}
		else
		{
			if(__textDirty == true)
			{
				__textDirty = false;
				__txtLabel.text = __text;
			}
			
			if(__htmlTextDirty == true)
			{
				__htmlTextDirty = false;
				__txtLabel.htmlText = __htmlText;
			}
		}
		
		if(tfDirty == true)
		{
			__txtLabel.setNewTextFormat(__tf);
			__txtLabel.setTextFormat(__tf);
		}
		
		if(__typeDirty == true)
		{
			__typeDirty = false;
			__txtLabel.type = __type;
		}
	}
	
	private function size():Void
	{
		super.size();
		
		__txtLabel._width = __width;
		__txtLabel._height = __height;
	}
	
	public function measureText():Object
	{
		var w:Number = __txtLabel.textWidth + 4;
		var h:Number = __txtLabel.textHeight + 4;
		return {textWidth: w, textHeight: h};
	}
	
	private function onChanged():Void
	{
		__text = __txtLabel.text;
		callLater(this, dispatchChange);
	}
	
	private function dispatchChange():Void
	{
		dispatchEvent(new ShurikenEvent(ShurikenEvent.CHANGE, this));
	}
}