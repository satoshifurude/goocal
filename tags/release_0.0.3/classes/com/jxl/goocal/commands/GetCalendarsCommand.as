
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.GetCalendarsEvent;
import com.jxl.goocal.business.GetCalendarsDelegate;

import com.jxl.goocal.model.ModelLocator;

import com.jxl.shuriken.core.Collection;

class com.jxl.goocal.commands.GetCalendarsCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:GetCalendarsEvent):Void
	{
		var gcd:GetCalendarsDelegate = new GetCalendarsDelegate(this);
		gcd.getCalendars(ModelLocator.getInstance().authCode, ModelLocator.getInstance().username);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		var c:Collection = new Collection();
		var a = result.result;
		var i:Number = a.length;
		while(i--)
		{
			c.addItemAt(a[i], i);
		}
		ModelLocator.getInstance().calendars = c;
		
		super.result(true);
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(status);
	}
	
	public function toString():String
	{
		return "[class GetCalendarsCommand]";
	}
}
