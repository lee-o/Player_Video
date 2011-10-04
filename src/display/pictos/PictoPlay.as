package display.pictos 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author david
	 */

	public class PictoPlay extends Sprite
	{

		[Embed(source="/assets/play.png")]
		public var PictoPlayClass:Class;
		
		public function PictoPlay() 
		{
			addChild(new PictoPlayClass());
		}
		
	}

}