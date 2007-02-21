
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;
import mx.rpc.ResultEvent;
import mx.utils.Delegate;

class com.jxl.goocal.business.GetCalendarsDelegate
{
	private var responder:Responder;
	private var lv:LoadVars;
	private var timeoutID:Number;
	private var attempts:Number;
	
	function GetCalendarsDelegate(p_responder:Responder)
	{
		responder = p_responder;
	}
	
	public function getCalendars(p_auth:String, p_email:String):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GetCalendarsDelegate:::getCalendars");
		//DebugWindow.debug("p_auth: " + p_auth);
		//DebugWindow.debug("p_email: " + p_email);
		//var list:Array = ["Jesse Warden", "JXL Test"];
		//responder.onResult(new ResultEvent(list));
		//return;
		
		attempts = 1;
		clearInterval(timeoutID);
		timeoutID = setInterval(this, "onTimeout", 20000);
		
		lv = new LoadVars();
		lv.onLoad = Delegate.create(this, onGetCalendars);
		lv.cmd = "get_calendars_names";
		lv.auth = p_auth;
		lv.email = p_email;
		lv.sendAndLoad(_global.phpURL, lv, "POST");
	}
	
	private function onGetCalendars(p_loaded:Boolean):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GetCalendarsDelegate:::onGetCalendars");
		//DebugWindow.debug("p_jsonStr: " + p_jsonStr);
		clearInterval(timeoutID);
		
		if(p_loaded == true)
		{
			//var list:Array = CalendarFactory.getCalendars(p_jsonStr);
			var list:Array = [];
			for(var p:String in lv)
			{
				if(p.indexOf("calendar") == -1) continue;
				var calName:String = lv[p];
				list.push(calName);
			}
			list.reverse();
			responder.onResult(new ResultEvent(list));
		}
		else
		{
			var fault:Fault = new Fault("failure", "xml load failure", "The XML failed to load from the server.", "XML");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
	private function onTimeout():Void
	{
		clearInterval(timeoutID);
		if(attempts < 3)
		{
			attempts++;
			timeoutID = setInterval(this, "onTimeout", 20000);
			lv.sendAndLoad(_global.phpURL, lv, "POST");
		}
		else
		{
			var fault:Fault = new Fault("failure", "xml load failure", "Timed out.  Tried " + attempts + " times.", "XML");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
}
