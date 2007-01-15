////////////////////////////////////////////////////////////////////////////////
//
// Ariaware RIA Platform (ARP)
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
// File: Animate.as
// Created by: Aral Balkan
//
// Example:
//
// To animate the current movie clip 400px to the right (_x), 200px down (_y)
// and to reduce its alpha by 50% (_alpha):
//
// 		var transitionType:Object = 
// 		{
// 			type: org.osflash.arp.transitions.Animate,
// 			duration: 2,
// 			easing: mx.transitions.easing.Regular.easeInOut,
//			deltaValues: { _x:400, _y:200, _alpha:-50 }
// 		} 
// 	
// 		transition = mx.transitions.TransitionManager.start ( this, transitionType );
//
////////////////////////////////////////////////////////////////////////////////

import mx.transitions.Transition;
import mx.transitions.TransitionManager;

class org.osflash.arp.transitions.Animate extends Transition 
{

	public var type:Object = Animate;
	public var className:String = "Animate";

	// Hashmap of object properties we want to change
	// and the amount we want to change them by.
	private var deltaValues:Object;	
	
	// Hashmap of the initial values of the object 
	private var initialValues:Object; 
	
	// Hashmap of the final values of the object
	private var finalValues:Object;

	function Animate (content:MovieClip, transParams:Object, manager:TransitionManager) 
	{
		init (content, transParams, manager);
	}

	function init (content:MovieClip, transParams:Object, manager:TransitionManager):Void 
	{		
		super.init (content, transParams, manager);

		deltaValues = transParams.deltaValues;
		initialValues = new Object();
		finalValues = new Object();

		// Store the initial starting values of the properties that we want to animate
		// and calculate and store the final values.
		for ( var deltaValueName:String in this.deltaValues )
		{
			var initialValue:Number = content [ deltaValueName ];
			var deltaValue:Number = deltaValues [ deltaValueName ];
			var finalValue:Number = initialValue + deltaValue;
						
			initialValues[ deltaValueName ] = initialValue;
			finalValues [ deltaValueName ] = finalValue;
		}
	}
	
	private function _render (p:Number):Void 
	{		
		// Animate the properties
		for ( var deltaValueName:String in this.deltaValues )
		{
			var initialValue:Number = initialValues [ deltaValueName ];
			var deltaValue:Number = deltaValues [ deltaValueName ];
			var finalValue:Number = finalValues [ deltaValueName ];
		
			content [ deltaValueName ] = finalValue + ( initialValue - finalValue ) * (1-p);
		}
	}

}


