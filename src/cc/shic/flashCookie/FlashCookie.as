package cc.shic.flashCookie
{
	/**
	 * ...
	 * @author shic
	 */
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Timer;
	
	/**
	 * La classe FlashCookie, s'utilse en statique. FlashCookie a pour but de simplifier l'utilisation des sharedObject dans un contexte simple. 
	 * Utilisez les méthodes statiques setValue et getValue pour enregistrer et lire des variables simplement. FlashCookie permet en plus d'avoir un listener qui vérifie quand une valeur a changé.
	 */
	public  class FlashCookie extends EventDispatcher
	{
		private static var _instance:FlashCookie = new FlashCookie(); 
		//private var sharedObject:SharedObject;
		
		private static var _refreshVerifiyinDelay:Number = 5000;
		private static var timer:Timer;
		private static var checkForChanges:Boolean = false;
		static private var oldSO:Object;
		
		public function FlashCookie() 
		{
			//trace("instance le timer");
		}
		
		static private function setRefreshLoop():void {
			if (timer) {
				timer.stop();
				timer = null;
			}
			timer = new Timer(_refreshVerifiyinDelay, 0);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onRefrehDelay);
		}
		
		static public function addEventListener(event:String, fonction:Function):void {
			if (event == "change") {
				//trace("listener change instancie");
				checkForChanges = true;
				oldSO=cloneSo();
			}
			setRefreshLoop();
			return _instance.addEventListener(event, fonction);
		}
		
		
		static private function cloneSo():Object {
			//trace("-------------------cloneSo()-------------------");
			var cloned:Object = new Object();
			var sharedObject : SharedObject = getSo();
			for  (var i:String in sharedObject.data) {
				cloned[i] = sharedObject.data[i];
				//trace("cloned: "+i+" = "+sharedObject.data[i]);
			}	
			
			return cloned;
		}
		static private function hasChanged():Boolean {
			var so : SharedObject = getSo();
			for ( var i:String in so.data ) {
				if ( so.data[i] != oldSO[i] ) {
					return true;		
				}
			}
			return false;
		}
		
		[Event(name = "refreshIntervalReached", type = "cc.shic.flashCookie.FlashCookieEvent")]
		[Event(name = "change", type = "cc.shic.flashCookie.FlashCookieEvent")]
		/**
		 * invoqué à chaque fois que l'intervale de temps de vérification est atteint ( voir refreshVerifiyinDelay). Par défaut l'intervale est de 5000 millisecondes.
		 * @param	e
		 */
		static private function onRefrehDelay(e:TimerEvent=null):void 
		{
			//trace("refreshCookie");
			_instance.dispatchEvent(new FlashCookieEvent(FlashCookieEvent.REFRESH_INTERVAL_REACHED));
			
			
			if (checkForChanges) {
				if (hasChanged()) {
					_instance.dispatchEvent(new FlashCookieEvent(FlashCookieEvent.CHANGE));
					oldSO=cloneSo();
				}
			}
		}
		
		/**
		* Le temps exprimé en millisecondes qui définiera les intervales de vérification du cookie afin de voir s'il a été modifié ou non.<br/>
		* Il est fortement conseillé de ne pas réduire trop cet intervale sans quoi flash player risque de se bloquer.
		*/
		static public function get refreshVerifiyinDelay():Number { return _refreshVerifiyinDelay; }
		static public function set refreshVerifiyinDelay(value:Number):void 
		{
			
			_refreshVerifiyinDelay = value;
			setRefreshLoop();
		}
		
		
		/**
		 * attribue une variable au cookie variableName
		 * @param	variableName
		 * @param	variableValue
		 */
		static public function setValue(variableName:String, variableValue:*):void {
			
			var sharedObject:SharedObject = getSo();
			sharedObject.data[variableName] = variableValue;
			sharedObject.flush();
			sharedObject = null;
			oldSO = cloneSo();
			
		}
		/**
		 * renvoie la valeur de variableName
		 * @param	variableName
		 * @return
		 */
		static public function getValue(variableName:String):* {
			var sharedObject:SharedObject = getSo();
			var retour:*= sharedObject.data[variableName];
			sharedObject = null;
			return retour;
		}
		/**
		 * efface variableName
		 * @param	variableName
		 * @return la taille sur le disque du shared object nommé flashCookie
		 */
		static public function clear(variableName:String):Number {
			setValue(variableName, null);
			return getSo().size
		}
		
		/**
		 * Attention! Efface tous les cookies invoqués par cette méthode (le sharedObject nommé flashCookie)
		 */
		public static function clearAll():void {
			getSo().clear();
		}
		/**
		 * Retourne le shared object. 
		 * On n'utilise sytématiquement cette méthode ainsi que sharedObject=null afin d'être certain que les valeurs ne seront pas enregistrées à la fin de la session du swf (comportement par défaut des objets sharedObject)
		 * 
		 * @return
		 */
		private static function getSo():SharedObject {
			return SharedObject.getLocal("flashCookie", "/", false);
		}
		

		
		
	}
	

}