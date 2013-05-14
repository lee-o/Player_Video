package cc.shic.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author david
	 */
	public class SoundLoop extends SoundBase
	{
		
		public function SoundLoop(url:String) 
		{
			super(url);
			
		}
		/**
		 * démare la boucle sonore
		 */
		public function startLoop():void
		{	
			soundChannel = start();	
		}


		

		
	}

}