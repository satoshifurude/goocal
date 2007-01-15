
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.GetEntryEvent;
import com.jxl.goocal.delegates.GetEntryDelegate;
import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.GetEntryCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:GetEntryEvent):Void
	{
		var ged:GetEntryDelegate = new GetEntryDelegate(this);
		ged.getEntry(ModelLocator.getInstance().authCode, p_event.eventID);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		ModelLocator.getInstance().currentEntry = EventVO(result.result);
		super.result(new ResultEvent(true));
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(new FaultEvent(false));
	}
	
	public function toString():String
	{
		return "[class GetEntryCommand]";
	}
}
