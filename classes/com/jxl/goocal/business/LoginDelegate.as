
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;

class com.jxl.goocal.business.LoginDelegate
{
	private var responder:Responder;
	private var lv:LoadVars;
	private var attempts:Number;
	private var maxAttempts:Number = 3;
	private var username:String;
	private var password:String;
	private var __progressScope:Object;
	private var __progressFunction:Function;
	
	function LoginDelegate(p_responder:Responder)
	{
		responder = p_responder;
		attempts = 0;
	}
	
	public function login(p_username:String, p_password:String):Void
	{
		attempts++;
		username = p_username;
		password = p_password;
		lv = new LoadVars();
		lv.onData = Delegate.create(this, onGetAuthCode);
		lv.cmd = "get_auth";
		//DebugWindow.debugHeader();
		//DebugWindow.debug("p_username: " + p_username);
		lv.username = p_username;
		lv.password = p_password;
		var theURL:String = "http://www.jessewarden.com/goocal/php/com/jxl/goocal/controller/Application.php";
		lv.sendAndLoad(theURL, lv, "POST");
	}
	
	private function onGetAuthCode(p_auth:String):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginDelegate::onGetAuthCode");
		//DebugWindow.debug("p_auth: " + p_auth);
		
		if(p_auth != undefined && p_auth.indexOf("Warning") == -1 && p_auth.indexOf("Error") == -1)
		{
			responder.onResult(new ResultEvent(p_auth));
		}
		else
		{
			if(attempts < maxAttempts)
			{
				__progressFunction.call(__progressScope, "Failed attempt " + attempts + ".  Trying again...");
				login(username, password);
			}
			else
			{
				var fault:Fault = new Fault("failure", "login failure", "Failed to login.", "Login");
				var fe:FaultEvent = new FaultEvent(fault);
				responder.onFault(fe);
			}
		}
	}
	
	public function setProgressCallback(scope:Object, func:Function):Void
	{
		__progressScope = scope;
		__progressFunction = func;
	}
	
}
