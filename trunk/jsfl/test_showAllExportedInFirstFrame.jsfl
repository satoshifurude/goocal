function init()
{
	fl.outputPanel.clear();
	var i = fl.getDocumentDOM().library.items.length;
	while(i--)
	{
		var theItem = fl.getDocumentDOM().library.items[i];
		if(theItem.linkageExportInFirstFrame == 1)
		{
			//theItem.linkageExportInFirstFrame = false;
			fl.trace(theItem.name + " exported in first frame.");
		}
	}
}

init();