import com.jxl.shuriken.controls.calendarclasses.CalendarBase;
import com.jxl.shuriken.controls.calendarclasses.CalendarDay;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
import com.jxl.shuriken.utils.DateUtils;
import com.jxl.shuriken.controls.SimpleButton;
import com.jxl.shuriken.events.ShurikenEvent;
import mx.utils.Delegate;

#include "ASProf.as"

function doneBuilding()
{
	ASProf.end(); // close “main”
	
	mc.removeMovieClip();
	txt.removeMovieClip();
	lbl.removeMovieClip();
	
	createTextField("debuglbl", 22, 0, 0, 176, 208);
	debuglbl.background = true;
	debuglbl.backgroundColor = 0xFFFFFF;
	debuglbl.border = true;
	debuglbl.borderColor = 0xFF0000;
	debuglbl.selectable = true;
	debuglbl.multiline = true;
	debuglbl.wordWrap = true;
	debuglbl.tabEnabled = true;
	debuglbl.focusEnabled = true;
	debuglbl.tabChildren = true;
	//debuglbl.text = "System.capabilities.hasMMS: " + System.capabilities.hasMMS;
	debuglbl.text = ASProf.getFlatGraph();
	
	//var bigStr:String = ASProf.getFlatGraph();
	//var myMessage:String = "mms:jesse.warden@gmail.com?body=" + ;
	//getURL(myMessage);
	//getURL("mms:jesse.warden@gmail.com?body=" + bigStr);
	//debuglbl.text = ASProf.getFlatGraph();
	
}

function init()
{
	Stage.scaleMode = "noScale";
	Stage.align = "TL";
	_quality = "LOW";
	fscommand2("FullScreen", true);
	
	ASProf.profile("com.jxl.shuriken.controls.calendarclasses.CalendarBase.prototype.createChildAt");
	ASProf.profile("com.jxl.shuriken.controls.calendarclasses.CalendarBase.prototype.drawNext");
	ASProf.profile("com.jxl.shuriken.controls.calendarclasses.CalendarBase.prototype.sizeNext");
	ASProf.profile("com.jxl.shuriken.controls.calendarclasses.CalendarBase.prototype.refreshSetValue");
	
	ASProf.begin("main");
	
	attachMovie(CalendarBase.SYMBOL_NAME, "mc", 0);
	attachMovie(Label.SYMBOL_NAME, "txt", 1);
	txt.move(0, 116);
	txt.text = DateUtils.getMonthName(mc.today) + " " + mc.currentDate.getFullYear();
	
	attachMovie(Label.SYMBOL_NAME, "lbl", 2);
	lbl.move(85, 116);
	lbl.text = "jessewarden.com";
	
	/*
	attachMovie(SimpleButton.SYMBOL_NAME, "test", 2);
	test.move(85, 116);
	test.setSize(22, 22);
	test.lineStyle(0, 0x000000);
	test.beginFill(0xCCCCCC);
	com.jxl.shuriken.utils.DrawUtils.drawBox(test, 0, 0, test.width, test.height);
	test.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onClick));
	*/
	
	//attachMovie(CalendarDay.SYMBOL_NAME, "mc", 0);
	//trace("mc.width: " + mc.width);
	//trace("mc.getWidth(): " + mc.getWidth());
	
	debug_txt.border = true;
	debug_txt.borderColor = 0x000000;
	
	Key.addListener(this);
}

function debug(o)
{
	debug_txt.text += o + "\n";
	debug_txt.textField.scroll = debug_txt.textField.maxscroll;
}

function onKeyDown()
{
	switch(Key.getCode())
	{
		case 52:
			mc.lastMonth();
			break;
			
		case 54:
			mc.nextMonth();
			break;
			
		case Key.DOWN:
			debuglbl.scroll++;
			break;
		
		case Key.UP:
			debuglbl.scroll--;
			break;
	}
	
	txt.text = DateUtils.getMonthName(mc.currentDate) + " " + mc.currentDate.getFullYear();
}

/*
function onClick()
{
	trace("-------------------");
	trace("onClick");
	var today:Date = new Date();
	today.setDate(today.getDate() + 1);
	mc.selectedDate = today;
}
*/

init();



