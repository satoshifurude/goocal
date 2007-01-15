<?php

	class StringUtils
	{
	
		public static function indexOf($haystack, $needle)
		{
			return strpos(strtoupper($haystack), strtoupper($needle));
		}
		
		public static function replace($str, $remove, $replacer)
		{
			return implode($replacer, explode($remove, $str));
		}
		
		public static function removeHeaderStrings($str)
		{
			$str = self::replace($str, "\r\n", "");
			$cIndex = self::indexOf($str, "Connection: close");
			$str = substr($str, $cIndex + 17);
			$str = self::replace($str, "\n", "");
			$str = self::replace($str, "\t", "");
			return $str;
		}
	}

?>