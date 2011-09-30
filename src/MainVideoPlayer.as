package 
{
	import cc.shic.display.EasyLoader;
	import cc.shic.display.SquareShape;
	import cc.shic.display.subtitles.Subtitles;
	import cc.shic.display.text.TexfieldMultiline;
	import cc.shic.display.video.EasyVideo;
	import cc.shic.events.CustomEvent;
	import cc.shic.mouse.MouseTimer;
	import cc.shic.ShicConfig;
	import cc.shic.StageUtils;
	import cc.shic.Utils;
	import com.greensock.TweenLite;
	import config.Css;
	import display.VideoMenu;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author david
	 */
	public class MainVideoPlayer extends Sprite 
	{
		
		public var videoUrl:String;
		public var videoLowDefUrl:String;
		public var posterUrl:String;
		public var poster:EasyLoader;
		public var srtUrl:String;
		public var autoplay:Boolean = false;
		public var posterScaling:Boolean;
		private var posterCrop:Boolean;
		public var videoScaling:Boolean;
		public var videoCrop:Boolean;
		public var loop:Boolean = false;
		private var video:EasyVideo;
		private var menu:VideoMenu;
		private var srtField:TexfieldMultiline = new TexfieldMultiline();
		private var mouseTimer:MouseTimer;
		private var muted : Boolean = false;
		public var HdOn:String;
		public var HdOff:String;
		public var autoload:Boolean;
		private var buildMenu:ContextMenu;
		private var menuVisible:Boolean = true;
		
		
		public function MainVideoPlayer():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			// entry point
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			ShicConfig.debug = false;
			EasyLoader.debug = false;
			Utils.stage = stage;
			StageUtils.TopLeftNoScale();
			stage.addEventListener(Event.RESIZE, resize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//
			buildMenu = new ContextMenu();
			buildMenu.hideBuiltInItems();
			contextMenu = buildMenu;
			//
			initFlashVars();
			build();
			
		}
		
		private function initFlashVars():void
		{
			this.videoUrl = Utils.flashVarsGet("videoUrl", "http://lionel.de.shic.cc/player/medias/videos/Lila_cayeux_HD.mp4?"+Math.random()*1000);
			//this.videoUrl = Utils.flashVarsGet("videoUrl", "");
			this.videoLowDefUrl = Utils.flashVarsGet("videoLowDefUrl", "http://lionel.de.shic.cc/player/medias/videos/Lila_cayeux_LD.mp4?"+Math.random()*1000);
			//this.videoLowDefUrl = Utils.flashVarsGet("videoLowDefUrl", "");
			this.posterUrl = Utils.flashVarsGet("posterUrl", "http://lionel.de.shic.cc/player/medias/photos/_Lila_cayeux.jpg");
			//this.posterUrl = Utils.flashVarsGet("posterUrl", "");
			//this.srtUrl=Utils.flashVarsGet("srtUrl", "http://clement.de.shic.cc/the-drone-v2/xml/subtitles/srt2usf/media/the-drone/2010/11/sethtroxler.srt");
			//this.srtUrl=Utils.flashVarsGet("srtUrl", "http://www.piaget.ae/xml/subtitles/srt2usf?file=media/vitrine2_VA_AR-11.srt");
			this.srtUrl=Utils.flashVarsGet("srtUrl", "");
			this.loop = Utils.getBool(Utils.flashVarsGet("loop", "false"));
			this.autoplay = Utils.getBool(Utils.flashVarsGet("autoplay", "false"));
			//Lancement netstream au debut ou pas --> non fonctionnel
			//this.autoload = Utils.getBool(Utils.flashVarsGet("autoload", "false"));
			//true || false : Si true le poster est étirée pour matcher les dimenssions du cadre
			this.posterScaling  = Utils.getBool(Utils.flashVarsGet("posterScaling", "true"));
			//true || false : Si false la totalité du poster est affiché, bordure noire si le cadre est plus grand
			this.posterCrop  = Utils.getBool(Utils.flashVarsGet("posterCrop", "true"));
			//true || false : Si true la vidéo est étirée pour matcher les dimenssions du cadre
			this.videoScaling  = Utils.getBool(Utils.flashVarsGet("videoScaling", "true"));
			//true || false : Si false la totalité de la vidéo est affichée, bordure noire si le cadre est plus grand
			this.videoCrop  = Utils.getBool(Utils.flashVarsGet("videoCrop", "false"));
			
		}
		
		private function build():void
		{
			
			mouseTimer = new MouseTimer(5000, Utils.stage);
			mouseTimer.addEventListener(CustomEvent.ON_SLEEPING, hideMenu);
			mouseTimer.addEventListener(CustomEvent.ON_MOVING, showMenu);
			
			menu = new VideoMenu(Utils.getBool(this.videoLowDefUrl));
			menu.visible = false;
			menu.addEventListener(CustomEvent.ON_QUALITY_CHANGE, onQualityChange);
			menu.height = Css.menuHeight;
			menu.onPlayStatus = onPlayStatus;
			
			srtField.text = " ";
			Css.textFormatSubtitles.applyTo(srtField);
			srtField.filters = [Css.subtitlesShadow];

			loadPoster(posterUrl);
			//loadVideo(videoUrl,autoload);
			loadVideo(videoUrl);
			
			resize();
			
		}
		private function onPlayStatus( flag : Boolean ):void {
			poster.visible = !flag && (video.stream.time == 0);
			video.visible = !poster.visible;
			srtField.visible = flag;
			try{
				ExternalInterface.call( "VideoPlayer.onPlayStatus" ,  flag  );
			}catch ( e : * ) {
				// not embeddeded
			}
		}
		
		private function hideMenu(e:CustomEvent):void 
		{
			menuVisible = menu.playPause.paused;
			if (Utils.getNumber(menu.playPause.paused) == 0) {
				TweenLite.to(menu, 0.3, { autoAlpha:0 } );
			}
			resize();
		}
		private function showMenu(e:CustomEvent):void 
		{
			TweenLite.to(menu, 0.3, { autoAlpha:1 } );
			menuVisible = true;
			resize();
		}
		private function loadVideo(url:String, autoLoad:Boolean = true ):void
		{
			if(video){
				video.stop();
				video.destroy();
				removeChild(video);
				video = null;
			}
			video = new EasyVideo(url, !autoplay, loop,autoLoad);
			//autoplay = true;
			video.addEventListener( CustomEvent.ON_PLAY_COMPLETE , function():void {
				video.time = 0;
				menu.play( loop );
			});
			video.addEventListener(MouseEvent.CLICK,function clicVideo():void{menu.play(!video.playing);});
			
			//autoplay = true; // au deuxielme lancement video ce sera toujours autoplay
			menu.video = video;
			menu.visible = true;
			menu.play( autoplay );
			
			//
			addChild(video);
			//
			addChild(srtField);
			//
			resize();
			//
			video.addEventListener(CustomEvent.ON_PLAY_COMPLETE, showPoster);
			video.addEventListener(CustomEvent.ON_META_DATA, onMetaData);
		}
		
		private function showPoster(e:* = null):void 
		{
			poster.visible = true;
		}
		
		private function hidePoster(e:* = null):void 
		{
			poster.visible = false;
		}
		
		private function loadPoster( url :String ):void {
			poster = new EasyLoader( url , true ,0.5,true,true);
			poster.addEventListener( Event.COMPLETE , function( e:*= null ):void {
				resize();
			});
			poster.visible = autoplay;
			poster.addEventListener(MouseEvent.CLICK,function clicPoster():void{menu.play(true)});
		}
		
		private function onMetaData(e:CustomEvent):void 
		{
			resize();
			trace(Utils.requestedFlashVarsGet)
			if (srtUrl) {
				var subtitles:Subtitles = new Subtitles();
				subtitles.load(srtUrl);
				subtitles.textField = srtField;
				subtitles.linkToStream(video.stream, srtField);
				subtitles.addEventListener(CustomEvent.ON_CHANGE, setPositionSrt);	
			}
			//trace(Utils.requestedFlashVarsGet);
		}
		
		private function onQualityChange(e:CustomEvent):void 
		{
			//trace("video low def? " + e.currentPosition);
			autoplay = video.playing;
			if (e.currentPosition == 0) {
				loadVideo(videoLowDefUrl);
			}else {
				//trace("hi def video");
				loadVideo(videoUrl);
			}
			if (video.playing) menu.play(true); 
			
		}
		

		private function setPositionSrt(e:*= null):void {
			srtField.width = stage.stageWidth * 0.75;
			menuVisible ? srtField.y = menu.y - srtField.height - 30 : srtField.y = stage.stageHeight - srtField.height - 30;
			srtField.x = stage.stageWidth / 2 - srtField.width / 2;
		}
		
		
		
		private function resize(e:*=null):void 
		{
			menu.width = stage.stageWidth;
			//
			menu.y = stage.stageHeight - menu.height;
			//
			if (video) {
				var maxWidthVideo:Number;
				var maxHeightVideo:Number;
				//
				if (videoScaling) {
					maxWidthVideo = stage.stageWidth;
					maxHeightVideo = stage.stageHeight;
				}else {
					maxWidthVideo = Math.min(stage.stageWidth,video.client.width);
					maxHeightVideo = Math.min(stage.stageHeight,video.client.height);
				}
				video.width = maxWidthVideo;
				video.scaleY = video.scaleX;
				//
				if (videoCrop) {
					if (video.height < maxHeightVideo) {
						video.height = maxHeightVideo;
						video.scaleX = video.scaleY;
					}
				}else {
					if (video.height > maxHeightVideo) {
						video.height = maxHeightVideo;
						video.scaleX = video.scaleY;
					}
				}
				//
				video.y = stage.stageHeight / 2 - video.height / 2;
				video.x = stage.stageWidth / 2 - video.width / 2;
			}				
			//
			//
			if ( poster ) {
				var maxWidthPoster:Number;
				var maxHeightPoster:Number;
				//
				if (posterScaling) {
					maxWidthPoster = stage.stageWidth;
					maxHeightPoster = stage.stageHeight;
				}else {
					poster.scaleX = poster.scaleY = 1;
					maxWidthPoster = Math.min(stage.stageWidth,poster.width);
					maxHeightPoster = Math.min(stage.stageHeight, poster.height);
				}
				poster.width = maxWidthPoster;
				poster.scaleY = poster.scaleX;
				//
				if (posterCrop) {
					if (poster.height < maxHeightPoster) {
						poster.height = maxHeightPoster;
						poster.scaleX = poster.scaleY;
					}
				}else {
					if (poster.height > maxHeightPoster) {
						poster.height = maxHeightPoster;
						poster.scaleX = poster.scaleY;
					}
				}
				//
				poster.y = stage.stageHeight / 2 - poster.height / 2;
				poster.x = stage.stageWidth / 2 - poster.width / 2;
				addChild(poster);
			}
			//
			addChild(menu);
			setPositionSrt();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private function onKeyDown(e:KeyboardEvent):void
		{	
			//Touche s
			if ( e.keyCode.toString() == "83" )
			{
				/*if ( available ){
					// We toggle the StageVideo on and off (fallback to Video and back to StageVideo)
					toggleStageVideo(inited = !inited);
				}*/
			//Touche f
			} else if ( e.keyCode.toString() == "70" ){
				toggleFullScreen();
			//Barre espace
			} else if ( e.keyCode == Keyboard.SPACE ) {
				menu.play(!video.playing);
			}
		}
		
		private function toggleFullScreen(e:* = null):void 
		{
			if (Utils.stage.displayState == StageDisplayState.FULL_SCREEN) {
				StageUtils.setFullScreenOut();
			}else {
				StageUtils.setFullScreen();
			}
		}
		
	}
	
}