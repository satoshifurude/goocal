
import org.osflash.arp.CommandRegistryTemplate;

import com.jxl.goocal.events.LoginEvent;
import com.jxl.goocal.commands.LoginCommand;

import com.jxl.goocal.events.GetCalendarsEvent;
import com.jxl.goocal.commands.GetCalendarsCommand;

import com.jxl.goocal.events.SelectCalendarEvent;
import com.jxl.goocal.commands.SelectCalendarCommand;

import com.jxl.goocal.events.GetCalendarEventsEvent;
import com.jxl.goocal.commands.GetCalendarEventsCommand;

class com.jxl.goocal.controller.CommandRegistry extends CommandRegistryTemplate
{
	private static var inst:CommandRegistry; 	// instance of self
	
	public static function getInstance()
	{
		if (inst == null) inst = new CommandRegistry();
		return inst;
	}	
	
	private function addCommands()
	{
		addCommand(LoginEvent.LOGIN, 						LoginCommand);
		addCommand(GetCalendarsEvent.GET_CALENDARS, 		GetCalendarsCommand);
		addCommand(SelectCalendarEvent.SELECT, 				SelectCalendarCommand);
		addCommand(GetCalendarEventsEvent.GET_EVENTS,		GetCalendarEventsCommand);
	}
}
