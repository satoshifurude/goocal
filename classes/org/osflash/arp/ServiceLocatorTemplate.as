////////////////////////////////////////////////////////////////////////////////
//
// ARP: The Open Source Pattern-Based RIA Framework for the Flash Platform
//
// ServiceLocatorTempalte - base class for your application's ServiceLocator.
//
// Author: Aral Balkan
// 
// Copyright:
// Copyright © 2004, 2005 Aral Balkan. All Rights Reserved.
// Copyright © 2004, 2005 Ariaware Limited.
// http://ariaware.com
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

class org.osflash.arp.ServiceLocatorTemplate
{
	
	private var serviceRegistry:Object;	// registry of known services
	
	function ServiceLocatorTemplate ()
	{
		serviceRegistry = new Object();
	   	addServices();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Method: getInstance
	//
	// (Primitive operation) Your application's ServiceLocator is a singleton. 
	// It should extend the ServiceLocatorTemplate and you must override the 
	// getInstance primitive operation with your concrete 
	// ServiceLocator class' getInstance singleton accessor method.
	//
	////////////////////////////////////////////////////////////////////////////
	public static function getInstance ()
	{
		throw new Error (
			"ERROR ServiceLocatorTemplate - getInstance primitive operation has not been implemented."
			+ "\nThe Service Locator must be a singleton and provide a concrete implementation of getInstance."
		);
	}

	// Method: getService() (Concrete operation)
	public function getService ( serviceName )
	{
		// Untyped because the Service Locator can handle many different 
		// types of services (eg. mx.remoting.Service for Remoting services
		// that use the Version 2 API.)
		var theService = serviceRegistry [ serviceName ];
		
		return theService;
	}

	// Mehtod: addServices() primitive operation
	private function addServices ()
	{
		//
		// Override this method in your Service Locator and add your services
		// to it using the inherited addService() method.
		//
		throw new Error ( 
			"ERROR ServiceLocatorTemplate - addServices() primitive operation not implemented."
			+ "\nServices not added to Service Locator." 
		);
	}
	
	// Method: addService() concrete method
	private function addService ( serviceName:String, serviceRef:Object )
	{
		// Register the passed service instance reference with the
		// Service Locator, using the name (String) passed in serviceName
		// as the lookup index. 
		serviceRegistry [ serviceName ] = serviceRef;
	}

}	
