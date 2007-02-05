<?php

	// http://www.philhord.com/phord/google-calendar-api-in-php/
	
	class GCalUtils
	{
		
		/*
		**  getAuthCode($user, $pword)
		**  $user = username on Google Calendar
		**  $pword = password on Google Calendar
		**
		**  Returns: Auth code for private calendar access, or "" on error
		**
		*/
		public function getAuthCode($user, $pword, $service='cl')
		{
			$buf=$this->sslToHost('www.google.com',
				'post', 
				'/accounts/ClientLogin', 
				'', 
				'Email='.$user.'&Passwd='.$pword.'&service='.$service.'&source=phord-gcal.php-1');
		
			$code = $this->returnCode($buf);
			if ($code === 200) {
				$lines=explode("\n", $buf);
				foreach ($lines as $line) {
					if (preg_match("/^Auth=(\S+)/i", $line, $matches)) {
						return $matches[1];
					}
				}
			}
			else
			{
				return "Error ($code) retrieving auth code";
			}
			
		}
		
		/* sslToHost
		 * ~~~~~~~~~~
		 * Params:
		 *   $host      - Just the hostname.  No http:// or 
						  /path/to/file.html portions
		 *   $method    - get or post, case-insensitive
		 *   $path      - The /path/to/file.html part
		 *   $headers   - new header to insert to request
		 *   $data      - The query string, without initial question mark
		 *   $useragent - If true, 'MSIE' will be sent as 
						  the User-Agent (optional)
		 *
		 * Examples:
		 *   sendToHost('www.google.com','get','/search','q=php_imlib');
		 *   sendToHost('www.example.com','post','/some_script.cgi',
		 *              'param=First+Param&second=Second+param');
		 */
		public function sslToHost($host,$method,$path,$headers='',$data='',$useragent=0)
		{
			// Supply a default method of GET if the one passed was empty
			if (empty($method)) {
				$method = 'GET';
			}
			$method = strtoupper($method);
			$fp = fsockopen("ssl://$host", 443, $errno, $err);
			if (FALSE === $fp) {
				return "Error $err opening socket!";
			}
		
			if ($method == 'GET') {
				$path .= '?' . $data;
			}
			$this->dfputs($fp, "$method $path HTTP/1.0\r\n");
			$this->dfputs($fp, "Host: $host\r\n");
			$this->dfputs($fp,"Content-type: application/x-www-form-urlencoded\r\n");
			$this->dfputs($fp, "Content-length: " . strlen($data) . "\r\n");
			if (strlen($headers)) {
				$this->dfputs($fp, "$headers\r\n");
			}
		
			if ($useragent) {
				$this->dfputs($fp, "User-Agent: MSIE\r\n");
			}
			$this->dfputs($fp, "Connection: close\r\n\r\n");
			if ($method == 'POST') {
				$this->dfputs($fp, $data);
			}
			
			while (!feof($fp)) {
				$buf .= fgets($fp,128);
			}
			fclose($fp);
			return $buf;
		}
		
		
		/* sendToHost
		 * ~~~~~~~~~~
		 * Params:
		 *   $host      - Just the hostname.  No http:// or 
						  /path/to/file.html portions
		 *   $method    - get or post, case-insensitive
		 *   $path      - The /path/to/file.html part
		 *   $headers   - new header to insert to request
		 *   $data      - The query string, without initial question mark
		 *   $useragent - If true, 'MSIE' will be sent as 
						  the User-Agent (optional)
		 *
		 * Examples:
		 *   sendToHost('www.google.com','get','/search','q=php_imlib');
		 *   sendToHost('www.example.com','post','/some_script.cgi',
		 *              'param=First+Param&second=Second+param');
		 */
		public function sendToHost($host,$method,$path,$headers='',$data='',$useragent=0)
		{
			// Supply a default method of GET if the one passed was empty
			if (empty($method)) {
				$method = 'GET';
			}
			$method = strtoupper($method);
			$fp = fsockopen($host, 80);
			if ($method == 'GET' && strlen($data)>0) {
				$path .= '?' . $data;
			}
			$this->dfputs($fp, "$method $path HTTP/1.0\r\n");
			$this->dfputs($fp, "Host: $host\r\n");
			if ($method == 'GET' && strlen($data)>0) {
				$this->dfputs($fp,"Content-type: application/x-www-form-urlencoded\r\n");
			}
			$this->dfputs($fp, "Content-length: " . strlen($data) . "\r\n");
			if (strlen($headers)) {
				$this->dfputs($fp, "$headers\r\n");
			}
		
			if ($useragent) {
				$this->dfputs($fp, "User-Agent: MSIE\r\n");
			}
			$this->dfputs($fp, "Connection: close\r\n\r\n");
			if ($method == 'POST') {
				$this->dfputs($fp, $data);
			}
		
			while (!feof($fp)) {
				$buf .= fgets($fp,128);
			}
			fclose($fp);
			return $buf;
		}
		
		/* curlToHost -- experiments in curl
		 * ~~~~~~~~~~
		 * Params:
		 *   $url       - Full url, with http:// prefix and query string
		 *   $method    - get or post, case-insensitive
		 *   $headers   - array of headers
		 *
		 */
		public function curlToHost($url,$method,$headers=array(''))
		{
			ob_start();
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $url);
			curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
			curl_setopt($ch, CURLOPT_CUSTOMREQUEST, strtoupper($method));
		//    curl_setopt($ch,    CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch,    CURLOPT_VERBOSE, 1); ########### debug
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1); // follow redirects recursively
		
			curl_exec($ch);
			curl_close($ch);
			$ret = ob_get_contents();
			ob_end_clean();
		
			return $ret;
		}
		
	
		
		
		/**
		 * returnCode -- Parse the resulting HTTP headers for an integer result code
		 * 
		 * returns: the result code, or -1 if not found
		 * 
		 **/
		protected function returnCode($buf)
		{
			list($response) = explode("\n", $buf, 2);
			if (preg_match("|^HTTP/\d.\d (\d+)|", $response, $matches)) {
				return 0+$matches[1];
			}
			return -1;
		}
		
		/**
		 * dfputs -- debug enabled fputs
		 * 
		 * Add debug here, for example to show all strings sent to the remote host
		 * 
		 **/
		protected function dfputs($fp, $msg)
		{
			//echo $msg;
			return fputs($fp, $msg);
		}
	}
	
	
?>