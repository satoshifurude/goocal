<?php

	require_once("com/jxl/goocal/vo/AuthorVO.php");
	require_once("com/jxl/goocal/vo/WhenVO.php");

	class EntryVO
	{
		public $id;
		public $published;
		public $updated;
		public $title;
		public $description;
		public $authorVO; // AuthorVO;
		public $sendEventNotifications;
		public $where;
		public $whenVO; // WhenVO;
		public $comments_array;
	}
?>