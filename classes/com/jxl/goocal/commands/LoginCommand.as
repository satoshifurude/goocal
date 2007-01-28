
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

import org.osflash.arp.CommandTemplate;

import com.jxl.goocal.events.LoginEvent;
import com.jxl.goocal.business.LoginDelegate;
import com.jxl.goocal.callbacks.LoginCallback;
import com.jxl.goocal.model.ModelLocator;

class com.jxl.goocal.commands.LoginCommand extends CommandTemplate implements Responder
{
	private function executeOperation(p_event:LoginEvent):Void
	{
		var ld:LoginDelegate = new LoginDelegate(this);
		ModelLocator.getInstance().username = p_event.username;
		ld.setProgressCallback(this, onProgress);
		ld.login(p_event.username, p_event.password);
	}
	
	private function onProgress(str:String):Void
	{
		var lc:LoginCallback = new LoginCallback(LoginCallback.LOGGED_IN_FAILED_ATTEMPT);
		lc.progress = str;
		super.result(lc);
	}
	
	public function onResult(result:ResultEvent):Void
	{
		ModelLocator.getInstance().authCode = result.result.toString();
		super.result(new LoginCallback(LoginCallback.LOGGED_IN_SUCCESS));
	}
	
	public function onFault(status:FaultEvent):Void
	{
		super.fault(new LoginCallback(LoginCallback.LOGGED_IN_FAILED));
	}
	
	public function toString():String
	{
		return "[class LoginCommand]";
	}
}
