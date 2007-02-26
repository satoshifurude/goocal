//****************************************************************************
// ActionScript Standard Library
// SharedObject object
//****************************************************************************

// jesse warden says: I removed the 'dynamic' keyword.  SharedObject shouldn't
// be dynamic, only the data property of SharedObject.  I spent 2 days
// going in circles on a bug because the compiler didn't see
// addListener vs. addEventListener even though addEventListner
// is clearly AS3... so to hell with it, MY intrinsic does WHAT I want.
intrinsic class SharedObject
{
	var data:Object;

	static function addListener(soName:String, notifyFunction:Function):Void;
	static function removeListener(soName:String):Void;
	static function getLocal(name:String,localPath:String,secure:Boolean):SharedObject;
	
	function clear():Void;
	function flush(minDiskSpace:Number):Object; // minDiskSpace optional
	function getMaxSize():Number;
	function getSize():Number;
	function onStatus(infoObject:Object):Void;
	function onSync(objArray:Array):Void;
}