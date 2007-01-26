
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.GetCalendarEventsEvent;
import com.jxl.goocal.business.GetCalendarEventsDelegate;

import com.jxl.goocal.model.ModelLocator;
import com.jxl.goocal.vo.CalendarVO;

class com.jxl.goocal.commands.GetCalendarEventsCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:GetCalendarEventsEvent):Void
	{
		var gced:GetCalendarEventsDelegate = new GetCalendarEventsDelegate(this);
		gced.setProgressCallback(this, onProgress);
		gced.getCalendarEvents(ModelLocator.getInstance().authCode, 
							   ModelLocator.getInstance().username,
							   p_event.calendarName,
							   p_event.startDate,
							   p_event.endDate);
	}
	
	private function onProgress(p_str:String):Void
	{
		super.result(p_str);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		// HACK: can't cast to array
		var o = result.result;
		ModelLocator.getInstance().entries_array = o;
		super.result(true);
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(status);
	}
	
	public function toString():String
	{
		return "[class GetCalendarEventsCommand]";
	}
}
