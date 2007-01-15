
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.utils.DrawUtils;

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
	private var __description_txt:UITextField;
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
		}
		
		if(__time_lbl == null)
		{
			__time_lbl = GCTimeHeading(createComponent(GCTimeHeading, "__time_lbl"));
		}
		
		if(__description_txt == null)
		{
			__description_txt = UITextField(createComponent(UITextField, "__description_txt"));
			__description_txt.html = true;
			__description_txt.multiline = true;
			__description_txt.wordWrap = true;
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
		super.init();
		
		if(__entryDirty == true)
		{
			__entryDirty = false;
			__title_lbl.text = __entry.title;
			__time_lbl.text = __entry.toHourRangeString();
			
			var descStr:String = "";
			descStr += "<b>Where</b><br />";
			descStr += __entry.where + "<br /><br />";
			descStr += "<b>Description</b><br />";
			descStr += __entry.description + "<br />";
			__description_txt.htmlText = descStr;
		}
	}
	
	private function size():Void
	{
		super.size();
		
		__title_lbl.move(0, 0);
		__title_lbl.setSize(__width, __title_lbl.height);
		
		__editDetails_link.move(0, __height - __editDetails_link.height);
		__editDetails_link.setSize(40, __editDetails_link.height);
		__or_txt.move(__editDetails_link.x + __editDetails_link.width + 2, __editDetails_link.y);
		__or_txt.setSize(14, __or_txt.height);
		__month_link.move(__or_txt.x + __or_txt.width, __or_txt.y);
		__month_link.setSize(30, __month_link.height);
		__view_txt.move(__month_link.x + __month_link.width, __month_link.y);
		__view_txt.setSize(30, __view_txt.height);
		
		beginFill(0xD2D2D2);
		DrawUtils.drawBox(this, 0, __title_lbl.y + __title_lbl.height, __width, 1);
		DrawUtils.drawBox(this, 0, __height - __editDetails_link.height - 1, __width, 1);
		beginFill(0xF0F0F0);
		DrawUtils.drawBox(this, 0, __title_lbl.y + __title_lbl.height + 1, __width, __height - __editDetails_link.height - 1);
		endFill();
		
		__time_lbl.move(4, __title_lbl.y + __title_lbl.height + 3);
		__time_lbl.setSize(__width - __time_lbl.x, __time_lbl.height);
		
		__description_txt.move(__time_lbl.x, __time_lbl.y + __time_lbl.height);
		__description_txt.setSize(__width - __description_txt.x, __height - __description_txt.y - __editDetails_link.height);
	}
	
	
	
}