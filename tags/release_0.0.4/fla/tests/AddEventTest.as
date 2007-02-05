import mx.utils.Delegate;

import com.jxl.goocal.factories.CalendarFactory;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.AuthorVO;
import com.jxl.goocal.vo.WhenVO;

class AddEventTest
{
	private static var inst:AddEventTest;
	
	public static function getInstance():AddEventTest
	{
		if(inst == null) inst = new AddEventTest();
		return inst;
	}
	
	private var lv:LoadVars;
	private var auth:String;
	private var send_xml:XML;
	private var entryVO:EntryVO;
	private var delete_xml:XML;
	
	public function test():Void
	{
		debug("--------------------");
		debug("AddEventTest::test");
		lv = new LoadVars();
		//lv.onData = Delegate.create(this, onDataLoaded);
		lv.onLoad = Delegate.create(this, onLVLoaded);
		lv.onHTTPStatus = Delegate.create(this, onLVHTTPStatus);
		var theURL:String = "https://www.google.com/accounts/ClientLogin";
		lv.Email = "someemail@gmail.com";
		lv.Passwd = "somepassword";
		lv.source = "jessewarden.com-WhenWhat-0.0.1";
		lv.service = "cl";
		lv.sendAndLoad(theURL, lv, "POST");
		
	}
	
	private function onLVHTTPStatus(p_httpStatus:Number):Void
	{
		debug("--------------------");
		debug("AddEventTest::onLVHTTPStatus");
		debug("p_httpStatus: " + p_httpStatus);
	}
	
	private function onDataLoaded(p_str:String):Void
	{
		debug("--------------------");
		debug("AddEventTest::onDataLoaded");
		debug("p_str: " + p_str);
	}
	
	private function onLVLoaded(p_success:Boolean):Void
	{
		debug("--------------------");
		debug("AddEventTest::onLVLoaded");
		debug("p_success: " + p_success);
		
		debug("Posting default entry...");
		var startIndex:Number = lv.SID.lastIndexOf("Auth=");
		auth = lv.SID.substr(startIndex + 5, lv.SID.length);
		//debug("auth: " + auth);
		
		var authorVO:AuthorVO = new AuthorVO("WhenWhereApp", "jesse.warden@gmail.com");
		var theStartTime:Date = new Date();
		//theStartTime.setHours(15);
		theStartTime.setMinutes(0);
		var theEndTime:Date = new Date();
		theEndTime.setHours(theEndTime.getHours() + 1);
		//theEndTime.setHours(16);
		theEndTime.setMinutes(0);
		var theReminder:Date = new Date();
		theReminder.setHours(theEndTime.getHours());
		theReminder.setMinutes(theReminder.getMinutes() - 10);
		var whenVO:WhenVO = new WhenVO(theStartTime, theEndTime, theReminder);
		var ID:String = "http://www.google.com/calendar/feeds/default/private/full";
		entryVO = new EntryVO(ID,
							  new Date(),
							  new Date(),
							  "Add Event Test",
							  "This is a unit test test.",
							  authorVO,
							  true,
							  "Flash 8 Authoring IDE",
							  whenVO,
							  []);
							
		var theXMLStr:String = CalendarFactory.getEventXMLString(entryVO);
		
		send_xml = new XML();
		send_xml.ignoreWhite = true;
		send_xml.parseXML(theXMLStr);
		send_xml.contentType = "application/atom+xml";
		send_xml.addRequestHeader("Authorization", "GoogleLogin auth=" + auth);
		//send_xml.onData = Delegate.create(this, onCreateEventData);
		send_xml.onLoad = Delegate.create(this, onCreateEventLoad);
		//send_xml.onHTTPStatus = Delegate.create(this, onCreateEventHTTPStatus);
		//send_xml.sendAndLoad(entryVO.id, send_xml, "POST");
		trace(send_xml);
	}
	
	private function onCreateEventHTTPStatus(p_httpStatus:Number):Void
	{
		debug("--------------------");
		debug("AddEventTest::onCreateEventHTTPStatus");
		debug("p_httpStatus: " + p_httpStatus);
	}
	
	private function onCreateEventData(p_str:String):Void
	{
		debug("--------------------");
		debug("AddEventTest::onCreateEventData");
		debug("p_str: " + p_str);
		//var tmp_xml:XML = new XML();
		//tmp_xml.ignoreWhite = true;
		//tmp_xml.parseXML(p_str);
		//debug("tmp_xml.firstChild.firstChild.nodeName: " + tmp_xml.firstChild.firstChild.nodeName);
		//debug("tmp_xml.firstChild.firstChild: " + tmp_xml.firstChild.firstChild);
		
		//deleteEntry();
	}
	
	private function onCreateEventLoad(p_success:Boolean):Void
	{
		debug("--------------------");
		debug("AddEventTest::onCreateEventLoad");
		debug("p_success: " + p_success);
	}
	
	private function deleteEntry():Void
	{
		delete_xml = new XML();
		delete_xml.ignoreWhite = true;
		//delete_xml.parseXML(theXMLStr);
		delete_xml.contentType = "application/atom+xml";
		delete_xml.addRequestHeader("Authorization", "GoogleLogin auth=" + auth);
		delete_xml.onData = Delegate.create(this, onDeleteEventData);
		//delete_xml.onHTTPStatus = Delegate.create(this, onDeleteEventHTTPStatus);
		delete_xml.sendAndLoad(entryVO.id + "/93grlv60f4i613kj6ql61fl38o", delete_xml, "POST");
	}
	
	private function onDeleteEventData(p_str:String):Void
	{
		debug("--------------------");
		debug("AddEventTest::onDeleteEventData");
		debug("p_str: " + p_str);
	}
	
	private function onDeleteEventHTTPStatus(p_httpStatus:Number):Void
	{
		debug("--------------------");
		debug("AddEventTest::onDeleteEventHTTPStatus");
		debug("p_httpStatus: " + p_httpStatus);
	}
	
	function debug(o)
	{
		_root.debug_txt.text += o + "\n";
		_root.debug_txt.scroll += 2;
	}
	
	function dProps(o)
	{
		for(var p in o)
		{
			debug(o + ": " + o[p]);
		}
	}
}