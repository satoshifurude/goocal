import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.TextArea;
import com.jxl.shuriken.utils.DrawUtils;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;

import com.jxl.goocal.views.GCHeading;
import com.jxl.goocal.views.GCTimeHeading;
import com.jxl.goocal.views.GCLinkButton;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;


class com.jxl.goocal.views.EntryView extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.EntryView";
	
	public static var EVENT_BACK_TO_MONTH:String = "backToMonth";
	public static var EVENT_EDIT_DETAILS:String = "editDetails";
	
	private var __title_lbl:GCHeading;
	private var __time_lbl:GCTimeHeading;
	private var __description_ta:TextArea;
	private var __editDetails_link:GCLinkButton;
	private var __or_txt:UITextField;
	private var __view_txt:UITextField;
	private var __month_link:GCLinkButton;
	
	private var __entry:EntryVO;
	private var __entryDirty:Boolean = false;
	
	public function get entry():EntryVO { return __entry; }
	public function set entry(p_val:EntryVO):Void
	{
		__entry = p_val;
		__entryDirty = true;
		invalidateProperties();
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
			__title_lbl = GCHeading(createComponent(GCHeading, "__title_lbl"));
			__title_lbl.textSize = 14;
			__title_lbl.bold = true;
		}
		
		if(__time_lbl == null)
		{
			__time_lbl = GCTimeHeading(createComponent(GCTimeHeading, "__time_lbl"));
		}
		
		if(__description_ta == null)
		{
			__description_ta = TextArea(createComponent(TextArea, "__description_ta"));
			__description_ta.html = true;
		}
		
		if(__editDetails_link == null)
		{
			__editDetails_link = GCLinkButton(createComponent(GCLinkButton, "__editDetails_link"));
			__editDetails_link.label = "Edit Details";
		}
		
		if(__or_txt == null)
		{
			__or_txt = UITextField(createComponent(UITextField, "__or_txt"));
			__or_txt.multiline = false;
			__or_txt.wordWrap = false;
			__or_txt.text = "or";
		}
		
		if(__month_link == null)
		{
			__month_link = GCLinkButton(createComponent(GCLinkButton, "__month_link"));
			__month_link.label = "month";
			__month_link.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onMonthClick));
		}
		
		if(__view_txt == null)
		{
			__view_txt = UITextField(createComponent(UITextField, "__view_txt"));
			__view_txt.multiline = false;
			__view_txt.wordWrap = false;
			__view_txt.text = "view";
		}
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__entryDirty == true)
		{
			__entryDirty = false;
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
	}
	
	private function size():Void
	{
		super.size();
		
		__title_lbl.move(4, 0);
		__title_lbl.setSize(__width, 20);
		
		__editDetails_link.move(0, __height - __editDetails_link.height);
		__editDetails_link.setSize(55, __editDetails_link.height);
		__or_txt.move(__editDetails_link.x + __editDetails_link.width + 2, __editDetails_link.y);
		__or_txt.setSize(14, __or_txt.height);
		__month_link.move(__or_txt.x + __or_txt.width, __or_txt.y);
		__month_link.setSize(32, __month_link.height);
		__view_txt.move(__month_link.x + __month_link.width, __month_link.y);
		__view_txt.setSize(30, __view_txt.height);
		
		__time_lbl.move(4, __title_lbl.y + __title_lbl.height + 3);
		__time_lbl.setSize(__width - __time_lbl.x, 22);
		
		__description_ta.move(__time_lbl.x, __time_lbl.y + __time_lbl.height);
		__description_ta.setSize(__width - __description_ta.x, __height - __description_ta.y - __editDetails_link.height);
		
		beginFill(0xD2D2D2);
		var lineSize:Number = 2;
		DrawUtils.drawBox(this, 0, __title_lbl.y + __title_lbl.height, __width, lineSize);
		DrawUtils.drawBox(this, 0, __height - __editDetails_link.height - lineSize, __width, lineSize);
		beginFill(0xF0F0F0);
		var targetDarkY:Number = __title_lbl.y + __title_lbl.height + lineSize;
		DrawUtils.drawBox(this, 
						  0, targetDarkY, 
						  __width, __height - __editDetails_link.height - targetDarkY - lineSize);
		endFill();
	}
	
	private function onMonthClick(p_event:ShurikenEvent):Void
	{
		dispatchEvent(new Event(EVENT_BACK_TO_MONTH, this));
	}
	
}