﻿/* [gb] commenting out nonfunction classimport mx.utils.Delegate;import mx.controls.Label;// ARP-i-fy!import com.jxl.ddo.model.vo.ValueObjects;import com.jxl.ddo.controller.CommandRegistry;import com.jxl.ddo.controller.DDOServerStatus;import com.jxl.ddo.utils.FilterUtils;class com.jxl.ddo.controller.Application extends MovieClip{	public var createClassObject:Function;	public var createObject:Function;	public var ddoServerStatus:DDOServerStatus;		private var bg:MovieClip;	private var icon_mc:MovieClip;	private var title_lbl:Label;	private var linkage_txt:TextField;	private var hitState_mc:MovieClip;	private var process_mc:MovieClip;		private var valueObjects:ValueObjects;	private var commandRegistry:CommandRegistry;		public function initApp():Void	{		Stage.scaleMode = "noScale";		Stage.align = "TL";			valueObjects = ValueObjects.getInstance();		valueObjects.registerValueObjects();				// setup our CommandRegistry		commandRegistry = CommandRegistry.getInstance();		commandRegistry.registerApp(this);				var depth:Number = 0;				createObject("Background", "bg", depth++);		createClassObject(DDOServerStatus, "ddoServerStatus", depth++);		ddoServerStatus.move(8, 26);				createObject("D20Icon", "icon_mc", depth++);		icon_mc._x = 2;		icon_mc._y = 4;				createClassObject(Label, "title_lbl", depth++);		title_lbl.text = "DDO Server Status";		title_lbl.move(20, 2);		title_lbl.setSize(Stage.width - title_lbl.x, title_lbl.height);		title_lbl.setStyle("color", 0x660000);		title_lbl.setStyle("fontWeight", "bold");		title_lbl.setStyle("fontSize", 12);		FilterUtils.addShadow(title_lbl, 1, null, 0x000000, null, 2, 2);				createTextField("linkage_txt", depth++, 4, 308, Stage.width - 8, 18);		linkage_txt.html = true;		linkage_txt.multiline = false;		linkage_txt.selectable = false;		linkage_txt.wordWrap = false;		linkage_txt.htmlText = "<a href='asfunction:onLinkageClick' target='_blank'><u>www.jessewarden.com</u></a>";		var _fmt:TextFormat = new TextFormat();		_fmt.align = "center";		_fmt.color = 0x660000;		_fmt.font = "_sans";		_fmt.size = 11;		linkage_txt.setTextFormat(_fmt);		FilterUtils.addShadow(linkage_txt, 1, null, 0x000000, null, 2, 2);						clear();				lineStyle(0, 0xEEEEEE);		moveTo(0, 22);		lineTo(Stage.width, 22);		lineStyle(0, 0xCCCCCC);		moveTo(0, 23);		lineTo(Stage.width, 23);				lineStyle(0, 0xEEEEEE);		moveTo(0, 308);		lineTo(Stage.width, 308);		lineStyle(0, 0xCCCCCC);		moveTo(0, 309);		lineTo(Stage.width, 309);				endFill();				createEmptyMovieClip("hitState_mc", depth++);		hitState_mc.beginFill(0x000000, 0);		hitState_mc.moveTo(0, 0);		hitState_mc.lineTo(Stage.width, 0);		hitState_mc.lineTo(Stage.width, 22);		hitState_mc.lineTo(0, 22);		hitState_mc.lineTo(0, 0);		hitState_mc.endFill();		hitState_mc.onPress = onDraggerPress;		hitState_mc.onRelease = onDraggerRelease;		hitState_mc.onReleaseOutside = onDraggerReleaseOutside;		hitState_mc.onDragOut = onDraggerDragOut;				ddoServerStatus._visible = false;		bg._visible = false;		title_lbl._visible = false;		linkage_txt._visible = false;				createEmptyMovieClip("process_mc", depth++);		process_mc.onEnterFrame = function()		{			this._parent.ddoServerStatus._visible = true;			this._parent.bg._visible = true;			this._parent.title_lbl._visible = true;			this._parent.linkage_txt._visible = true;			_global.mApplication.setSystemTrayIcon(-1, -1);			this.removeMovieClip();		};				if(_global.mSystem != null)		{			_global.mWindow.enableAlphaMode(true);						_global.mApplication.showInSystemTray(true);			_global.mApplication.setSystemTrayIcon(2, 2);						_global.mMenu.addItem("About DDO Server Status...");			_global.mMenu.onCommand = Delegate.create(this, onMenuCommand);		}		else		{			delete onDraggerPress;			delete onDraggerRelease;			delete onDraggerReleaseOutside;			delete onDraggerDragOut;						var my_cm:ContextMenu = new ContextMenu();			var menuItem_cmi:ContextMenuItem = new ContextMenuItem("About DDO Server Status...", Delegate.create(this, onMenuCommand));			my_cm.customItems.push(menuItem_cmi);			this.menu = my_cm;		}	}		private function onMenuCommand(p_menuName:String):Void	{		if(_global.mSystem != null)		{			//if(p_menuName == "About DDO Server Status...")				//{				//}			_global.mApplication.createWindow("About.swf", 											  "-100", "-100", 											  "about", 											  "About DDO Server Status", 											  "WINDOWLESS", 											  null,											  true);		}		else		{			getURL("http://dev.jessewarden.com/flash/ddo/ss/About.swf", "_blank");		}	}		public function onDraggerPress():Void	{		if(_global.mSystem != null)		{			_global.mWindow.startDrag();		}	}		public function onDraggerRelease():Void	{		if(_global.mSystem != null)		{			_global.mWindow.stopDrag();		}	}		public function onDraggerReleaseOutside():Void	{		onDraggerRelease();	}		public function onDraggerDragOut():Void	{		onDraggerRelease();	}		private function onLinkageClick():Void	{		getURL("http://www.jessewarden.com/", "_blank");	}}*/class com.jxl.goocal.controller.Application {}