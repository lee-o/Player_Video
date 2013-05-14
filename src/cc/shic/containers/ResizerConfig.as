package cc.shic.containers 
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class ResizerConfig
	{
		public var width:Number=200;
		public var height:Number=200;
		/**
		 * @see StageScaleMode
		 */
		public var scaleMode:String = StageScaleMode.SHOW_ALL;
		/**
		 * @see StageAlign
		 */
		public var align:String="";
		/**
		 * describe if the resulting background is transparent or not.
		 */
		public var transparent:Boolean = false;
		/**
		 * background color of the container
		 */
		public var backgroundColor:uint=0x00ff00;
		
		public function ResizerConfig() 
		{
			
		}
		
	}

}