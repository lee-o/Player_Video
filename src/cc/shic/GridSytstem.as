package cc.shic 
{
	import flash.accessibility.Accessibility;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author david
	 */
	public class GridSytstem 
	{
		public var column:Number = 60;
		public var gutter:Number = 20;
		public var lineHeight:Number = 16;
		private var grid:Sprite;

		public function GridSytstem(column:Number=60,gutter:Number=20,lineHeight:Number=16) 
		{
			this.gutter = gutter;
			this.column = column;
			this.lineHeight = lineHeight;
		}
		/**
		 * retourn y callé sur la ligne superieure.
		 * @param	y
		 * @return
		 */
		public function fitLineHeight(y:Number):Number {
			return Math.ceil(y / lineHeight) * lineHeight;
		}
		public function fitDoubleLineHeight(y:Number):Number {
			return Math.ceil(y / (lineHeight*2)) * (lineHeight*2);
		}
		public function getHeightByLines(line:int ):Number {
			return line * lineHeight;
		}
		public function getWidthByCols(columns:int ):Number {
			return columns * (column)+(columns-1)*gutter;
		}
		
		
		public function getGrid(cols:int = 12, lines:int = 40, color:uint = 0xff0000):Sprite {
			if (grid) {
				return grid
			}
			grid = new Sprite();
			var g:Graphics = grid.graphics;
			
			g.lineStyle(1, color);
			var x:Number;
			var y:Number;
			for (y = 0; y < lines; y++) {
				g.moveTo(0, getHeightByLines(y));
				g.lineTo(getWidthByCols(cols), getHeightByLines(y));
			}
			for (x = 0; x < cols; x++) {
				g.moveTo(getWidthByCols(x), 0);
				g.lineTo(getWidthByCols(x), getHeightByLines(lines));
				g.moveTo(getWidthByCols(x)+gutter, 0);
				g.lineTo(getWidthByCols(x)+gutter, getHeightByLines(lines));
			}
			
			Utils.stage.addEventListener(KeyboardEvent.KEY_UP, onkeyUp);
			
			return grid;
			
		}
		
		private function onkeyUp(e:KeyboardEvent):void 
		{
			trace(e.keyCode);
			if (e.ctrlKey && e.keyCode == 71) {
				
				if (grid) {
					grid.visible = !grid.visible;
				}
			}
		}
		
		
		
		
	}

}