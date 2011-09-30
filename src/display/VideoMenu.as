package  display
{
	import cc.shic.display.SpriteMore;
	import cc.shic.display.Square;
	import cc.shic.display.SquareShape;
	import cc.shic.display.text.TexfieldMonoline;
	import cc.shic.display.video.EasyVideo;
	import cc.shic.events.CustomEvent;
	import cc.shic.Utils;
	import cc.shic.UtilsTime;
	import config.Css;
	import display.FullScreenButton;
	import display.HdToggle;
	import display.PlayPause;
	import display.VolumeControl;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author david
	 */
	[Event(name="onQualityChange", type="cc.shic.events.CustomEvent")]
	public class VideoMenu extends SpriteMore
	{
		
		public var timeField:TexfieldMonoline;
		private var _video:EasyVideo;
		private var background:SquareShape = new SquareShape(10,Css.menuHeight,Css.menuBgColor,Css.menuBgAlpha);
		private var progressBg:SquareShape = new SquareShape(500, Css.progressHeight, Css.progressBgColor);
		private var progressLoading:Square = new Square(500, Css.progressHeight, Css.progressLoadingColor,Css.progressLoadingAlpha);
		private var progress:Square = new Square(500, Css.progressHeight, Css.progressColor);
		private var progressBt:Square = new Square(500, 10, 0x00ff00,0);
		private var fs:FullScreenButton;
		public var playPause:PlayPause;
		private var draggin:Boolean;
		private var volumeControl:VolumeControl;
		private var hd:HdToggle;
		private var onLoadingComplete:Boolean;
		private var videoWasPlaying:Boolean;
		public var hasHdControler:Boolean;
		public var onPlayStatus:Function = function( flag : Boolean ) :void {
			// rien
		}
		
		public function VideoMenu(hasHdControler:Boolean) 
		{
			hasHdControler = hasHdControler;
			
			timeField = new TexfieldMonoline();
			Css.textFormatMenu.applyTo(timeField);
			timeField.text = "00:00 / 00:00";
			
			fs = new FullScreenButton();
			
			playPause = new PlayPause();
			
			volumeControl = new VolumeControl();
			volumeControl.addEventListener(CustomEvent.ON_CHANGE, defineVolume);
			
			try{
				ExternalInterface.addCallback("play", play);
			}catch (e:*) { 
				trace("no external interface"); 
			}
			
			addChild(background);
			addChild(progressBg);
			addChild(progressLoading);
			addChild(progress);
			addChild(progressBt);
			addChild(timeField);
			addChild(fs);
			addChild(volumeControl);
			addChild(playPause);
			
			if(hasHdControler){
				hd = new HdToggle();
				hd.addEventListener(CustomEvent.ON_CHANGE, onHdChange);
				addChild(hd);
			}
			
			//playPause.pictoPause.addEventListener(Event.COMPLETE, onComponentLoaded);
			//playPause.pictoPlay.addEventListener(Event.COMPLETE, onComponentLoaded);
			//volumeControl.bg.addEventListener(Event.COMPLETE, onComponentLoaded);
			//volumeControl.progress.addEventListener(Event.COMPLETE, onComponentLoaded);
			resize();
			
		}
		
		/*private function onComponentLoaded(e:Event):void 
		{
			resize();
		}*/
		
		private function onHdChange(e:CustomEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.ON_QUALITY_CHANGE, hd.isOn?1:0));
		}
		
		private function defineVolume(e:*=null):void 
		{
			if(video){
				video.volume = volumeControl.volume;
			}
		}
		
		public function get video():EasyVideo { return _video; }
		
		public function set video(value:EasyVideo):void 
		{
			_video = value;
			_video.addEventListener(CustomEvent.ON_PLAY_PROGRESS, onProgress);
			_video.addEventListener(CustomEvent.ON_LOADING, onLoading);
			_video.addEventListener(CustomEvent.ON_DOWNLOAD_COMPLETE, onLoading);
			playPause.addEventListener(MouseEvent.CLICK, togglePlayPause);
			progressBt.buttonMode = true;
			progressBt.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			defineVolume();
			
		}
		
		private function stopdrag(e:MouseEvent):void 
		{
			draggin = false;
			Utils.stage.removeEventListener(MouseEvent.MOUSE_MOVE, loopDrag);
			Utils.stage.removeEventListener(MouseEvent.MOUSE_UP, stopdrag);
			loopDrag();
			//_video.play();
			//playPause.paused = false;
			play(videoWasPlaying);
			
		}
		
		private function drag(e:MouseEvent):void 
		{
			draggin = true;
			videoWasPlaying = _video.playing;
			Utils.stage.addEventListener(MouseEvent.MOUSE_UP, stopdrag);
			Utils.stage.addEventListener(MouseEvent.MOUSE_MOVE, loopDrag);
			
		}
		
		private function loopDrag(e:*=null):void 
		{
			_video.time = Utils.rapport(Math.min(mouseX, progressLoading.width), _width, video.duration, 0, 0);
			_video.stop();
		}
		
		private function togglePlayPause(e:*=null):void 
		{
			play( playPause.paused );
		}
		
		public function play( flag : Boolean ) : void
		{
			playPause.paused = !flag;
						
			onPlayStatus( flag );
			
			if ( flag ) {
				_video.play();
			}else {
				_video.stop();
			}		
		}
				
		private function onLoading(e:CustomEvent):void 
		{
			progressBt.width = progressLoading.width = Utils.rapport(e.currentPosition, e.maxPosition, _width, 0, 0);
			if (e.currentPosition==e.maxPosition && e.currentPosition>100) {
				//progressLoading.visible = false;
				onLoadingComplete = true;
			}
			
		}
		
		private function onProgress(e:CustomEvent):void 
		{
			timeField.text = UtilsTime.secondsToHumanMinutes(_video.time) + " / " + UtilsTime.secondsToHumanMinutes(_video.duration);
			progress.width=Utils.rapport(e.currentPosition, e.maxPosition, _width, 0, 0);
		}
		
		public override function resize():void {
			var m:int = 16;
			background.width = _width;
			if(onLoadingComplete){
				progressBt.width = _width;
				progressLoading.width = _width;
			}
			progressBg.width = _width;
			timeField.y = _height / 2 - timeField.height / 2;
			playPause.y = _height / 2 - playPause.height / 2;
			fs.y = Math.floor(_height / 2 - fs.height / 2);
			playPause.x = m;
			timeField.x = playPause.x + playPause.width + m;
			volumeControl.y = _height / 2 - volumeControl.height / 2;
			
			
			if (hd) {
				hd.y = _height / 2 - hd.height / 2;
				hd.x = width - m - hd.width;
				fs.x = hd.x - fs.width - m;
			}else {
				fs.x = width - fs.width - m;
			}
			volumeControl.x = fs.x - volumeControl.width - m;
		}
		
		
	}

}