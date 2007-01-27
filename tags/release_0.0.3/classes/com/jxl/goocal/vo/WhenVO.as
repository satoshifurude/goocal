class com.jxl.goocal.vo.WhenVO
{
	public var startTime:Date;
	public var endTime:Date;
	public var reminder:Date;
	
	public function WhenVO(p_startTime:Date,
						   p_endTime:Date,
						   p_reminder:Date)
	{
		startTime			= p_startTime;
		endTime				= p_endTime;
		reminder			= p_reminder;
	}
	
	public function toString():String
	{
		return "[class WhenVO]";
	}
}