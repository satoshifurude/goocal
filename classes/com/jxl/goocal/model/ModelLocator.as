import com.jxl.shuriken.core.Collection;
import com.jxl.goocal.vo.CalendarVO;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.shuriken.utils.DateUtils;

class com.jxl.goocal.model.ModelLocator
{
	private static var inst:ModelLocator;
	
	public function ModelLocator()
	{
	}
	
	public static function getInstance():ModelLocator
	{
		if(inst == null)
		{
			inst = new ModelLocator();
			inst.timeZoneOffset = DateUtils.getLocalOffset();
		}
		return inst;
	}
	
	public var calendars:Collection; // array of strings
	public var selectedCalendar:String;
	public var authCode:String;
	public var username:String;
	public var entries_array:Array;
	public var currentEntry:EntryVO;
	public var currentDate:Date;
	public var currentVersion:String = "1.0.0";
	public var timeZoneOffset:Number;
}