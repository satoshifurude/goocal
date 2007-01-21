class com.jxl.goocal.callbacks.LoginCallback
{
	public var isLoggedIn:Boolean = false;
	
	public function LoginCallback(p_isLoggedIn:Boolean)
	{
		isLoggedIn = (p_isLoggedIn == true) ? true : false;
	}
}