package cc.shic.display.text{

	import cc.shic.events.CustomEvent;
	import cc.shic.Utils;
	import cc.shic.xml.EasyXml;
	import cc.shic.xml.EasyXmlEvent;
	import flash.events.*;
	import flash.net.*;
	import flash.display.*;
	import flash.text.*;
	import flash.utils.*;
	
	/**
	 * La classe TextStyle permet de charger des définitions de styles mêlant TextFormat et Propriétés de champ texte depuis un xml.
	 */
	public class TextStyle extends EventDispatcher
	{
		public var xmlUrl:String;
		public var xml:XML;
		public var styles:Vector.<TextStyleFormat> = new Vector.<TextStyleFormat>();
		public var fontLoaders:Vector.<FontLoader> = new Vector.<FontLoader>();
		private var loadedCount:Number;
		private var finalXmlEvent:EasyXmlEvent;
		/**
		 * dernier jeux de textes a avoir été créé.
		 */
		public static var current:TextStyle;
		
		[Event(name = "complete", type = "cc.shic.xml.EasyXmlEvent")]

		public function TextStyle() {
			current = this;
		}
		/**
		 * Charge le fichier xml de définition des styles depuis l'URL définie par xmlUrl.
		 * @param	xmlUrl
		 */
		public function loadStyles(xmlUrl:String):void {
			this.xmlUrl = xmlUrl;
			var xmlLoader:EasyXml = new EasyXml(xmlUrl);
			xmlLoader.addEventListener(EasyXmlEvent.COMPLETE, onXml);
		}
		/**
		 * réception
		 * @param	event
		 */
		public function onXml (e:EasyXmlEvent):void {
			
			e.target.removeEventListener ("complete", onXml);
			finalXmlEvent=e;
			xml = e.xml;
			createStyles();
		}
		
		private function createStyles():void
		{
			var list:XMLList = xml.children();
			var fl:FontLoader;
			loadedCount = 0;
			for (var i:int = 0; i < list.length(); i++) {
				
				if (list[i].name()=="fontLoader") {
					fl = new FontLoader(Utils.flashVarsGet('fontsFolder','')+list[i].swf, list[i].className);
					fl.addEventListener(CustomEvent.ON_DOWNLOAD_COMPLETE, onFontLoaded);
					fontLoaders.push(fl);
				}else {
					styles.push(new TextStyleFormat(list[i]));
				}
			}
			if (fontLoaders.length<=0) {
				onFontLoaded();
			}
		}
		
		private function onFontLoaded(e:CustomEvent=null):void 
		{
			loadedCount++;
			if (loadedCount >= fontLoaders.length) {
				//efface les font loader
				var fl:FontLoader;
				while ( fontLoaders.length>0) {
					fl = fontLoaders.shift();
					fl.removeEventListener(CustomEvent.ON_DOWNLOAD_COMPLETE, onFontLoaded);
					fl = null;
				}
				fontLoaders = null;
				dispatchEvent(finalXmlEvent);
			}
		}

		/**
		 * retourne un TextStyleFormat à partir de son nom.
		 * @param	name
		 * @return
		 */
		public function getStyleByName(name:String):TextStyleFormat {
			for (var i:int; i < styles.length; i++) {
				if (styles[i].name == name) {
					return styles[i];
				}
			}
			trace("Attention TextStyle nommé "+name+" n'existe pas ou pas encore");
			return null;
		}
		/**
		 * retourne un nouveau TextStyleFormat à partir du nom d'un autre formatage de texte.
		 * @param	name
		 * @return un nouveau TextStyleFormat
		 */
		public function cloneByName(name:String):TextStyleFormat {
			var originalFormat:TextStyleFormat = getStyleByName(name);
			var newFormat:TextStyleFormat = new TextStyleFormat(originalFormat.xml);
			return newFormat;
		}
		/**
		 * applique le format style (défini sous le même nom dans le xml) à txt.
		 * @param	txt
		 * @param	style
		 */
		public function appliqueFormat (txt:TextField, style:String):void {
			
			var ts:TextStyleFormat = getStyleByName(style);
			if (!ts) {
				var error:TextFormat=new TextFormat;
				error.color=0xff0000;
				error.bold=true;
				error.size=12;
				txt.embedFonts=false;
				txt.text = "style not defined in xml! " + txt.text;
				
				txt.setTextFormat (error);
				return;
			}else {
				ts.applyTo(txt);
			}
		}
		
	}
}