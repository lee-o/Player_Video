package display 
{
	//import cc.shic.display.EasyLoader;
	import cc.shic.display.Square;
	import cc.shic.display.text.TexfieldMonoline;
	import cc.shic.display.text.TextStyleFormat;
	import cc.shic.Utils;
	import com.greensock.TweenMax;
	import config.Config;
	import display.pictos.PictoPause;
	import display.pictos.PictoPlay;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	

	/**
	 * ...
	 * @author david
	 */
	public class PlayPause extends Sprite 
	{

		[Embed(source="/assets/pause.png")]
		public var PausePicture:Class;
		
		public var pictoPlay:PictoPlay=new PictoPlay() ;
		public var pictoPause:PictoPause = new PictoPause();
		//
		public var background:Square;
		
		private var _paused:Boolean = true;
		
		public function PlayPause() 
		{

			
			addChild(pictoPlay);
			addChild(pictoPause);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			
			
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function set paused(value:Boolean):void 
		{
			_paused = value;
			
			if (_paused) {
				pictoPlay.visible = true;
				pictoPause.visible = false;
			}else {
				pictoPlay.visible = false;
				pictoPause.visible = true;
			}
		}
		
	}

}