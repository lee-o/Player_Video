package cc.shic.mouse.cursor.gnome_2_19_6 
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
	public class Crop extends Sprite
	{
		[Embed(source='stockCrop.png')]
		private var icoClass:Class;
		private var ico:Bitmap=new icoClass()
		
		public function Crop() 
		{
			//ico.width = ico.height = 16;
			addChild(ico);
			ico.smoothing = false;
			ico.blendMode = BlendMode.INVERT;
			/*
			var contour:GlowFilter = new GlowFilter();
			contour.color = 0xffffff;
			contour.strength = 20;
			contour.blurX = contour.blurY = 2;
			contour.alpha = 1;
			ico.filters = [contour];
			*/
			
		}
		
	}

}