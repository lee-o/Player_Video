package org.bytearray.video.events
{
	import flash.events.Event;
	
	import org.bytearray.video.SimpleStageVideo;
	
	public class SimpleStageVideoEvent extends Event
	{
		public static const STATUS:String = "status";

		private var _hwDecoding:Boolean;
		private var _hwCompositing:Boolean;
		private var _fullGPU:Boolean;
		
		public function SimpleStageVideoEvent(type:String, hwDecoding:Boolean, hwCompositing:Boolean, fullGPU:Boolean)
		{
			super(type, false, false);
			_hwDecoding = hwDecoding;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
			_hwCompositing = hwCompositing;
			_fullGPU = fullGPU;
		}
		
		public function get hardwareCompositing():Boolean
		{
			return _hwCompositing;
		}

		public function get hardwareDecoding():Boolean
		{
			return _hwDecoding;
		}	
		
		public function get fullGPU():Boolean
		{
			return _fullGPU;
		}	

		public override function clone():Event
		{
			return new SimpleStageVideoEvent(type, _hwDecoding, _hwCompositing, _fullGPU);
		}
		
		public override function toString():String
		{
			return "[SimpleStageVideoEvent compositing="+_hwCompositing+" decoding="+_hwDecoding+" fullGPU="+_fullGPU+"]";	
		}
	}
}