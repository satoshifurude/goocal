
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.SelectCalendarEvent;

import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.SelectCalendarCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:SelectCalendarEvent):Void
	{
		ModelLocator.getInstance().selectedCalendar = p_event.selectedCalendar;
		onResult();
	}
	
	public function onResult(result:ResultEvent):Void
	{
		super.result(true);
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(false);
	}
	
	public function toString():String
	{
		return "[class SelectCalendarCommand]";
	}
}
