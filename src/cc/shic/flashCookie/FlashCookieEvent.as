package cc.shic.flashCookie
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author shic
	 */
	public class FlashCookieEvent extends Event 
	{
		public static const REFRESH_INTERVAL_REACHED:String = "refreshIntervalReached";
		public static const CHANGE:String = "change";
		
		public function FlashCookieEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);	
		} 
		
		public override function clone():Event 
		{ 
			return new FlashCookieEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FlashCookieEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}