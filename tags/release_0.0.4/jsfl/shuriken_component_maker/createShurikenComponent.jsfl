var PATH_COMPONENT_MAKER					= "file:///C|:\Documents and Settings\Syle\My Documents\_Projects\Google Calendar Flash Lite\jsfl\shuriken_component_maker";
var FOLDER_NAME 							= "JXL/shuriken_component_maker";
var XML_FILE_NAME 							= "ShurikenComponentMaker.xml";
var BOUNDING_BOX_LAYER_NAME 				= "bounding box";
var BOUNDING_BOX 							= "BoundingBox";
var BOUNDING_BOX_INSTANCE_NAME 				= "__boundingBox_mc";
var ASSETS_LAYER_NAME 						= "assets";
var SHURIKEN_COMPONENT_CLASS_NAME 			= "com.jxl.shuriken.core.UIComponent"; 
var SHURIKEN_COMPONENT_NAME 				= "UIComponent";
var FOLDER_SHURIKEN_COMPONENT_ASSETS 		= "com/jxl/shuriken/core/UIComponent Assets/";

function createShurikenComponent(p_symbolName, p_className, p_baseClass, p_additionalComponents)
{
	//clearDebug();
	//debugHeader();
	
	var theSymbolName;
	var theClassName;
	var theBaseClass;
	if( (p_symbolName == undefined || p_symbolName == "") && (p_className == undefined || p_className == "") && (p_baseClass == undefined || p_baseClass == ""))
	{
		// get the symbol name and class name
		var results = fl.getDocumentDOM().xmlPanel(fl.configURI + FOLDER_NAME + "/" + XML_FILE_NAME);
		if(results.dismiss != "accept") return;
		theSymbolName 	= results.symbolName;
		theClassName 	= results.className;
		theBaseClass 	= results.baseClass;
	}
	else
	{
		theSymbolName 	= p_symbolName;
		theClassName 	= p_className;
		theBaseClass 	= p_baseClass;
	}
	
	// if symbol exists, abort
	var newSymbolExists = fl.getDocumentDOM().library.itemExists(theSymbolName);
	if(newSymbolExists == true)
	{
		debug("[Create Shuriken Component] " + theSymbolName + " already exists, aborting.");
		return;
	}
	
	// if class name already exists, abort
	var cnLen = fl.getDocumentDOM().library.items.length;
	while(cnLen--)
	{
		var cnItemCheck = fl.getDocumentDOM().library.items[cnLen];
		if(cnItemCheck.linkageClassName == theClassName)
		{
			debug("[Create Shuriken Component] The class '" + theClassName + "' already exists, aborting.");
			return;
		}
	}
	
	// if Component doesn't exist, create it
	var shurikenComponentItem;
	var libItems = fl.getDocumentDOM().library.items;
	var libLen = libItems.length;
	while(libLen--)
	{
		var searchItem = libItems[libLen];
		if(searchItem.linkageClassName == SHURIKEN_COMPONENT_CLASS_NAME)
		{
			shurikenComponentItem = searchItem;
			break;
		}
	}
	
	if(shurikenComponentItem == null)
	{
		shurikenComponentItem = createComponentShell(SHURIKEN_COMPONENT_NAME, SHURIKEN_COMPONENT_CLASS_NAME);
	}
	
	var newComponent = createComponentShell(theSymbolName, theClassName);
	fl.getDocumentDOM().library.editItem(newComponent.name);
	
	// new layer
	var timeline = fl.getDocumentDOM().getTimeline();
	var assetsLayerIndex = timeline.addNewLayer(ASSETS_LAYER_NAME, "normal", true);
	timeline.reorderLayer(assetsLayerIndex, assetsLayerIndex + 1, false);
	timeline.setLayerProperty("layerType", "guide");
	
	// make frame 2
	timeline.convertToBlankKeyframes(1);
	timeline.currentFrame = 1;
	
	if(theBaseClass == SHURIKEN_COMPONENT_CLASS_NAME)
	{
		// shuriken component on new layer
		fl.getDocumentDOM().addItem({x:0, y:0}, shurikenComponentItem); 
		fl.getDocumentDOM().align("left", true);
		fl.getDocumentDOM().align("top", true);
	}
	else
	{
		// low-risk implementation:
		// - look for the component
		// - if found, attach it, otherwise, silently fail
		var baseClassComponentItem = findItemInLibraryByClassName(fl.getDocumentDOM().library, theBaseClass);
		if(baseClassComponentItem != null)
		{
			fl.getDocumentDOM().addItem({x:0, y:0}, baseClassComponentItem); 
			fl.getDocumentDOM().align("left", true);
			fl.getDocumentDOM().align("top", true);
		}
	}
	
	// any additional components to add?
	if(p_additionalComponents != null && p_additionalComponents.length > 0)
	{
		// low-risk implementation:
		// - look for the component
		// - if found, attach it, otherwise, silently fail
		var adcCounterX = 0;
		var adcInc = 20;
		var adcLen = p_additionalComponents.length;
		while(adcLen--)
		{
			var additionalComponentName = p_additionalComponents[adcLen];
			var additionalComponentItem = findItemInLibraryByClassName(fl.getDocumentDOM().library, additionalComponentName);
			if(additionalComponentItem != null)
			{
				// I know my x and y are being negated by the align,
				// need to fix; the x and y are not always relative to top left
				fl.getDocumentDOM().addItem({x:adcCounterX, y:0}, additionalComponentItem); 
				fl.getDocumentDOM().align("left", true);
				fl.getDocumentDOM().align("top", true);
				adcCounterX += adcInc;
			}
		}
	}
}

