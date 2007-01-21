<?php

	set_include_path("/home/9936/domains/jessewarden.com/html/goocal/php/");
	
	require_once("com/jxl/goocal/controller/FrontController.php");
	
	if(isset($HTTP_POST_VARS['cmd']))
	{
		$fc = new FrontController();
		$params = new stdClass();
		
		switch($HTTP_POST_VARS['cmd'])
		{
			case FrontController::COMMAND_GET_AUTH:
				$params->username = $HTTP_POST_VARS['username'];
				$params->password = $HTTP_POST_VARS['password'];
				$auth = $fc->runCommand(FrontController::COMMAND_GET_AUTH, $params);
				echo($auth);
				break;
				
			case FrontController::COMMAND_GET_CALENDAR_NAMES:
				$params->auth = $HTTP_POST_VARS['auth'];
				$params->email = $HTTP_POST_VARS['email'];
				$names = $fc->runCommand(FrontController::COMMAND_GET_CALENDAR_NAMES, $params);
				echo($names);
				break;
			
			case FrontController::COMMAND_GET_CALENDAR_ENTRIES:
				$params->auth 				= $HTTP_POST_VARS['auth'];
				$params->email 				= $HTTP_POST_VARS['email'];
				$params->calendarName 		= $HTTP_POST_VARS['calendarName'];
				$params->startYear 			= $HTTP_POST_VARS['startYear'];
				$params->startMonth 		= $HTTP_POST_VARS['startMonth'];
				$params->startDay 			= $HTTP_POST_VARS['startDay'];
				$params->endYear 			= $HTTP_POST_VARS['endYear'];
				$params->endMonth 			= $HTTP_POST_VARS['endMonth'];
				$params->endDay 			= $HTTP_POST_VARS['endDay'];
				$entries = $fc->runCommand(FrontController::COMMAND_GET_CALENDAR_ENTRIES, $params);
				echo($entries);
				return;
				
			case FrontController::COMMAND_GET_ENTRY:
				$params->auth				= $HTTP_POST_VARS['auth'];
				$params->entryURL			= $HTTP_POST_VARS['entryURL'];
				$entry = $fc->runCommand(FrontController::COMMAND_GET_ENTRY, $params);
				echo($entry);
				return;
			
			default:
				echo("ERROR: unknown command");
				break;
		}
	}
?>