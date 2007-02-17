<?php

	require_once("com/philhord/GCalUtils.php");
	require_once("com/jxl/utils/StringUtils.php");
	require_once("com/jxl/goocal/factories/GDataFactory.php");
	require_once("JXLDebug.php");
	
	class Application
	{
		const COMMAND_GET_AUTH						= "get_auth";
		const COMMAND_GET_CALENDAR_NAMES 			= "get_calendars_names";
		const COMMAND_GET_CALENDAR_ENTRIES			= "get_calendar_entries";
		const COMMAND_GET_ENTRY						= "get_entry";
		const COMMAND_CREATE_ENTRY					= "create_entry";
		
		protected $gcalutils;
		protected $strutils;
		
		public function Application()
		{
			$this->gcalutils = new GCalUtils();
			$this->strutils = new StringUtils();
		}
		
		public function runCommand($p_cmd, $params)
		{
			switch($p_cmd)
			{
				case self::COMMAND_GET_AUTH:
					return $this->getAuthCode($params->username, 
											  $params->password);
				
				case self::COMMAND_GET_CALENDAR_NAMES:
					return $this->getCalendars($params->auth,
											   $params->email);
				
				case self::COMMAND_GET_CALENDAR_ENTRIES:
					return $this->getCalendarEntries($params->auth, 
													 $params->email,
											   		 $params->calendarName,
													 $params->startYear,
													 $params->startMonth,
													 $params->startDay,
													 $params->endYear,
													 $params->endMonth,
													 $params->endDay);
				
				case self::COMMAND_GET_ENTRY:
					return $this->getEntry($params->auth,
										   $params->entryURL);
				
				case self::COMMAND_CREATE_ENTRY:
					return $this->createEntry($params->auth,
											  $params->name,
											  $params->email,
											  $params->calendarName,
											  $params->startYear,
											  $params->startMonth,
											  $params->startDay,
											  $params->startHour,
											  $params->startMinute,
											  $params->endYear,
											  $params->endMonth,
											  $params->endDay,
											  $params->endHour,
											  $params->endMinute,
											  $params->title,
											  $params->description,
											  $params->where);
			}
		}
		
		protected function getAuthCode($p_username, $p_password)
		{
			// do a barrel roll!  ...er, I mean, login, and get an auth code
			$theCode = $this->gcalutils->getAuthCode($p_username, $p_password);
			return $theCode;
		}
		
		protected function getCalendars($p_auth, $p_email)
		{
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth);
			
			// get the feed from Google
			$baseFeed = $this->gcalutils->curlToHost('http://www.google.com/calendar/feeds/' . $p_email, 
							 	 		 			 'GET',
								 					 $headers);
			
			$calNames = GDataFactory::getCalendarNames($baseFeed);
			return $calNames;
		}
		
		protected function getCalendarEntries($p_auth, 
												$p_email, 
												$p_calendarName, 
												$p_startYear, 
												$p_startMonth,
												$p_startDay,
												$p_endYear,
												$p_endMonth,
												$p_endDay)
		{
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth);
			
			// get the feed from Google
			$baseFeed 		= $this->gcalutils->curlToHost('http://www.google.com/calendar/feeds/' . $p_email, 
							 	 		 			 'GET',
								 					 $headers);
								  
			$calendarURL 	= GDataFactory::getCalendarFeedURL($baseFeed, $p_calendarName);
			
			$startDate 		= $this->getStartMinDateParameter($p_startYear, $p_startMonth, $p_startDay);
			$endDate		= $this->getStartMaxDateParameter($p_endYear, $p_endMonth, $p_endDay);
			
			$calendarURL  	.= "?" . $startDate . "&" . $endDate;
			
			// get the feed from Google
			$feed = $this->gcalutils->curlToHost($calendarURL, 
												 'GET',
												 $headers);
												 
			$result = GDataFactory::getEntries($feed);
			return $result;
		}
		
		protected function getStartMinDateParameter($p_year, $p_month, $p_day)
		{
			$startDate =  "start-min=";
			$startDate .= $p_year . "-";
			
			if($p_month > 9)
			{
				$startDate .= $p_month . "-";
			}
			else
			{
				$startDate .= "0" . $p_month . "-";
			}
			
			if($p_day > 9)
			{
				$startDate .= $p_day;
			}
			else
			{
				$startDate .= "0" . $p_day;
			}
			
			$startDate .= "T00:00:00";
			return $startDate;
		}
		
		protected function getStartMaxDateParameter($p_year, $p_month, $p_day)
		{
			$startDate =  "start-max=";
			$startDate .= $p_year . "-";
			
			if($p_month > 9)
			{
				$startDate .= $p_month . "-";
			}
			else
			{
				$startDate .= "0" . $p_month . "-";
			}
			
			if($p_day > 9)
			{
				$startDate .= $p_day;
			}
			else
			{
				$startDate .= "0" . $p_day;
			}
			
			$startDate .= "T23:59:59";
			return $startDate;
		}
		
		protected function getEntry($p_auth, $p_entryURL)
		{
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth);
			
			// get the feed from Google
			$entryFeed = $this->gcalutils->curlToHost($p_entryURL, 
													   'GET',
													   $headers);
													   
			$result = GDataFactory::getFullEntry($entryFeed);
			return $result;
		}
		
		protected function createEntry($p_auth,
										$p_name,
										$p_email,
										$p_calendarName,
										$p_startYear,
										$p_startMonth,
										$p_startDay,
										$p_startHour,
										$p_startMinute,
										$p_endYear,
										$p_endMonth,
										$p_endDay,
										$p_endHour,
										$p_endMinute,
										$p_title,
										$p_description,
										$p_where)
		{
			
			$baseHeaders = array('Authorization: GoogleLogin auth=' . $p_auth);
			// get the feed from Google
			$baseFeed 		= $this->gcalutils->curlToHost('http://www.google.com/calendar/feeds/' . $p_email, 
							 	 		 			 'GET',
								 					 $baseHeaders);
								  
			$calendarURL 	= GDataFactory::getCalendarFeedURL($baseFeed, $p_calendarName);
			$calendarURLChunk = substr($calendarURL, 21);
			
			JXLDebug::debugHeader();
			JXLDebug::debug("calendarURL: " . $calendarURL);
			JXLDebug::debug("calendarURLChunk: " . $calendarURLChunk);
			
			// get the GData XML
			$createXML = GDataFactory::getCreateEntryXML($p_title,
														 $p_description,
														 $p_name,
														 $p_email,
														 $p_where,
														 $p_startYear,
														 $p_startMonth,
														 $p_startDay,
														 $p_startHour,
														 $p_startMinute,
														 $p_endYear,
														 $p_endMonth,
														 $p_endDay,
														 $p_endHour,
														 $p_endMinute);
			
			
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth,
							 'Content-Type: application/atom+xml',
							 'X-If-No-Redirect: 1');
			
			/*				 
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth,
							 'Content-Type: application/atom+xml');
			*/
			
			// post to Google
			$addResponse = $this->gcalutils->sendToHost2("www.google.com", 
													   'POST',
													   $calendarURLChunk,
													   $headers,
													   $createXML);
													   
			// this will be a 302 re-direct if good.  Grab the
			// url to redirect to, and parse the calendar
			
			//addResponse: HTTP/1.0 302 Moved Temporarily
			//Location: http://www.google.com/calendar/feeds/default/private/full?gsessionid=2gQlCzXHguc
			
			JXLDebug::debugHeader();
			JXLDebug::debug("createXML: " . $createXML);
			
			JXLDebug::debugHeader();
			JXLDebug::debug("addResponse: " . $addResponse);
			
			if($this->isHTTP412($addResponse) == true)
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("it's a 302");
				$theLocationURL = $this->getHTTPLocation($addResponse);
				//JXLDebug::debugHeader();
				//JXLDebug::debug("Location is: " . $theLocationURL);
			}
			else
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("it's not a 302...");
				return NULL;
			}
			
			
			//http://www.google.com/calendar/feeds/default/private/full?gsessionid=nVdBzNVwH-M
			
			$urlChunk = substr($theLocationURL, 21);
			
			// Now, post again...
			$goodResponse = $this->gcalutils->sendToHost2("www.google.com", 
													   'POST',
													   $urlChunk,
													   $headers,
													   $createXML);				
				
			
			if($this->isHTTP201($goodResponse) == true)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function isHTTP412($str)
		{
			//JXLDebug::debugHeader();
			//JXLDebug::debug("Application::isHTTP412");
			$responseSplit = explode("\n", $str);
			$rLen = count($responseSplit);
			for($r = 0; $r < $rLen; $r++)
			{
				$rStr = $responseSplit[$r];
				//JXLDebug::debug(">>>>>>>>>>>>>>>");
				//JXLDebug::debug("rStr: " . $rStr);
				$pair = explode(":", $rStr);
				$pair[0] = trim($pair[0]);
				$pair[1] = trim($pair[1]);
				
				JXLDebug::debug("pair[0]: " . $pair[0]);
				JXLDebug::debug("pair[1]: " . $pair[1]);
				if($pair[0] == "HTTP/1.0 412 Precondition Failed")
				{
					return true;
				}
			}
			return false;
		}
		
		private function isHTTP201($str)
		{
			//JXLDebug::debugHeader();
			//JXLDebug::debug("Application::isHTTP412");
			$responseSplit = explode("\n", $str);
			$rLen = count($responseSplit);
			for($r = 0; $r < $rLen; $r++)
			{
				$rStr = $responseSplit[$r];
				//JXLDebug::debug(">>>>>>>>>>>>>>>");
				//JXLDebug::debug("rStr: " . $rStr);
				$pair = explode(":", $rStr);
				$pair[0] = trim($pair[0]);
				$pair[1] = trim($pair[1]);
				
				if($pair[0] == "HTTP/1.0 201 Created")
				{
					return true;
				}
			}
			return false;
		}
		
		private function getHTTPLocation($str)
		{
			$responseSplit = explode("\n", $str);
			$rLen = count($responseSplit);
			for($r = 0; $r < $rLen; $r++)
			{
				$rStr = $responseSplit[$r];
			//	JXLDebug::debug(">>>>>>>>>>>>>>>");
			//	JXLDebug::debug("rStr: " . $rStr);
				$pair = explode(": ", $rStr);
				$pair[0] = trim($pair[0]);
				$pair[1] = trim($pair[1]);
				
				if($pair[0] == "X-Redirect-Location")
				{
					return $pair[1] . $pair[2];
				}
			}
			return NULL;
		}
	}

?>