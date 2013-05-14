package cc.shic.display.video 
{
	
	import cc.shic.events.CustomEvent;
	import cc.shic.ShicConfig;
	import cc.shic.Utils;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * DisplayObject permettant d'afficher une vidéo.
	 * @author david@shic.fr
	 */
	
	/**
	 * Distribué quand la lecture de la vidéo progresse
	 */
	[Event(name = "onPlayProgress", type = "cc.shic.events.CustomEvent")]

	/**
	 * Distribué quand la vidéo est fermée
	 */
	[Event(name = "onClose", type = "cc.shic.events.CustomEvent")]
	/**
	 * evènement renvoyé quand la vidéo arrive au bout de la lecture
	 */
	[Event(name="onPlayComplete", type="cc.shic.events.CustomEvent")]
	/**
	 * evènement renvoyé quand la vidéo se lit
	 */
	[Event(name = "onPlayStart", type = "cc.shic.events.CustomEvent")]
	
	
	
	/**
	 * evènement renvoyé quand la vidéo buffurise
	 */
	[Event(name = "onBuffuring", type = "cc.shic.events.CustomEvent")]
	/**
	 * evènement renvoyé quand la vidéo ne buffurise plus
	 */
	[Event(name = "onBuffuringEnd", type = "cc.shic.events.CustomEvent")]
	/**
	 * Quand le client est renseigné
	 */
	[Event(name = "onMetaData", type = "cc.shic.events.CustomEvent")]
	/**
	 * Quand la vidéo est complètement téléchargée
	 */
	[Event(name = "onDownloadComplete", type = "cc.shic.events.CustomEvent")]
	/**
	 * Quand la vidéo se télécharge (ce qui ne veut pas dire qu'elle n'est pas en cours de lecture)
	 */
	[Event(name="onLoading", type="cc.shic.events.CustomEvent")]
	public class EasyVideo extends Sprite
	{
		/**
		 * Url de la vidéo
		 */
		public var videoURL:String;
		/**
		 * Stream associé à la vidéo
		 */
		public var stream:NetStream;
		/**
		 * Client qui contient notament les meta données de la vidéo
		 */
		public var client:VideoClient;
		/**
		 * Volume sonore de la vidéo
		 */
		private var _volume:Number = 1;
		/**
		 * variable utilisée pour se souvenir du niveau de volume avant une opération de seek
		 * @see audioWhileSeekIng
		 */
		private var saveVolume:Number=_volume;
		
        private var connection:NetConnection;
		/**
		 * Objet graphique de la vidéo
		 */
		private var video:Video;
		/**
		 * Détermine si par défaut la vidéo est arrêtée au démarage.
		 */
		private var stopOnLoad:Boolean = false;
		/**
		 * Applique un smoothing ou pas sur la vidéo
		 */
		private var _smooting:Boolean = true;
		/**
		 * si défini sur true, pendant les opérations de seek, le son sera audible.
		 */
		public var audioWhileSeekIng:Boolean = false;
		/**
		 * si true et que ShicConfig.debug sur true aussi alors renvoie des messages trace.
		 */
		private static var _debug:Boolean = true;
		
		public var loop:Boolean = false;
		private var loaded:Boolean;
		
		private var _playing:Boolean = true;
		
		private var _time:Number;
		private var useStageVideo:Boolean;
		
		public function EasyVideo(videoURL:String,stopOnLoad:Boolean=false,loop:Boolean=false,autoLoad:Boolean=true,useStageVideo:Boolean=true) 
		{
			useStageVideo = useStageVideo;
			this.videoURL = videoURL;
			this.stopOnLoad = stopOnLoad;
			this.loop = loop;
			video = new Video();
			video.smoothing = smooting;
			
			if(autoLoad){
				//création des objets
				load();
			}
			if (useStageVideo) {
				//Utils.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState);
				
				//Utils.stage.addEventListener
				//Utils.stage.addEventListener(StageVideoAvailabilityEvent
			}
		}
		public function load():void {
			connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			//trace(event.info.code);
			switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Unable to locate video: " + videoURL);
                    break;
				case "NetStream.Play.Start":
					dispatchEvent(new CustomEvent(CustomEvent.ON_PLAY_START));
					break;
					
				case "NetStream.Buffer.Empty":
					dispatchEvent(new CustomEvent(CustomEvent.ON_BUFFURING));
					break;
				
				case "NetStream.Buffer.Full":
					dispatchEvent(new CustomEvent(CustomEvent.ON_BUFFURING_END));
					break;	
				
				case "NetStream.Play.Stop":
					if (client.duration-1 <= stream.time) {
						//trace("end video");
						dispatchEvent(new CustomEvent(CustomEvent.ON_PLAY_COMPLETE));
						if (loop) {
							stream.seek(0);
						}
					}
            }
        }
		/**
		 * Quand la connection est étable, on l'attache au stream
		 */
        private function connectStream():void {
			stream = new NetStream(connection);
			//définit le volume de départ
			volume = _volume;
			stream.client = new VideoClient();
			stream.bufferTime = 1;
			client = stream.client as VideoClient;
			client.addEventListener(CustomEvent.ON_META_DATA, onMetaData);
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);

			
            video.attachNetStream(stream);
            stream.play(videoURL);
			if (stopOnLoad) {
				stop();
			}
			
            addChild(video);
			//video.de
			addEventListener(Event.ENTER_FRAME, enterFrame);	
        }
		public function get playing():Boolean 
		{
			return _playing;
		}
		/**
		 * effectue une pause sur la vidéo
		 */
		public function stop():void {
			if(stream){
				stream.pause();
				_playing = false;
			}
		}
		/**
		 * relance la lecture apres une pause
		 */
		public function play():void {
			if(stream){
				stream.resume();
				_playing = true;
			}
		}
		public function destroy():void {
			dispatchEvent(new CustomEvent(CustomEvent.ON_CLOSE));
			if(stream){
				stream.close();
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				stream = null;
			}
			if(client){
				client.removeEventListener(CustomEvent.ON_META_DATA, onMetaData);
				client = null;
			}
			if (video) {
				removeChild(video);
				video = null;
			}
			if (connection) {
				connection.close();
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection = null;
			}
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		/**
		 * boucle pendant la lecture
		 * @param	e
		 */
		private function enterFrame(e:Event):void 
		{
			if (stream && client) {
				dispatchEvent(new CustomEvent(CustomEvent.ON_PLAY_PROGRESS, stream.time, client.duration));
				if (stream.bytesLoaded < stream.bytesTotal) {
					dispatchEvent(new CustomEvent(CustomEvent.ON_LOADING, stream.bytesLoaded, stream.bytesTotal));
				}else if (!loaded) {
					loaded = true;
					dispatchEvent(new CustomEvent(CustomEvent.ON_DOWNLOAD_COMPLETE, stream.bytesLoaded, stream.bytesTotal));
				}
			}
		}

		/**
		 * Quand les meta données de la vidéo sont disponibles
		 * @param	e
		 */
		private function onMetaData(e:CustomEvent):void 
		{
			video.width = client.width;
			video.height = client.height;
			if (_time) {
				time = _time;
			}
			dispatchEvent(new CustomEvent(CustomEvent.ON_META_DATA));
			
		}

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
        
        private function asyncErrorHandler(event:AsyncErrorEvent):void {
            // ignore AsyncErrorEvent events.
			trace("catch asyncErrorHandler");
        }
		/**
		 * Smoothing ou pas sur la vidéo
		 */
		public function get smooting():Boolean { return _smooting; }
		public function set smooting(value:Boolean):void 
		{
			_smooting = value;
			video.smoothing = _smooting;
		}
		/**
		 * Position temporelle actuelle de la vidéo. Redéfinir cette propriété permet de se déplacer dans la vidéo.
		 */
		public function get time():Number { return stream.time; }
		public function set time(_value:Number):void {
			_time = _value;
			if (stream) {
				stream.seek(_value);
				
				if (!audioWhileSeekIng && saveVolume == volume) {
					saveVolume = volume;
					volume = 0;
					TweenMax.to(stream, 0.2, { delay:0.2, volume:saveVolume, 
					onComplete:function():void {
						if(stream){
							volume = saveVolume = stream.soundTransform.volume
						}
					} 
					} );
				}
			}
		}
		/**
		 * Durée de la vidéo, cette donnée est renvoyée par client et n'est donc disponible qu'après l'event CustomEvent.ON_META_DATA
		 */
		public function get duration():Number { return client.duration; }
		
		/**
		 * Renvoie et définit le volume sonore de la vidéo.
		 */
		public function get volume():Number {return _volume;}
		public function set volume(value:Number):void 
		{
			_volume = value;
			if(stream){
				var transform:SoundTransform = new SoundTransform();
				transform.volume = _volume;
				stream.soundTransform = transform;
			}
		}
		static public function get debug():Boolean 
		{
			return _debug && ShicConfig.debug;
		}
		
		static public function set debug(value:Boolean):void 
		{
			_debug = value;
		}
		

	}

}

