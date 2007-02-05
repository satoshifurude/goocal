var LOCAL_TEST_PATH 			= "file:///C|/Documents and Settings/Syle/My Documents/_Projects/Google Calendar Flash Lite/jsfl";
var FOLDER_NAME 				= "JXL/shuriken_property_maker";
var XML_FILE_NAME				= "ShurikenPropertyMaker.xml";

function init()
{
	fl.outputPanel.clear();
	var props_array = [];
	
	props_array = gatherProps(props_array);
	debug("props_array: " + props_array);
	if(props_array == null)
	{
		return;
	}
	
	showCode(props_array);
}

function gatherProps(pArray)
{
	var xmlPath = fl.configURI + FOLDER_NAME + "/" + XML_FILE_NAME;
	var results = fl.getDocumentDOM().xmlPanel(xmlPath);
	
	debugHeader();
	debug("xmlPath: " + xmlPath);
	debug("results: " + results);
	debug("results.dismiss: " + results.dismiss);
	
	if(results.dismiss != "accept")
	{
		return;
	}
	else
	{
		theName 					= results.propertyName;
		if(theName == "") return;
		theDataType 				= results.dataType;
		if(theDataType == "")
		{
			alert("Please define a datatype.");
			return;
		}
		theDefaultValue				= (results.defaultValue == "") ? "" : results.defaultValue;
		theInspectableType			=  results.inspectableType;
		theGenVarDef 				= (results.genVarDef == "true") ? true : false;
		theGenGetterSetter			= (results.genGetterSetter == "true") ? true : false;
		theGenInspectable 			= (results.genInspectable == "true") ? true : false;
		theGenCommitProp 			= (results.genCommitProp == "true") ? true : false;
		
		debug("theName: " + theName);
		debug("theDataType: " + theDataType);
		debug("theDefaultValue: " + theDefaultValue);
		debug("theInspectableType: " + theInspectableType);
		debug("theGenVarDef: " + theGenVarDef);
		debug("theGenGetterSetter: " + theGenGetterSetter);
		debug("theGenInspectable: " + theGenInspectable);
		debug("theGenCommitProp: " + theGenCommitProp);
		
		
		var cg = new CodeGen(theName,
								theDataType,
								theDefaultValue,
								theInspectableType,
								theGenVarDef,
								theGenGetterSetter,
								theGenInspectable,
								theGenCommitProp);
		
		if(theName != "" && theName != null)
		{
			if(theDataType != "" && theDataType != null)
			{
				pArray.push(cg);
				if(results.anotherOne == "true")
				{
					pArray = gatherProps(pArray);
					return pArray;
				}
				else
				{
					return pArray;
				}
			}
			else
			{
				return pArray;
			}
		}
		else
		{
			return pArray;
		}
	}
}

function showCode(pArray)
{
	var len = pArray.length;
	for(var i = 0; i<len; i++)
	{
		//var jsflPath = LOCAL_TEST_PATH + "/" + FOLDER_NAME + "/" + "createShurikenProperty.jsfl";
		var jsflPath = fl.configURI + FOLDER_NAME + "/" + "createShurikenProperty.jsfl";
		debugHeader();
		debug("jsflPath: " + jsflPath);
		var o = pArray[i];
		var codeStr = createShurikenProperty(o.name, 
												o.dataType, 
												o.defaultValue,
												o.inspectableType,
												o.genVarDef, 
												o.genGetterSetter, 
												o.genInspectable, 
												o.genCommitProp);
		fl.trace(codeStr);
	}
}

function createShurikenProperty(pName, 
								   pDataType, 
								   pDefaultValue,
								   pInspectableType, 
								   pGenVarDef, 
								   pGenGetterSetter, 
								   pGenInspectable, 
								   pGenCommitProp)
{
	debugHeader();
	debug("createShurikenProperty");
	debug("pName: " + pName);
	debug("pDataType: " + pDataType);
	debug("pDefaultValue: " + pDefaultValue);
	debug("pInspectableType: " + pInspectableType);
	debug("pGenVarDef: " + pGenVarDef);
	debug("pGenGetterSetter: " + pGenGetterSetter);
	debug("pGenInspectable: " + pGenInspectable);
	debug("pGenCommitProp: " + pGenCommitProp);
	
	
	if(pName == null || pName == "") return;
	if(pDataType == null || pDataType == "") return;
	
	var newline = "\n";
	var tab = "\t";
	var code = "";

	if(pGenVarDef == true)
	{
		code += "// property definitions" + newline;
		code += newline;
		code += "private var __" + pName + ":" + pDataType + ";" + newline;
		code += "private var __" + pName + "Dirty:Boolean = false;" + newline;
		code += newline;
	}
	
	if(pGenGetterSetter == true)
	{
		code += "// getter / setter" + newline;
		code += newline;
		
		if(pGenInspectable == true)
		{
			code += "[Inspectable(defaultValue=";
			
			var defaultValue;
			var type = pInspectableType;
			
			if(pDefaultValue == null)
			{
				defaultValue = "'null'";
			}
			else
			{
				switch(pInspectableType)
				{
					case "Array":
						defaultValue = pDefaultValue;
						break;
					
					case "Boolean":
						defaultValue = pDefaultValue;
						break;
					
					case "Color":
						defaultValue = pDefaultValue;
						break;
					
					case "Font Name":
						defaultValue = pDefaultValue;
						break;
					
					case "List":
						defaultValue = pDefaultValue;
						break;
					
					case "Number":
						defaultValue = pDefaultValue;
						break;
					
					case "Object":
						defaultValue = pDefaultValue;
						break;
					
					case "String":
						defaultValue = pDefaultValue;
						break;
				}
			}
			if(defaultValue == "")
			{
				defaultValue = "\"" + defaultValue + "\"";
			}
			code += defaultValue + ", ";
			code += "type=\"" + type + "\")]" + newline;
		}
		
		code += "public function get " + pName + "():" + pDataType + " { return __" + pName + "; }" + newline;
		code += newline;
		code += "public function set " + pName + "(pVal:" + pDataType + "):Void" + newline;
		code += "{" + newline;
		if(pGenVarDef == true)
		{
			code += tab + "if(pVal != __" + pName + ")" + newline;
			code += tab + "{" + newline;
			code += tab + tab + "__" + pName + " = pVal;" + newline;
			code += tab + tab + "__" + pName + "Dirty = true;" + newline;
			code += tab + tab + "invalidateProperties();" + newline;
			code += tab + "}" + newline;
		}
		code += "}" + newline;
		code += newline;
	}
	
	if(pGenCommitProp == true)
	{
		code += "// commitProperties code" + newline;
		code += newline;
		code += "if(__" + pName + "Dirty == true)" + newline;
		code += "{" + newline;
		code += tab + "__" + pName + "Dirty = false;" + newline;
		code += "}" + newline;
		code += newline;
	}
	
	return code;
}
		
function CodeGen(pName, pDataType, pDefaultValue, pInspectableType, pGenVarDef, pGenGetterSetter, pGenInspectable, pGenCommitProp)
{
	this.name 					= pName;
	this.dataType 				= pDataType;
	this.defaultValue			= pDefaultValue;
	this.inspectableType		= pInspectableType;
	this.genVarDef 				= pGenVarDef;
	this.genGetterSetter 		= pGenGetterSetter;
	this.genInspectable 		= pGenInspectable;
	this.genCommitProp 			= pGenCommitProp;
}

function debug(o)
{
	//fl.trace(o);
}

function debugHeader()
{
	debug("-------------------");
}

init();
