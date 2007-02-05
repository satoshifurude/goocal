import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.TextArea;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;

import com.jxl.goocal.views.GCLinkButton;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;


class com.jxl.goocal.views.EntryView extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.EntryView";
	
	public static var EVENT_BACK_TO_MONTH:String = "backToMonth";
	public static var EVENT_EDIT_DETAILS:String = "editDetails";
	
	private var __title_lbl:TextField;
	private var __time_lbl:TextField;
	private var __description_ta:TextArea;
	private var __editDetails_link:GCLinkButton;
	private var __or_txt:TextField;
	private var __view_txt:TextField;
	private var __month_link:GCLinkButton;
	
	private var __entry:EntryVO;
	private var __monthCallback:Callback;
	
	public function get entry():EntryVO { return __entry; }
	public function set entry(p_val:EntryVO):Void
	{
		__entry = p_val;
		__title_lbl.text = __entry.title;
		__time_lbl.text = __entry.toHourRangeString();
		
		var descStr:String = "<font size='11' face='Verdana, Arial, Helvetica, sans-serif'>";
		if(__entry.where != null && __entry.where != "")
		{
			descStr += "<b>Where</b><br />";
			descStr += __entry.where + "<br /><br />";
		}
		if(__entry.description != null && __entry.description != "")
		{
			descStr += "<b>Description</b><br />";
			descStr += __entry.description + "<br />";
		}
		
		descStr += "</font>";
		__description_ta.htmlText = descStr;
	}
	
	
	public function EntryView()
	{
		super();
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__title_lbl == null)
		{
			__title_lbl = createLabel("__title_lbl");
			var fmt:TextFormat = __title_lbl.getTextFormat();
			fmt.size = 14;
			fmt.bold = true;
			__title_lbl.setTextFormat(fmt);
			__title_lbl.setNewTextFormat(fmt);
		}
		
		if(__time_lbl == null)
		{
			__time_lbl = createLabel("__time_lbl");
		}
		
		if(__description_ta == null)
		{
			__description_ta = TextArea(createComponent(TextArea, "__description_ta"));
			__description_ta.textField.html = true;
		}
		
		if(__editDetails_link == null)
		{
			__editDetails_link = GCLinkButton(createComponent(GCLinkButton, "__editDetails_link"));
			__editDetails_link.label = "Edit Details";
		}
		
		if(__or_txt == null)
		{
			__or_txt = createLabel("__or_txt");
			__or_txt.multiline = false;
			__or_txt.wordWrap = false;
			__or_txt.text = "or";
		}
		
		if(__month_link == null)
		{
			__month_link = GCLinkButton(createComponent(GCLinkButton, "__month_link"));
			__month_link.label = "month";
			__month_link.setReleaseCallback(this, onMonthClick);
		}
		
		if(__view_txt == null)
		{
			__view_txt = createLabel("__view_txt");
			__view_txt.multiline = false;
			__view_txt.wordWrap = false;
			__view_txt.text = "view";
		}
	}
	
	private function redraw():Void
	{
		super.redraw();
		
		__title_lbl.move(4, 0);
		__title_lbl.setSize(__width, 20);
		
		__editDetails_link.move(0, __height - __editDetails_link.height);
		__editDetails_link.setSize(57, __editDetails_link.height);
		__or_txt.move(__editDetails_link.x + __editDetails_link.width + 2, __editDetails_link.y);
		__or_txt.setSize(14, __or_txt._height);
		__month_link.move(__or_txt._x + __or_txt._width, __or_txt._y);
		__month_link.setSize(34, __month_link.height);
		__view_txt.move(__month_link.x + __month_link.width, __month_link.y);
		__view_txt.setSize(30, __view_txt._height);
		
		__time_lbl.move(4, __title_lbl._y + __title_lbl._height + 3);
		__time_lbl.setSize(__width - __time_lbl._x, 22);
		
		__description_ta.move(__time_lbl._x, __time_lbl._y + __time_lbl._height);
		__description_ta.setSize(__width - __description_ta.x, __height - __description_ta.y - __editDetails_link.height);
		
		beginFill(0xD2D2D2);
		var lineSize:Number = 2;
		DrawUtils.drawBox(this, 0, __title_lbl._y + __title_lbl._height, __width, lineSize);
		DrawUtils.drawBox(this, 0, __height - __editDetails_link.height - lineSize, __width, lineSize);
		beginFill(0xF0F0F0);
		var targetDarkY:Number = __title_lbl._y + __title_lbl._height + lineSize;
		DrawUtils.drawBox(this, 
						  0, targetDarkY, 
						  __width, __height - __editDetails_link.height - targetDarkY - lineSize);
		endFill();
	}
	
	private function onMonthClick(p_event:ShurikenEvent):Void
	{
		__monthCallback.dispatch(new Event(EVENT_BACK_TO_MONTH, this));
	}
	
	public function setMonthCallback(scope:Object, func:Function):Void
	{
		__monthCallback = new Callback(scope, func);
	}
	
}