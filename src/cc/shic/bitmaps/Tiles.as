package cc.shic.bitmaps 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class Tiles extends BitmapData
	{
		private var dessin:Shape;
		
		public function Tiles(color1:uint=0xffffff,color2:uint=0xcccccc,alpha:Number=0.8,size:Number=8,margin:Number=0,bgAlpha:Number=2) 
		{
			if (bgAlpha==2) {
				bgAlpha = alpha;
			}
			super(size*2+margin*3, size*2+margin*3, true, 0xff0000);
			
			dessin = new Shape();
			var g:Graphics = dessin.graphics;
			
			g.beginFill(color1, bgAlpha);
			g.drawRect(0, 0, this.width, this.height);
			//g.drawRect(size, size, size, size);
			
			g.beginFill(color2, alpha);
			g.drawRect(size+margin*2, 0+margin, size, size);
			g.drawRect(0+margin, size+margin*2, size, size);
			
			build();
		}
		private function build():void {
			this.draw(dessin);
		}
		
	}

}