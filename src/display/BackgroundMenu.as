package display 
{
	import cc.shic.display.EasyLoader;
	import cc.shic.display.Square;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author lee-o
	 */
	
	public class BackgroundMenu extends Sprite
	{
		private var backgroundMenuPicture:EasyLoader;
		private var bitmapRect:Square;
		
		public function BackgroundMenu() 
		{
			bitmapRect = new Square(200,200,0x000000,1);
			bitmapRect.bitmapFillUrl = Config.racine + "img/territoire.jpg";
			bitmapRect.bitmapRepeatX = true;
			addChild(bitmapRect);
		}
		
		public function set _height(h:Number):void
		{
			bitmapRect.height = h;
		}
		
		public function get _height():Number
		{
			return bitmapRect.height;
		}
		
		public function set _width(w:Number):void
		{
			bitmapRect.width = w;
		}
		
		public function get _width():Number
		{
			return bitmapRect.width;
		}
		
	}

}