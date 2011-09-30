package 
{
	import cc.shic.display.EasyLoader;
	import cc.shic.display.SquareShape;
	import cc.shic.display.subtitles.Subtitles;
	import cc.shic.display.text.FontLoader;
	import cc.shic.display.text.TexfieldMonoline;
	import cc.shic.display.text.TexfieldMultiline;
	import cc.shic.display.video.EasyVideo;
	import cc.shic.events.CustomEvent;
	import cc.shic.mouse.MouseTimer;
	import cc.shic.ShicConfig;
	import cc.shic.StageUtils;
	import cc.shic.Utils;
	import cc.shic.xml.EasyXml;
	import cc.shic.xml.EasyXmlEvent;
	import com.havana.LangCode;
	import display.BackgroundMenu;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.text.Font;
	
	/**
	 * ...
	 * @author david
	 */
	public class MainEmbedVideoPlayer extends Sprite 
	{
		public var txtSprite:Sprite;
		public var videoUrl:String;
		public var videoLowDefUrl:String;
		public var posterUrl:String;
		public var poster:EasyLoader;
		public var srtUrl:String;
		public var autoPlay:Boolean = false;
		public var loop:Boolean = false;
		public var xmlUrl:String;
		public var infoXml:EasyXml;
		public var titleTxt:String;
		public var baselineTxt:String;
		public var linkUrl:String;
		public var racine:String;
		private var video:EasyVideo;
		private var menu:VideoMenu;
		private var masque:SquareShape = new SquareShape(100, 100, 0xff0000, 0.5);
		private var masque2:SquareShape = new SquareShape(100, 100, 0xff0000, 0.5);
		private var srtField:TexfieldMultiline = new TexfieldMultiline();
		private var mouseTimer:MouseTimer;
		private var muted : Boolean = false;
		private var overlaySprite:Sprite;
		private var backgroundMenu:BackgroundMenu;
		//private var fontLoader:FontLoader;
		
		
		
		[Embed(source = 'font/Fonts.swf', fontName = 'Futura Std Condensed', fontWeight="normal ", fontStyle="normal")] 
		public static var FuturaStdCnd:Class;
		
		
		public function MainEmbedVideoPlayer():void 
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
			//
			//FontLoader.debug = true;
			//fontLoader = new FontLoader("font.swf", "Futura");
			
			initXml();			
		}
		
		/**
		 * Charge le xml initial 
		 */
		private function initXml():void
		{
			this.xmlUrl = Utils.flashVarsGet("xmlUrl","http://clement.de.shic.cc/havana-v2/en/int/xml/video?v=3042&p=104&m=1&l=2");
			//this.xmlUrl = Utils.flashVarsGet("xmlUrl","http://clement.de.shic.cc/havana-v2/en/int/xml/video?v=3042&p=3041&m=1&l=2");
			infoXml = new EasyXml(xmlUrl);
			infoXml.addEventListener(EasyXmlEvent.COMPLETE, initFlashVars);
		}
		
		private function initFlashVars(e:EasyXmlEvent):void
		{
			LangCode.current = e.xml.langue;
			this.racine = Utils.flashVarsGet("racine", e.xml.racine);
			Config.racine = racine;
			//
			this.titleTxt = Utils.flashVarsGet("titleTxt", e.xml.page.title);
			this.baselineTxt = Utils.flashVarsGet("baselineTxt", e.xml.page.baseline);
			this.linkUrl = Utils.flashVarsGet("linkUrl", e.xml.page.website);
			//
			this.videoUrl = Utils.flashVarsGet("videoUrl", e.xml.video.url);
			//this.posterUrl = Utils.flashVarsGet("poster", "http://clement.de.shic.cc/havana-v2/media/img/Iskander-preview.jpg");
			this.posterUrl = Utils.flashVarsGet("poster", e.xml.video.poster);
			//
			this.srtUrl = Utils.flashVarsGet("srtUrl", e.xml.subtitle.url);
			//
			this.videoLowDefUrl = Utils.flashVarsGet("videoLowDefUrl", "");
			this.loop = false;
			this.autoPlay = false;
			//
			build();
		}
		
		private function build():void
		{
			
			mouseTimer = new MouseTimer(5000, this);
			mouseTimer.addEventListener(CustomEvent.ON_SLEEPING, hideMenu);
			mouseTimer.addEventListener(CustomEvent.ON_MOVING, showMenu);
			
			backgroundMenu = new BackgroundMenu();
			addChild(backgroundMenu);
			
			menu = new VideoMenu(Utils.getBool(this.videoLowDefUrl));
			menu.visible = false;
			menu.addEventListener(CustomEvent.ON_QUALITY_CHANGE, onQualityChange);
			menu.height = Css.menuHeight;
			menu.onPlayStatus = onPlayStatus;
			
			srtField.text = " ";
			Css.textFormatSubtitles.applyTo(srtField);
			srtField.filters = [Css.subtitlesShadow];

			createTitle();
			
			loadPoster(posterUrl);
			loadVideo(videoUrl);
			
			resize();
			
		}
		
		private function createTitle():void
		{
			txtSprite = new Sprite();
			//
			if(titleTxt != "" || baselineTxt != ""){
				overlaySprite = new Sprite();
				drawOverlay(overlaySprite);
				overlaySprite.blendMode = BlendMode.MULTIPLY;
			}
			//
			var title:TexfieldMonoline = new TexfieldMonoline();
			title.text = titleTxt;
			Css.textFormatTitle.applyTo(title);
			title.filters = [Css.titleShadow];
			title.x = 16;
			title.y = -36;
			//
			var baseline:TexfieldMonoline = new TexfieldMonoline();
			baseline.text = baselineTxt;
			Css.textFormatBaseline.applyTo(baseline);
			baseline.filters = [Css.titleShadow];
			if(titleTxt != ""){
				baseline.x = title.x + title.width + 16;
			}else {
				baseline.x = 16;
			}
			baseline.y = title.y + 11;
			//
			if(overlaySprite){
				txtSprite.addChild(overlaySprite);
			}
			txtSprite.addChild(title);
			txtSprite.addChild(baseline);
			//
			txtSprite.y = menu.y;
			addChild(txtSprite);
		}
		
		private function drawOverlay(cible:Sprite):void
		{
			cible.graphics.clear();
			cible.graphics.beginFill(0xd80000);
			cible.graphics.moveTo(0, 0);
			cible.graphics.lineTo(stage.stageWidth, 0);
			cible.graphics.lineTo(stage.stageWidth, -80);
			cible.graphics.lineTo(0, -40);
			cible.graphics.lineTo(0, 0);
			cible.graphics.endFill();
		}
		
		private function drawBitmap(cible:Sprite):void
		{
			cible.graphics.clear();
			cible.graphics.beginFill(0xd80000);
			cible.graphics.moveTo(0, 0);
			cible.graphics.lineTo(stage.stageWidth, 0);
			cible.graphics.lineTo(stage.stageWidth, -80);
			cible.graphics.lineTo(0, -40);
			cible.graphics.lineTo(0, 0);
			cible.graphics.endFill();
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
			//trace("hide "+mouseTimer.sleeping);
			menu.visible = menu.playPause.paused;
			txtSprite.visible = menu.visible;
			resize();
		}
		private function showMenu(e:CustomEvent):void 
		{
			//trace("show "+mouseTimer.sleeping);
			menu.visible = true;
			txtSprite.visible = true;
			resize();
		}
		private function loadVideo(url:String):void
		{
			if(video){
				video.stop();
				video.destroy();
				removeChild(video);
				video = null;
			}
			video = new EasyVideo(videoUrl, !autoPlay, loop);
			video.addEventListener( CustomEvent.ON_PLAY_COMPLETE , function():void {
				video.time = 0;
				menu.play( loop );
			});
			
			//autoPlay = true; // au deuxielme lancement video ce sera toujours autoplay
			video.mask = masque;
			menu.video = video;
			menu.visible = true;
			menu.play( autoPlay );
			
			addChild(video);
			addChild(menu);
			addChild(masque);
			addChild(srtField);
			
			if ( poster ) {
				addChild( poster );
				addChild( masque2 );
				poster.mask = masque2;
			}
			
			addChild(txtSprite);
			
			resize();
			
			video.addEventListener(CustomEvent.ON_META_DATA, onMetaData);
			
		}
		
		private function loadPoster( url :String ):void {
			poster = new EasyLoader( url , true );
			Utils.smoothRecursive(poster);
			poster.addEventListener( Event.COMPLETE , function( e:* = null ):void {
				resize();
			});
			poster.visible = autoPlay;
			addChild( poster );
			addChild( menu );
			addChild(txtSprite);
			
		}
		
		private function onMetaData(e:CustomEvent):void 
		{
			resize();
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
			//trace("video low def? "+e.currentPosition);
			if (e.currentPosition == 0) {
				//trace("low def video");
				loadVideo(videoLowDefUrl);
			}else {
				//trace("hi def video");
				loadVideo(videoUrl);
			}
		}
		

		private function setPositionSrt(e:*= null):void {
			srtField.width = stage.stageWidth * 0.75;
			srtField.y = menu.y - srtField.height - 30;
			srtField.x = stage.stageWidth / 2 - srtField.width / 2;
		}
		
		
		
		private function resize(e:*=null):void 
		{
			//menu.visible = true;
			menu.width = stage.stageWidth;
			
			
			masque.x = masque.y = masque2.x = masque2.y = 0;
			masque2.width = masque.width = stage.stageWidth;
			
			if(!menu.visible){
				menu.y = stage.stageHeight;
			}else {
				menu.y = stage.stageHeight - menu.height;
			}
			masque.height = masque2.height = menu.y;
			
			video.width = stage.stageWidth;
			video.scaleY = video.scaleX;
			if(stage.displayState == StageDisplayState.NORMAL){
					if (video.height < masque.height) {
						video.height = stage.stageHeight;
						video.scaleX = video.scaleY;
					}
					video.y = stage.stageHeight / 2 - video.height / 2;
				}else {
					if (video.height > masque.height-40) {
						video.height = masque.height-40;
						video.scaleX = video.scaleY;
					}
					video.y = menu.y / 2 - video.height / 2;
				}
				
			video.x = stage.stageWidth / 2 - video.width / 2;
			
			// poster showall
			if ( poster ) {
				//poster.scaleX = poster.scaleY = 1;
				poster.visible = menu.playPause.paused;
				var r:Number = 1.0;
				//if ( poster.width > stage.stageWidth ) {
					r = stage.stageWidth / poster.width;
					poster.width *= r;
					poster.height *= r;
				//}
				//if ( poster.height > stage.stageHeight ) {
				if ( poster.height < stage.stageHeight ) {
					r = stage.stageHeight / poster.height;
					poster.width *= r;
					poster.height *= r;
				}
				poster.x = ( stage.stageWidth - poster.width ) / 2;
				poster.y = ( stage.stageHeight - poster.height ) / 2;
				addChild(poster);
			}
			
			if (overlaySprite)
			{
				drawOverlay(overlaySprite);
			}
			
			addChild(backgroundMenu);
			backgroundMenu.y = menu.y;
			backgroundMenu._height = menu.height;
			backgroundMenu._width = stage.stageWidth;
			//
			addChild(menu);
			//
			txtSprite.y = menu.y;
			addChild(txtSprite);
			//
			addChild(srtField);
			//
			setPositionSrt();
			
		}
		
	}
	
}