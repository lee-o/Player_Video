package cc.shic.ui 
{
	import cc.shic.CssConfig;
	import cc.shic.display.SquareShape;
	import cc.shic.Utils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author david
	 */
	public class LoadingBar extends Sprite 
	{
		private var _backgroundBar:DisplayObject;
		private var _progressBar:DisplayObject;
		private var _padding:int = 2;
		
		public function LoadingBar(backgroundBar:DisplayObject=null,progressBar:DisplayObject=null,padding:Number=2) 
		{

			if (!backgroundBar) {
				this.backgroundBar = new SquareShape(100, 20, CssConfig.backgroundColor, 1);
			}else {
				this.backgroundBar = backgroundBar;
			}
			if (!progressBar) {
				this.progressBar = new SquareShape(100, 18, CssConfig.foregroundColor, 1);
			}else {
				this.progressBar=progressBar
			}
			if (padding) {
				this.padding = padding;
			}
			
		}
		
		public function setProgress(current:Number, total:Number):void 
		{
			if(_progressBar && _backgroundBar){
			_progressBar.width = Utils.rapport(current, total, _backgroundBar.width-padding*2, 0, 0);
			}
		}
		
		public function get backgroundBar():DisplayObject 
		{
			return _backgroundBar;
		}
		
		public function set backgroundBar(value:DisplayObject):void 
		{
			if (_backgroundBar) {
				removeChild(backgroundBar);
			}
			_backgroundBar = value;
			addChild(_backgroundBar);
			if (_progressBar) {
				progressBar = _progressBar;
			}
		}
		
		public function get progressBar():DisplayObject 
		{
			return _progressBar;
		}
		
		public function set progressBar(value:DisplayObject):void 
		{
			if (_progressBar) {
				removeChild(_progressBar);
			}
			_progressBar = value;
			addChild(_progressBar);
			if (_padding) {
				padding = padding;
			}
		}
		
		public function get padding():int {return _padding;}
		
		public function set padding(value:int):void 
		{
			_padding = value;
			if (_progressBar) {
				_progressBar.x = progressBar.y = _padding;
			}
			progressBar.height = backgroundBar.height - _padding * 2;
		}
		
		
	}

}