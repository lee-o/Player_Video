package cc.shic.mouse.cursor.ps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ResizeObliqueTlBr extends Sprite
	{
		[Embed(source='lib/resizeObliqueTlBr.png')]
		private var icoClass:Class;
		private var ico:Bitmap=new icoClass()
		
		public function ResizeObliqueTlBr() 
		{
			addChild(ico);
			ico.smoothing = false;
			ico.x = ico.y = -20;
		}
		
	}

}