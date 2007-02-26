
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.EditEventEvent;
import com.jxl.goocal.business.EditEventDelegate;

import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.EditEventCommand extends CommandTemplate implements Responder
{
	private function executeOperation(event:EditEventEvent):Void
	{
		var eed:EditEventDelegate = new EditEventDelegate(this);
		eed.editEvent(ModelLocator.getInstance().authCode,
						ModelLocator.getInstance().username,
						ModelLocator.getInstance().username,
						event.id,
						event.calendar,
						event.startDate,
						event.endDate,
						event.title,
						event.description,
						event.where,
						ModelLocator.getInstance().timeZoneOffset);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		super.result(true);
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(true);
	}
}
