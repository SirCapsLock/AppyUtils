package io.appylife.ui
{
	import mx.utils.UIDUtil;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.PickerList;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	
	import starling.events.Event;

	public class DatePicker extends LayoutGroup
	{
		private var months:Array;
		
		private var monPicker:PickerList;
		private var dayPicker:PickerList;
		private var yearPicker:PickerList;

		private var showYear:Boolean;

		private var yearSpan:int;

		private var startYear:int;
		
		public function DatePicker(showYear:Boolean = true, startYear:int = 0, yearSpan:int = 0)
		{
			this.months = ["January","February", "March", "April","May", "June", "July", "August", "September", "October", "November", "December"];
			
			this.startYear = startYear;
			this.showYear = showYear;
			this.yearSpan = yearSpan;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var thisLayout:AnchorLayout = new AnchorLayout();
			this.layout = thisLayout;
			
			monPicker = new PickerList();
			monPicker.labelField = "text";
			monPicker.listProperties.@itemRendererProperties.labelField = "text";
			var monthData:ListCollection = new ListCollection();
			monthData.push({ text: "" });
			for each(var month:String in months)
			{
				monthData.push({ text: month });
			}
			monPicker.dataProvider = monthData;
			addChild(monPicker);
			
			dayPicker = new PickerList();
			dayPicker.labelField = "text";
			dayPicker.listProperties.@itemRendererProperties.labelField = "text";
			var dayData:ListCollection = new ListCollection();
			
			//default to 31 days in month
			dayData.push({ text: "" });
			for(var i:uint = 1; i <= 31; i++)
			{
				dayData.push({ text: i+"" });
			}
			dayPicker.dataProvider = dayData;
			dayPicker.invalidate(INVALIDATION_FLAG_DATA);
			addChild(dayPicker);
			
			if(showYear)
			{
				yearPicker = new PickerList();
				yearPicker.labelField = "text";
				yearPicker.listProperties.@itemRendererProperties.labelField = "text";
				var lastYear:int = startYear + yearSpan;
				var years:ListCollection = new ListCollection();
				years.push({ text: "" });
				for(var i:uint = startYear; i<= lastYear; i++)
				{
					years.push({ text: i + "" });
				}
				yearPicker.dataProvider = years;
				addChild(yearPicker);
			}
			
			
			/* LAYOUT RULES */
			var dayLayoutData:AnchorLayoutData = new AnchorLayoutData();
			dayLayoutData.verticalCenter = 0;
			dayLayoutData.verticalCenterAnchorDisplayObject = monPicker;
			dayLayoutData.left = 20;
			dayLayoutData.leftAnchorDisplayObject = monPicker;
			dayPicker.layoutData = dayLayoutData;
			
			if(showYear)
			{
				var yearLayoutData:AnchorLayoutData = new AnchorLayoutData();
				yearLayoutData.verticalCenter = 0;
				yearLayoutData.verticalCenterAnchorDisplayObject = monPicker;
				yearLayoutData.left = 20;
				yearLayoutData.leftAnchorDisplayObject = dayPicker;
				yearPicker.layoutData = yearLayoutData;
			}
			
			/* EVENTS */
			monPicker.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(monPicker.selectedIndex != -1)
				{
					var numDays:int = getNumDays(2012, monPicker.selectedIndex);
					var newDays:ListCollection = new ListCollection();
					newDays.push({ text: "" });
					for(var i:uint = 1; i <= numDays; i++)
					{
						newDays.push({ text: i+"" });	
					}
					dayPicker.dataProvider = newDays;
					dayPicker.invalidate(INVALIDATION_FLAG_DATA);
				}
			});
			
		}
		
		public function isValid():Boolean
		{
			if(monPicker.selectedIndex <= 0 || dayPicker.selectedIndex <= 0)
				return false;
			else if(showYear && yearPicker.selectedIndex <= 0)
				return false;
			return true;
		}
		
		public function getYear():int
		{
			if(yearPicker != null)
				return yearPicker.selectedItem.text;
			return new Date().fullYear;
		}
		
		public function getMonthIndex():int
		{
			if(monPicker.selectedIndex > 11)
				return 11;
			return monPicker.selectedIndex - 1;
		}
		
		public function getDay():int
		{
			return dayPicker.selectedIndex;
		}
		
		public function getDate():Date
		{
			return new Date(getYear(), getMonthIndex(), getDay());
		}
		
		public function setMonth(month:int):void
		{
			monPicker.selectedIndex = month;
		}
		
		public function setDay(day:int):void
		{
			dayPicker.selectedIndex = day;	
		}
		
		public function setYear(year:int):void
		{
			if(yearPicker)
				yearPicker.selectedIndex = (year - startYear) + 1;
		}
		
		private function getNumDays(year:int, month:int):int
		{
			return (new Date(year, month, 0)).date;
		}
		
		
		
		override protected function draw():void
		{
			super.draw();
		}
		
	}
}