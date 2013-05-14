package cc.shic.display
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author david m
	 */
	public class Square extends Sprite
	{
		
		private var _bitmapFillUrl:String;
		private var loader:EasyLoader;
		private var _bmpdFill:BitmapData;
		
		private var _width:Number=100;
		private var _height:Number = 100;
		
		private var _alphaFill:Number=1;
		private var _color:uint = 0xff0000;
		
		private var _showBackground:Boolean = false;
		/**
		 * Si défini sur false, l'imge pourra subir des transformation non homothétiques en modifiant width et height
		 * n'a d'influence que quand un bitmap de remplissage est défini.
		 */
		private var _homothetic:Boolean = true;
		/**
		 * Si défini sur false, le bitmap ne se répetera pas sur les x et laissera place au fond de couleur.
		 */
		private var _bitmapRepeatX:Boolean = true;
		/**
		 * Si défini sur false, le bitmap ne se répetera pas sur les y et laissera place au fond de couleur.
		 */
		private var _bitmapRepeatY:Boolean = true;
		/**
		 * Active ou pas le smmoothing sur le bitmap de remplissage s'il est défini.
		 */
		private var _smoothing:Boolean = false;
		
		/**
		 retourne un carré rouge de 100 / 100 pixels
		 */
		public function Square(width:Number=100,height:Number=100,color:uint=0x00ff00,alphaFill:Number=1) 
		{
			this.width = width;
			this.height = height;
			this.alphaFill = alphaFill;
			this.color = color;

		}
		/**
		 * url d'une image permettant de remplir l'objet avec une trame
		 */
		public function get bitmapFillUrl():String { return _bitmapFillUrl; }
		public function set bitmapFillUrl(value:String):void 
		{
			_bitmapFillUrl = value;
			loader = new EasyLoader();
			loader.addEventListener(Event.COMPLETE, setBitmap);
			loader.loadUrl(_bitmapFillUrl);
			
		}
		
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void 
		{
			_width = value;
			build();
		}
		
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void 
		{
			_height = value;
			build();
		}
		/**
		 * valeur de 0 à 1 utilisée pour définir l'alpha de remplissage
		 */
		public function get alphaFill():Number { return _alphaFill; }
		public function set alphaFill(value:Number):void 
		{
			_alphaFill = value;
			build();
		}
		/**
		 * bitmap data de remplissage
		 */
		public function get bmpdFill():BitmapData { return _bmpdFill; }
		public function set bmpdFill(value:BitmapData):void 
		{
			_bmpdFill = value;
			build();
		}
		/**
		 * couleur de remplissage
		 */
		public function get color():uint { return _color; }
		public function set color(value:uint):void 
		{
			_color = value;
			build();
		}
		
		public function get homothetic():Boolean {return _homothetic;}
		public function set homothetic(value:Boolean):void 
		{
			_homothetic = value;
			build();
		}
		
		public function get bitmapRepeatX():Boolean 	{return _bitmapRepeatX;}		
		public function set bitmapRepeatX(value:Boolean):void 
		{
			_bitmapRepeatX = value;
			build();
		}
		public function get bitmapRepeatY():Boolean 	{return _bitmapRepeatY;}		
		public function set bitmapRepeatY(value:Boolean):void 
		{
			_bitmapRepeatY = value;
			build();
		}		
		public function get smoothing():Boolean {return _smoothing;}		
		public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
			build();
		}
		
		public function get showBackground():Boolean {return _showBackground;}		
		public function set showBackground(value:Boolean):void 
		{
			_showBackground = value;
			build();
		}
		/**
		 * applique le bitmap en remplissage
		 * @param	e
		 */
		private function setBitmap(e:Event):void 
		{
			if (loader) {
				bmpdFill = new BitmapData(Math.max(loader.width,1), Math.max(loader.height,1),true,0x225544);
				bmpdFill.draw(loader);
				build();
			}
		}
		/**
		 * crée la forme
		 */
		private function build():void
		{
			this.graphics.clear();
			if (bmpdFill) {
				drawBitmap();
				return;
			}else {
				this.graphics.beginFill(color, alphaFill);
			}
			if(_width>0 && _height>0){
			this.graphics.drawRect(0, 0, _width, _height);
			}
		}
		/**
		 * crée la forme bitmap
		 */
		private function drawBitmap():void {
			//la couleur de fond
			
			this.graphics.beginFill(color, showBackground?_alphaFill:0);
			if (homothetic && width>0 && height>0) {
				this.graphics.drawRect(0, 0, width, height);
			}
			this.graphics.endFill();
			
			this.graphics.beginBitmapFill(bmpdFill, null, bitmapRepeatX||bitmapRepeatY, smoothing);
			if (!_homothetic) {
				this.graphics.drawRect(0, 0, bmpdFill.width,bmpdFill.height);
				super.width = _width;
				super.height = height;
				return;
			}
			
			if(Math.min(bmpdFill.width, width) > 0 && Math.min(bmpdFill.height, height) >0){
				this.graphics.drawRect(
					0, 0, 
					bitmapRepeatX?width:Math.min(bmpdFill.width, width), 
					bitmapRepeatY?height:Math.min(bmpdFill.height, height)
				);
			}
			this.graphics.endFill();
				

		}
		
	}
}