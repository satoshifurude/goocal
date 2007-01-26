////////////////////////////////////////////////////////////////////////////////
//
// ARP: The Open Source Pattern-Based RIA Framework for the Flash Platform
//
// ControllerTemplate - Application Controller base class
//
// Author: Aral Balkan
//
// Copyright Â© 2004 Aral Balkan.
// Copyright Â© 2004 Ariaware Limited
// http://www.ariaware.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

import org.osflash.arp.CommandTemplate;
import org.osflash.arp.controller.ArpEvent;

class org.osflash.arp.CommandRegistryTemplate
{
	
	private var app = null; // reference to the application instance
	private var commands:Object = null; 	// holds named list of commands
	
	private var commandLog:Array = null;	// log of commands
	private var command;
	
	function CommandRegistryTemplate()
	{
		// initialize properties
		commands = new Object();
		commandLog = new Array();
		addCommands();
	}
	
	
	// getInstance() primitive operation
	public static function getInstance ()
	{
		//
		// The class that subclasses ControllerTemplate must be a singleton
		// and must thus override the getInstance method.
		//
		throw new Error (
			"ERROR ControllerTemplate - getInstance primitive operation has not been implemented."
			+ "\nThe Application Controller must be a singleton and provide a concrete implementation of getInstance."
		);
	}


	
	// addCommand() (Concrete)
	private function addCommand ( commandName:String, commandRef:Function)
	{
		//trace("Controller - Command added: " + commandName);
		
		if ( commands [ commandName ] != undefined ) 
		{
			throw new Error ("ERROR The command "+commandName+" has already been added to the Controller.");
		}
		else
		{
			commands [ commandName ] = commandRef;
		}
	}
	
	public function dispatchEvent(event:ArpEvent):Void
	{
		var command:CommandTemplate = CommandTemplate(new commands[event.type]());
		//command = CommandTemplate(new commands[commandName]());
		arguments.shift();
		arguments.shift();
		arguments.shift();
		command.execute(event.target, event.callback, event);
	}
	
	// addCommands() - primitive operation for manual addition of commands
	private function addCommands ()
	{
		//
		// Note: Commands are added as references to the classes. Dispatching 
		// a command includes creating an instance of it, which is then kept
		// in a history log on the controller. The command is automatically 
		// removed after the service has returned (so we don't have a memory leak).
		// This is superior to how a single command was reused in the previous
		// framework and allows a single command to be called from multiple views.
		//
		// The general format should be:
		//
		// addCommand ( "getPersonListCommand", GetPersonListCommand );
		
		throw new Error ( 
			"ERROR ControllerTemplate - addCommands() primitive operation not implemented."
			+ "\nCommands not added to controller" 
		);
	}
}
