import com.jxl.goocal.vo.AuthorVO;
import com.jxl.goocal.vo.WhenVO;

class com.jxl.goocal.vo.EntryVO
{
	
	public var id:String;
	public var published:Date;
	public var updated:Date;
	public var title:String;
	public var description:String;
	public var authorVO:AuthorVO;
	public var sendEventNotifications:Boolean;
	public var where:String;
	public var whenVO:WhenVO;
	public var comments_array:Array;
	
	public function EntryVO(p_id:String,
							p_published:Date,
							p_updated:Date,
							p_title:String,
							p_description:String,
							p_authorVO:AuthorVO,
							p_sendEventNotifications:Boolean,
							p_where:String,
							p_whenVO:WhenVO,
							p_comments_array:Array)
	{
		id							= p_id;
		published					= p_published;
		updated						= p_updated;
		title						= p_title;
		description					= p_description;
		authorVO					= p_authorVO;
		sendEventNotifications		= p_sendEventNotifications;
		where						= p_where;
		whenVO						= p_whenVO;
		comments_array				= p_comments_array;
	}
	/*
	public function toString():String
	{
		return "[class EntryVO]";
	}
	*/
	
	public function toVerboseString():String
	{
		var s:String = "";
		s += "id=" + id + " ";
		s += "published=" + published + " ";
		s += "updated=" + updated + " ";
		s += "title=" + title + " ";
		s += "description=" + description + " ";
		s += "authorVO=" + authorVO + " ";
		s += "sendEventNotifications=" + sendEventNotifications + " ";
		s += "where=" + where + " ";
		s += "whenVO=" + whenVO + " ";
		s += "comments_array=" + comments_array + " ";
		s += "]";
		return s;
	}
	
	public function clone():EntryVO
	{
		// TODO: implement
		//var entry:EntryVO = new EntryVO();
		return null;
	}
	
	public function toHourString():String
	{
		var hrStr:String = "";
		var d:Date = whenVO.startTime;
		if(whenVO.isAllDay == false)
		{
			var hour:Number = d.getHours();
			if(hour > 11)
			{
				if(hour > 12) hour -= 12;
				hrStr += hour + "pm";
			}
			else
			{
				hrStr += hour + "am";
			}
			return hrStr;
		}
		else
		{
			return "All Day";
		}
	}
	
	public function toHourRangeString():String
	{
		if(whenVO.isAllDay == false)
		{
			var hrStr:String = "";
			var startDate:Date = whenVO.startTime;
			var endDate:Date = whenVO.endTime;
			var startHour:Number = startDate.getHours();
			var endHour:Number = endDate.getHours();
			if(startHour > 11)
			{
				if(startHour > 12) startHour -= 12;
				hrStr += startHour + "pm";
			}
			else
			{
				hrStr += startHour + "am";
			}
			
			hrStr += " - ";
			
			if(endHour > 11)
			{
				if(endHour > 12) endHour -= 12;
				hrStr += endHour + "pm";
			}
			else
			{
				hrStr += endHour + "am";
			}
			return hrStr;
		}
		else
		{
			return "All Day";
		}
	}
}