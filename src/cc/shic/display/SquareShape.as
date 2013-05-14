package cc.shic.display 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	
	/**
	 * Une simple Shape Carrée en une ligne
	 * @author david
	 */
	public class SquareShape extends Shape 
	{
		
		public function SquareShape(width:Number=100,height:Number=100,color:uint=0x00ff00,alphaFill:Number=1) 
		{
			var g:Graphics = this.graphics;
			g.beginFill(color, alphaFill);
			g.drawRect(0, 0, width, height);
		}
		
	}

}