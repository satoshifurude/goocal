import mx.controls.listclasses.DataSelector;
import mx.controls.listclasses.DataProvider;

import com.jxl.shuriken.core.Container;

class com.jxl.shuriken.core.DataSelectorTemplate extends Container 
{
	
	private static var dataSelectorMixIn:Boolean = DataSelector.Initialize(DataSelectorTemplate);
	private static var mixIt2 : Boolean = DataProvider.Initialize(Array);	
	

	// Props Mixed In from DataSelector

	// TIPTEXT BLOCK -- PLEASE NOTE, REPLACE ~~ WITH * FOR THIS TO WORK

 	/**
	* @helpid 3218
	* @tiptext the list of data to be used as a model
	**/
	var dataProvider : Object;

 	/**
	* @param index the index at which to add the item
	* @param label the label of the new item
	* @param data the data for the new item
	* @return the added item
	*
	* @helpid 3219
	* @tiptext adds an item to the list
	**/
	var addItemAt : Function;

 	/**
	* @param label the label of the new item
	* @param data the data for the new item
	* @return the added item
	*
	* @helpid 3220
	* @tiptext adds an item to the end of the list
	**/
	var addItem : Function;

	/**
	* @param index the index of the item to remove
	* @return the removed item
	*
	* @helpid 3221
	* @tiptext removes an item from the list
	**/
	var removeItemAt : Function;

	/**
	* @helpid 3222
	* @tiptext removes all items from the list
	**/
	var removeAll : Function;

 	/**
	* @param index the index of the item to replace
	* @param label the label for the replacing item
	* @param data the data for the replacing item
	*
	* @helpid 3223
	* @tiptext adds an item to the list
	**/
	var replaceItemAt : Function;

 	/**
	* @param fieldName the field to sort on
	* @param order either "ASC" or "DESC"
	*
	* @helpid 3224
	* @tiptext sorts the list by some field of each item
	**/
	var sortItemsBy : Function;

 	/**
	* @param compareFunc a function to use for comparison
	*
	* @helpid 3225
	* @tiptext sorts the list by using a compare function
	**/
	var sortItems : Function;

 	/**
	* @helpid 3226
	* @tiptext the length of the list in items
	**/
	var length : Number;

 	/**
	* @param index the index of the items to return
	* @return the item
	*
	* @helpid 3227
	* @tiptext returns the item at the requested index
	**/
	var getItemAt : Function;

 	/**
	* @helpid 3228
	* @tiptext returns the selected data (or label)
	**/
	var value : Object;

	/**
	* @helpid 3229
	* @tiptext returns or sets the selected index
	**/
	var selectedIndex : Number;

 	/**
	* @helpid 3230
	* @tiptext returns or sets the selected indices
	**/
	var selectedIndices : Array;

	/**
	* @helpid 3231
	* @tiptext returns the selected items
	**/
	var selectedItems : Array;

	/**
	* @helpid 3232
	* @tiptext returns the selected item
	**/
	var selectedItem; // relaxed type - could be string but usually object

 	/**
	* @helpid 3233
	* @tiptext allows the control to have multiple selected items
	**/
	var multipleSelection : Boolean = false;



// END TIPTEXT BLOCK

	var __dataProvider : Object;
	var vPosition : Number;
	var __rowCount : Number;
	var enabled : Boolean;
	var lastSelID : Number;
	var lastSelected;
	var selected : Object;

	var invUpdateControl : Boolean;

	var invalidate : Function;
	var createLabel : Function;
	var labelFunction : Function;
	var labelField : String;
	var updateControl : Function;

	var tempLabel : Object;
	var rows : Object;
	var isDragScrolling : Boolean;

 // Functions Mixed in from DataSelector

 	var setDataProvider : Function;
	var getDataProvider : Function;
	var getLength : Function;

	//::: PRIVATE DATA MANAGEMENT METHOD

	var modelChanged : Function;
	var calcPreferredWidthFromData : Function;
	var calcPreferredHeightFromData : Function;

	//::: SELECTION METHODS

	var getValue : Function;
	var getSelectedIndex : Function;
	var setSelectedIndex : Function;
	var getSelectedIndices : Function;
	var setSelectedIndices : Function;
	var getSelectedItems : Function;
	var getSelectedItem : Function;

	// ::: PRIVATE SELECTION METHODS

	var selectItem : Function;
	var isSelected : Function;
	var clearSelected : Function;

}