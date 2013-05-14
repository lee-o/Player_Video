package cc.shic.sound 
{
	import cc.shic.flashCookie.FlashCookie;
	import cc.shic.flashCookie.FlashCookieEvent;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	/**
	 * ...
	 * @author david
	 */
	public class SoundGlobal
	{
		/**
		 * identifiant unique du swf en cours
		 */
		public static var thisSwfId:Number = new Date().getTime();
		public static var allSounds:Vector.<SoundBase> = new Vector.<SoundBase>();
		public function SoundGlobal() 
		{
			
		}
		/**
		 * Le swf courrant demande aux autres swf qui sont sur le même domaine et qui utilisent la classe de stoper leurs sons associés à la classe SoundGlobal
		 */
		public static function takeControl():void {
			FlashCookie.setValue("currentSwfSound",thisSwfId);
		}
		/**
		 * Démare la vérification du cookie afin de s'assurer qu'il ne faille pas arrâter le son
		 */
		public static function watchForExternalStop():void {
			FlashCookie.refreshVerifiyinDelay = 5 * 1000;
			FlashCookie.addEventListener(FlashCookieEvent.CHANGE, onChangeSwf);
		}
		/**
		 * Quand le cookie change, s'il est diférent de thisSwfId alors, on arrête tous les sons
		 * @param	e
		 */
		static private function onChangeSwf(e:FlashCookieEvent):void 
		{
			if (FlashCookie.getValue("currentSwfSound") != thisSwfId) {
				for (var i:int = 0; i < allSounds.length; i++ ) {
					allSounds[i].stop();
				}
			}
		}
		
	}

}