
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
	private var retryID:Number;
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
		lv.sendAndLoad(_global.phpURL, lv, "POST");
	}
	
	private function onGetAuthCode(p_auth:String):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginDelegate::onGetAuthCode");
		//DebugWindow.debug("p_auth: " + p_auth);
		
		// NOTE: PHP will sometimes throw an SSL error after numerous logins.  I know why
		// this happens on IIS, but not Apache.  It even gets an auth ID from Google
		// despite the error.  Regardless, to be safe, I merely send a login again,
		// and it normally immediately responds nicely.  So, most common
		// scenario is the first response is fubarred, and 2nd always goes through.
		clearInterval(retryID);
		if(p_auth != undefined && p_auth.indexOf("Warning") == -1 && p_auth.indexOf("Error") == -1)
		{
			responder.onResult(new ResultEvent(p_auth));
		}
		else
		{
			if(attempts < 3)
			{
				__progressFunction.call(__progressScope, "Failed attempt " + attempts + ".");
				retryID = setInterval(this, "loginAgain", 1000);
				
			}
			else
			{
				var fault:Fault = new Fault("failure", "login failure", "Failed to login.", "Login");
				var fe:FaultEvent = new FaultEvent(fault);
				responder.onFault(fe);
			}
		}
	}
	
	private function loginAgain():Void
	{
		
		clearInterval(retryID);
		__progressFunction.call(__progressScope, "Trying again...");
		login(username, password);
	}
	
	public function setProgressCallback(scope:Object, func:Function):Void
	{
		__progressScope = scope;
		__progressFunction = func;
	}
	
}
