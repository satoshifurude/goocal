import com.jxl.shuriken.controls.ToolTip;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.managers.DepthManager;

class com.jxl.shuriken.managers.ToolTipManager
{
	
	public static var hideDelay:Number = 1000;
	public static var showDelay:Number = 500;
	public static var scrubDelay:Number = 100;
	public static var toolTipClass:ToolTip = ToolTip;
	public static var currentTaget:Component;
	public static var currentToolTip:ToolTip;
	
	public static function createToolTip(pText:String, pX:Number, pY:Number, pContext:Component):Void
	{
		//destroyToolTip(currentToolTip);
		// HACK: using _root as the base level for the tooltip.  This assumes no one is at the tooltip
		// depth which is a bad assumption to make.  I refush to use a reserved depth movieclip like
		// Macromedia does with their systemmanager / depthmanager where it creates an MC to reserve
		// the depth.  This would cause too many issues with the badly written code we're forced to deal
		// with, thus we have to write some bad code to compensate.  For now, use _root; later,
		// hopefully we can create a SystemManager to hanldle depths for Applications, even loaded ones.
		//currentToolTip = ToolTip(_root.attachMovie(toolTipClass.symbolName, "__mcToolTip", DepthManager.DEPTH_TOOLTIP));
		//currentToolTip.move(pX, pY);
		//currentToolTip.text = pText;
	}
	
	public static function destroyToolTip(pToolTip:ToolTip):Void
	{
		if(currentToolTip != null) currentToolTip.removeMovieClip();
	}
	
}