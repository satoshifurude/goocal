import com.jxl.shuriken.factories.FactoryTemplate;
import com.jxl.shuriken.utils.DateUtils;

import com.jxl.goocal.vo.CalendarVO;
import com.jxl.goocal.vo.AuthorVO;
import com.jxl.goocal.vo.EntryVO;
import com.jxl.goocal.vo.WhenVO;

import com.jxl.shuriken.utils.LoopUtils;
import GoogleCalendar;


class com.jxl.goocal.factories.CalendarFactory extends FactoryTemplate
{
	
	private static var __callbackScope:Object;
	private static var __callbackFunction:Function;
	
	private static var __entries_array:Array;
	private static var __eventList_lu:LoopUtils;
	private static var __currentEntryVO:EntryVO;
	private static var __lv:LoadVars;
	
	public static function getEventListFromLV(p_lv:LoadVars, 
												p_scope:Object,
												p_func:Function):Boolean
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("CalendarFactory::getEventListFromJSON");
		//DebugWindow.debug("p_json.length: " + p_json.length);
		
		__lv						= p_lv;
		__callbackScope 			= p_scope;
		__callbackFunction 			= p_func;
		
		__entries_array = [];
		
		if(__eventList_lu != null) __eventList_lu.destroy(false);
		__eventList_lu = new LoopUtils(GoogleCalendar.loop_mc);
		
		__currentEntryVO = new EntryVO();
		
		var totalEntries:Number = parseInt(p_lv.totalEntries);
		//DebugWindow.debug("totalEntries: " + totalEntries);
		
