import mx.utils.Delegate;

import com.jxl.goocal.factories.CalendarFactory;
import com.jxl.goocal.vo.AuthorVO;
import com.jxl.goocal.vo.WhenVO;
import com.jxl.goocal.vo.EntryVO;

class GetCalendarsTest
{
	private static var inst:GetCalendarsTest;
	
	public static function getInstance():GetCalendarsTest
	{
		if(inst == null) inst = new GetCalendarsTest();
		return inst;
	}
	
	var lv:LoadVars;
	var cal_xml:XML;
	var get_lv:LoadVars;
	var auth;
	var send_xml:XML;
	
	public function test():Void
	{
		debug("--------------------");
		debug("GetCalendarsTest::test");
		
		lv = new LoadVars();
		lv.onLoad = Delegate.create(this, onLVLoaded);
		lv.onHTTPStatus = Delegate.create(this, onLVHTTPStatus);
		var theURL:String = "https://www.google.com/accounts/ClientLogin";
		//var headers:Array = ["X-If-No-Redirect", "1"];
		//var headers = ["Content-Type", "text/plain", "X-ClientAppVersion", "2.0"];
		//lv.addRequestHeader(headers);
		lv.Email = "someemail@gmail.com";
		lv.Passwd = "somepassword";
		lv.source = "jessewarden.com-WhenWhat-0.0.1";
		lv.service = "cl";
		lv.sendAndLoad(theURL, lv, "POST");
	}
	
	private function onLVHTTPStatus(p_httpStatus:Number):Void
	{
		debug("--------------------");
		debug("GetCalendarsTest::onLVHTTPStatus");
		debug("p_httpStatus: " + p_httpStatus);
	}
	
	private function onDataLoaded(p_str:String):Void
	{
		debug("--------------------");
		debug("GetCalendarsTest::onDataLoaded");
		debug("p_str: " + p_str);
	}
	
	public function onLVLoaded(p_success:Boolean):Void
	{
		debug("--------------------");
		debug("GetCalendarsTest::onLVLoaded, p_success: " + p_success);
		
		var startIndex:Number = lv.SID.lastIndexOf("Auth=");
		auth = lv.SID.substr(startIndex + 5, lv.SID.length);
		debug("auth: " + auth);
		
		var theURL:String = "http://www.google.com/calendar/feeds/jesse.warden@gmail.com";
		
		/*
		get_lv = new LoadVars();
		get_lv.contentType = "application/atom+xml";
		get_lv.onHTTPStatus = Delegate.create(this, onGetHTTP);
		get_lv.onLoad = Delegate.create(this, onGetLoaded);
		//var headers:Array = ["Authorization", "GoogleLogin Auth=" + auth, "X-If-No-Redirect", "1"];
		//var headers:Array = ["Authorization", "GoogleLogin Auth=" + auth];
		//get_lv.addRequestHeader(headers);
		get_lv.sendAndLoad(theURL, get_lv, "POST");
		*/
		
		var xmlStr:String = "<entry><id>http://calendar.google.com/calendar/feeds/jesse.warden@gmail.com/jesse.warden@gmail.com</id><published>2006-06-20T03:28:01.868Z</published><updated>2006-06-15T22:03:57.000Z</updated><title type=\"text\">My Social Calendar</title><link rel=\"alternate\" type=\"application/atom+xml\" href=\"http://www.google.com/calendar/feeds/jo@gmail.com/private/full\"/><link rel=\"self\" type=\"application/atom+xml\" href=\"http://www.google.com/calendar/feeds/jo@gmail.com/jo@gmail.com\"/><author><name>Jesse Warden/name><email>jesse.warden@gmail.com</email></author><gCal:accesslevel value=\"owner\"/><gCal:selected value=\"false\"/><gCal:hidden value=\"false\"/><gCal:color value=\"#2952A3\"/><gCal:timezone value=\"America/Los_Angeles\"/></entry>";

		send_xml = new XML();
		send_xml.ignoreWhite = true;
		send_xml.parseXML(xmlStr);
		send_xml.contentType = "application/atom+xml";
		var headers:Array = ["Authorization", "GoogleLogin auth=" + auth];
		send_xml.addRequestHeader(headers);
		send_xml.onData = Delegate.create(this, onCreateEventData);
		send_xml.onLoad = Delegate.create(this, onCreateEventLoad);
		//send_xml.onHTTPStatus = Delegate.create(this, onCreateEventHTTPStatus);
		send_xml.sendAndLoad(theURL, send_xml, "POST");
		
		debug("send_xml: " + send_xml);
		
	}
	
	private function onCreateEventHTTPStatus(p_httpStatus:Number):Void
	{
		debug("----------------");
		debug("GetCalendarsTest::onCreateEventHTTPStatus, p_httpStatus: " + p_httpStatus);
	}
	
	private function onCreateEventData(p_str:String):Void
	{
		debug("----------------");
		debug("GetCalendarsTest::onCreateEventData, p_str: " + p_str);
		send_xml.parseXML(p_str);
		send_xml.loaded = true;
		send_xml.onLoad(true);
	}
	
	private function onCreateEventLoad(p_success:Boolean):Void
	{
		debug("----------------");
		debug("GetCalendarsTest::onCreateEventLoad, p_success: " + p_success);
	}
	
	private function onGetData(p_str:String):Void
	{
		debug("----------------");
		debug("GetCalendarsTest::onGetLoadedData, p_str: " + p_str);
	}
	
	private function onGetLoaded(p_success:Boolean):Void
	{
		debug("----------------");
		debug("GetCalendarsTest::onGetLoaded, p_success: " + p_success);
		//dProps(get_lv);
		if(p_success == false)
		{
			//var theURL:String = "http://www.google.com/calendar/feeds/jesse.warden@gmail.com";
			//get_lv.load(theURL, get_lv, "GET");
		}
		else
		{
			var list:Array = CalendarFactory.getCalendarsFromXML(cal_xml);
			debug("list: " + list);
		}
	}
	
	private function onGetHTTP(p_httpStatus:Number):Void
	{
		debug("--------------------");
		debug("GetCalendarsTest::onGetHTTP");
		debug("p_httpStatus: " + p_httpStatus);
		if(p_httpStatus == 412)
		{
			//var theURL:String = "http://www.google.com/calendar/feeds/jesse.warden@gmail.com";
			//get_lv.sendAndLoad(theURL, get_lv, "POST");
		}
	}
	
	function debug(o)
	{
		trace(o);
		_root.debug_txt.text += o + "\n";
		_root.debug_txt.scroll++;
	}
	
	function dProps(o)
	{
		for(var p in o)
		{
			debug(o + ": " + o[p]);
		}
	}
}