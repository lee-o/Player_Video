package display.pictos 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author david
	 */

	public class PictoPlay128 extends Sprite
	{

		[Embed(source="/assets/play128.png")]
		public var PictoPlayClass:Class;
		
		public function PictoPlay128() 
		{
			addChild(new PictoPlayClass());
		}
		
	}

}