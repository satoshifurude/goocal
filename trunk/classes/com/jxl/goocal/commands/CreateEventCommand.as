/*
	CommandTemplate
	
	Template for a ARP Command class.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.CreateEventEvent;
import com.jxl.goocal.business.CreateEventDelegate;
import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.CreateEventCommand extends CommandTemplate implements Responder
{
	private function executeOperation(event:CreateEventEvent):Void
	{
		var ced:CreateEventDelegate = new CreateEventDelegate(this);
		ced.createEvent(ModelLocator.getInstance().authCode,
						ModelLocator.getInstance().username,
						ModelLocator.getInstance().username,
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
		super.fault(false);
	}
	
	public function toString():String
	{
		return "[class CreateEventCommand]";
	}
}
