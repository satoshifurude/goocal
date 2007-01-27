
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.GetEntryEvent;
import com.jxl.goocal.business.GetEntryDelegate;
import com.jxl.goocal.model.ModelLocator;
import com.jxl.goocal.vo.EntryVO;

class com.jxl.goocal.commands.GetEntryCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:GetEntryEvent):Void
	{
		var ged:GetEntryDelegate = new GetEntryDelegate(this);
		ged.getEntry(ModelLocator.getInstance().authCode, p_event.entryVO);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		ModelLocator.getInstance().currentEntry = EntryVO(result.result);
		super.result(new ResultEvent(true));
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(status);
	}
	
	public function toString():String
	{
		return "[class GetEntryCommand]";
	}
}
