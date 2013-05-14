package cc.shic.xml 
{
	import cc.shic.ShicConfig;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	/**
	 * Un objet EasyXML est un URLLoader. 
	 * La simple différence est qu'un EasyXML prend comme argument une URL d'où est téléchargé un XML. Le xml est disponible dans la propriété xml sur l'objet ou sur ses listeners. 
	 * Le contenu du xml étant téléchargé, il est donc fourni de manière asynchrone et n'est disponible qu'après lévènement EasyXxmlEvent.COMPLETE.
	 * @author shic
	 */
	public class EasyXml extends URLLoader
	{
		public var xmlUrl:String;
		public var xml:XML;
		public var loader:URLLoader;
		private static var _debug:Boolean = true;
		public var isXml:Boolean = true;
	
		
		public function EasyXml(xmlUrl:String=null,variables:URLVariables=null,isXml:Boolean=true) 
		{
			this.isXml = isXml;
			if(xmlUrl){
				this.xmlUrl = xmlUrl;
				loadXml(xmlUrl,variables);
			}
			super();
		}
		/**
		 * charge le fichier xml
		 * @param	xml l'url du xml à charger
		 */
		public function loadXml(xml:String,variables:URLVariables=null):void {
			this.xmlUrl = xml;
			if(debug){
				trace("loading Xml: " + xml);
			}
			loader = new URLLoader();
            getXML_configureListeners(loader);
           	var request:URLRequest = new URLRequest(xml);
			if (variables) {
				request.data = variables;
			}
			try {
                loader.load(request);
            } catch (error:Error) {
				if(debug){
                trace("Unable to load requested XML document. ( " + xml + " )");
				}
            }
		}
		/**
		 * Configure les listeners
		 * @param	dispatcher
		 */
		private function getXML_configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, getXmlComplete);
			dispatcher.addEventListener(Event.OPEN, openHandler,false,0,true);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler,false,0,true);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler,false,0,true);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler,false,0,true);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
        }	
		private function openHandler(event:Event):void {
			if(debug){
            trace("openHandler: " + event);
			}
        }
        private function progressHandler(event:ProgressEvent):void {
			if(debug){
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
			}
        }
		[Event(name = "error", type = "cc.shic.xml.EasyXmlEvent")]
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			if(debug){
            trace("securityErrorHandler: " + event);
			}
			dispatchEvent(new EasyXmlEvent(EasyXmlEvent.ERROR,xml,event));
        }
        private function httpStatusHandler(event:HTTPStatusEvent):void {
			if(debug){
            trace("httpStatusHandler: " + event);
			}
			//dispatchEvent(new EasyXmlEvent(EasyXmlEvent.ERROR,xml));
			if (event.status == 200) {
				//getXmlComplete(event);
			}
        }
        private function ioErrorHandler(event:IOErrorEvent):void {
			if(debug){
            trace("EasyXML a détecté une erreur --> ioErrorHandler: " + event);
			}
			dispatchEvent(new EasyXmlEvent(EasyXmlEvent.ERROR,xml,event));
        }
		
		
		/**
		* Invoqué quandle xml est chargé
		*
		* @param	event	l'event complete du XML loadé
		*/
		[Event(name = "complete", type = "cc.shic.xml.EasyXmlEvent")]
        private function getXmlComplete(event:Event):void {
			var loaderLocal:URLLoader = URLLoader(event.target);
			if (!isXml) {
				xml = null;
			}else{
				try{
					xml = new XML(loaderLocal.data);
				}catch (e:String) {
					if (debug) {
						trace(e);
						for (var i:uint = 0; i < 10;i++ ) {
							trace("Attention !!! problème, le xml " + xmlUrl + " n'est pas bien formé");
						}
					}
					dispatchEvent(new EasyXmlEvent(EasyXmlEvent.ERROR, xml,e,loaderLocal.data));
					return;
				}
			}
			dispatchEvent(new EasyXmlEvent(EasyXmlEvent.COMPLETE, xml,null,loaderLocal.data));
			destroy();
		}
		
		public function destroy():void {
			if(loader){
				loader.removeEventListener(Event.COMPLETE, getXmlComplete);
				loader.removeEventListener(Event.OPEN, openHandler);
				loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
				loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader = null;
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