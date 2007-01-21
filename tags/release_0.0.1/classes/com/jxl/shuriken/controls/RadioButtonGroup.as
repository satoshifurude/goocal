import mx.utils.Delegate;

import com.jxl.shuriken.core.IUIComponent;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.controls.RadioButton;
import com.jxl.shuriken.vo.RadioButtonVO;
import com.jxl.shuriken.events.ShurikenEvent;

class com.jxl.shuriken.controls.RadioButtonGroup extends List
{
	//REQUIRED INFO/------------------------------------------
	
	public static var SYMBOL_NAME:String = "com.jxl.shuriken.controls.RadioButtonGroup";
	
	private var __lastSelectedChild:RadioButton;
	
	public function init():Void
	{
		super.init();
		
		__childClass 					= RadioButton;
		__childSetValueScope 			= this;
		__childSetValueFunction 		= onSetRadioButtonValue;
		__direction 					= DIRECTION_VERTICAL;
	}
	
	private function onSetRadioButtonValue(p_child:RadioButton, p_index:Number, p_item:Object):Void
	{
		// assumes p_item is a RadioButtonVO
		var rbvo:RadioButtonVO 			= RadioButtonVO(p_item);
		p_child.label 					= rbvo.label;
		p_child.selected 				= rbvo.selected;		
	}
	
	private function setupChild(p_child:IUIComponent):Void
	{
		super.setupChild(p_child);
		
		p_child.addEventListener(ShurikenEvent.RELEASE, Delegate.create(this, onRadioButtonRelease));
	}
	
	private function onRadioButtonRelease(p_event:ShurikenEvent):Void
	{
		if(__lastSelectedChild != null) __lastSelectedChild.selected = false;
		var lastRadioButton:RadioButton = __lastSelectedChild;
		var lastSelectedIndex:Number = getChildIndex(__lastSelectedChild);
		var lastSelectedItemVO:RadioButtonVO = RadioButtonVO(__dataProvider.getItemAt(lastSelectedIndex));
		__dataProvider.itemUpdated(lastSelectedItemVO, "selected", lastSelectedItemVO.selected, false);
		__lastSelectedChild = RadioButton(p_event.target);
		p_event.target.selected = true;
		var releasedIndex:Number = getChildIndex(RadioButton(p_event.target));
		var releasedItemVO:RadioButtonVO = RadioButtonVO(__dataProvider.getItemAt(releasedIndex));
		__dataProvider.itemUpdated(releasedItemVO, "selected", releasedItemVO.selected, true);
		
		var event:ShurikenEvent = new ShurikenEvent(ShurikenEvent.RADIO_BUTTON_CLICKED, true);
		event.radioButton = RadioButton(p_event.target);
		event.lastRadioButton = lastRadioButton;
		event.index = releasedIndex;
		event.lastIndex = lastSelectedIndex;
		dispatchEvent(event);
	}
	
	
}