function findItemInLibraryByClassName(pLibrary, p_className)
{
	var libItems = pLibrary.items;
	var i = libItems.length;
	while(i--)
	{
		var item = libItems[i];
		if(item.linkageClassName == p_className)
		{
			return item;
		}
	}
	return null;
}

function createComponentShell(p_symbolName, p_className)
{
	// create symbol name
	fl.getDocumentDOM().library.addNewItem("movie clip", p_symbolName);
	var selItems = fl.getDocumentDOM().library.getSelectedItems();
	var item = selItems[0];
	// create symbol class name
	item.linkageExportForAS = true;
	item.linkageExportInFirstFrame = true;
	item.linkageClassName = p_className;
	item.linkageIdentifier = p_className;
	
	// stop on first layer
	fl.getDocumentDOM().library.editItem(p_symbolName);
	var timeline = fl.getDocumentDOM().getTimeline();
	timeline.layers[0].name = "Actions";
	timeline.layers[0].frames[0].actionScript = "stop();";
	
	// bounding box on new layer
	// if bounding box doesn't exist, create it
	var boundingBoxExists = fl.getDocumentDOM().library.itemExists(BOUNDING_BOX);
	var boundingBoxInFolderExists = fl.getDocumentDOM().library.itemExists(FOLDER_SHURIKEN_COMPONENT_ASSETS + BOUNDING_BOX);
	if(boundingBoxExists == false && boundingBoxInFolderExists == false)
	{
		fl.getDocumentDOM().library.addNewItem("movie clip", BOUNDING_BOX);
		var boundingBoxSelectedItems = fl.getDocumentDOM().library.getSelectedItems();
		var boxItem = boundingBoxSelectedItems[0];
		fl.getDocumentDOM().library.editItem(boxItem.name);
		fl.getDocumentDOM().addNewRectangle({left:0,top:0,right:100,bottom:100}, 0);
		// color the box
		fl.getDocumentDOM().mouseClick({x:16, y:16}, false, true);
		fl.getDocumentDOM().mouseDblClk({x:16, y:16}, false, false, true);
		fl.getDocumentDOM().setFillColor("#CCCCCC");
		fl.getDocumentDOM().setStrokeColor("#333333");
		fl.getDocumentDOM().setStrokeSize(0.05);
		fl.getDocumentDOM().setStrokeStyle("hairline");
		fl.getDocumentDOM().library.editItem(p_symbolName);
	}
	
	var boundingBoxItemIndex = fl.getDocumentDOM().library.findItemIndex(BOUNDING_BOX);
	if(boundingBoxItemIndex == "")
	{
		boundingBoxItemIndex = fl.getDocumentDOM().library.findItemIndex(FOLDER_SHURIKEN_COMPONENT_ASSETS + BOUNDING_BOX);
	}
	var boundingBoxItem = fl.getDocumentDOM().library.items[boundingBoxItemIndex];
	
	var boundingBoxLayerIndex = timeline.addNewLayer(BOUNDING_BOX_LAYER_NAME, "normal", true);
	timeline.reorderLayer(boundingBoxLayerIndex, boundingBoxLayerIndex + 1, false);
	fl.getDocumentDOM().addItem({x:0, y:0}, boundingBoxItem);
	var boxItemOnDocument = fl.getDocumentDOM().selection[0];
	boxItemOnDocument.name = BOUNDING_BOX_INSTANCE_NAME;
	if(p_className == "com.jxl.shuriken.core.UITextField")
	{
		boxItemOnDocument.height = 18;
	}
	fl.getDocumentDOM().align("left", true);
	fl.getDocumentDOM().align("top", true);
	
	return item;
}

function debug(o)
{
	fl.trace(o);
}

function debugProps(o)
{
	for(var p in o)
	{
		debug(p + ": " + o[p]);
	}
}

function clearDebug()
{
	fl.outputPanel.clear();
}

function debugHeader()
{
	debug("-----------------------");
}
























