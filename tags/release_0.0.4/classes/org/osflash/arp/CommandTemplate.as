////////////////////////////////////////////////////////////////////////////////
//
// ARP: The Open Source Pattern-Based RIA Framework for the Flash Platform
//
// CommandTemplate: Base command class template. All this base class does
// is save a reference to the viewRef when its execute() method is called
// and then calls the executeOperation() primitive operation as a hook. The
// functionality provided by the CommandTemplate class is limited and you
// may just want to create your own Command classes without extending it.
//
// Author: Aral Balkan
//
// Copyright © 2004 Aral Balkan.
// Copyright © 2004 Ariaware Limited
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

import org.osflash.arp.core.ICommand;
import org.osflash.arp.controller.ArpEvent;

class org.osflash.arp.CommandTemplate implements ICommand
{
	var viewRef;
	var resultFunction;
	
	function CommandTemplate()
	{
	}
	
	public function executeOperation():Void
	{
		throw new Error ("ERROR Command did not implement primitive operation executeOperation(). No behavior defined for command.");
	}

	public function execute(viewRef, resultFunction:Function, event:ArpEvent)
	{
		this.viewRef = viewRef;
		this.resultFunction = resultFunction;
		executeOperation.call(this, event);
	}
	
	// does same as fault; here for naming convetion; fault is more clear than calling
	// result for the same thing
	private function result(p_callback:Object):Void
	{
		resultFunction.call(viewRef, p_callback);
	}
	
	private function fault(p_callback:Object):Void
	{
		resultFunction.call(viewRef, p_callback);
	}

}
