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
// File: TextAreaDecorator.as
// Created by: Aral Balkan
//
// What it does:
//
// This decorator fixes a bug with the TextArea component that manifests itself
// while loading HTML text with images/swfs. The bug is time-related and thus
// can appear to be random. It results in the TextArea component's scrollbar/thumb
// being incorrectly set up.
//
// This bug is detailed on FlashAnt at the following URL:
// http://flashant.org/index.php?m=200412#239
// 
// Usage:
//
// 		var myTextAreaDecorator:TextAreaDecorator = new TextAreaDecorator ( myTextArea );
// 		myTextAreaDecorator.watchAndFix();
// 		
// 		myTextArea.text = someHtmlText;
//
// Use the watchAndFix() method before setting the text property of your
// TextArea to have the decorator automatically fix the scrollbar/thumb once
// the content has fully loaded. You have to call this method *every time*
// before setting the text property as the watch is removed each time
// it performs a fix. (This is to prevent circular references.)
//
// Note: This should only be used on HTML TextAreas containing images or swfs. 
// The bug does not appear to be present in plain text TextAreas or 
// HTML TextAreas that do not contain images/swfs.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

import mx.controls.TextArea;

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: TextAreaDecorator
//
//
////////////////////////////////////////////////////////////////////////////////

class org.osflash.arparp.utils.TextAreaDecorator
{
	//
	// Properties
	//
	var textArea:TextArea;	// Reference to the TextArea component we're decorating.
	var intervalId:Number;	// For storing the interval ID so we can clear it later.
	
	// For troubleshooting
	var elapsedTime:Number = 0;
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Constructor
	//
	////////////////////////////////////////////////////////////////////////////	
	function TextAreaDecorator ( textArea:TextArea )
	{
		// Save a reference to the TextArea component
		this.textArea = textArea;
	}
	

	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Public Methods
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	// Method: watchAndFix()
	////////////////////////////////////////////////////////////////////////////
	public function watchAndFix ():Void
	{
		//
		// Set it up so that we listen for changes on the htmlText
		// property of the label of the TextArea in question. 
		// When this property changes, we'll start looking at the 
		// contents of the label textfield to find out when all
		// the external media has loaded (at which point we'll tell 
		// the TextArea to invalidate itself to fix the bug
		// with the faulty scrollbar/thumb-size.
		//
		
		// The final argument is the scope that we need to pass back
		// to the handler because Object.watch loses scope on the callback.
		textArea.label.watch ( "htmlText", htmlTextChange, this );		
	}
	
	////////////////////////////////////////////////////////////////////////////
	// Group: Event Handlers
	////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
	// Method: htmlTextChange()
	////////////////////////////////////////////////////////////////////////////
	public function htmlTextChange ( prop, oldVal, newVal, scope )
	{
		//
		// This event handler gets called when the value of htmlText
		// in the TextArea changes.
		//
		
		// Fix the scope
		this = scope;
		
		// Remove an old interval if one exists
		clearInterval ( intervalId );
		
		// Set a new interval to check for text area image/swf load completion
		intervalId = setInterval ( checkForComplete, 100, this );
		
		// Return the new value
		return newVal;
	}
	

	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Private Methods
	//
	////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
	// Method: checkForComplete()
	////////////////////////////////////////////////////////////////////////////
	private function checkForComplete ( scope )
	{
		//
		// Checks if all external media in the TextArea's label (text field) have
		// loaded and, if so, asks the TextArea to redraw itself fully, fixing
		// the scrollbar/thumb issue.
		//
		
		// Fix the scope
		this = scope;
		
		// Update elapsed time
		elapsedTime += 100;
	
		// Counter: how many clips are there in the label text field?
		var numClips = 0;
		
		// Short-cut to the TextArea's label	
		var tf:TextField = textArea.label;

		// Flag: have all the clips loaded?
		var clipsLoaded:Boolean = true;
		
		//
		// Loop through all items in the text field and isolate the external media
		// movie clip (exclude special TextArea clips that we know about.)
		//
		for ( var i:String in tf )
		{
			var clip:Object = tf[i];
			
			var isExternalMediaClip:Boolean = typeof clip == "movieclip" && i != "owner" && i != "styleName" && i.substring(0, 8) != "clipper-";
			
			if ( isExternalMediaClip )
			{
				//
				// We have a new external media movie clip. Check if it has fully loaded.
				//
				var bL = clip.getBytesLoaded();
				var bT = clip.getBytesTotal();
				
				if ( bL != bT || bL < 100 )
				{
					// At least one of the clips has not fully loaded, return so we don't waste any more CPU
					return;
				}
				
				// Update the clip counter
				numClips++;
			}
		}

		// Check if we found any clips. If we did and we've reached this point,
		// we can be sure that they've all loaded and we can apply the fix.
		if ( numClips > 0 )
		{
			//
			// All external content has loaded. 
			//			
			
			// DEBUG
			//trace ("TextAreaDecorator::Fixing text area - "+textArea+" (took "+elapsedTime+"ms to init.)");
			
			// Remove the interval
			clearInterval ( intervalId );
			
			// Stop watching (so we don't get circular references)
			textArea.label.unwatch ( "htmlText" );
			
			// Let's ask the TextArea to fix itself!
			textArea.invalidate();
		}
	}
}
