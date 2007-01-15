<?php

	require_once("com/philhord/GCalUtils.php");
	require_once("com/jxl/utils/StringUtils.php");
	require_once("com/jxl/goocal/factories/GDataFactory.php");
	require_once("JXLDebug.php");
	
	class FrontController
	{
		const COMMAND_GET_AUTH						= "get_auth";
		const COMMAND_GET_CALENDAR_NAMES 			= "get_calendars_names";
		const COMMAND_GET_CALENDAR_ENTRIES			= "get_calendar_entries";
		const COMMAND_GET_ENTRY						= "get_entry";
		
		protected $gcalutils;
		protected $strutils;
		
		public function FrontController()
		{
			$this->gcalutils = new GCalUtils();
			$this->strutils = new StringUtils();
		}
		
		public function runCommand($p_cmd, $params)
		{
			//JXLDebug::debugHeader();
			//JXLDebug::debug("FrontController::runCommand");
			//JXLDebug::debug("p_cmd: " . $p_cmd);
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
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("startDate: $startDate");
			//JXLDebug::debug("endDate: $endDate");
			
			$calendarURL  	.= "?" . $startDate . "&" . $endDate;
			
			//JXLDebug::debug("calendarURL: $calendarURL");
			
			// get the feed from Google
			$feed = $this->gcalutils->curlToHost($calendarURL, 
												 'GET',
												 $headers);
			
			//JXLDebug::debugHeader();
			//JXLDebug::debug("FrontController::getCalendarEntries");
			//JXLDebug::debug("calendarURL: " . $calendarURL);
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
													   
			$result = GDataFactory::getFullEntry($feed);
			return $result;
		}
	}

?>