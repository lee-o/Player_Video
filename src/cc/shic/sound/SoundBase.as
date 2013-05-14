package cc.shic.sound 
{
	import cc.shic.events.CustomEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * Methode qui simplifie la gestion des sons
	 * @author david
	 */
	[Event(name="onPlayComplete", type="cc.shic.events.CustomEvent")]
	public class SoundBase extends Sound
	{
		public var soundChannel:SoundChannel;
		private var _volume:Number = 1;
		public var loop:Boolean;
		private var _position:Number;
		private var _duration:Number;
		public var paused:Boolean = false;
		
		public function SoundBase(url:String, autoplay:Boolean = true,loop:Boolean=false ) 
		{
			super();
			SoundGlobal.allSounds.push(this);
			super.load(new URLRequest(url));
			start();
			if (!autoplay) {
				stop();
			}
			
			this.loop = loop;
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundEnd);
			super.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			
			
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			
		}
		
		public override  function close():void 
		{
			try{
				super.close();
			}catch (e:*) {
				
			}
		}
		
		private function onSoundEnd(e:Event):void 
		{
			trace("Sound end")
			if (loop) {
				seek(0);
			}else {
				stop();
			}
			dispatchEvent(new CustomEvent(CustomEvent.ON_PLAY_COMPLETE));
		}
		
		public function seek(position:Number):void {
			start(position);
		}
		
		/**
		 * arrête la lecture du son
		 */
		public function stop():void {
			paused = true;
			if (soundChannel) {
				_position = position;
				trace("sc destroy stop");
				soundChannel.stop();
				soundChannel = null;
			}else {
				trace("SoundBase stop ---> no soundChannel");
			}
		}
		/**
		 * démare la lecture du son en boucle
		 * @return
		 */
		public function start(position:Number = 0):SoundChannel {
			paused = false;
			if (soundChannel) {
				trace("sc destroy start");
				soundChannel.stop();
				soundChannel = null;
			}
			trace("sc create");
			soundChannel = super.play(position,1);
			this.addEventListener(Event.OPEN, onComplete);
			return soundChannel;
		}
		public override function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel {
			
			return start(startTime);
		}
		/**
		 * propriété définissant le volume
		 */
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void 
		{
			_volume = value;
			if (soundChannel) {
				//soundChannel.soundTransform.volume = _volume;
				soundChannel.soundTransform = new SoundTransform(_volume);
				//trace("volume "+soundChannel.soundTransform.volume+"/"+_volume);
			}
		}
		/**
		 * position du du son en millisecondes
		 */
		public function get position():Number {
			if (paused) {
				
			}else {
				_position = soundChannel.position;
			}
			
			return _position; 
		}
		public function set position(value:Number):void 
		{
			_position = value;
			seek(_position);
		}
		/**
		 * durée du son en millisecondes, la durée avant la fin du téléchargement est approximativement calculée
		 */
		public function get duration():Number {
			if (super.length) {
				if (bytesTotal==bytesLoaded) {
					_duration = super.length;
				}else {
					_duration = (super.length)*bytesTotal/bytesLoaded;
				}
				
				
			}else {
				_duration = 0;
			}
			return _duration; 
		}
		private function onComplete(e:Event):void 
		{
			trace("on open");
			volume = _volume;
		}
		
	}

}