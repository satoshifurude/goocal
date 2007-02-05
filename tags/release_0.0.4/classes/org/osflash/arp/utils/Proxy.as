////////////////////////////////////////////////////////////////////////////////
//
// ARP: The Open Source Pattern-Based RIA Framework for the Flash Platform
//
// Copyright  2004 Aral Balkan.
// Copyright  2004 Ariaware Limited
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
// Project: ARP
// File: Proxy.as
// Created by: Joey Lott. Added to ARP by Aral Balkan
//
// This is Joey Lott's Proxy class as released at:
// http://www.person13.com/articles/proxy/Proxy.htm. 
//
// It's very simple and useful and I've added it to the utils folder in ARP.
// When Joey's framework is released, we might just use the class in there instead
// (unless it requires other classes from the framework to be loaded in.)
//
////////////////////////////////////////////////////////////////////////////////
class org.osflash.arp.utils.Proxy 
{

  public static function create(oTarget:Object, fFunction:Function):Function {

	// Create an array of the extra parameters passed to the method. Loop 
    // through every element of the arguments array starting with index 2, 
    // and add the element to the aParameters array.

    var aParameters:Array = new Array();

    for(var i:Number = 2; i < arguments.length; i++) 
    {
      aParameters[i - 2] = arguments[i];
    }

    // Create a new function that will be the proxy function.
    var fProxy:Function = function():Void 
    {
      // The actual parameters to pass along to the method called by proxy 
      // should be a concatenation of the arguments array of this function 
      // and the aParameters array.
      var aActualParameters:Array = arguments.concat(aParameters);

      // When the proxy function is called, use the apply( ) method to call 
      // the method that is supposed to get called by proxy. The apply( ) 
      // method allows you to specify a different scope (oTarget) and pass 
      // the parameters as an array.
      fFunction.apply(oTarget, aActualParameters);
    };

    // Return the proxy function.
    return fProxy;

  }
}
