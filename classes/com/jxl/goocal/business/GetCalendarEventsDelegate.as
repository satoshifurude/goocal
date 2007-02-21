
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import com.jxl.goocal.factories.CalendarFactory;
import com.jxl.goocal.vo.CalendarVO;
import com.jxl.goocal.vo.AuthorVO;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;

class com.jxl.goocal.business.GetCalendarEventsDelegate
{
	private var responder:Responder;
	private var __callbackScope:Object;
	private var __callbackFunction:Function;
	private var lv:LoadVars;
	
	public function GetCalendarEventsDelegate(p_responder:Responder)
	{
		responder = p_responder;
	}
	
	public function setProgressCallback(p_scope:Object, p_func:Function):Void
	{
		__callbackScope 			= p_scope;
		__callbackFunction 			= p_func;
	}
	
	public function getCalendarEvents(p_auth:String, 
									  p_email:String, 
									  p_calendarName:String,
									  p_startDate:Date,
									  p_endDate:Date):Void
	{
		/*
		var author:AuthorVO = new AuthorVO("Jesse Warden", "jesse.warden@gmail.com");
		var when:WhenVO = new WhenVO(new Date(), new Date(), new Date());
		var entries_array:Array = [];
		var mainEntry:EntryVO = new EntryVO("id",
									   new Date(),
									   new Date(),
									   "entry temp 1",
									   "entry temp desc",
									   author,
									   true,
									   "home",
									   when,
									   []);
		
		entries_array.push(mainEntry);
		entries_array.push(mainEntry);
		entries_array.push(mainEntry);
									   
		var calendarVO:CalendarVO = new CalendarVO("id",
												   new Date(),
												   "Temp Calendar",
												   "temp cal sub",
												   author,
												   "home",
												   "New York",
												   entries_array);
		
		responder.onResult(new ResultEvent(calendarVO));
		return;
		*/
		
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GetCalendarEventsDelegate::getCalendarEvents");
		//DebugWindow.debug("p_auth: " + p_auth);
		//DebugWindow.debug("p_email: " + p_email);
		//DebugWindow.debug("p_calendarName: " + p_calendarName);
		
		onProgress("Getting Calendar Entries...");
		
		lv						= new LoadVars();
		lv.onLoad 				= Delegate.create(this, onGetCalendarEvents);
		lv.cmd 					= "get_calendar_entries";
		lv.auth 				= p_auth;
		lv.email 				= p_email;
		lv.calendarName 		= p_calendarName;
		lv.startYear 			= p_startDate.getFullYear();
		lv.startMonth 			= p_startDate.getMonth() + 1;
		lv.startDay 			= p_startDate.getDate();
		lv.endYear				= p_endDate.getFullYear();
		lv.endMonth				= p_endDate.getMonth() + 1;
		lv.endDay				= p_endDate.getDate();
		lv.sendAndLoad(_global.phpURL, lv, "POST");
	}
	
	private function onGetCalendarEvents(p_success:Boolean):Void
	{
		//trace("-------------------");
		//trace("GetCalendarEventsDelegate::onGetCalendarEvents");
		for(var p in lv)
		{
			trace(p + ": " + lv[p]);
		}
		
		if(p_success == true)
		{
			onProgress("Received.  Parsing...");
			CalendarFactory.getEventListFromLV(lv,
												 this,
												 onDoneParsing);
		}
		else
		{
			onProgress("Error.");
			var fault:Fault = new Fault("failure", "xml load failure", "The XML failed to load from the server.", "XML");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
	private function onDoneParsing(p_array:Array):Void
	{
		//trace("----------------------");
		//trace("GetCalendarEventsDelegate::onDoneParsing, p_array.length: " + p_array.length);
		
		onProgress("Done!");
		responder.onResult(new ResultEvent(p_array));
	}
	
	// TODO: in the future, could report back total parsed... for now, just strings
	private function onProgress(p_str:String):Void
	{
		__callbackFunction.call(__callbackScope, p_str);
	}
	
	/*
	public function toString():String
	{
		return "[class GetCalendarEventsDelegate]";
	}
	*/
	
}
