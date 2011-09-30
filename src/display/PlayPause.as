package display 
{
	//import cc.shic.display.EasyLoader;
	import cc.shic.display.Square;
	import cc.shic.display.text.TexfieldMonoline;
	import cc.shic.display.text.TextStyleFormat;
	import cc.shic.Utils;
	import com.greensock.TweenMax;
	import config.Config;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	

	/**
	 * ...
	 * @author david
	 */
	public class PlayPause extends Sprite 
	{
		[Embed(source="/assets/play.png")]
		public var PlayPicture:Class;
		[Embed(source="/assets/pause.png")]
		public var PausePicture:Class;
		
		//public var pictoPlay:EasyLoader ;
		public var pictoPlay:Bitmap ;
		//public var pictoPause:EasyLoader;
		public var pictoPause:Bitmap;
		//
		public var background:Square;
		
		private var _paused:Boolean = true;
		
		public function PlayPause() 
		{
			//pictoPlay = new EasyLoader(Utils.flashVarsGet("playBtn", Config.racine + "img/videoPlayer/play.png"));
			pictoPlay = new PlayPicture();
			//pictoPause = new EasyLoader(Utils.flashVarsGet("pauseBtn", Config.racine + "img/videoPlayer/pause.png"));
			pictoPause = new PausePicture();
			
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