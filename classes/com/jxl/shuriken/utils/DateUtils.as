﻿class com.jxl.shuriken.utils.DateUtils
{
	public static var FORMAT_TIME_MONTH_DAY_FULLYEAR:Number 	= 0;
	public static var FORMAT_MONTH_DAY_FULLYEAR:Number 			= 1;
	public static var MONTH_DAY_YEAR:Number						= 2;
	public static var HOUR_MIN_AM_PM:Number						= 3;
	
	
	public static function clone(p_date:Date):Date
	{
		if(p_date == null || p_date == "") return null;
		
		var d:Date = new Date(p_date.getFullYear(),
								p_date.getMonth(),
								p_date.getDate(),
								p_date.getHours(),
								p_date.getMinutes(),
								p_date.getSeconds(),
								p_date.getMilliseconds());
		return d;
	}
	
	public static function getLastMonth(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var thisMonth:Number = today.getMonth();
		if(thisMonth > 0)
		{
			today.setMonth(thisMonth - 1);
		}
		else
		{
			today.setMonth(11);
			today.setFullYear(today.getFullYear() - 1);
		}
		return today;
	}
	
	public static function getNextMonth(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var thisMonth:Number = today.getMonth();
		if(thisMonth < 11)
		{
			today.setMonth(thisMonth + 1);
		}
		else
		{
			today.setMonth(0);
			today.setFullYear(today.getFullYear() + 1);
		}
		return today;
	}
	
	public static function setEndOfMonth(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var month:Number = today.getMonth();
		var END_OF_MONTH_DATES_ARRAY:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var lastDate:Number = END_OF_MONTH_DATES_ARRAY[month];
		today.setDate(lastDate);
		return today;
	}
	
	public static function setBeginningOfMonth(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		today.setDate(1);
		return today;
	}
	
	public static function setFirstDayOfWeek(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var day:Number = today.getDay();
		while(day > 0)
		{
			today.setDate(today.getDate() - 1);
			day = today.getDay();
		}
		return today;
	}
	
	public function setLastDayOfWeek(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var day:Number = today.getDay();
		while(day < 6)
		{
			today.setDate(today.getDate() + 1);
			day = today.getDay();
		}
		return today;
	}
	
	public static function setDay(p_optionalToday:Date, p_val:Number):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var day:Number = today.getDay();
		while(day != p_val)
		{
			if(today.getDay() < p_val)
			{
				today.setDate(today.getDate() + 1);
			}
			else
			{
				today.setDate(today.getDate() - 1);
			}
			day = today.getDay();
		}
		return today;
	}
	
	public static function getWeekDayName(p_val):String
	{ 
		var weekDayNames_array:Array = ["Sunday", 
										"Monday", 
										"Tuesday", 
										"Wednesday", 
										"Thursday", 
										"Friday", 
										"Saturday"];
		var day:Number;
		if(p_val instanceof Date)
		{
			day = p_val.getDay();
		}
		else if(p_val instanceof Number || typeof(p_val) == "number")
		{
			day = p_val;
		}
		else if(p_val == undefined)
		{
			var today:Date = new Date();
			day = today.getDay();
		}
		
		return weekDayNames_array[day];
	}
	
	public static function getMonthNames():Array
	{
		var monthNames_array:Array = ["January", 
										  "February", 
										  "March", 
										  "April", 
										  "May", 
										  "June", 
										  "July", 
										  "August", 
										  "September", 
										  "October", 
										  "November", 
										  "December"];
		return monthNames_array;
	}
	
	public static function getMonthName(p_val):String
	{
		var monthNames_array:Array = getMonthNames();
		var day:Number;
		if(p_val instanceof Date)
		{
			day = p_val.getMonth();
		}
		else if(p_val instanceof Number || typeof(p_val) == "number")
		{
			day = p_val;
		}
		else if(p_val == undefined)
		{
			var today:Date = new Date();
			day = today.getMonth();
		}
		
		return monthNames_array[day];
	}
	
	public static function isEndOfMonth(p_optionalToday:Date):Boolean
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		var month:Number = today.getMonth();
		var END_OF_MONTH_DATES_ARRAY:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var lastDate:Number = END_OF_MONTH_DATES_ARRAY[month];
		return (today.getDate() == lastDate);
	}
	
	public static function lastMonth(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		today.setMonth(today.getMonth() - 1);
		return today;
	}
	
	public static function nextMonth(p_optionalToday:Date):Date
	{
		var today:Date = (p_optionalToday == undefined) ? new Date() : p_optionalToday;
		today.setMonth(today.getMonth() + 1);
		return today;
	}
	
	public static function isEqualByDate(p_firstDate:Date, p_secondDate:Date):Boolean
	{
		//trace("-----------------");
		//trace("p_firstDate.getFullYear(): " + p_firstDate.getFullYear() + ", p_secondDate.getFullYear(): " + p_secondDate.getFullYear());
		//trace("p_firstDate.getMonth(): " + p_firstDate.getMonth() + ", p_secondDate.getMonth(): " + p_secondDate.getMonth());
		//trace("p_firstDate.getDate(): " + p_firstDate.getDate() + ", p_secondDate.getDate(): " + p_secondDate.getDate());
		
		if(p_firstDate.getFullYear() == p_secondDate.getFullYear())
		{
			if(p_firstDate.getMonth() == p_secondDate.getMonth())
			{
				if(p_firstDate.getDate() == p_secondDate.getDate())
				{
					return true;
				}
			}
		}
		
		return false;
	}
	
	public static function format(p_date:Date, p_type:Number):String
	{
		
		switch(p_type)
		{
			case FORMAT_TIME_MONTH_DAY_FULLYEAR:
				// Today Dec 18th 2006
				var s:String = "";
				var today:Date = new Date();
				if(today.getFullYear() == p_date.getFullYear())
				{
					if(today.getMonth() == p_date.getMonth())
					{
						if(today.getDate() == p_date.getDate())
						{
							s += "Today ";
						}
						else if(today.getDate() - 1 == p_date.getDate())
						{
							s += "Yesterday ";
						}
						else if(today.getDate() + 1 == p_date.getDate())
						{
							s += "Tomorrow ";
						}
						else
						{
							s += DateUtils.getWeekDayName(p_date) + " ";
						}
					}
				}
				
				var monthNames_array:Array = getMonthNames();
				s += monthNames_array[p_date.getMonth()].substr(0, 3) + " ";
				s += p_date.getDate().toString() + " ";
				s += p_date.getFullYear().toString();
				return s;
				
			case FORMAT_MONTH_DAY_FULLYEAR:
				// Oct 9th 2006
				var s:String = "";
				var monthNames_array:Array = getMonthNames();
				s += monthNames_array[p_date.getMonth()].substr(0, 3) + " ";
				s += p_date.getDate().toString() + " ";
				s += p_date.getFullYear().toString();
				return s;
			
			case MONTH_DAY_YEAR:
				// 11/7/2006
				var s:String = "";
				s += (p_date.getMonth() + 1) + "/";
				s += p_date.getDate() + "/";
				s += p_date.getFullYear().toString();
				return s;
				
		}
	}
	
	public static function parseDate(p_str:String, p_type:Number):Date
	{
		switch(p_type)
		{
			case MONTH_DAY_YEAR:
				var d:Date = new Date();
				var strArray:Array = p_str.split("/");
				d.setMonth(parseInt(strArray[0]) - 1);
				d.setDate(parseInt(strArray[1]));
				d.setFullYear(parseInt(strArray[2]));
				return d;
		}
	}
	
	/*
		If the day in local time is one day after the day in utc time, and
		the hour in local time is larger than the hour in utc time, the offset
		is negative
	*/
	public static function getLocalOffset():Number
	{
		// local time minus UTC
		trace("---------------------------");
		trace("DateUtils::getLocalOffset");
		var d:Date = new Date();
		var offset:Number = d.getTimezoneOffset() / 60;
		var theDay:Number = d.getDate();
		var utcDay:Number = d.getUTCDate();
		var theMonth:Number = d.getMonth();
		var utcMonth:Number = d.getUTCMonth();
		var theYear:Number = d.getFullYear();
		var utcYear:Number = d.getUTCFullYear();
		trace("offset: " + offset);
		offset = offset * -1;
		if(theDay > utcDay)
		{
			if(theMonth == utcMonth)
			{
				if(theYear == utcYear)
				{
					var hour:Number = d.getHours();
					var utcHour:Number = d.getUTCHours();
					if(hour > utcHour)
					{
						offset = Math.abs(offset);
					}
				}
			}
		}
		//offset: 5
		//theDay: 28
		//utcDay: 1
		//hour: 21
		//utcHour: 2
		//returning: 5
		trace("theDay: " + theDay);
		trace("utcDay: " + utcDay);
		trace("hour: " + hour);
		trace("utcHour: " + utcHour);
		trace("returning: " + offset);
		return offset;
	}
	
}