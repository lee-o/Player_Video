package display.pictos 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author david
	 */

	public class PictoPause extends Sprite
	{

		[Embed(source="/assets/pause.png")]
		public var PictoPauseClass:Class;
		
		public function PictoPause() 
		{
			addChild(new PictoPauseClass());
		}
		
	}

}