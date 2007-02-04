////////////////////////////////////////////////////////////////////////////////
//
// ARP: The Open Source Pattern-Based RIA Framework for the Flash Platform
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
// Project: ARP
// File: ArpForm.as
// Created by: Aral Balkan
//
// Base class for creating graphic (icon) buttons. Used by, among others,
// the AriaMenu component. Note: This is the initial import of some older code
// that uses callbacks.
//
// TO-DO: Replace old-style callbacks with event dispatcher events (extend ARPForm)
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: GraphicButton
//
//
//////////////////////////////////////////////////////////////////////////////// 
class org.osflash.arp.controls.GraphicButton
{
	//
	// Properties 
	//
	var button_mc:MovieClip;	// the movie clip instance to use as button
	var captureEnter:Boolean;	// whether or not this button should capture the enter key
	var state:Boolean;			// state of the button (disabled/enabled)		
	
	var onKeyDown:Function;
			
	////////////////////////////////////////////////////////////////////////////
	//
	// Constructor
	//
	// Requires a movie clip *reference* as the target. The movieclip must
	// contain the following frame labels for the various states:
	// "disabled", "normal", "over", "down". 
	//
	///////////////////////////////////////////////////////////////////////////
	function GraphicButton ( button_mc:MovieClip, disabled:Boolean, captureEnter:Boolean ) 
	{
	
		// trace ("GraphicButton::Constructor - Info: Setting up "+button_mc);
	
		this.button_mc = button_mc;
		this.button_mc.instanceRef = this; // ref to class
		//
		// Note: if captureEnter is true, this button will capture the
		// enter key and trigger its callback *even if it does not
		// have focus* This is good for form submit buttons where you
		// would like to have this behavior.
		//
		var captureEnter = (captureEnter == undefined || captureEnter == null ) ? false : captureEnter;
		this.setupKeyboardControl( captureEnter ); // setup keyboard control
		var disabled = ( disabled == undefined || disabled == null ) ? false : disabled;
		this.setEnabled ( !disabled );
	}

	
	////////////////////////////////////////////////////////////////////////////
	// setEnabled()
	////////////////////////////////////////////////////////////////////////////	
	function setEnabled( state:Boolean )
	{
		this.state = state;
		
		if ( state ) 
		{
			this.enableButton();
		} 
		else 
		{
			this.disableButton();
		}
	}

	
	////////////////////////////////////////////////////////////////////////////
	// getEnabled()
	////////////////////////////////////////////////////////////////////////////	
	function getEnabled()
	{
		// DEBUG
		// // trace ("GraphicButton::getEnabled - Info: State = "+this.state);
		
		return this.state;
	}

	
	////////////////////////////////////////////////////////////////////////////
	// enableButton()
	////////////////////////////////////////////////////////////////////////////	
	function enableButton() 
	{
		var btn_mc = this.button_mc;
		
		// add the listener
		Key.addListener( this );
		
		//
		// Add mouse handler and other behavior to the
		// button movie clip.
		//
		
		// set onPress
		btn_mc.onPress = function() 
		{
			this.gotoAndStop("down");		
		};
		
		// set onRollOver
		btn_mc.onRollOver = function() 
		{
			this.gotoAndStop("over");
		};
		
		// set onRollOut, onDragOut, etc.
		btn_mc.onRollOut = btn_mc.onReleaseOutside = btn_mc.onDragOut = function() 
		{
			this.gotoAndStop("normal");	
		};
		
		// set onRelease
		btn_mc.onRelease = function() 
		{
			this.gotoAndStop("normal");
			this.instanceRef.onRelease();			// call default handler
			this.callbackFunc.apply( this.callbackObj, this.callbackArgs );	// call click handler
		};
		
		// display the enabled state
		btn_mc.gotoAndStop("normal");
		
		// use the hand cursor
		btn_mc.useHandCursor = true;
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// disableButton()
	////////////////////////////////////////////////////////////////////////////	
	function disableButton() 
	{
		var btn_mc = this.button_mc;
		//
		// Remove mouse handler behavior from button and 
		// display it in its disabled state.
		//
		btn_mc.onPress = null;
		btn_mc.onRollOver = null;
		btn_mc.onRollOut = btn_mc.onReleaseOutside = btn_mc.onDragOut = null;
		btn_mc.onRelease = null;
		btn_mc.gotoAndStop("disabled");
		btn_mc.useHandCursor = false;	// hide hand cursor
		//
		// Remove the key listener.
		// Note: this does not work due to the error with the Flash broadcaster
		// Thus: Don't use global Enter captures.
		//
		Key.removeListener( this );
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	// setClickHandler()
	////////////////////////////////////////////////////////////////////////////	
	function setClickHandler ( callbackObj , callbackFunc ) 
	{
	
		if (typeof callbackObj == "function") 
		{
			//
			// Called in the form setClickHandler ( functionReference )
			//
			this.button_mc.callbackObj = null;
			this.button_mc.callbackFunc = callbackObj;
			arguments.splice(0,1);
			this.button_mc.callbackArgs = [];	
			this.button_mc.callbackArgs.push(this); // save reference to self
			this.button_mc.callbackArgs = this.button_mc.callbackArgs.concat(arguments);// save the rest of the arguments to be passed to callback
		} 
		else
		{
			//
			// Called in the form setClickHandler ( objectReference, functionNameString )
			//
			this.button_mc.callbackObj = callbackObj;
			this.button_mc.callbackFunc = callbackObj[callbackFunc];
			arguments.splice(0, 2);						// remove object ref and function name from arguments
			this.button_mc.callbackArgs = [];	
			this.button_mc.callbackArgs.push(this); // save reference to self
			this.button_mc.callbackArgs = this.button_mc.callbackArgs.concat(arguments);// save the rest of the arguments to be passed to callback
			
		}
	}

	
	////////////////////////////////////////////////////////////////////////////
	// setupKeyboardControl()
	////////////////////////////////////////////////////////////////////////////
	function setupKeyboardControl ( captureEnter:Boolean )
	{
		// trace ("GraphicButton::Info - Setting up keyboard control!");
		
		this.captureEnter = captureEnter;
		
		this.onKeyDown = function ()
		{
			// DEBUG
			// // trace ("onKeyDown graphic button");
		
			// only handle keys if we have focus
			var focussed = Selection.getFocus();
			
			// DEBUG
			// // trace ("focussed = "+focussed);
			// // trace ("this.button_mc = " + this.button_mc);
	
			var objectWithFocus = eval ( focussed );
			
			// DEBUG
			// // trace ("objectWithFocus = "+objectWithFocus);
	
			if ( objectWithFocus == this.button_mc )
			{
				// ok, we have focus, let's see what the user pressed
				
				// DEBUG
				// // trace ("we have focus!");		
				
				if ( Key.isDown ( Key.ENTER ) || Key.isDown ( Key.SPACE ) ) 
				{
					// trigger button
					
					// DEBUG
					// // trace ("GraphicButton::onKeyDown - Info: Triggering due to Enter/Space on button");
					
					this.button_mc.onRelease();
				}
			}
			else if ( this.captureEnter && Key.isDown ( Key.ENTER ) )
			{
				// user pressed Enter and we're set up to capture it
				
				// DEBUG
				// // trace ("GraphicButton::onKeyDown - Info: Triggering due to captured Enter.");
				
				this.button_mc.onRelease();
			}	
		};
	}
	
}
