/*
	DelegateTemplate
	
	Template for a ARP Delegate class.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

class com.jxl.goocal.business.CheckForUpdatesDelegate
{
	private var responder:Responder;
	private var lv:LoadVars;
	
	public function CheckForUpdatesDelegate(p_responder:Responder)
	{
		responder = p_responder;
	}
	
	public function checkForUpdates(currentVersion:String):Void
	{
		lv						= new LoadVars();
		lv.onLoad 				= Delegate.create(this, onUpdates);
		lv.cmd 					= "check_version";
		lv.currentVersion		= currentVersion;
		lv.sendAndLoad(_global.phpURL, lv, "POST");
	}
	
	private function onUpdates(success:Boolean):Void
	{
		trace("------------------");
		trace("CheckForUpdatesDelegate::onUpdates, success: " + success);
		for(var p in lv)
		{
			trace(p + ": " + lv[p]);
		}
		if(success == true)
		{
			if(lv.needUpdate == "true")
			{
				responder.onResult(new ResultEvent({newVersion: lv.newVersion,
												    updateURL: lv.updateURL}));
			}
			else if(lv.needUpdate == "false")
			{
				responder.onResult(new ResultEvent(false));
			}
		}
		else
		{
			var fault:Fault = new Fault("failure", "check update failure", "Failed to hit update server.", "LoadVars");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
}
