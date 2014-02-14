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
	import com.greensock.TweenMax;
	import config.Css;
	import display.pictos.PictoPlay128;
	import display.VideoMenu;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author david
	 */
	public class MainVideoPlayer extends Sprite 
	{
		
		public var videoUrl:String;
		public var videoLowDefUrl:String;
		public var posterUrl:String;
		//public var poster:EasyLoader;
		public var poster:*;
		public var srtUrl:String;
		public var gaId:String;
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
		private var posterContainer:Sprite;
		private var posterPlay:PictoPlay128;
		private var conteneurImage:Loader;
		private var conteneurImageRequest:URLRequest;
		private var alreadyPlayed:Boolean = false;
		
		
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
			ShicConfig.debug = true;
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
			
		}
		/**
		 * met à disposion les flash vars
		 */
		private function initFlashVars():void
		{
			//EN LIGNE
			this.videoUrl = Utils.flashVarsGet("videoUrl", "");
			this.videoLowDefUrl = Utils.flashVarsGet("videoLowDefUrl", "");
			this.posterUrl = Utils.flashVarsGet("posterUrl", "");
			this.srtUrl = Utils.flashVarsGet("srtUrl", "");
			this.gaId = Utils.flashVarsGet("gaId", "");
			//LOCALE
			/*this.videoUrl = Utils.flashVarsGet("videoUrl", "http://thinkadelik.fr/kids/medias/videos/Lila_cayeux_HD.mp4");
			this.videoLowDefUrl = Utils.flashVarsGet("videoLowDefUrl", "http://thinkadelik.fr/kids/medias/videos/Lila_cayeux_LD.mp4");
			this.posterUrl = Utils.flashVarsGet("posterUrl", "http://thinkadelik.fr/kids/medias/photos/Lila_cayeux.jpg");
			//this.srtUrl=Utils.flashVarsGet("srtUrl", "http://clement.de.shic.cc/the-drone-v2/xml/subtitles/srt2usf/media/the-drone/2010/11/sethtroxler.srt");
			//this.gaId = Utils.flashVarsGet("gaId", "UA-11817273-5");*/
			//PARAMS
			this.loop = Utils.getBool(Utils.flashVarsGet("loop", "false"));
			this.autoplay = Utils.getBool(Utils.flashVarsGet("autoplay", "false"));
			//Lancement netstream au debut ou pas 
			this.autoload = Utils.getBool(Utils.flashVarsGet("autoload", "false"));
			//true || false : Si true le poster est étirée pour matcher les dimenssions du cadre
			this.posterScaling  = Utils.getBool(Utils.flashVarsGet("posterScaling", "true"));
			//true || false : Si false la totalité du poster est affiché, bordure noire si le cadre est plus grand
			this.posterCrop  = Utils.getBool(Utils.flashVarsGet("posterCrop", "true"));
			//true || false : Si true la vidéo est étirée pour matcher les dimenssions du cadre
			this.videoScaling  = Utils.getBool(Utils.flashVarsGet("videoScaling", "true"));
			//true || false : Si false la totalité de la vidéo est affichée, bordure noire si le cadre est plus grand
			this.videoCrop  = Utils.getBool(Utils.flashVarsGet("videoCrop", "false"));	
			//
			build();
		}
		
		/**
		 * met en place tout le bazar
		 */
		private function build():void
		{
			//on verifie que autoload est bien sur true au cas ou autoplay est true
			if (autoplay) autoload = true;
			
			mouseTimer = new MouseTimer(800, Utils.stage);
			mouseTimer.addEventListener(CustomEvent.ON_SLEEPING, hideMenu);
			mouseTimer.addEventListener(CustomEvent.ON_MOVING, showMenu);
			
			
			posterContainer = new Sprite();
			posterPlay = new PictoPlay128();
			if (posterUrl != "") {
				loadPoster(posterUrl);
			}else{
				createEmptyPoster();
			}
			
			
			
		}
		
		private function createSrt():void 
		{
			srtField.text = " ";
			Css.textFormatSubtitles.applyTo(srtField);
			srtField.filters = [Css.subtitlesShadow];
		}
		
		private function createMenu():void 
		{
			menu = new VideoMenu(Utils.getBool(this.videoLowDefUrl));
			menu.visible = false;
			menu.addEventListener(CustomEvent.ON_QUALITY_CHANGE, onQualityChange);
			menu.height = Css.menuHeight;
			menu.onPlayStatus = onPlayStatus;
		}
		/**
		 * invoqué qd le status de lecture change
		 * @param	playing true si en cours de lecteur, false sinon
		 */
		private function onPlayStatus( playing : Boolean ):void {
			trace("onPlayStatus")
			var videoTime:Number;
			video.stream ? videoTime = video.stream.time : videoTime = 0;
			var currentPostContVisible:Boolean = posterContainer.visible;
			var nextPostContVisible:Boolean = !playing && (videoTime == 0);
			if (currentPostContVisible && (nextPostContVisible == false)) {
				TweenMax.to(posterContainer, 0.3, { autoAlpha:0 } );
			}else {
				posterContainer.visible = nextPostContVisible;
				posterContainer.alpha = 1;
			}
			//video.visible = !posterContainer.visible;
			video.visible = !nextPostContVisible;
			srtField.visible = playing;
			try {
				if(ExternalInterface.available){
					ExternalInterface.call( "VideoPlayer.onPlayStatus" ,  playing  );
				}
			}catch ( e : * ) {
				// not embeddeded
			}
		}
		/**
		 * Cache le menu...
		 * @param	e
		 */
		private function hideMenu(e:CustomEvent):void 
		{
			if(menu){
				menuVisible = menu.playPause.paused;
				if (Utils.getNumber(menu.playPause.paused) == 0) {
					TweenMax.to(menu, 0.3, { autoAlpha:0 } );
				}
				resize();
			}
		}
		/**
		 * Affiche le menu
		 * @param	e
		 */
		private function showMenu(e:CustomEvent):void 
		{
			if(menu){
				TweenMax.to(menu, 0.3, { autoAlpha:1 } );
				menuVisible = true;
				resize();
			}
		}
		/**
		 * Charge une vidéo
		 * @param	url
		 * @param	autoLoad
		 */
		private function loadVideo(url:String, autoLoad:Boolean = true ):void
		{
			if(video){
				video.stop();
				video.destroy();
				removeChild(video);
				video = null;
			}
			video = new EasyVideo(url, !autoplay, loop,autoLoad);
			video.addEventListener( CustomEvent.ON_PLAY_COMPLETE , function():void {
				video.time = 0;
				menu.play( loop );
			});
			video.addEventListener(MouseEvent.CLICK, function clicVideo():void { menu.play(!video.playing); } );
			video.doubleClickEnabled = true;
			video.addEventListener(MouseEvent.DOUBLE_CLICK, dubbleClikFullscreen);
			//
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
		
		private function dubbleClikFullscreen(e:MouseEvent = null):void
		{
			toggleFullScreen();
			video.playing ? menu.play(false) : menu.play(true);
			
		}
		/**
		 * affiche le poster
		 * @param	e
		 */
		private function showPoster(e:* = null):void 
		{
			posterContainer.visible = true;
		}
		/**
		 * cache le poster
		 * @param	e
		 */
		private function hidePoster(e:* = null):void 
		{
			posterContainer.visible = false;
		}
		/**
		 * cree le poster avec un fond noir
		 * @param	url
		 */
		private function createEmptyPoster():void {
			trace("createEmptyPoster");
			poster = new SquareShape(100, 100, 0x000000, 1);
			posterContainer.addChild(poster);
			posterContainer.addChild(posterPlay);
			posterLoaded();
		}
		/**
		 * charge le poster
		 * @param	url
		 */
		private function loadPoster( url :String ):void {
			trace("loadPoster");
			/*poster = new EasyLoader( url , false , 0.5, true, true);
			posterContainer.visible = false;
			posterContainer.alpha = 0;
			posterContainer.addChild(poster);
			posterContainer.addChild(posterPlay);
			poster.addEventListener( Event.COMPLETE , posterLoaded );*/
			
			poster = new Sprite();
			poster.alpha = 0;
			posterContainer.addChild(poster);
			posterContainer.addChild(posterPlay);
			//
			conteneurImage = new Loader();
			conteneurImageRequest = new URLRequest(url);
			
			//function onProgress(e:ProgressEvent):void
			//{
			//    var p:Number=(e.bytesLoaded*100)/e.bytesTotal;
			//    trace(p);
			//}
			//conteneurImage.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			conteneurImage.contentLoaderInfo.addEventListener(Event.COMPLETE, posterImgLoaded);
			conteneurImage.load(conteneurImageRequest);
		}
		
		private function posterImgLoaded(e:Event):void
		{
			var image:Bitmap = Bitmap(conteneurImage.content);
			image.smoothing = true;
			poster.addChild(image);
			posterLoaded();
		}
			
		private function posterLoaded(e:Event = null):void 
		{
			trace("poster loaded");
			resize();
			
			if(!autoplay) TweenMax.to(poster, 0.5, { autoAlpha:1 } );
			//
			autoload ? posterContainer.visible = !autoplay : posterContainer.visible = true;
			posterContainer.buttonMode = true;
			posterContainer.addEventListener(MouseEvent.CLICK, clicPoster);
			//
			if (autoload) {
				createMenu();
				createSrt();
				loadVideo(videoUrl, autoload);
			}
		}
		//
		private function clicPoster(e:MouseEvent = null):void
		{
			if (autoload){
				menu.play(true);
			}else {
				autoload = true;
				trace("autoload: " + autoload);
				createMenu();
				createSrt();
				loadVideo(videoUrl, autoload);
				menu.play(true);
			}
			
		}
		/**
		 * invoqué quand les meta de la vidéo sont disponibles, entraine un resize et le chargement des sous titres
		 * @param	e
		 */
		private function onMetaData(e:CustomEvent):void 
		{
			trace("onMetaData");
			resize();
			//trace(Utils.requestedFlashVarsGet)
			if (srtUrl) {
				var subtitles:Subtitles = new Subtitles();
				subtitles.load(srtUrl);
				subtitles.textField = srtField;
				subtitles.linkToStream(video.stream, srtField);
				subtitles.addEventListener(CustomEvent.ON_CHANGE, setPositionSrt);	
			}
			//trace(Utils.requestedFlashVarsGet);
			if (!alreadyPlayed) {
				alreadyPlayed = true;
				try {
					if(ExternalInterface.available){
						ExternalInterface.call( "gaPlayerAction" ,  "firstPlay"  );
					}
				}catch ( e : * ) {
					// not embeddeded
				}
			}
		}
		/**
		 * Quand on toggle hi et low quality
		 * @param	e
		 */
		private function onQualityChange(e:CustomEvent):void {
			autoplay = video.playing;
			if (e.currentPosition == 0) {
				loadVideo(videoLowDefUrl);
			}else {
				loadVideo(videoUrl);
			}
			if (video.playing) menu.play(true); 
			
		}
		

		private function setPositionSrt(e:*= null):void {
			srtField.width = stage.stageWidth * 0.75;
			if(menu){
				menuVisible ? srtField.y = menu.y - srtField.height - 30 : srtField.y = stage.stageHeight - srtField.height - 30;
			}else {
				srtField.y = stage.stageHeight - srtField.height - 30;
			}
			srtField.x = stage.stageWidth / 2 - srtField.width / 2;
		}
		
		
		
		private function resize(e:*=null):void 
		{
			trace("resize");
			if(menu){
				menu.width = stage.stageWidth;
				menu.y = stage.stageHeight - menu.height;
			}
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
				posterPlay.x = stage.stageWidth / 2 - posterPlay.width / 2;
				posterPlay.y = stage.stageHeight / 2 - posterPlay.height / 2;
				addChild(posterContainer);

			}
			//
			if(menu) addChild(menu);
			if(srtField) setPositionSrt();
		}
		
		/**
		 * gère les racourcis clavier utilisateurs
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
		/**
		 * passe en full screen ou l'inverse en fonction du status actuel
		 * @param	e
		 */
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