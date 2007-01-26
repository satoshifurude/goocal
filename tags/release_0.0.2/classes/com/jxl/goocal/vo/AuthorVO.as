class com.jxl.goocal.vo.AuthorVO
{
	public var name:String;
	public var email:String;
	
	public function AuthorVO(p_name:String, p_email:String)
	{
		name			= p_name;
		email			= p_email;
	}
	
	public function toString():String
	{
		return "[class AuthorVO]";
	}
	
	public function clone():AuthorVO
	{
		return new AuthorVO(name, email);
	}
}