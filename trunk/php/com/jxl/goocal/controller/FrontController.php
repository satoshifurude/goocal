<?php

	set_include_path("/home/9936/domains/jessewarden.com/html/goocal/php/");
	
	require_once("com/jxl/goocal/controller/Application.php");
	
	if(isset($HTTP_POST_VARS['cmd']))
	{
		$fc = new Application();
		$params = new stdClass();
		
		switch($HTTP_POST_VARS['cmd'])
		{
			case Application::COMMAND_GET_AUTH:
				$params->username = $HTTP_POST_VARS['username'];
				$params->password = $HTTP_POST_VARS['password'];
				$auth = $fc->runCommand(Application::COMMAND_GET_AUTH, $params);
				echo($auth);
				break;
				
			case Application::COMMAND_GET_CALENDAR_NAMES:
				$params->auth = $HTTP_POST_VARS['auth'];
				$params->email = $HTTP_POST_VARS['email'];
				$names = $fc->runCommand(Application::COMMAND_GET_CALENDAR_NAMES, $params);
				echo($names);
				break;
			
			case Application::COMMAND_GET_CALENDAR_ENTRIES:
				$params->auth 				= $HTTP_POST_VARS['auth'];
				$params->email 				= $HTTP_POST_VARS['email'];
				$params->calendarName 		= $HTTP_POST_VARS['calendarName'];
				$params->startYear 			= $HTTP_POST_VARS['startYear'];
				$params->startMonth 		= $HTTP_POST_VARS['startMonth'];
				$params->startDay 			= $HTTP_POST_VARS['startDay'];
				$params->endYear 			= $HTTP_POST_VARS['endYear'];
				$params->endMonth 			= $HTTP_POST_VARS['endMonth'];
				$params->endDay 			= $HTTP_POST_VARS['endDay'];
				$params->timeZoneOffset		= $HTTP_POST_VARS['tzo'];
				$entries = $fc->runCommand(Application::COMMAND_GET_CALENDAR_ENTRIES, $params);
				echo($entries);
				return;
				
			case Application::COMMAND_GET_ENTRY:
				$params->auth				= $HTTP_POST_VARS['auth'];
				$params->entryURL			= $HTTP_POST_VARS['entryURL'];
				$entry = $fc->runCommand(Application::COMMAND_GET_ENTRY, $params);
				echo($entry);
				return;
			
			case Application::COMMAND_CREATE_ENTRY:
				$params->auth				= $HTTP_POST_VARS['auth'];
				$params->name				= $HTTP_POST_VARS['name'];
				$params->email				= $HTTP_POST_VARS['email'];
				$params->calendarName		= $HTTP_POST_VARS['calendarName'];
				$params->startYear			= $HTTP_POST_VARS['startYear'];
				$params->startMonth			= $HTTP_POST_VARS['startMonth'];
				$params->startDay			= $HTTP_POST_VARS['startDay'];
				$params->startHour			= $HTTP_POST_VARS['startHour'];
				$params->startMinute		= $HTTP_POST_VARS['startMinute'];
				$params->endYear			= $HTTP_POST_VARS['endYear'];
				$params->endMonth			= $HTTP_POST_VARS['endMonth'];
				$params->endDay				= $HTTP_POST_VARS['endDay'];
				$params->endHour			= $HTTP_POST_VARS['endHour'];
				$params->endMinute			= $HTTP_POST_VARS['endMinute'];
				$params->title				= $HTTP_POST_VARS['title'];
				$params->description		= $HTTP_POST_VARS['description'];
				$params->where				= $HTTP_POST_VARS['where'];
				$params->timeZoneOffset		= $HTTP_POST_VARS['tzo'];
				
				$success = $fc->runCommand(Application::COMMAND_CREATE_ENTRY, $params);
				echo($success);
				return;
				
			case Application::COMMAND_EDIT_ENTRY:
				$params->auth				= $HTTP_POST_VARS['auth'];
				$params->name				= $HTTP_POST_VARS['name'];
				$params->email				= $HTTP_POST_VARS['email'];
				$params->id					= $HTTP_POST_VARS['id'];
				$params->calendarName		= $HTTP_POST_VARS['calendarName'];
				$params->startYear			= $HTTP_POST_VARS['startYear'];
				$params->startMonth			= $HTTP_POST_VARS['startMonth'];
				$params->startDay			= $HTTP_POST_VARS['startDay'];
				$params->startHour			= $HTTP_POST_VARS['startHour'];
				$params->startMinute		= $HTTP_POST_VARS['startMinute'];
				$params->endYear			= $HTTP_POST_VARS['endYear'];
				$params->endMonth			= $HTTP_POST_VARS['endMonth'];
				$params->endDay				= $HTTP_POST_VARS['endDay'];
				$params->endHour			= $HTTP_POST_VARS['endHour'];
				$params->endMinute			= $HTTP_POST_VARS['endMinute'];
				$params->title				= $HTTP_POST_VARS['title'];
				$params->description		= $HTTP_POST_VARS['description'];
				$params->where				= $HTTP_POST_VARS['where'];
				$params->timeZoneOffset		= $HTTP_POST_VARS['tzo'];
				
				$success = $fc->runCommand(Application::COMMAND_EDIT_ENTRY, $params);
				echo($success);
				return;
			
			case Application::COMMAND_DELETE_ENTRY:
				$params->auth				= $HTTP_POST_VARS['auth'];
				$params->name				= $HTTP_POST_VARS['name'];
				$params->email				= $HTTP_POST_VARS['email'];
				$params->id					= $HTTP_POST_VARS['id'];
				$params->calendarName		= $HTTP_POST_VARS['calendarName'];
				$params->startYear			= $HTTP_POST_VARS['startYear'];
				$params->startMonth			= $HTTP_POST_VARS['startMonth'];
				$params->startDay			= $HTTP_POST_VARS['startDay'];
				$params->startHour			= $HTTP_POST_VARS['startHour'];
				$params->startMinute		= $HTTP_POST_VARS['startMinute'];
				$params->endYear			= $HTTP_POST_VARS['endYear'];
				$params->endMonth			= $HTTP_POST_VARS['endMonth'];
				$params->endDay				= $HTTP_POST_VARS['endDay'];
				$params->endHour			= $HTTP_POST_VARS['endHour'];
				$params->endMinute			= $HTTP_POST_VARS['endMinute'];
				$params->title				= $HTTP_POST_VARS['title'];
				$params->description		= $HTTP_POST_VARS['description'];
				$params->where				= $HTTP_POST_VARS['where'];
				$params->timeZoneOffset		= $HTTP_POST_VARS['tzo'];
				$success = $fc->runCommand(Application::COMMAND_DELETE_ENTRY, $params);
				echo($success);
				return;
			
			case Application::COMMAND_CHECK_VERSION:
				$params->currentVersion		= $HTTP_POST_VARS['currentVersion'];
				$needToUpdate = $fc->runCommand(Application::COMMAND_CHECK_VERSION, $params);
				if($needToUpdate == true)
				{
					echo("needUpdate=true&newVersion=1.0.0&updateURL=http://www.jessewarden.com/");
				}
				else
				{
					echo("needUpdate=false");
				}
				return;
				
				
			
			default:
				echo("ERROR: unknown command");
				break;
		}
	}
?>