		__eventList_lu.forLoop(0, 
							   totalEntries,
							   1,
							   CalendarFactory,
							   onEventListParse,
							   onEventListParseDone);
		return true;
	}
	
	private static function onEventListParseDone():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("CalendarFactory::onEventListParseDone");
	
		if(__eventList_lu != null) __eventList_lu.destroy(false);
		delete __eventList_lu;
		__callbackFunction.call(__callbackScope, __entries_array);
		delete __lv;
		delete __entries_array;
		delete __currentEntryVO;
		delete __callbackScope;
		delete __callbackFunction;
	}
	
	private static function onEventListParse(p_currentIndex:Number):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("CalendarFactory::onEventListParse");
		//DebugWindow.debug("p_propName: " + p_propName + ", p_val: " + p_val);
		
		__currentEntryVO = new EntryVO();
		__currentEntryVO.whenVO = new WhenVO();
		__currentEntryVO.id = __lv["id" + p_currentIndex];
		__currentEntryVO.title = String(__lv["title" + p_currentIndex]);
		
		var startTimeValue:String = __lv["startTime" + p_currentIndex];
		__currentEntryVO.whenVO.startTime = parseDateTime(startTimeValue);
		if(isAllDayEvent(startTimeValue) == true)
		{
			__currentEntryVO.whenVO.isAllDay = true;
		}
		
		var endTimeValue:String = __lv["endTime" + p_currentIndex];
		__currentEntryVO.whenVO.endTime = parseDateTime(endTimeValue);
		
		var reminderMins:Number = parseInt(__lv["minutes" + p_currentIndex]);
		var theEntryReminder:Date = DateUtils.clone(__currentEntryVO.whenVO.endTime);
		theEntryReminder.setMinutes(__currentEntryVO.whenVO.endTime.getMinutes() - reminderMins);
		__currentEntryVO.whenVO.reminder = theEntryReminder;
		__entries_array.push(__currentEntryVO);
		
		//DebugWindow.debug("startTime: " + __lv["startTime" + p_currentIndex]);
		//DebugWindow.debug("endTime: " +__lv["endTime" + p_currentIndex]);
	}
	
	public static function getCalendarFromXML(p_xmlOrString:Object):CalendarVO
	{
		var parsedXML:XML = getParsedXML(p_xmlOrString);
		var nodes:Array = parsedXML.firstChild.childNodes;
		var i:Number = nodes.length;
		var entries_array:Array = [];
		while(i--)
		{
			var nextNode:XMLNode = nodes[i];
			var nodeName:String = nextNode.nodeName;
			switch(nodeName)
			{
				case "id":
					var theID:String = String(nextNode.firstChild);
					break;
				
				case "updated":
					var theUpdatedDate:Date = parseDateTime(String(nextNode.firstChild));
					break;
				
				case "title":
					var theTitle:String = String(nextNode.firstChild);
					break;
				
				case "subtitle":
					var theSubTitle:String = String(nextNode.firstChild);
					break;
					
				case "author":
					var theAuthor:AuthorVO = parseAuthorNode(nextNode);
					break;
					
				
				case "gd:where":
					var whereVal:String = nextNode.attributes.valueString;
					var theWhere:String = (whereVal != undefined) ? whereVal : "";
					break;
				
				case "gCal:timezone":
					var theTimeZone:String = String(nextNode.attributes.value);
					break;
				
				case "entry":
					var entryChildNodes:Array = nextNode.childNodes;
					var entryChildNodesLen:Number = entryChildNodes.length;
					while(entryChildNodesLen--)
					{
						var nextEntryChildNode:XMLNode = entryChildNodes[entryChildNodesLen];
						var nextEntryNodeName:String = nextEntryChildNode.nodeName;
						switch(nextEntryNodeName)
						{
							case "id":
								var theEntryID:String = String(nextEntryChildNode.firstChild);
								break;
							
							case "published":
								var theEntryPublished:Date = parseDateTime(String(nextEntryChildNode.firstChild));
								break;
							
							case "updated":
								var theEntryUpdated:Date = parseDateTime(String(nextEntryChildNode.firstChild));
								break;
							
							case "title":
								var theEntryTitle:String = String(nextEntryChildNode.firstChild);
								break;
								
							case "content":
								var theEntryDescription:String = (nextEntryChildNode.firstChild == null) ? nextEntryChildNode.firstChild : "";
								break;
							
							case "author":
								var theEntryAuthor:AuthorVO = parseAuthorNode(nextEntryChildNode);
								break;
								
							case "gCal:sendEventNotifications":
								var theEntrySendEventNotifications:Boolean = parseBoolean(String(nextEntryChildNode.attributes.value));
								break;
							
							case "gd:where":
								var entryWhereVal:String = nextEntryChildNode.attributes.valueString;
								var theEntryWhere:String = (entryWhereVal != undefined) ? entryWhereVal : "";
								break;
							
							case "gd:when":
								var theEntryStartTime:Date = parseDateTime(nextEntryChildNode.attributes.startTime);
								var theEntryEndTime:Date = parseDateTime(nextEntryChildNode.attributes.endTime);
								var reminderMins:Number = parseInt(nextEntryChildNode.firstChild.attributes.minutes);
								var theEntryReminder:Date = DateUtils.clone(theEntryEndTime);
								theEntryReminder.setMinutes(theEntryEndTime.getMinutes() - reminderMins);
								var theEntryWhenVO:WhenVO = new WhenVO(theEntryStartTime,
																	   theEntryEndTime,
																	   theEntryReminder);
								break;
						}
					}
					var entryVO:EntryVO = new EntryVO(theEntryID,
														  theEntryPublished,
														  theEntryUpdated,
														  theEntryTitle,
														  theEntryDescription,
														  theEntryAuthor,
														  theEntrySendEventNotifications,
														  theEntryWhere,
														  theEntryWhenVO,
														  []);
						
					entries_array.push(entryVO);
			}
			
		}
		
		var calendarVO:CalendarVO = new CalendarVO(theID,
													   theUpdatedDate,
													   theTitle,
													   theSubTitle,
													   theAuthor,
													   theWhere,
													   theTimeZone,
													   entries_array);
			
		return calendarVO;
	}
	
	public static function parseAuthorNode(p_xmlNode:XMLNode):AuthorVO
	{
		var authorChildNodes:Array = p_xmlNode.childNodes;
		var aLen:Number = authorChildNodes.length;
		var theAuthor:AuthorVO = new AuthorVO();
		while(aLen--)
		{
			var nextAuthorNode:XMLNode = authorChildNodes[aLen];
			var nextAuthorNodeName:String = nextAuthorNode.nodeName;
			switch(nextAuthorNodeName)
			{
				case "name":
					theAuthor.name = String(nextAuthorNode.firstChild);
					break;
				
				case "email":
					theAuthor.email = String(nextAuthorNode.firstChild);
					break;
			}
		}
		
		return theAuthor;
	}
	
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
			<gd:where valueString="Home"/>
			
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
	
	public static function getEventXMLString(p_entryVO:EntryVO):String
	{
		var xml_str:String = "";
		xml_str += "<entry xmlns='http://www.w3.org/2005/Atom'";
		xml_str += "	xmlns:gd='http://schemas.google.com/g/2005'>";
		xml_str += "<category scheme='http://schemas.google.com/g/2005#kind'";
		xml_str += "	term='http://schemas.google.com/g/2005#event'></category>";
		xml_str += "	<title type='text'>";
		xml_str += p_entryVO.title;
		xml_str += "	</title>";
		xml_str += "	<content type='text'>";
		xml_str += p_entryVO.description;
		xml_str += "	</content>";
		xml_str += "	<author>";
		xml_str += "		<name>";
		xml_str += EntryVO(p_entryVO).authorVO.name;
		xml_str += "		</name>";
		xml_str += "		<email>";
		xml_str += EntryVO(p_entryVO).authorVO.email;
		xml_str += "		</email>";
		xml_str += "	</author>";
		//xml_str += "<gCal:sendEventNotifications value='" + (p_entryVO.sendNotifications == true) ? "true" : "false";
		//xml_str += "' />";
		xml_str += "<gd:transparency";
		xml_str += "	value='http://schemas.google.com/g/2005#event.opaque'>";
		xml_str += "</gd:transparency>";
		xml_str += "<gd:eventStatus";
		xml_str += "	value='http://schemas.google.com/g/2005#event.confirmed'>";
		xml_str += "</gd:eventStatus>";
		xml_str += "<gd:where valueString='" + p_entryVO.where + "'></gd:where>";
		xml_str += "<gd:when startTime='" + getDateTimeString(p_entryVO.whenVO.startTime);
		xml_str += "'";
		xml_str += "	endTime='" + getDateTimeString(p_entryVO.whenVO.endTime);
		xml_str += "'>";
		xml_str += "	<gd:reminder minutes='";
		//xml_str += String(new Date(p_entryVO.whenVO.endTime.getMinutes() - p_entryVO.whenVO.reminder).getMinutes());
		xml_str += "10";
		xml_str += "' />";
		xml_str += "</gd:when>";
		xml_str += "</entry>";
		
		return xml_str;
		
		/*
			<entry xmlns='http://www.w3.org/2005/Atom'
				xmlns:gd='http://schemas.google.com/g/2005'>
				
				<category scheme='http://schemas.google.com/g/2005#kind'
					term='http://schemas.google.com/g/2005#event'></category>
					<title type='text'>Tennis with Beth</title>
					<content type='text'>Meet for a quick lesson.</content>
					<author>
						<name>Jo March</name>
						<email>jo@gmail.com</email>
					</author>
				<gd:transparency
					value='http://schemas.google.com/g/2005#event.opaque'>
				</gd:transparency>
				<gd:eventStatus
					value='http://schemas.google.com/g/2005#event.confirmed'>
				</gd:eventStatus>
				<gd:where valueString='Rolling Lawn Courts'></gd:where>
				<gd:when startTime='2006-04-17T15:00:00.000Z'
					endTime='2006-04-17T17:00:00.000Z'></gd:when>
			</entry>
		*/
	}
	
	public static function parseDateTime(p_dateStr:String):Date
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("p_dateStr: " + p_dateStr);
		// 2006-04-17T17:00:00.000Z
		// Wed May 17 17:00:00 GMT-0400 2006
		var splitDateString:Array = p_dateStr.split("T");
		var dateInfo:String = splitDateString[0];
		var timeInfo:String = splitDateString[1];
		
		var splitDateInfo:Array = dateInfo.split("-");
		var theFullYear:Number = parseInt(splitDateInfo[0]);
		var theMonth:Number = parseInt(splitDateInfo[1]) - 1;
		var theDay:Number = parseInt(splitDateInfo[2]);
		
		var theDate:Date;
		if(splitDateString.length > 1)
		{
			var splitTimeInfo:Array = timeInfo.split(".");
			var hmsPart:Array = splitTimeInfo[0].split(":");
			var theHours:Number = parseInt(hmsPart[0]);
			var theMins:Number = parseInt(hmsPart[1]);
			var theSeconds:Number = parseInt(hmsPart[2]);
			
			theDate = new Date(theFullYear, theMonth, theDay, theHours, theMins, theSeconds);
		}
		else
		{
			theDate = new Date(theFullYear, theMonth, theDay);
		}
		return theDate;
	}
	
	public static function isAllDayEvent(str:String):Boolean
	{
		var splitDateString:Array = str.split("T");
		if(splitDateString.length > 1)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	
	public static function getDateTimeString(p_date:Date):String
	{
		var date_str:String = "";
		date_str += String(p_date.getFullYear());
		date_str += "-";
		date_str += (p_date.getMonth() > 8) ? String(p_date.getMonth() + 1) : "0" + String(p_date.getMonth() + 1);
		date_str += "-";
		date_str += (p_date.getDate() > 9) ? String(p_date.getDate()) : "0" + String(p_date.getDate());
		date_str += "T";
		date_str += (p_date.getHours() > 9) ? String(p_date.getHours()) : "0" + String(p_date.getHours());
		date_str += ":";
		date_str += (p_date.getMinutes() > 9) ? String(p_date.getMinutes()) : "0" + String(p_date.getMinutes());
		date_str += ":";
		date_str += (p_date.getSeconds() > 9) ? String(p_date.getSeconds()) : "0" + String(p_date.getSeconds());
		//date_str += ".000Z";
		date_str += "-05:00";
		return date_str;
	}
	
	public static function getCalendarsFromXML(p_xmlOrString:Object):Array
	{
		var list:Array = [];
		var parsedXML:XML = getParsedXML(p_xmlOrString);
		var feedNode:XMLNode = parsedXML.firstChild;
		var entries:Array = feedNode.childNodes;
		var i:Number = entries.length;
		while(i--)
		{
			var node:XMLNode = entries[i];
			if(node.nodeName == "entry")
			{
				var entryNodes:Array = node.childNodes;
				var entryNodesLen:Number = entryNodes.length;
				//trace("entryNodesLen: " + entryNodesLen);
				while(entryNodesLen--)
				{
					var entryChildNode:XMLNode = entryNodes[entryNodesLen];
					//trace("entryChildNode.nodeName: " + entryChildNode.nodeName);
					if(entryChildNode.nodeName == "title")
					{
						list.push(entryChildNode.firstChild);
						break;
					}
				}
			}
		}
		list.reverse();
		return list;
	}
	
	public static function getCalendarFeedURLFromXML(p_calendarName:String, 
													 p_xmlOrString:Object):String
	{
		var lastAlternateFound:String;
		var parsedXML:XML = getParsedXML(p_xmlOrString);
		var feedNode:XMLNode = parsedXML.firstChild;
		var entries:Array = feedNode.childNodes;
		var i:Number = entries.length;
		while(i--)
		{
			var node:XMLNode = entries[i];
			if(node.nodeName == "entry")
			{
				var entryNodes:Array = node.childNodes;
				var entryNodesLen:Number = entryNodes.length;
				while(entryNodesLen--)
				{
					var entryChildNode:XMLNode = entryNodes[entryNodesLen];
					
					if(entryChildNode.nodeName == "link")
					{
						if(entryChildNode.attributes.rel == "alternate")
						{
							lastAlternateFound = entryChildNode.attributes.href;
						}
					}
					
					if(entryChildNode.nodeName == "title")
					{
						if(entryChildNode.firstChild.toString().toLowerCase() == p_calendarName.toLowerCase())
						{
							// a match!
							return lastAlternateFound;
						}
					}
				}
			}
		}
		return undefined;
	}
	
}