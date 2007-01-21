<?php

	require_once('JSON.php');
	require_once('com/jxl/goocal/vo/EntryVO.php');
	require_once('com/jxl/goocal/vo/WhenVO.php');
	require_once('com/jxl/goocal/vo/AuthorVO.php');
	
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
	}

?>