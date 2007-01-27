var LOCAL_TEST_PATH 				= "file:///C|/Documents and Settings/Syle/My Documents/_Projects/Google Calendar Flash Lite/jsfl";
var FOLDER_NAME 					= "JXL/shuriken_component_maker";
var FOLDER_SHURIKEN_CORE 			= "com/jxl/shuriken/core";
var FOLDER_SHURIKEN_CONTROLS 		= "com/jxl/shuriken/controls";
var FOLDER_SHURIKEN_CONTAINERS 		= "com/jxl/shuriken/containers";
var FOLDER_SHURIKEN_ASSETS			= "com/jxl/shuriken/core/UIComponent Assets";

function createShurikenComponent(p_symbolName, p_className, p_baseClass, p_AdditionalComponents, p_FolderPath)
{
	//var jsflPath = LOCAL_TEST_PATH + "/" + FOLDER_NAME + "/" + "createShurikenComponent.jsfl";
	var jsflPath = fl.configURI + FOLDER_NAME + "/" + "createShurikenComponent.jsfl";
	debug("jsflPath: " + jsflPath);
	fl.runScript(jsflPath, "createShurikenComponent", p_symbolName, p_className, p_baseClass, p_AdditionalComponents);
	if(p_FolderPath != null) fl.getDocumentDOM().library.moveToFolder(p_FolderPath, p_symbolName, true);
}

function createDir(p_name, p_insideDir)
{
	var lib = fl.getDocumentDOM().library;
	// see if folder exists
	var folderExists;
	if(p_insideDir == null)
	{
		folderExists = lib.itemExists(p_name);
	}
	else
	{
		folderExists = lib.itemExists(p_insideDir + "/" + p_name);
	}
	if(folderExists == false)
	{
		lib.addNewItem("folder", p_name);
		//lib.expandFolder(true, true, p_name);
		if(p_insideDir != null)	lib.moveToFolder(p_insideDir, p_name, true);
	}
}

function createShurikenFramework()
{
	
	// create folders first
	createDir("com");
	createDir("jxl", "com");
	createDir("shuriken", "com/jxl");
	createDir("core", "com/jxl/shuriken");
	createDir("UIComponent Assets", "com/jxl/shuriken/core");
	createDir("controls", "com/jxl/shuriken");
	createDir("containers", "com/jxl/shuriken");
	
	// core
	createShurikenComponent("Container", "com.jxl.shuriken.core.Container", "com.jxl.shuriken.core.UIComponent", null, FOLDER_SHURIKEN_CORE);
	createShurikenComponent("UITextField", "com.jxl.shuriken.core.UITextField", "com.jxl.shuriken.core.UIComponent", null, FOLDER_SHURIKEN_CORE);
	createShurikenComponent("TweenComponent", "com.jxl.shuriken.core.TweenComponent", "com.jxl.shuriken.core.UIComponent", null, FOLDER_SHURIKEN_CORE);
	
	// controls
	createShurikenComponent("SimpleButton", "com.jxl.shuriken.controls.SimpleButton", "com.jxl.shuriken.core.UIComponent", null, FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("Loader", "com.jxl.shuriken.controls.Loader", "com.jxl.shuriken.core.UIComponent", null, FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("Button", "com.jxl.shuriken.controls.Button", "com.jxl.shuriken.controls.SimpleButton", ["com.jxl.shuriken.controls.Loader",
																									  "com.jxl.shuriken.core.UITextField"], FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("Label", "com.jxl.shuriken.controls.Label", "com.jxl.shuriken.core.UITextField", null, FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("LinkButton", "com.jxl.shuriken.controls.LinkButton", "com.jxl.shuriken.controls.SimpleButton", ["com.jxl.shuriken.controls.Label"], FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("ComboBox", "com.jxl.shuriken.controls.ComboBox", "com.jxl.shuriken.core.UIComponent", ["com.jxl.shuriken.core.UITextField",
																									"com.jxl.shuriken.containers.List",
																									"com.jxl.shuriken.containers.ScrollableList",
																									"com.jxl.shuriken.controls.SimpleButton",
																									"com.jxl.shuriken.controls.Button",
																									"com.jxl.shuriken.controls.LinkButton"], FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("RadioButton", "com.jxl.shuriken.controls.RadioButton", "com.jxl.shuriken.controls.Button", ["com.jxl.shuriken.controls.Label"], FOLDER_SHURIKEN_CONTROLS);
	createShurikenComponent("CheckBox", "com.jxl.shuriken.controls.CheckBox", "com.jxl.shuriken.controls.Button", ["com.jxl.shuriken.controls.Label"], FOLDER_SHURIKEN_CONTROLS);
	// TODO: need to create scrollbar components
	createShurikenComponent("TextArea", "com.jxl.shuriken.controls.TextArea", "com.jxl.shuriken.core.UIComponent", ["com.jxl.shuriken.core.UITextField"], FOLDER_SHURIKEN_CONTROLS);
	
	
	// containers
	createShurikenComponent("List", "com.jxl.shuriken.containers.List", "com.jxl.shuriken.core.DataSelectorTemplate", ["com.jxl.shuriken.core.UIComponent",
																													   "com.jxl.shuriken.controls.Label"], FOLDER_SHURIKEN_CONTAINERS);
	createShurikenComponent("ScrollableList", "com.jxl.shuriken.containers.ScrollableList", "com.jxl.shuriken.core.UIComponent", ["com.jxl.shuriken.containers.List",
																												  "com.jxl.shuriken.containers.SimpleButtonList",
																												  "com.jxl.shuriken.controls.SimpleButton"], FOLDER_SHURIKEN_CONTAINERS);
	createShurikenComponent("TileList", "com.jxl.shuriken.containers.TileList", "com.jxl.shuriken.containers.List", ["com.jxl.shuriken.core.UIComponent"], FOLDER_SHURIKEN_CONTAINERS);
	createShurikenComponent("ButtonBar", "com.jxl.shuriken.containers.ButtonBar", "com.jxl.shuriken.containers.List", ["com.jxl.shuriken.controls.Button",
																										 "com.jxl.shuriken.core.UIComponent",
																										 "com.jxl.shuriken.controls.SimpleButton"], FOLDER_SHURIKEN_CONTAINERS);
	
	// controls, continued (dependency on containers)
	createShurikenComponent("RadioButtonGroup", "com.jxl.shuriken.controls.RadioButtonGroup", "com.jxl.shuriken.containers.List", ["com.jxl.shuriken.core.UIComponent",
																												 "com.jxl.shuriken.controls.RadioButton"], FOLDER_SHURIKEN_CONTROLS);
	// clean up
	fl.getDocumentDOM().library.moveToFolder(FOLDER_SHURIKEN_CORE, "UIComponent", true);
	fl.getDocumentDOM().library.moveToFolder(FOLDER_SHURIKEN_CORE + "/UIComponent Assets", "BoundingBox", true);
	
	// expand all
	fl.getDocumentDOM().library.expandFolder(true, true, "com");
}

function debug(o)
{
	//fl.trace(o);
}

function debugHeader()
{
	debug("-------------------");
}

createShurikenFramework();
