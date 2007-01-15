import com.jxl.goocal.vo.AuthorVO;

class com.jxl.goocal.vo.CalendarVO
{
	public var id:String;
	public var updated:Date;
	public var title:String;
	public var subTitle:String;
	public var author:AuthorVO;
	public var where:String;
	public var timeZone:String;
	public var entries_array:Array;
	
	
	/*
	
	<feed>
	
		<id>
		http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full
		</id>
		<updated>2006-11-03T16:36:01.000Z</updated>
		<title type="text">JXL Sample</title>
		<subtitle type="text">Public calendar to showcase with Flash Lite.</subtitle>
		<link rel="http://schemas.google.com/g/2005#feed" type="application/atom+xml" href="http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full"/>
		<link rel="self" type="application/atom+xml" href="http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full?max-results=25"/>
		
		<author>
			<name>Jesse Warden</name>
			<email>jesse.warden@gmail.com</email>
		</author>
		<generator version="1.0" uri="http://www.google.com/calendar">Google Calendar</generator>
		<openSearch:startIndex>1</openSearch:startIndex>
		<openSearch:itemsPerPage>25</openSearch:itemsPerPage>
		<gd:where valueString="Atlanta, GA, USA"/>
		<gCal:timezone value="America/New_York"/>
		
		<entry>
	
			<id>
			http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full/16135lsn0b50tc1s33tct9jrf8
			</id>
			<published>2006-11-03T16:36:01.000Z</published>
			<updated>2006-11-03T16:36:01.000Z</updated>
			<category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/g/2005#event"/>
			<title type="text">BSG on SciFi</title>
			<content type="text"/>
			<link rel="alternate" type="text/html" href="http://www.google.com/calendar/event?eid=MTYxMzVsc24wYjUwdGMxczMzdGN0OWpyZjggZTJqNzdqYXJxb3VrcWluOTlocGwycjJrNDRAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ" title="alternate"/>
			<link rel="self" type="application/atom+xml" href="http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full/16135lsn0b50tc1s33tct9jrf8"/>
			
			<author>
				<name>JXL Sample</name>
			</author>
			<gCal:sendEventNotifications value="true"/>
			<gd:transparency value="http://schemas.google.com/g/2005#event.opaque"/>
			
			<gd:comments>
				<gd:feedLink href="http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full/16135lsn0b50tc1s33tct9jrf8/comments"/>
			</gd:comments>
			<gd:eventStatus value="http://schemas.google.com/g/2005#event.confirmed"/>
			<gd:where/>
			
			<gd:when startTime="2006-11-03T21:00:00.000-05:00" endTime="2006-11-03T22:00:00.000-05:00">
				<gd:reminder minutes="10"/>
			</gd:when>
		</entry>
			
		<entry>
			
			<id>
			http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full/61g9o1cu6jlb6tocmj98ac0hrc
			</id>
			<published>2006-11-03T16:35:29.000Z</published>
			<updated>2006-11-03T16:35:52.000Z</updated>
			<category scheme="http://schemas.google.com/g/2005#kind" term="http://schemas.google.com/g/2005#event"/>
			<title type="text">Call Matt</title>
			<content type="text">Gotta call Matt to discuss outline.</content>
			<link rel="alternate" type="text/html" href="http://www.google.com/calendar/event?eid=NjFnOW8xY3U2amxiNnRvY21qOThhYzBocmMgZTJqNzdqYXJxb3VrcWluOTlocGwycjJrNDRAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ" title="alternate"/>
			<link rel="self" type="application/atom+xml" href="http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full/61g9o1cu6jlb6tocmj98ac0hrc"/>
			
			<author>
				<name>JXL Sample</name>
			</author>
			<gCal:sendEventNotifications value="true"/>
			<gd:transparency value="http://schemas.google.com/g/2005#event.opaque"/>
			
			<gd:comments>
				<gd:feedLink href="http://www.google.com/calendar/feeds/e2j77jarqoukqin99hpl2r2k44%40group.calendar.google.com/public/full/61g9o1cu6jlb6tocmj98ac0hrc/comments"/>
			</gd:comments>
			<gd:eventStatus value="http://schemas.google.com/g/2005#event.confirmed"/>
			<gd:where/>
			
			<gd:when startTime="2006-11-03T14:00:00.000-05:00" endTime="2006-11-03T15:00:00.000-05:00">
				<gd:reminder minutes="10"/>
			</gd:when>
		</entry>
		
	</feed>
	
	*/
	
	public function CalendarVO(p_id:String,
							   p_updated:Date,
							   p_title:String,
							   p_subTitle:String,
							   p_author:AuthorVO,
							   p_where:String,
							   p_timeZone:String,
							   p_entries_array:Array)
	{
		id				= p_id;
		updated			= p_updated;
		title			= p_title;
		subTitle		= p_subTitle;
		author			= p_author;
		where			= p_where;
		timeZone		= p_timeZone;
		entries_array 	= p_entries_array;
	}
	
	public function toString():String
	{
		return "[class CalendarVO]";
	}
}