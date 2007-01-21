/*

	SelfService
	
	This is the main Application file.  This class is effectively
	_root in Flash; it merely turns _root into a class.  Here,
	everything is setup.  The ValueObjects are reigstered, 
	the ServiceLocator has his services added,
	the Controller is created and its commands are registered,
	and the MainScreen, which holds the majority of the GUI
	is setup. 

*/


import org.osflash.arp.ValueObjects;
//import org.osflash.arp.ServiceLocator;
//import org.osflash.arp.Controller;

//import mx.core.UIObject; // optional
//import mx.remoting.debug.NetDebug; // optional

class org.osflash.arp.ApplicationTemplate extends MovieClip
{
	
	// publics
	public var createClassObject:Function; // via mx.core.ext.UIObjectExtensions
	public var calledOnLoad:Boolean = false; // ensures 1 onLoad
	
	// privates
	private var scopeRef:MovieClip; // optional for MTASC
	private var valueObjects:ValueObjects;
	//private var serviceLocator:ServiceLocator;
	//private var controller:Controller;
	//private var dependUIObject:UIObject; // ensure's class is compiled
	
	// controls
	private var boundingBox_mc:MovieClip; // define default width & height
	
	public function get width():Number
	{
		return Stage.width;	
	}
	
	public function get height():Number
	{
		return Stage.height;	
	}
	
	function ApplicationTemplate(p_scopeRef:MovieClip)
	{
		debug("ApplicationTemplate::constructor");
		_lockroot = true;
		scopeRef = p_scopeRef;
		// optional
		//NetDebug.initialize();
	}
	
	static function main()
	{
		/*
			optional for MTASC
			if this class is _root hacked,
			leave the line below this commented out
		*/
		//var s:SelfService = new SelfService(_root);
	}
	
	static public function application():Object
	{
		// not _level0, because of _lockroot
		// _root therefore is this instance
		return _root;
	}
	
	// only works with mx.core.UIObject
	/*
	static public function centerPopUp(mc:UIObject):Void
	{
		var w:Number = Math.max(Stage.width, 800);
		var h:Number = Math.max(Stage.height, 600);
		mc.move( (w / 2) - (mc.width / 2),
				 (h / 2) - (mc.height / 2));
	}
	*/
	
	function onLoad()
	{
		//trace("ApplicationTemplate::onLoad");
		if(calledOnLoad == false)
		{
			calledOnLoad = true;
			
			Stage.scaleMode = "noScale";
			Stage.align = "TL";
			
			// setup our ValueObjects to map Java & AS classes
			valueObjects = ValueObjects.getInstance();
			valueObjects.registerValueObjects();
			
			// setup our ServiceLocator
			//serviceLocator = ServiceLocator.getInstance();
			
			// setup our Controller with commands
			//controller = Controller.getInstance();
			//controller.registerApp(this);
			
			// :: create main application component here :: //
			
			// remove the bounding box from the sizing of our app
			boundingBox_mc._visible = false;
			// only resize if you are sure you won't be loaded
			// into another movie
			//boundingBox_mc._width = 0;
			//boundingBox_mc._height = 0;
		}
	}
	
	public function debug(o)
	{
		//trace(o);
		//NetDebug.trace(o);
		//TRACE(Flashout.DEBUG + o);
	}

}