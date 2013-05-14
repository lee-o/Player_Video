package com.shic.display 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class WebcamEvent extends Event 
	{
		
		public static const ACTIVE:String = "active";
		public static const INACTIVE:String = "inactive";
		public static const ON_START_RECORDING:String = "onStartRecording";
		public static const ON_STOP_RECORDING:String = "onStopRecording";
		
		public function WebcamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new WebcamEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WebcamEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}