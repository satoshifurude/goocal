/*

	DDOServerStatus
	
	The main application component.  This component
	pings the servers, shows their status in the form
	of lights with text labels showing their name,
	and repeats the pings every minute.
	
	by Jesse R. Warden
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/

*/
import mx.core.View;
import mx.utils.Delegate;
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.controls.Label;

import com.jxl.ddo.view.controls.StatusLightLabel;
import com.jxl.ddo.model.XMLConfigReader;
import com.jxl.ddo.model.vo.ServerConfigVO;
import com.jxl.ddo.controller.CommandRegistry;
import com.jxl.ddo.controller.commands.LoadServerStatusCommand;
import com.jxl.ddo.model.vo.ServerStatusVO;
import com.jxl.ddo.model.vo.ConfigVO;
import com.jxl.ddo.utils.FilterUtils;
import com.jxl.ddo.model.ModelLocator;


class com.jxl.ddo.controller.DDOServerStatus extends View
{
	public static var symbolName:String = "com.jxl.ddo.controller.DDOServerStatus";
	public static var symbolOwner:Object = com.jxl.ddo.controller.DDOServerStatus;
	public var className:String = "DDOServerStatus";
	
	public static var PINGING_SERVER:String = "pingingServer";
	public static var PINGED_ALL_SERVERS:String = "pingedAllServers";
	
	private var loading_mc:MovieClip;
	private var xmlConfig:XMLConfigReader;
	private var baseURL:String;
	private var serverConfigs_array:Array;
	private var commandRegistry:CommandRegistry;
	private var serverCounter:Number;
	private var error_txt:TextField;
	private var checkID:Number;
	
	public function init():Void
	{
		super.init();
		
		commandRegistry = CommandRegistry.getInstance();
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(depth == null) depth = 0;
		createObject("LoadingAnimation", "loading_mc", depth++);
	}
	
	private function initLayout():Void
	{
		super.initLayout();
		
		xmlConfig = new XMLConfigReader();
		XMLConfigReader.configXMLFile = XMLConfigReader.configXMLFile;
		xmlConfig.addEventListener(XMLConfigReader.CONFIG_READ, Delegate.create(this, onXMLConfigRead));
		xmlConfig.addEventListener(XMLConfigReader.CONFIG_ERROR, Delegate.create(this, onXMLConfigError));
		xmlConfig.loadConfig();
	}
	
	private function doLayout():Void
	{
		super.doLayout();
		
		if(loading_mc)
		{
			loading_mc._x = (width / 2) - (loading_mc._width / 2);
			loading_mc._y = (height / 2) - (loading_mc._height / 2);
		}
		
		if(error_txt)
		{
			error_txt._width = width;
			error_txt._height = 60;
			//error_txt._y = (height / 2) - (error_txt._height / 2);
		}
	}
	
	private function onXMLConfigRead(event:Object):Void
	{
		var config:ConfigVO = xmlConfig.config;
		baseURL = config.baseURL;
		serverConfigs_array = config.serverConfigs_array;
		ModelLocator.proxy_url = config.proxy_url;
		doLater(this, "drawInitialStatusBars");
	}
	
	private function onXMLConfigError(event:Object):Void
	{
		destroyObject("loading_mc");
		createTextField("error_txt", depth++, 0, 0, width, 60);
		error_txt.text = "Could not load configuration file.";
		error_txt.wordWrap = true;
		error_txt.multiline = true;
		var _fmt:TextFormat = new TextFormat();
		_fmt.align = "center";
		_fmt.color = 0x660000;
		_fmt.font = "_sans";
		_fmt.size = 11;
		error_txt.setTextFormat(_fmt);
		FilterUtils.addShadow(error_txt, 1, null, 0x000000, null, 2, 2);
		
		invalidate();
	}
	
	private function drawInitialStatusBars():Void
	{
		destroyObject("loading_mc");
		
		var len:Number = serverConfigs_array.length;
		var origY:Number = 0;
		for(var i:Number = 0; i<len; i++)
		{
			var sc:ServerConfigVO = serverConfigs_array[i];
			var ref:StatusLightLabel = StatusLightLabel(createChild(StatusLightLabel, String(i)));
			ref.text = sc.name;
			ref.move(0, origY);
			origY += ref.height;
			FilterUtils.addShadow(ref, 1, null, 0x000000, null, 2, 2);
		}
		
		doLater(this, "startPingingServers");
	}
	
	private function startPingingServers():Void
	{
		clearInterval(checkID);
		serverCounter = -1;
		pingNextServer();
	}
	
	private function pingNextServer():Void
	{
		var serverConfigLen:Number = serverConfigs_array.length;
		if(serverCounter + 1 < serverConfigLen)
		{
			serverCounter++;
			var ref:StatusLightLabel = StatusLightLabel(getChildAt(serverCounter));
			ref.isLoading = true;
			var sc:ServerConfigVO = ServerConfigVO(serverConfigs_array[serverCounter]);
			var theURL:String = baseURL + sc.ip;
			commandRegistry.runCommand(LoadServerStatusCommand.className, 
									   this, 
									   onPingServerResult,
									   theURL);
			dispatchEvent({type: PINGING_SERVER, target: this, 
						   index: serverCounter, total: serverConfigLen});
		}
		else
		{
			clearInterval(checkID);
			checkID = setInterval(this, "startPingingServers", 60 * 1000);
			dispatchEvent({type: PINGED_ALL_SERVERS, target: this});
		}
	}
	
	private function onPingServerResult(result:ResultEvent):Void
	{
		var ref:StatusLightLabel = StatusLightLabel(getChildAt(serverCounter));
		ref.isLoading = false;
		ref.status = StatusLightLabel.STATUS_ON;
		
		if(result.result != null)
		{
			ref.status = StatusLightLabel.STATUS_ON;
		}
		else
		{
			ref.status = StatusLightLabel.STATUS_ERROR;
		}
		
		doLater(this, "pingNextServer");
	}
	
}