
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import com.jxl.shuriken.utils.DateUtils;

import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;
import com.jxl.goocal.factories.CalendarFactory;

class com.jxl.goocal.business.GetEntryDelegate
{
	private var responder:Responder;
	private var lv:LoadVars;
	private var entryVO:EntryVO;
	
	public function GetEntryDelegate(p_responder:Responder)
	{
		responder = p_responder;
	}
	
	public function getEntry(p_auth:String, p_entryVO:EntryVO):Void
	{
		entryVO = p_entryVO;
		
		lv = new LoadVars();
		lv.onLoad = Delegate.create(this, onGetEntry);
		lv.cmd = "get_entry";
		lv.auth = p_auth;
		lv.entryURL = entryVO.id;
		lv.sendAndLoad(_global.phpURL, lv, "POST");
	}
	
	private function onGetEntry(p_success:Boolean):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("GetEntryDelegate::onGetEntry, p_success: " + p_success);
		
		if(p_success == true)
		{
			var newEntryVO:EntryVO = new EntryVO();
			/*
			id
			title
			description
			startTime
			endTime
			minutes
			*/
			
			//DebugWindow.debugProps(lv);
			
			newEntryVO.id = lv.id;
			newEntryVO.title = lv.title;
			newEntryVO.description = lv.description;
			newEntryVO.where = lv.where;
			newEntryVO.whenVO = new WhenVO();
			//newEntryVO.whenVO.startTime = CalendarFactory.parseDateTime(lv.startTime);
			//newEntryVO.whenVO.endTime = CalendarFactory.parseDateTime(lv.endTime);
			newEntryVO.whenVO.startTime = entryVO.whenVO.startTime;
			newEntryVO.whenVO.endTime = entryVO.whenVO.endTime;
			var reminderMins:Number = parseInt(lv.minutes);
			var theEntryReminder:Date = DateUtils.clone(newEntryVO.whenVO.endTime);
			theEntryReminder.setMinutes(newEntryVO.whenVO.endTime.getMinutes() - reminderMins);
			newEntryVO.whenVO.reminder = theEntryReminder;
			
			responder.onResult(new ResultEvent(newEntryVO));
		}
		else
		{
			var fault:Fault = new Fault("failure", "xml load failure", "The XML failed to load from the server.", "XML");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
}
			