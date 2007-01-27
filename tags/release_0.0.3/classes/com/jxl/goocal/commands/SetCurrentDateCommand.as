
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.SetCurrentDateEvent;
import com.jxl.goocal.callbacks.SetCurrentDateCallback;
import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.SetCurrentDateCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:SetCurrentDateEvent):Void
	{
		ModelLocator.getInstance().currentDate = p_event.currentDate;
		onResult(new ResultEvent(true));
	}
	
	public function onResult(result:ResultEvent):Void
	{
		var callback:SetCurrentDateCallback = new SetCurrentDateCallback(true);
		super.result(callback);
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(status);
	}
	
	public function toString():String
	{
		return "[class SetCurrentDateCommand]";
	}
}
