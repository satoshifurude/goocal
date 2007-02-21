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

import com.jxl.goocal.events.CheckForUpdatesEvent;
import com.jxl.goocal.business.CheckForUpdatesDelegate;
import com.jxl.goocal.callbacks.CheckForUpdatesCallback;
import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.CheckForUpdatesCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:CheckForUpdatesEvent):Void
	{
		var cfud:CheckForUpdatesDelegate = new CheckForUpdatesDelegate(this);
		cfud.checkForUpdates(ModelLocator.getInstance().currentVersion);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		var callback:CheckForUpdatesCallback = new CheckForUpdatesCallback();
		callback.failed = false;
		if(result.result == false)
		{
			callback.newerVersionAvailable = false;
		}
		else
		{
			callback.newerVersionAvailable = true;
			callback.newVersion = result.result.newVersion;
			callback.updateURL = result.result.updateURL;
		}
		super.result(callback);
	}
	
	public function onFault(status:FaultEvent):Void
	{
		var callback:CheckForUpdatesCallback = new CheckForUpdatesCallback();
		callback.failed = true;
		super.fault(callback);
	}
	/*
	public function toString():String
	{
		return "[class CheckForUpdatesCommand]";
	}
	*/
}
