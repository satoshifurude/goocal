////////////////////////////////////////////////////////////////////////////////
//
// [%TEST_NAME%]
// AsUnit Test Class Template for %CLASS_NAME% class.
//
// You can use this template as a replacement for the TestClassTemplate.as
// file in AsUnit. Copy it to:
//
// Flash installation folder -> ...\Configuration\External Libraries\asunit
// 
// Author: Aral Balkan
//
// Copyright:
// Copyright © 2005 Aral Balkan. All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
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

// AsUnit unit testing framework
import com.asunit.framework.*;

// Import package the class being tested is in 
import [%PACKAGE_NAME%].*;

////////////////////////////////////////////////////////////////////////////////
//
//
// Class: [%TEST_NAME%]
//
//
////////////////////////////////////////////////////////////////////////////////
class [%TEST_NAME%] extends TestCase 
{
	// 
	// Group: Properties
	//
	private var className:String = "[%TEST_PACKAGE_NAME%].[%TEST_NAME%]";
	private var instance:%CLASS_NAME%;
	
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Public Methods
	//
	////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Method: setUp()
	//
	// Gets called before *each* test method is run. Commonly used to initialize
	// an instance of the class being tested. May also be used to get the 
	// said instance to a common initial state.
	//
	////////////////////////////////////////////////////////////////////////////	
	public function setUp():Void 
	{
		instance = new %CLASS_NAME%();
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Method: tearDown()
	//
	// Gets called after *each* test method is run. Commonly used to delete
	// the instance of the test class being tested and carry out any other
	// necessary garbage collection.
	//
	////////////////////////////////////////////////////////////////////////////	
	public function tearDown():Void 
	{
		delete instance;
 	}
	

	////////////////////////////////////////////////////////////////////////////
	//
	// Group: Sample Tests
	//
	// You can remove these methods once you've tested that your new 
	// test class been successfully added to your test suite.
	// (The testFail method should fail when you run your test suite after
	// adding this test to it.)
	//
	////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////
	//
	// Method: testInstantiated()
	//
	// A simple test that should always pass if you've done a correct 
	// search-and-replace for %CLASS_NAME% on this template.
	//
	////////////////////////////////////////////////////////////////////////////	
 	public function testInstantiated():Void 
	{
		assertTrue("%CLASS_NAME% instantiated", instance instanceof [%CLASS_NAME%]);
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Method: testFail()
	//
	// A simple test that should always fail. By failing, it signals that 
	// your test has been successfully added to the test suite.
	//
	////////////////////////////////////////////////////////////////////////////	
	public function testFail():Void 
	{
		assertTrue("failingtest", false);
	}

}

