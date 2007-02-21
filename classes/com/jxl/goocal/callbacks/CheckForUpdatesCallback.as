/*
	CallbackTemplate
	
	Used by Command classes to send back information
	to Views about the result of a Command being run.
	Provides context about successes/failures/errors,
	as well as the flexibility of putting that
	context as class properties that are strongly typed.
	
	Not part of ARP standard, added by me.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/
class com.jxl.goocal.callbacks.CheckForUpdatesCallback
{
	
	public var newerVersionAvailable:Boolean 		= false;
	public var updateURL:String;
	public var failed:Boolean 						= false;
	public var newVersion:String;
	
	public function CheckForUpdatesCallback()
	{
	}
}