package cc.shic.imageEncoder 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class ImageEncoderEvent extends Event 
	{
		
		public static const ENCODING_COMPLETE:String = "encodingComplete";
		
		/**
		 * Les données résultantes
		 */
		private var imageData:ByteArray;
		
		public function ImageEncoderEvent(type:String,data:ByteArray ,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			imageData = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ImageEncoderEvent(type, imageData,bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ImageEncoderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}