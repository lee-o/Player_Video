package cc.shic.display 
{
	import cc.shic.events.CustomEvent;
	import cc.shic.ShicConfig;
	import cc.shic.Utils;
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author shic
	 */
	
	 /**
	  * Evènement renvoyé pendant le loading
	  */
	[Event(name = "onLoading", type = "cc.shic.events.CustomEvent")]
	
	
	public class EasyLoader extends Loader
	{
		private var file:String;
		private var fadeIn:Boolean;
		private var fadeInDuration:Number;
		private var useCache:Boolean;
		private var smoothing:Boolean;
		private var useBytes:Boolean;
		private static var cacheBitmapData:Dictionary = new Dictionary();
		public var loaded:Boolean = false;
		private static var _debug:Boolean = true;
		

		private var chargeur:URLLoader = new URLLoader ();


		
		public function EasyLoader(_file:String=null,_fadeIn:Boolean=false,_fadeInDuration:Number=0.5,_useCache:Boolean=true,_smoothing:Boolean=false,_useBytes:Boolean=true) 
		{
			
			
			file = _file;
			fadeIn = _fadeIn;
			fadeInDuration = _fadeInDuration;
			useBytes = _useBytes;
			if (!useBytes) {
					_useCache = false;
			}
			useCache = _useCache;
			smoothing = _smoothing;
			chargeur.dataFormat=URLLoaderDataFormat.BINARY;
			
			if (fadeIn) {
				alpha = 0;
			}
			
			if (file) {
				loadUrl(file);
			}else {
				
			}

			
		}
		
		public function loadUrl(url:String):void {
			file = url;
			if(debug){
				trace("cc.shic.EasyLoader load file : " + file);
			}

			if (cacheBitmapData[file] && useCache) {
				//on affiche à partir du cache et le fichier est déjà chargé
				onComplete();		
			}else if (useCache) {
				//on affiche à partir du cache mais le fichier n'est pas encore chargé
				chargeur.addEventListener(Event.COMPLETE, onComplete);//
				chargeur.addEventListener(IOErrorEvent.IO_ERROR, onError);//
				this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);//
				chargeur.load(new URLRequest(file));
				chargeur.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress);

			}else {
				//on ne s'occupe pas du cache on loade le fichier simplement
				this.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);//
				this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				this.load(new URLRequest(file));
				this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			}
			
		}
		
		private function onLoadingProgress(e:ProgressEvent):void 
		{
			dispatchEvent(new CustomEvent(CustomEvent.ON_LOADING, e.bytesLoaded, e.bytesTotal));
		}
		
		/**
		 * En cas d'erreur de chargement...
		 * @param	e
		 */
		private function onError(e:IOErrorEvent):void 
		{
			trace("Easy loader a rencontré une erreur: "+e.text);
		}
		
		
		
		
		[Event(name="complete", type="flash.events.Event")]
		/**
		 * Quand le fichier et fini d'être chargé
		 * @param	e
		 */
		private function onComplete(e:Event=null):void 
		{

			
			if (useCache) {
				if(e){
					cacheBitmapData[file] = e.target.data;
				}
				this.loadBytes(cacheBitmapData[file]);
			}
			
			this.addEventListener(Event.ENTER_FRAME, ready);
			
		}
		
		
		private function ready(e:Event=null):void 
		{
			
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);//
			chargeur.removeEventListener(Event.COMPLETE, onComplete);//
			chargeur.removeEventListener(IOErrorEvent.IO_ERROR, onError);//
			
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			chargeur.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			
			
			if (this.width > 0) {
				this.removeEventListener(Event.ENTER_FRAME, ready);
				if (smoothing) {
					Utils.smoothRecursive(this);
				}
				dispatchEvent(new Event(Event.COMPLETE));
				
				if (fadeIn) {
					TweenLite.to(this, fadeInDuration, { 
					alpha:1 
					} 
				);
				}
				loaded = true;
				chargeur = null;
			}
			

		}
		/**
		 * Détruit les listeners de l'objet et le loader de bytes si il est utilisé
		 */
		public function destroy():void {
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			this.removeEventListener(Event.ENTER_FRAME, ready);
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			if(chargeur){
				chargeur.removeEventListener(Event.COMPLETE, onComplete);
				chargeur.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				chargeur.removeEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
				chargeur = null;
			}
		}
		
		public static function get debug():Boolean 
		{
			return (_debug && ShicConfig.debug);
			
		}
		
		public static function set debug(value:Boolean):void 
		{
			_debug = value;
		}
	}
}