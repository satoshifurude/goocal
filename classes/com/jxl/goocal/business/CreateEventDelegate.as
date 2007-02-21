/*
	DelegateTemplate
	
	Template for a ARP Delegate class.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

class com.jxl.goocal.business.CreateEventDelegate
{
	private var responder:Responder;
	
	public function CreateEventDelegate(p_responder:Responder)
	{
		responder = p_responder;
	}
	
	public function createEvent(auth:String,
								name:String,
								email:String,
								calendarName:String,
								startDate:Date,
								endDate:Date,
								title:String,
								description:String,
								where:String):Void
	{
		var lv:LoadVars			= new LoadVars();
		lv.onData 				= Delegate.create(this, onCreateEvent);
		lv.cmd 					= "create_entry";
		lv.auth					= auth;
		lv.name					= name;
		lv.email				= email;
		lv.calendarName			= calendarName;
		lv.startYear			= startDate.getFullYear();
		lv.startMonth			= startDate.getMonth() + 1;
		lv.startDay				= startDate.getDate();
		lv.startHour			= startDate.getHours();
		lv.startMinute			= startDate.getMinutes();
		lv.endYear				= endDate.getFullYear();
		lv.endMonth				= endDate.getMonth() + 1;
		lv.endDay				= endDate.getDate();
		lv.endHour				= endDate.getHours();
		lv.endMinute			= endDate.getMinutes();
		lv.title				= title;
		lv.description			= description;
		lv.where				= where;
		lv.sendAndLoad(_global.phpURL, lv, "POST");
	}
	
	private function onCreateEvent(o):Void
	{
		trace("------------------");
		trace("CreateEventDelegate::onCreateEvent, o: " + o);
		/*for(var p in o)
		{
			trace(p + ": " + o[p]);
		}
		*/
		
		if(o == "true" || o == 1 || o == "1")
		{
			responder.onResult(new ResultEvent(true));
		}
		else
		{
			var fault:Fault = new Fault("failure", "create event failure", "Failed to create event.", "LoadVars");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
	/*
	private function onCreateEvent(p_success:Boolean):Void
	{
		if(p_success == true)
		{
			responder.onResult(new ResultEvent(true));
		}
		else
		{
			var fault:Fault = new Fault("failure", "create event failure", "Failed to create event.", "LoadVars");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	*/
}
