<?php

	set_include_path("/home/9936/domains/jessewarden.com/html/goocal/php/");
	
	require_once("com/philhord/GCalUtils.php");
	require_once("com/jxl/utils/StringUtils.php");
	require_once("com/jxl/goocal/factories/GDataFactory.php");
	//require_once("JXLDebug.php");
	
	class Application
	{
		const COMMAND_GET_AUTH						= "get_auth";
		const COMMAND_GET_CALENDAR_NAMES 			= "get_calendars_names";
		const COMMAND_GET_CALENDAR_ENTRIES			= "get_calendar_entries";
		const COMMAND_GET_ENTRY						= "get_entry";
		const COMMAND_CREATE_ENTRY					= "create_entry";
		//const COMMAND_EDIT_ENTRY					= "edit_entry";
		//const COMMAND_DELETE_ENTRY					= "delete_entry";
		const COMMAND_CHECK_VERSION					= "check_version";
		
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
													 $params->endDay,
													 $params->timeZoneOffset);
				
				case self::COMMAND_GET_ENTRY:
					return $this->getEntry($params->auth,
										   $params->entryURL);
				
				case self::COMMAND_CREATE_ENTRY:
					return $this->modifyEntry(self::COMMAND_CREATE_ENTRY,
											  $params->auth,
											  $params->name,
											  $params->email,
											  NULL,
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
											  $params->where,
											  $params->timeZoneOffset);
				/*					  
				case self::COMMAND_EDIT_ENTRY:
					return $this->modifyEntry(self::COMMAND_EDIT_ENTRY,
											  $params->auth,
											  $params->name,
											  $params->email,
											  $params->id,
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
											  $params->where,
											  $params->timeZoneOffset);
				
				case self::COMMAND_DELETE_ENTRY:
					return $this->deleteEntry($params->auth, $params->id);
				*/
				
				case self::COMMAND_CHECK_VERSION:
					return $this->checkVersion($params->currentVersion);
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
			
			//$l->log("baseFeed: " . $baseFeed);
			
			$calNames = GDataFactory::getCalendarNames($baseFeed);
			//$l->log("calNames: " . $calNames);
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
												$p_endDay,
												$p_timeZoneOffset)
		{
			//JXLDebug::debugHeader();
			//JXLDebug::debug("Application::getCalendarEntries");
			//JXLDebug::debug("p_auth: " . $p_auth);
			//JXLDebug::debug("p_email: " . $p_email);
			//JXLDebug::debug("p_calendarName: " . $p_calendarName);
			//JXLDebug::debug("p_startYear: " . $p_startYear);
			//JXLDebug::debug("p_startMonth: " . $p_startMonth);
			//JXLDebug::debug("p_startDay: " . $p_startDay);
			//JXLDebug::debug("p_endYear: " . $p_endYear);
			//JXLDebug::debug("p_endMonth: " . $p_endMonth);
			//JXLDebug::debug("p_endDay: " . $p_endDay);
			//JXLDebug::debug("p_timeZoneOffset: " . $p_timeZoneOffset);
			
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth);
			
			// get the feed from Google
			$baseFeed 		= $this->gcalutils->curlToHost('http://www.google.com/calendar/feeds/' . $p_email, 
							 	 		 			 'GET',
								 					 $headers);
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("baseFeed: " . $baseFeed);
								  
			$calendarURL 	= GDataFactory::getCalendarFeedURL($baseFeed, $p_calendarName);
			
			$startDate 		= $this->getStartMinDateParameter($p_startYear, $p_startMonth, $p_startDay);
			$endDate		= $this->getStartMaxDateParameter($p_endYear, $p_endMonth, $p_endDay);
			
		
			$timeOffset = GDataFactory::getTimezoneOffsetString($p_timeZoneOffset);	
			$startDate .= $timeOffset;
			$endDate .= $timeOffset;
			
			$calendarURL  	.= "?" . $startDate . "&" . $endDate;
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("p_startDay: " . $p_startDay);
			//JXLDebug::debug("startDate: " . $startDate);
			//JXLDebug::debug("endDate: " . $endDate);
			//JXLDebug::debug("timeOffset: " . $timeOffset);
			//JXLDebug::debug("calendarURL: " . $calendarURL);
			
			// get the feed from Google
			$feed = $this->gcalutils->curlToHost($calendarURL, 
												 'GET',
												 $headers);
												 
			//JXLDebug::debugHeader();
			//JXLDebug::debug("feed: " . $feed);
												 
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
													   
			//JXLDebug::debugHeader();
			//JXLDebug::debug("entryFeed: " . htmlentities($entryFeed));
													   
			$result = GDataFactory::getFullEntry($entryFeed);
			return $result;
		}
		
		// Note: modes = CREATE, UPDATE, DELETE
		// we'll reuse the constants defined up top
		protected function modifyEntry($p_mode,
										$p_auth,
										$p_name,
										$p_email,
										$p_id,
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
										$p_where,
										$p_timeZoneOffset)
		{
			/*
			JXLDebug::debugHeader();
			JXLDebug::debug("Application::modifyEntry");
			JXLDebug::debug("p_mode: " . $p_mode);
			JXLDebug::debug("p_auth: " . $p_auth);
			JXLDebug::debug("p_email: " . $p_email);
			JXLDebug::debug("p_id: " . $p_id);
			JXLDebug::debug("p_calendarName: " . $p_calendarName);
			JXLDebug::debug("p_startYear: " . $p_startYear);
			JXLDebug::debug("p_startMonth: " . $p_startMonth);
			JXLDebug::debug("p_startDay: " . $p_startDay);
			JXLDebug::debug("p_startHour: " . $p_startHour);
			JXLDebug::debug("p_startMinute: " . $p_startMinute);
			JXLDebug::debug("p_endYear: " . $p_endYear);
			JXLDebug::debug("p_endMonth: " . $p_endMonth);
			JXLDebug::debug("p_endDay: " . $p_endDay);
			JXLDebug::debug("p_endHour: " . $p_endHour);
			JXLDebug::debug("p_endMinute: " . $p_endMinute);
			JXLDebug::debug("p_title: " . $p_title);
			JXLDebug::debug("p_description: " . $p_description);
			JXLDebug::debug("p_where: " . $p_where);
			JXLDebug::debug("p_timeZoneOffset: " . $p_timeZoneOffset);
			*/
		
		
			$baseHeaders = array('Authorization: GoogleLogin auth=' . $p_auth);
			
			// get the feed from Google
			$baseFeed 		= $this->gcalutils->curlToHost('http://www.google.com/calendar/feeds/' . $p_email, 
							 	 		 			 'GET',
								 					 $baseHeaders);
								  
			$calendarURL 	= GDataFactory::getCalendarFeedURL($baseFeed, $p_calendarName);
			$calendarURLChunk = substr($calendarURL, 21);
			
			
			$theID = NULL;
			$theMode = NULL;
			/*	
			if($p_mode == self::COMMAND_CREATE_ENTRY)
			{
				$theID = NULL;
				$theMode = NULL;
			}
			else if($p_mode == self::COMMAND_EDIT_ENTRY)
			{
				$theID = $p_id;
				$theMode = "edit";
			}
			else if($p_mode == self::COMMAND_DELETE_ENTRY)
			{
				$theID = $p_id;
				$theMode = "delete";
			}
			*/
			
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("theID: " . $theID);
			//JXLDebug::debug("theMode: " . $theMode);
			
			// get the GData XML
			$createXML = GDataFactory::getCreateEntryXML($theMode,
														 $theID,
														 $p_title,
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
														 $p_endMinute,
														 $p_timeZoneOffset);
															
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth,
							 'Content-Type: application/atom+xml',
							 'X-If-No-Redirect: 1');
			
			/*
			if($p_mode == self::COMMAND_EDIT_ENTRY)
			{
				array_push($headers, 'X-HTTP-Method-Override: PUT');
			}
			else if($p_mode == self::COMMAND_DELETE_ENTRY)
			{
				array_push($headers, 'X-HTTP-Method-Override: DELETE');
			}
			*/
			
			$addResponse = $this->gcalutils->sendToHost2("www.google.com", 
													   'POST',
													   $calendarURLChunk,
													   $headers,
													   $createXML);
			/*
			if($p_mode == self::COMMAND_CREATE_ENTRY)
			{
				$addResponse = $this->gcalutils->sendToHost2("www.google.com", 
													   'POST',
													   $calendarURLChunk,
													   $headers,
													   $createXML);
			}
			else if($p_mode == self::COMMAND_EDIT_ENTRY)
			{
				$addResponse = $this->gcalutils->sendToHost2("www.google.com", 
													   'PUT',
													   $calendarURLChunk,
													   $headers,
													   $createXML);
			}
			else if($p_mode == self::COMMAND_DELETE_ENTRY)
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("p_id: " . $p_id);
				$addResponse = $this->gcalutils->sendToHost2("www.google.com", 
															   'POST',
															   $calendarURLChunk,
															   $headers,
															   $createXML);
			}
			*/
			
			
													   
			// this will be a 302 re-direct if good.  Grab the
			// url to redirect to, and parse the calendar
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("calendarURLChunk: " . $calendarURLChunk);
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("createXML: " . htmlentities($createXML));
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("addResponse: " . $addResponse);
			
			if($this->isHTTP412($addResponse) == true)
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("is 412");
				$theLocationURL = $this->getHTTPLocation($addResponse);
			}
			else
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("ERROR: Not a pre-condition failed.");
				return "ERROR: Not a pre-condition failed.";
			}
			
			$urlChunk = substr($theLocationURL, 21);
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("urlChunk: " . $urlChunk);
			
			// Now, post again...
			$goodResponse = $this->gcalutils->sendToHost2("www.google.com", 
													   'POST',
													   $urlChunk,
													   $headers,
													   $createXML);				
				
			
			if($this->isHTTP201($goodResponse) == true)
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("it's a 201");
				return true;
			}
			else
			{
				//JXLDebug::debugHeader();
				//JXLDebug::debug("ERROR: Not a 201.  Response: " . $goodResponse . "  createXML: " . $createXML);
				return "ERROR: Not a 201.  Response: " . $goodResponse . "  createXML: " . $createXML;
			}
		}
		/*
		protected function deleteEntry($p_auth, $p_idURL)
		{
			$headers = array('Authorization: GoogleLogin auth=' . $p_auth,
							 'Content-Type: application/atom+xml',
							 'X-If-No-Redirect: 1',
							 'X-HTTP-Method-Override: DELETE');
			
			$deleteResponse = $this->gcalutils->curlToHost($p_idURL, "DELETE", $headers);
															   
			JXLDebug::debugHeader();
			JXLDebug::debug("deleteResponse: " . htmlentities($deleteResponse));
		}
		*/
		private function isHTTP412($str)
		{
			//$l = new LogUtils("test_log.txt");
			//$l->log("------------");
			//$l->log("Application::isHTTP412");
			//JXLDebug::debugHeader();
			//JXLDebug::debug("Application::isHTTP412");
			$responseSplit = explode("\n", $str);
			$rLen = count($responseSplit);
			for($r = 0; $r < $rLen; $r++)
			{
				$rStr = $responseSplit[$r];
				//JXLDebug::debug(">>>>>>>>>>>>>>>");
				//JXLDebug::debug("rStr: " . $rStr);
				//$l->log(">>>>>>>>>>>>>>>");
				//$l->log("rStr: " . $rStr);
				$pair = explode(":", $rStr);
				$pair[0] = trim($pair[0]);
				$pair[1] = trim($pair[1]);
				
				//JXLDebug::debug("pair[0]: " . $pair[0]);
				//JXLDebug::debug("pair[1]: " . $pair[1]);
				//$l->log("pair[0]: " . $pair[0]);
				//$l->log("pair[1]: " . $pair[1]);
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
			//JXLDebug::debug("Application::isHTTP201");
			//$l = new LogUtils("test_log.txt");
			//$l->log("------------");
			//$l->log("Application::isHTTP201");
			$responseSplit = explode("\n", $str);
			$rLen = count($responseSplit);
			for($r = 0; $r < $rLen; $r++)
			{
				$rStr = $responseSplit[$r];
				//JXLDebug::debug(">>>>>>>>>>>>>>>");
				//JXLDebug::debug("rStr: " . $rStr);
				
				//$l->log(">>>>>>>>>>>>>>>");
				//$l->log("rStr: " . $rStr);
				
				$pair = explode(":", $rStr);
				$pair[0] = trim($pair[0]);
				$pair[1] = trim($pair[1]);
				
				//$l->log("pair[0]: " . $pair[0]);
				//$l->log("pair[1]: " . $pair[1]);
				
				if($pair[0] == "HTTP/1.0 201 Created")
				{
					return true;
				}
			}
			return false;
		}
		
		private function getHTTPLocation($str)
		{
			//$l = new LogUtils("test_log.txt");
			//$l->log("------------");
			//$l->log("Application::getHTTPLocation");
			//$l->log("str: " . $str);
			
			$responseSplit = explode("\n", $str);
			$rLen = count($responseSplit);
			for($r = 0; $r < $rLen; $r++)
			{
				$rStr = $responseSplit[$r];
			//	JXLDebug::debug(">>>>>>>>>>>>>>>");
			//	JXLDebug::debug("rStr: " . $rStr);
				//$l->log(">>>>>>>>>>>>>>>");
				//$l->log("rStr: " . $rStr);
				
				$pair = explode(": ", $rStr);
				$pair[0] = trim($pair[0]);
				$pair[1] = trim($pair[1]);
				
				//$l->log("pair[0]: " . $pair[0]);
				//$l->log("pair[1]: " . $pair[1]);
				
				if($pair[0] == "X-Redirect-Location")
				{
					return $pair[1] . $pair[2];
				}
			}
			return NULL;
		}
		
		protected function checkVersion($currentVersion)
		{
			$major = 1;
			$minor = 0;
			$build = 0;
			
			$arr = explode(".", $currentVersion);
			$clientMajor = $arr[0];
			$clientMinor = $arr[1];
			$clientBuild = $arr[2];
			
			if($major > $clientMajor)
			{
				return true;
			}
			else if($major == $clientMajor)
			{
				if($minor > $clientMinor)
				{
					return true;
				}
				else if($build == $clientBuild)
				{
					if($build > $clientBuild)
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}

?>