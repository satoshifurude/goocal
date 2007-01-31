import mx.utils.Delegate;

import com.jxl.goocal.factories.CalendarFactory;
import com.jxl.goocal.vo.CalendarVO;


class CalendarFactoryTest
{
	private static var inst:CalendarFactoryTest;
	
	public static function getInstance():CalendarFactoryTest
	{
		if(inst == null) inst = new CalendarFactoryTest();
		return inst;
	}
	
	public function test():Void
	{
		trace("---------------");
		trace("CalendarFactoryTest::test");
		var lv:LoadVars = new LoadVars();
		lv.onData = Delegate.create(this, onData);
		var theURL:String = "http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44@group.calendar.google.com/public/full";
		lv.load(theURL, lv, "GET");
	}
	
	private function onData(p_str:String):Void
	{
		trace("---------------");
		trace("CalendarFactoryTest::onData");
		//trace("p_str: " + p_str);
		var calendarVO:CalendarVO = CalendarFactory.getCalendarFromXML(p_str);
		trace("calendarVO: " + calendarVO);
		_root.calendarVO = calendarVO;
	}
}