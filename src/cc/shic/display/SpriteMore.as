package cc.shic.display 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author david
	 */
	public class SpriteMore extends Sprite
	{
		public var _width:Number=300;
		public var _height:Number=300;
		
		public function SpriteMore() 
		{
			
		}
		
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void 
		{
			_height = value;
			resize();
		}
		
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void 
		{
			_width = value;
			resize();
		}
		/**
		 * Méthode appelée à chaque modification de width et height, la plupart du temps elle sera overridée
		 */
		public function resize():void {
			super.width = width;
			super.height = height;
		}
		
	}

}