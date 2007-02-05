import com.jxl.shuriken.core.Collection;
import com.jxl.goocal.vo.CalendarVO;
import com.jxl.goocal.vo.EntryVO;

class com.jxl.goocal.model.ModelLocator
{
	private static var inst:ModelLocator;
	
	public function ModelLocator()
	{
	}
	
	public static function getInstance():ModelLocator
	{
		if(inst == null) inst = new ModelLocator();
		return inst;
	}
	
	public var calendars:Collection; // array of strings
	public var selectedCalendar:String;
	public var authCode:String;
	public var username:String;
	public var entries_array:Array;
	public var currentEntry:EntryVO;
	public var currentDate:Date;
}