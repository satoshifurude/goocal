import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.controls.Button;
import com.jxl.shuriken.controls.CheckBox;
import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.events.ShurikenEvent;
import com.jxl.shuriken.events.Callback;


class com.jxl.goocal.views.LoginForm extends UIComponent
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.LoginForm";
	
	public static var EVENT_REMEMBER_CHANGED:String 		= "com.jxl.goocal.views.LoginForm.rememberChanged";
	public static var EVENT_SUBMIT:String 					= "com.jxl.goocal.views.LoginForm.submit";
	
	public var soName:String = "GoogleCalendar_us";
	
	public function get username():String { return __username_ti.text; }
	public function set username(p_val:String):Void
	{
		__username = p_val;
		__username_ti.text = p_val;
	}
	
	public function get password():String { return __password_ti.text; }
	public function set password(p_val:String):Void
	{
		__password = p_val;
		__password_ti.text = p_val;
	}
	
	public function get remember():Boolean { return __remember; }
	public function set remember(p_val:Boolean):Void
	{
		__remember = p_val;
		__remember_ch.setReleaseCallback();
		__remember_ch.selected = __remember;
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginForm::commitProperties");
		__remember = __remember_ch.selected;
		//DebugWindow.debug("__remember: " + __remember);
		//DebugWindow.debug("__remember_ch.selected: " + __remember_ch.selected);
		__remember_ch.setReleaseCallback(this, onRemember);
		//enabled = false;
		if(System.capabilities.isDebugger == false)
		{
			if(__saveSOListener == null)
			{
				__saveSOListener = Delegate.create(this, onSOReady);
				SharedObject.addListener(soName, __saveSOListener);
			}
			var saveSO:SharedObject = SharedObject.getLocal(soName);
		}
		else
		{
			var saveSO:SharedObject = SharedObject.getLocal(soName);
			onSOReady(saveSO);
		}
	}
	
	private var __username:String 				= "";
	private var __password:String				= "";
	private var __remember:Boolean				= false;
	private var __saveSOListener:Function;
	private var __initialSOList:Function;
	private var __closingList:Function;
	private var __rememberCallback:Callback;
	private var __submitCallback:Callback;
	
	private var __username_lbl:TextField;
	private var __username_ti:TextField;
	private var __password_lbl:TextField;
	private var __password_ti:TextField;
	private var __remember_ch:CheckBox;
	private var __submit_pb:Button;
	
	public function LoginForm()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__username_lbl == null)
		{
			__username_lbl = createLabel("__username_lbl");
			__username_lbl.wordWrap = false;
			__username_lbl.multiline = false;
			__username_lbl.selectable = false;
			__username_lbl.text = "Username";
		}
		
		if(__username_ti == null)
		{
			__username_ti = createLabel("__username_ti");
			__username_ti.wordWrap = false;
			__username_ti.multiline = false;
			__username_ti.type = TextField.TYPE_INPUT;
			__username_ti.border = true;
			__username_ti.borderColor = 0x000000;
			__username_ti.background = true;
			__username_ti.backgroundColor = 0xFFFFFF;
		}
		
		if(__password_lbl == null)
		{
			__password_lbl = createLabel("__password_lbl");
			__password_lbl.wordWrap = false;
			__password_lbl.multiline = false;
			__password_lbl.selectable = false;
			__password_lbl.text = "Password";
		}
		
		if(__password_ti == null)
		{
			__password_ti = createLabel("__password_ti");
			__password_ti.wordWrap = false;
			__password_ti.multiline = false;
			__password_ti.type = TextField.TYPE_INPUT;
			__password_ti.border = true;
			__password_ti.borderColor = 0x000000;
			__password_ti.background = true;
			__password_ti.backgroundColor = 0xFFFFFF;
			__password_ti.password = true;
		}
		
		if(__remember_ch == null)
		{
			__remember_ch = CheckBox(createComponent(CheckBox, "__remember_ch"));
			__remember_ch.setReleaseCallback(this, onRemember);
			__remember_ch.label = "Remember Me";
			__remember_ch.setSize(120, __remember_ch.height);
		}
		
		if(__submit_pb == null)
		{
			__submit_pb = Button(createComponent(Button, "__submit_pb"));
			__submit_pb.setReleaseCallback(this, onSubmit);
			__submit_pb.label = "Login";
		}
	}
	
	private function onLoad():Void
	{
		super.onLoad();
		
		if(System.capabilities.isDebugger == false)
		{
			if(__initialSOList == null)
			{
				__initialSOList = Delegate.create(this, onInitialSOReady);
				SharedObject.addListener(soName, __initialSOList);
				var readSO:SharedObject = SharedObject.getLocal(soName);
			}
		}
		else
		{
			var readSO:SharedObject = SharedObject.getLocal(soName);
			onInitialSOReady(readSO);
		}
	}
	
	private function redraw():Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginForm::redraw");
		super.redraw();
		
		var margin:Number = 4;
		var m2:Number = margin * 2;
		
		__username_lbl.move(0, 0);
		__username_lbl.setSize(__width, __username_lbl._height);
		
		__username_ti.move(__username_lbl._x, __username_lbl._y + __username_lbl._height + margin);
		__username_ti.setSize(__username_lbl._width, __username_ti._height);
		
		__password_lbl.move(__username_ti._x, __username_ti._y + __username_ti._height + m2);
		__password_lbl.setSize(__username_ti._width, __password_lbl._height);
		
		__password_ti.move(__password_lbl._x, __password_lbl._y + __password_lbl._height + margin);
		__password_ti.setSize(__password_lbl._width, __password_ti._height);
		
		__remember_ch.move(__password_ti._x, __password_ti._y + __password_ti._height + m2);
		__remember_ch.setSize(__password_ti._width, __password_ti._height);
		
		__submit_pb.move(__remember_ch._x, __remember_ch._y + __remember_ch._height + m2);
		__submit_pb.setSize(__remember_ch._width, __submit_pb._height);
	}
	
	private function onSOReady(p_so:SharedObject):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginForm::onSOReady");
		//DebugWindow.debug("__remember: " + __remember);
		if(__remember == true)
		{
			p_so.data.username = __username_ti.text;
			p_so.data.password = __password_ti.text;
			p_so.data.remember = true;
			var r = p_so.flush();
			//DebugWindow.debug("r: " + r);
		}
		else
		{
			p_so.data.username = null;
			p_so.data.password = null;
			p_so.data.remember = null;
			p_so.clear();
		}
		
		//enabled = true;
		SharedObject.removeListener(soName);
		delete __saveSOListener;
		
		//DebugWindow.debug("__username: " + __username);
		//DebugWindow.debug("__password: " + __password);
	}
	
	private function onRemember(p_event:ShurikenEvent):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginForm::onRemember");
		//DebugWindow.debug("__username: " + __username);
		//DebugWindow.debug("__password: " + __password);
		remember = __remember_ch.selected;
		//DebugWindow.debug("__remember: " + __remember);

		__rememberCallback.dispatch(new Event(EVENT_REMEMBER_CHANGED, this));
		//DebugWindow.debug("__username: " + __username);
		//DebugWindow.debug("__password: " + __password);
	}
	
	private function onSubmit(p_event:ShurikenEvent):Void
	{
		__submit_pb.setReleaseCallback();
		
		if(__remember == false)
		{
			__submitCallback.dispatch(new Event(EVENT_SUBMIT, this));
		}
		else
		{
			if(System.capabilities.isDebugger == false)
			{
				if(__closingList == null)
				{
					__closingList = Delegate.create(this, onCloseSOReady);
					SharedObject.addListener(soName, __closingList);
				}
				var saveBeforeCloseSO:SharedObject = SharedObject.getLocal(soName);
			}
			else
			{
				var saveBeforeCloseSO:SharedObject = SharedObject.getLocal(soName);
				onCloseSOReady(saveBeforeCloseSO);
			}
			
		}
	}
	
	private function onInitialSOReady(p_so:SharedObject):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("LoginForm::onInitialSOReady");
		//DebugWindow.debug("p_so.data.username: " + p_so.data.username);
		//DebugWindow.debug("p_so.data.password: " + p_so.data.password);
		
		if(p_so.data.username != null) username = p_so.data.username;
		if(p_so.data.password != null) password = p_so.data.password;
		if(p_so.data.remember != null)
		{
			if(p_so.data.remember == true)
			{
				__remember = true;
				__remember_ch.setReleaseCallback();
				__remember_ch.selected = __remember;
				__remember_ch.setReleaseCallback(this, onRemember);
			}
		}
		
		SharedObject.removeListener(soName);
		delete __initialSOList;
	}
	
	private function onCloseSOReady(p_so:SharedObject):Void
	{
		p_so.data.username = username;
		p_so.data.password = password;
		p_so.data.remember = true;
		p_so.flush();
		SharedObject.removeListener(soName);
		delete __closingList;
		__submitCallback.dispatch(new Event(EVENT_SUBMIT, this));
	}
	
	public function setRememberCallback(scope:Object, func:Function):Void
	{
		__rememberCallback = new Callback(scope, func);
	}
	
	public function setSubmitCallback(scope:Object, func:Function):Void
	{
		__submitCallback = new Callback(scope, func);
	}
}