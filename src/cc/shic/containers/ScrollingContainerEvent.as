package cc.shic.containers 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class ScrollingContainerEvent extends Event 
	{
		public static const ON_MOVE:String = "onMove";
		public static const ON_ZOOM:String = "onZoom";
		public static const ON_CHANGE_SIZE:String = "onChangeSize";
		
		
		public function ScrollingContainerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ScrollingContainerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScrollingContainerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}