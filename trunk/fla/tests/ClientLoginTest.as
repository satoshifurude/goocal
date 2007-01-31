import mx.utils.Delegate;

class ClientLoginTest
{
	private static var inst:ClientLoginTest;
	
	public static function getInstance():ClientLoginTest
	{
		if(inst == null) inst = new ClientLoginTest();
		return inst;
	}
	
	private var lv:LoadVars;
	private var auth:String;
	
	public function test():Void
	{
		debug("--------------------");
		debug("ClientLoginTest::test");
		lv = new LoadVars();
		//lv.onData = Delegate.create(this, onDataLoaded);
		lv.onLoad = Delegate.create(this, onLVLoaded);
		lv.onHTTPStatus = Delegate.create(this, onLVHTTPStatus);
		var theURL:String = "https://www.google.com/accounts/ClientLogin";
		lv.Email = "someuser@gmail.com";
		lv.Passwd = "somepassword";
		lv.source = "jessewarden.com-WhenWhat-0.0.1";
		lv.service = "cl";
		lv.sendAndLoad(theURL, lv, "POST");
	}
	
	private function onLVHTTPStatus(p_httpStatus:Number):Void
	{
		debug("--------------------");
		debug("ClientLoginTest::onLVHTTPStatus");
		debug("p_httpStatus: " + p_httpStatus);
	}
	
	private function onDataLoaded(p_str:String):Void
	{
		debug("--------------------");
		debug("ClientLoginTest::onDataLoaded");
		debug("p_str: " + p_str);
	}
	
	private function onLVLoaded(p_success:Boolean):Void
	{
		debug("--------------------");
		debug("ClientLoginTest::onLVLoaded");
		debug("p_success: " + p_success);
		var startIndex:Number = lv.SID.lastIndexOf("Auth=");
		auth = lv.SID.substr(startIndex, lv.SID.length);
	}
	
	function debug(o)
	{
		_root.debug_txt.text += o + "\n";
	}
	
	function dProps(o)
	{
		for(var p in o)
		{
			debug(o + ": " + o[p]);
		}
	}
}