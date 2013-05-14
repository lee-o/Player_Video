package cc.shic.mouse.cursor.ps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class ResizeObliqueTrBl extends Sprite
	{
		[Embed(source='lib/resizeObliqueTrBl.png')]
		private var icoClass:Class;
		private var ico:Bitmap=new icoClass()
		
		public function ResizeObliqueTrBl() 
		{
			addChild(ico);
			ico.smoothing = false;
			ico.x = ico.y = -20;
		}
		
	}

}