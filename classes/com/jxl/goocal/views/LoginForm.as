﻿import mx.utils.Delegate;

import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.core.UITextField;
import com.jxl.shuriken.controls.Label;
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
	
	public function get username():String { return __username; }
	public function set username(p_val:String):Void
	{
		__username = p_val;
		__usernameDirty = true;
		invalidateProperties();
	}
	
	public function get password():String { return __password; }
	public function set password(p_val:String):Void
	{
		__password = p_val;
		__passwordDirty = true;
		invalidateProperties();
	}
	
	public function get remember():Boolean { return __remember; }
	public function set remember(p_val:Boolean):Void
	{
		__remember = p_val;
		__rememberDirty = true;
		invalidateProperties();
	}
	
	private var __username:String 				= "";
	private var __usernameDirty:Boolean 		= false;
	private var __password:String				= "";
	private var __passwordDirty:Boolean			= false;
	private var __remember:Boolean				= false;
	private var __rememberDirty:Boolean			= false;
	private var __saveSOListener:Function;
	private var __initialSOList:Function;
	private var __closingList:Function;
	private var __rememberCallback:Callback;
	private var __submitCallback:Callback;
	
	private var __username_lbl:Label;
	private var __username_ti:UITextField;
	private var __password_lbl:Label;
	private var __password_ti:UITextField;
	private var __remember_ch:CheckBox;
	private var __submit_pb:Button;
	
	public function LoginForm()
	{
	}
	
	private function onInitialized():Void
	{
		super.onInitialized();
		
		__username_ti.setChangeCallback(this, onTextChanged);
		__password_ti.setChangeCallback(this, onTextChanged);
		__username_lbl.text = "Username";
		__password_lbl.text = "Password";
		__password_ti.password = true;
		
		__remember_ch.setReleaseCallback(this, onRemember);
		__remember_ch.label = "Remember Me";
		__remember_ch.setSize(120, __remember_ch.height);
		
		__submit_pb.setReleaseCallback(this, onSubmit);
		__submit_pb.label = "Login";
		
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
		
		commitProperties();
	}
	
	private function commitProperties():Void
	{
		super.commitProperties();
		
		if(__usernameDirty == true)
		{
			__usernameDirty = false;
			__username_ti.text = __username;
		}
		
		if(__passwordDirty == true)
		{
			__passwordDirty = false;
			__password_ti.text = __password;
		}
		
		if(__rememberDirty == true)
		{
			__rememberDirty = false;
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
		__remember = __remember_ch.selected;
		//DebugWindow.debug("__remember: " + __remember);
		__rememberDirty = true;
		invalidateProperties();
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
	
	private function onTextChanged(p_event:ShurikenEvent):Void
	{
		if(p_event.target == __username_ti)
		{
			__username = __username_ti.text;
		}
		else if(p_event.target == __password_ti)
		{
			__password = __password_ti.text;
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
		p_so.data.username = __username;
		p_so.data.password = __password;
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