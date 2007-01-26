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
// File: AnimateMultiple.as
// Created by: Aral Balkan
//
// Example:
//
// To animate multiple movie clips:
//
// 		var transitionType:Object = 
// 		{
// 			type: org.osflash.arp.transitions.AnimateMultiple,
// 			duration: 2,
// 			easing: mx.transitions.easing.Regular.easeInOut,
//			animations:
//				[
// 					{
// 						target: someClip,
// 						deltaValues: { _x:400, _y:200, _alpha:-50 }
// 					},
// 					{
// 						target: someOtherClip,
// 						deltaValues: { _rotation: 200 }
// 					}
// 				]
// 		} 
// 	
// 		transition = mx.transitions.TransitionManager.start ( this, transitionType );
//
////////////////////////////////////////////////////////////////////////////////

import mx.transitions.Transition;
import mx.transitions.TransitionManager;

class org.osflash.arp.transitions.AnimateMultiple extends Transition 
{

	public var type:Object = AnimateMultiple;
	public var className:String = "AnimateMultiple";

	// Hashmap of animation objects. Structure/example:
	// 
	// { 
	// 		target: myMovieClipOrObject,
	// 		deltaValues: { _x: dX, _y: dY, ... }
	// }
	//
	private var animations:Object;	
	
	function AnimateMultiple (content:MovieClip, transParams:Object, manager:TransitionManager) 
	{
		init (content, transParams, manager);
	}

	function init (content:MovieClip, transParams:Object, manager:TransitionManager):Void 
	{		
		super.init (content, transParams, manager);

		// Save the animations object
		animations = transParams.animations;
	
		// Store the initial starting values of the properties that we want to animate
		// and calculate and store the final values.
		for ( var i:Number = 0; i < animations.length; i++ )
		{
			var currentAnimation:Object = animations [ i ];
			
			var target:Object = currentAnimation.target;
			var deltaValues:Object = currentAnimation.deltaValues;
			
			currentAnimation.initialValues = new Object();
			currentAnimation.finalValues = new Object();
			
			for ( var deltaValueName:String in deltaValues )
			{
				var initialValue:Number = target [ deltaValueName ];
				var deltaValue:Number = deltaValues [ deltaValueName ];
				var finalValue:Number = initialValue + deltaValue;
							
				currentAnimation.initialValues [ deltaValueName ] = initialValue;
				currentAnimation.finalValues [ deltaValueName ] = finalValue;
			}
		}
	}
	
	private function _render (p:Number):Void 
	{				
		// Animate the objects
		for ( var i:Number = 0; i < animations.length; i++ )
		{
			var currentAnimation:Object = animations [ i ];
			
			var target:Object = currentAnimation.target;
			var deltaValues:Object = currentAnimation.deltaValues;
		
			// Animate the properties
			for ( var deltaValueName:String in deltaValues )
			{
				var initialValue:Number = currentAnimation.initialValues [ deltaValueName ];
				var deltaValue:Number = deltaValues [ deltaValueName ];
				var finalValue:Number = currentAnimation.finalValues [ deltaValueName ];
			
				target [ deltaValueName ] = finalValue + ( initialValue - finalValue ) * (1-p);
			}
		}
	}
}


