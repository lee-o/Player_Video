package com.shic.display 
{
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.system.System;
	
	/**
	 * Un dispplay object qui contient un objet vidéo connecté à la webca de l'utilisateur.
	 * @author 
	 */
	public class Webcam extends Sprite
	{
		/**
		 * Objet caméra utilisé
		 */
		public static var cam:Camera;
		/**
		 * Objet vidéo dans lequel est affichée la webcam
		 */
		public var video:Video;
		
		//propriétés personnalisées
		private static var _hasWebcam:Boolean;
		private var _isActive:Boolean;
		private var _mirror:Boolean = false;
		
		/**
		 * adresse de l'application FMS où enregistrer la vidéo 
		 */
		public var rtmpAppAdress:String;
		/**
		 * nom à donner au fichier flv qui sera enregistré
		 */
		public var rtmpRecordName:String;
		/**
		 * netStream pour l'enregistrement
		 */
		private var stream:NetStream;
		/**
		 * NetConnection pour l'enregistrement
		 */
		private var connection:NetConnection;
		
		public function Webcam(initWidth:uint=640,initHeight:uint=480,fps:Number=15,bandwidth:Number=0,quality:Number=90) 
		{
			video = new Video(initWidth, initHeight);	
			if(!cam){
				cam = Camera.getCamera();
				cam.setMotionLevel(1);
				cam.setMode(initWidth, initHeight, fps);
				cam.setQuality(bandwidth,quality);
			}
			video.attachCamera(cam);
			addChild(video);

			cam.addEventListener(StatusEvent.STATUS, onCamStatus);
			//cam.addEventListener(ActivityEvent.ACTIVITY, onCamActivity);
			
			if (stage) {
				init()
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			
		}
		
		private function onCamActivity(e:ActivityEvent):void 
		{
			trace("onCamActivity: " + e.activating);
			checkWebcamStatus();
		}
		
		/**
		 * invoqué quand on sait que la webcm est active
		 */
		[Event(name = "active", type = "com.shic.display.WebcamEvent")]
		/**
		 * invoqué quand on sait que la webcam est inactive
		 */
		[Event(name = "inactive", type = "com.shic.display.WebcamEvent")]
		/**
		 * invoqué quand l'enregistrement de la vidéo débute
		 */
		[Event(name = "onStartRecording", type = "com.shic.display.WebcamEvent")]
		/**
		 * invoqué quand l'enregistrement de la vidéo s'arrête
		 */
		[Event(name="onStopRecording", type="com.shic.display.WebcamEvent")]
		
		
		private function init(e:*=null):void 
		{	
			trace("init webcam");
			trace("cam = " + cam);
			if (cam && !cam.muted) {
				//camera déjà ok
				//effetAfficheImage(video);
				checkWebcamStatus();
			}else if (cam && cam.muted) {
				//caméra a été refusée par le passé donc on force la réouverture de la fenêtre de paramètres
				attendreFermeturePaneauSecurite();
				//askUserToActiveWebcam();
			}
			
			
			
		}
		
		private function attendreFermeturePaneauSecurite(e:*= null):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onFermeturPanneauSecurite);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onFermeturPanneauSecurite);
		}
		
		private function onFermeturPanneauSecurite(e:MouseEvent):void 
		{
			//trace("focus");
			checkWebcamStatus();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onFermeturPanneauSecurite);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onFermeturPanneauSecurite);
			
		}
		
		
		private function checkWebcamStatus(e:Event=null):void 
		{
			trace(_isActive);
			//trace(cam.activityLevel);
			
			if (!cam.muted /*&& cam.activityLevel>-1*/) {
				
				//trace("webcam active");
				//if (_isActive === false) {
					_isActive = true;
					dispatchEvent(new WebcamEvent(WebcamEvent.ACTIVE));
				//}
			}else {
				//trace("webcam inactive");
				//if (_isActive === true) {
					_isActive = false;
					dispatchEvent(new WebcamEvent(WebcamEvent.INACTIVE));
				//}
			}
		}
		
		/**
		 * Lance la fenêtre de paramètres de confidentialité afin que l'utilisateur puisse autoriser flash player à utiliser sa caméra
		 */
		public static function askUserToActiveWebcam():void {
			Security.showSettings(SecurityPanel.PRIVACY);
		}
		/**
		 * Lance la fenêtre de paramètres de confidentialité afin que l'utilisateur puisse choisir la webcam à utiliser
		 */
		public static function askUserToChooseWebcam():void {
			Security.showSettings(SecurityPanel.CAMERA);
		}
		
		

		/**
		 * 
		 * @param	e
		 */
		private function onCamStatus(e:StatusEvent):void 
		{
			trace("Webcam : "+e.code);
			if (e.code == "Camera.Unmuted") {
				//effetAfficheImage(video);
				//_isActive = true;
				//dispatchEvent(new WebcamEvent(WebcamEvent.ACTIVE));
				checkWebcamStatus();
			}else if (e.code == "Camera.Muted") {
				//_isActive = false;
				//dispatchEvent(new WebcamEvent(WebcamEvent.INACTIVE));
				checkWebcamStatus();
			}
		}
		

		/**
		 * retourne true si l'utilisateur dispose d'au moins une webcam.
		 */
		static public function get hasWebcam():Boolean { 
			if (Camera.names.length > 0) {
				_hasWebcam = true;
			}
			return _hasWebcam; 
		}
		
		/**
		 * propriété permettant d'inverser la vidéo afin que la webcam se comporte comme un mirroir.
		 */
		public function get mirror():Boolean { return _mirror; }
		public function set mirror(value:Boolean):void 
		{
			_mirror = value;
			if (_mirror) {
				video.scaleX = -1;
				video.x = video.width;
			}else {
				video.scaleX = 1;
				video.x = 0;
			}
			
			
		}
		
		/**
		 * propriété indiquant si la caméra est activée ou pas
		 */
		public function get isActive():Boolean { 
			return _isActive;
		}
		
		
		private function connect(url:String):void {
			connection = new NetConnection();
			connection.client = {
				onBWDone : function():void { trace("Je sers à rien"); }
			}
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler );
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void { trace(e); });
			connection.connect(url);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("netStatusHandler="+event.info.code);
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
				if (!stream) {
					if(connection.connected){
					   stream = new NetStream(connection);
					   stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					   stream.attachCamera(cam);
					   trace("démare l'eregistrement de la vidéo : " + rtmpRecordName);
					   stream.publish(rtmpRecordName/*"maVideo"*/, "record");
					}
				}
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Unable to locate video: ");
                    break;
				case "NetStream.Play.Stop":
                    break;
				case "NetStream.Publish.Start":
					//TweenLite.delayedCall(5, recordVideoStop);
					trace("start recording video");
					dispatchEvent(new WebcamEvent(WebcamEvent.ON_START_RECORDING));
                    break;
				case "NetStream.Unpublish.Success":
					dispatchEvent(new WebcamEvent(WebcamEvent.ON_STOP_RECORDING));
					break;
				
				
            }
        }
		
		
		
		
		/**
		 * se connecte à l'application FMS et démarre l'enregistrement quand la connection est établie
		 */
		public function recordVideo():void {
			connect(rtmpAppAdress /*"rtmp://shic.cc:1936/fantaFreakShow"*/);
			trace("essaye de se connecter au serveur FMS : "+rtmpAppAdress);
		}
		/**
		 * arrête d'enregistrer la vidéo
		 */
		public function recordVideoStop():void {
			if(stream){
				stream.close();
				trace("stop recording video");
			}
		}
		/**
		 * éteind la caméra
		 */
		public function off():void {
			if (stream) {
				stream.close();
				stream = null;
			}
			if (connection) {
				connection = null;
			}
			video.attachCamera(null);
		}
		/**
		 * détruit l'objet et tous ses écouteurs, éteind la caméra si elle n'est pas utilisée autre part
		 * @param	e
		 */
		public function destroy(e:*= null):void {
			if (cam) {
				off();
				recordVideoStop();
				cam.removeEventListener(StatusEvent.STATUS, onCamStatus);
			}
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onFermeturPanneauSecurite);
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onFermeturPanneauSecurite);
			}
			if (connection) {
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler );
			}
			if(video){
				removeChild(video);
				video = null;
			}
		}
	}

}