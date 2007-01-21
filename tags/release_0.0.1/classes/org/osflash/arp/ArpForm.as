////////////////////////////////////////////////////////////////////////////////
//
// ARP: The Open Source Pattern-Based RIA Framework for the Flash Platform
//
// ARPForm - a lightweight form class with event dispatching.
//
// Author: Aral Balkan
// 
// Copyright:
// Copyright © 2004, 2005 Aral Balkan. All Rights Reserved.
// Copyright © 2004, 2005 Ariaware Limited.
// http://ariaware.com
//
// Released under the open-source MIT license.  
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

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

import mx.events.EventDispatcher;

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: ArpForm
//
// The base class that all forms should be based on. Provides simple event
// dispatching capabilities as well as methods for hiding or showing the form.
//
//
////////////////////////////////////////////////////////////////////////////////
class org.osflash.arp.ArpForm extends MovieClip
{
	//
	// Properties
	//
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Constructor
	//
	////////////////////////////////////////////////////////////////////////////
	public function ArpForm()
	{
		EventDispatcher.initialize(this);
	}


	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Public methods
	//
	////////////////////////////////////////////////////////////////////////////
	
	//
	// Note: The show() and hide() methods have been depracated as of ARP version 2.1
	// 
	public function show()
	{
		_visible = true;		
	}
	
	public function hide() 
	{
		_visible = false;
	}
	
	//
	// Note: Added for Flash MX 2004 and Flex compatibility. These implicit accessors are
	// synonymous with the show() and hide() methods and should be preferred
	// for any new development with ArpForms for easier migration to Flash MX 2004 Forms
	// and Macromedia Flex. 
	//
	public function get visible ()
	{
		return _visible;
	}
	
	public function set visible ( state:Boolean )
	{
		_visible = state;
	}
	
	//
	// Note: Methods to be mixed in by the EventDispatcher
	//
	function addEventListener(){};
	function removeEventListener(){};
	function dispatchEvent(){};
}
