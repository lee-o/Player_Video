package cc.shic.display.subtitles 
{
	import cc.shic.events.CustomEvent;
	import cc.shic.Utils;
	import cc.shic.UtilsArray;
	import cc.shic.UtilsTime;
	import cc.shic.xml.EasyXml;
	import cc.shic.xml.EasyXmlEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * Quand les sous titres sont prêts à être utilisé.
	 */
	[Event(name = "onLoaded", type = "cc.shic.events.CustomEvent")]
	
	
	/**
	 * Quand le sous titre change
	 */
	[Event(name = "onChange", type = "cc.shic.events.CustomEvent")]
	
	
	
	public class Subtitles extends EventDispatcher
	{
		/**
		 * XML des sous titres
		 */
		public var xml:XML;
		/**
		 * url du xml qui aura été utilisé par la fonction load
		 */
		private var _url:String;
		/**
		 * objet utilisé pour charger le xml
		 */
		private var xmlLoader:EasyXml;
		/**
		 * liste des SubtitleItem associés
		 */
		public var subtitles:Vector.<SubtitleItem>= new Vector.<SubtitleItem>();;
		public var stream:NetStream;
		public var textField:TextField;
		public var currentSubtitles:Vector.<SubtitleItem>;
		private var timer:Timer;
		
		
		
		public function Subtitles(xml:XML=null) 
		{
			if (xml) {
				this.xml = xml;
				init();
			}			
		}
		/**
		 * charge le xml situé à l'url définie par url.
		 * @param	url
		 */
		public function load(url:String):void {
			_url = url;
			xmlLoader = new EasyXml();
			xmlLoader.addEventListener(EasyXmlEvent.COMPLETE, onLoadXml);
			xmlLoader.loadXml(url);
		}
		/**
		 * Quand le xml est chargé
		 * @param	e
		 */
		private function onLoadXml(e:EasyXmlEvent):void 
		{
			xmlLoader.removeEventListener(EasyXmlEvent.COMPLETE, onLoadXml);
			this.xml = e.xml;
			init();
			xmlLoader = null;
		}

		/**
		 * génere les SubtitleItem
		 */
		private function init():void 
		{
			var list:XMLList = xml.subtitles.children();
			var s:SubtitleItem;
			for (var i:int; i < list.length(); i++) {
				s = new SubtitleItem(list[i]);
				subtitles.push(s);
			}
			dispatchEvent(new CustomEvent(CustomEvent.ON_LOADED));
		}
		/**
		 * Renvoie les SubtitleItems correspondants à time ou null.
		 * @param	time
		 * @return
		 */
		public function getSubtitlesAt(time:int):Vector.<SubtitleItem> {
			var foundSubtitles:Vector.<SubtitleItem> = new Vector.<SubtitleItem>();
			for (var i:int; i < subtitles.length; i++) {
				if (time>=subtitles[i].start  && time<subtitles[i].stop) {
					foundSubtitles.push(subtitles[i]);
				}
			}
			if (foundSubtitles.length > 0) {
				return foundSubtitles;
			}else{
				return null;
			}
		}
		/**
		 * Lie un objet net stream à un textField et modifie la valeur du champ texte en fonction des sous titres
		 * @param	stream
		 * @param	textField
		 */
		public function linkToStream(stream:NetStream, textField:TextField=null):void {
			this.stream = stream;
			this.textField = textField;
			timer = new Timer(10, 0);
			timer.addEventListener(TimerEvent.TIMER, loop);
			timer.start();
		}
		/**
		 * efface la liaison avec le stream
		 */
		public function unlinkStream():void {
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, loop);
				timer = null;
			}
		}
		/**
		 * boucle déclenchée par linkToStream. Elle met en relation le temps de stream et les timecode des sous titres.
		 * Si un sous titre différent est trouvé la boucle déclenchera un evenement ON_CHANGE et mettra à jour currentSubtitles.
		 * @param	e
		 */
		private function loop(e:TimerEvent):void 
		{
			
			if (stream && subtitles) {
				if (!UtilsArray.areEqual(currentSubtitles,getSubtitlesAt(stream.time * 1000))) {
					currentSubtitles = getSubtitlesAt(stream.time * 1000);
					if(textField){
						var tf:TextFormat = textField.getTextFormat();
						if (currentSubtitles) {
							textField.htmlText = currentSubtitles[0].text;
						}else {
							textField.text=" ";
						}
						textField.setTextFormat(tf);
					}
					dispatchEvent(new CustomEvent(CustomEvent.ON_CHANGE));
				}
			}
		}
		
		/**
		 * Efface les listener et vide les objets créés au sein de l'occurence.
		 */
		public function destroy(e:Event=null):void {
			if(xmlLoader){
				xmlLoader.removeEventListener(EasyXmlEvent.COMPLETE, onLoadXml);
				xmlLoader.destroy();
				xmlLoader = null;
			}
			if (xml) {
				xml = null;
			}
			if (subtitles) {
				while (subtitles.length>0) {
					var c:SubtitleItem=subtitles.pop()
					c=null;
				}
			}
			_url = null;
			if (textField) {
				textField = null;
			}
			unlinkStream();
			
		}
		
		public function get url():String {return _url;}
		
		
	}

}