import com.jxl.shuriken.controls.LinkButton;

class com.jxl.goocal.views.GCLinkButton extends LinkButton
{
	public static var SYMBOL_NAME:String = "com.jxl.goocal.views.GCLinkButton";
	
	public function GCLinkButton()
	{
	}
	
	private function createChildren():Void
	{
		super.createChildren();
		
		if(__mcLabel != null)
		{
			var fmt:TextFormat = __mcLabel.getTextFormat();
			fmt.color = 0x0066CC;
			__mcLabel.setTextFormat(fmt);
			__mcLabel.setNewTextFormat(fmt);
		}
	}
}