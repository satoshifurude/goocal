<?php

	
	class GDataFactory
	{
	
		public static function getCalendarFeedURL($xmlstr, $calendarName)
		{
			$xml = new SimpleXMLElement($xmlstr);
			
			foreach($xml->children() as $node)
			{
				if($node->getName() == "entry")
				{
					foreach($node->children() as $entryChild)
					{	
						if($entryChild->getName() == "link")
						{
							if($entryChild['rel'] == "alternate")
							{
								if(strtolower((string) $node->title) == strtolower($calendarName))
								{
									$lastAlternateFound = (string) $entryChild['href'];
								}
							}
						}
					}
				}
			}
			
			return $lastAlternateFound;
		}
		
		public static function getCalendarNames($xmlstr)
		{
			$xml = new SimpleXMLElement($xmlstr);
			$calendarNames = "";
			$counter = 0;
			foreach($xml->entry as $entryNode)
			{
				if($counter > 0) $calendarNames .= "&";
				$calendarNames .= "calendar" . $counter . "=" . (string) $entryNode->title;
				$counter++;
			}
			return $calendarNames;
		}
		
		public static function getEntries($xmlstr)
		{
			$xml = new SimpleXMLElement($xmlstr);
			$entries = "";
			$counter = 0;
			
			foreach($xml->entry as $entryNode)
			{
				if($counter > 0) $entries .= "&";
				$entries .= "id" . $counter . "=" . $entryNode->id;
				$entries .= "&title" . $counter . "=" . $entryNode->title;
				
				foreach($entryNode->children('http://schemas.google.com/g/2005') as $entryChildNode)
				{
					if($entryChildNode->getName() == "when")
					{
						foreach($entryChildNode->attributes() as $a => $b)
						{
							if($a == "startTime")
							{
								$entries .= "&startTime" . $counter . "=" . $b;
							}
							else if($a == "endTime")
							{
								$entries .= "&endTime" . $counter . "=" . $b;
							}
						}
						
						foreach($entryChildNode->children('http://schemas.google.com/g/2005') as $reminder)
						{
							foreach($reminder->attributes() as $a => $b)
							{
								$entries .= "&minutes" . $counter . "=" . $b;
							}
						}
					}
				}
				
				$counter++;
			}
			
			$entries .= "&totalEntries=" . $counter;
			
			return $entries;
		}
		
		public static function getFullEntry($p_entryFeed)
		{
			$xml = new SimpleXMLElement($p_entryFeed);
			$entry = "";
			$counter = 0;
			
			$entry .= "id=" . $xml->id;
			$entry .= "&title=" . $xml->title;
			$entry .= "&description=" . $xml->content;
			
			foreach($xml->children('http://schemas.google.com/g/2005') as $where)
			{
				foreach($where->attributes() as $a => $b)
				{
					if($a == "valueString")
					{
						$entry .= "&where=" . $b;
					}
				}
			}
			
			return $entry;
		}
		
		public static function getCreateEntryXML($title,
												  $description,
												  $name,
												  $email,
												  $where,
												  $startYear,
												  $startMonth,
												  $startDay,
												  $startHour,
												  $startMinute,
												  $endYear,
												  $endMonth,
												  $endDay,
												  $endHour,
												  $endMinute)
		{
		
			$xml_str  = "<entry xmlns='http://www.w3.org/2005/Atom'";
			$xml_str .=	" xmlns:gd='http://schemas.google.com/g/2005'>";
			$xml_str .=	"<category scheme='http://schemas.google.com/g/2005#kind'";
			$xml_str .=	" term='http://schemas.google.com/g/2005#event'></category>";
			$xml_str .=	"<title type='text'>" . $title . "</title>";
			$xml_str .=	"<content type='text'>" . $description . "</content>";
			$xml_str .=	"<author>";
			$xml_str .=	"<name>" . $name . "</name>";
			$xml_str .=	"<email>" . $email . "</email>";
			$xml_str .=	"</author>";
			$xml_str .=	"<gd:transparency";
			$xml_str .=	" value='http://schemas.google.com/g/2005#event.opaque'>";
			$xml_str .=	"</gd:transparency>";
			$xml_str .=	"<gd:eventStatus";
			$xml_str .=	" value='http://schemas.google.com/g/2005#event.confirmed'>";
			$xml_str .=	"</gd:eventStatus>";
			$xml_str .=	"<gd:where valueString='" . $where . "'></gd:where>";
			
			$startTime  = "";
			$startTime .= $startYear . "-";
			$startTime .= self::getZeroString($startMonth) . "-";
			$startTime .= self::getZeroString($startDay) . "T";
			$startTime .= self::getZeroString($startHour) . ":";
			$startTime .= self::getZeroString($startMinute) . ":00-05:00";
			
			$xml_str .=	"<gd:when startTime='" . $startTime . "'";
			
			$endTime  = "";
			$endTime .= $endYear . "-";
			$endTime .= self::getZeroString($endMonth) . "-";
			$endTime .= self::getZeroString($endDay) . "T";
			$endTime .= self::getZeroString($endHour) . ":";
			$endTime .= self::getZeroString($endMinute) . ":00-05:00";
			
			$xml_str .=	" endTime='" . $endTime . "'>";
			$xml_str .= "<gd:reminder minutes='10' />";
			$xml_str .= "</gd:when>";
			$xml_str .=	"</entry>";
			
			return $xml_str;
		}
		
		public static function getZeroString($num)
		{
			if($num > 9)
			{
				return "" . $num;
			}
			else
			{
				return "0" . $num;
			}
		}
	}

?>