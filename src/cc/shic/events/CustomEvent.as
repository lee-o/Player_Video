package cc.shic.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class CustomEvent extends Event 
	{
		static public const ON_QUALITY_CHANGE:String = "onQualityChange";
		static public const ON_MOVING:String = "onMoving";
		static public const ON_SLEEPING:String = "onSleeping";
		static public const ON_LOADING:String = "onLoading";
		
		public static const ON_RESIZE:String = "onResize";
		public static const ON_SELECT:String = "onSelect";
		public static const ON_UNSELECT:String = "onUnselect";
		public static const ON_CHANGE:String = "onChange";
		public static const ON_META_DATA:String = "onMetaData";
		public static const ON_PLAY_COMPLETE:String = "onPlayComplete";
		public static const ON_BEFORE_PLAY_COMPLETE:String = "onBeforePlayComplete";
		public static const ON_START:String = "onStart";
		public static const ON_STOP:String = "onStop";
		public static const ON_CLOSE:String = "onClose";
		public static const ON_READY_TO_PLAY:String = "onReadyToPlay";
		public static const ON_DOWNLOAD_COMPLETE:String = "onDownloadComplete";		
		public static const ON_LOADED:String = "onLoaded";
		public static const ON_PLAY_PROGRESS:String = "onPlayProgress";
		public static const ON_BUFFURING:String = "onBuffuring";
		static public const ON_BUFFURING_END:String = "onBuffuringEnd";
		public static const ON_PLAY_START:String = "onPlayStart";
		static public const ON_DELETE:String = "onDelete";
		
		/**
		 * position actuelle
		 */
		public var currentPosition:Number;
		/**
		 * pisition maximale
		 */
		public var maxPosition:Number;
		/*
		[Event(name="onResize", type="cc.shic.events.CustomEvent")]
		 */
		public function CustomEvent(type:String,currentPosition:Number=0,maxPosition:Number=0, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.currentPosition = currentPosition;
			this.maxPosition = maxPosition;
			
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new CustomEvent(type, currentPosition,maxPosition,bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}