class com.jxl.goocal.callbacks.LoginCallback
{
	public static var LOGGED_IN_SUCCESS:Number = 0;
	public static var LOGGED_IN_FAILED:Number = 1;
	public static var LOGGED_IN_FAILED_ATTEMPT:Number = 2;
	
	public var isLoggedIn:Number;
	public var progress:String;
	
	public function LoginCallback(p_isLoggedIn:Number)
	{
		isLoggedIn = (p_isLoggedIn == 0) ? 0 : 1;
	}
}