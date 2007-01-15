
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import com.jxl.shuriken.utils.DateUtils;

class class com.jxl.goocal.delegates.GetEntryDelegate
{
	private var responder:Responder;
	private var lv:LoadVars;
	
	public function GetEntryDelegate(p_responder:Responder)
	{
		responder = p_responder;
	}
	
	public function getEntry(p_auth:String, p_entryID:String):Void
	{
		lv = new LoadVars();
		lv.onLoad = Delegate.create(this, onGetEntry);
		lv.cmd = "get_entry";
		lv.auth = p_auth;
		lv.entryURL = p_entryID;
		var theURL:String = "http://www.jessewarden.com/goocal/php/com/jxl/goocal/controller/Application.php";
		lv.sendAndLoad(theURL, lv, "POST");
	}
	
	private function onGetEntry(p_success:Boolean):Void
	{
		if(p_loaded == true)
		{
			var entryVO:EntryVO = new EntryVO();
			/*
			id
			title
			description
			startTime
			endTime
			minutes
			*/
			
			entryVO.id = lv.id;
			entryVO.title = lv.title;
			entryVO.description = lv.description;
			entryVO.whenVO = new WhenVO();
			entryVO.whenVO.startTime = CalendarFactory.parseDateTime(lv.startTime);
			entryVO.whenVO.endTime = CalendarFactory.parseDateTime(lv.endTime);
			var reminderMins:Number = parseInt(lv.minutes);
			var theEntryReminder:Date = DateUtils.clone(entryVO.whenVO.endTime);
			theEntryReminder.setMinutes(entryVO.whenVO.endTime.getMinutes() - reminderMins);
			entryVO.whenVO.reminder = theEntryReminder;
			
			responder.onResult(new ResultEvent(entryVO));
		}
		else
		{
			var fault:Fault = new Fault("failure", "xml load failure", "The XML failed to load from the server.", "XML");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
}
			