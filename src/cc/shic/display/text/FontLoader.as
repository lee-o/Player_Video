package cc.shic.display.text 
{
	import cc.shic.events.CustomEvent;
	import cc.shic.ShicConfig;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.text.Font;
	import flash.display.LoaderInfo;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class FontLoader extends EventDispatcher
	{
		public var fontName:String;
		private var loader:Loader;
		public static var debug:Boolean = true;
		
		public function FontLoader(swfUrl:String,fontName:String) 
		{
			Security.allowDomain("*");
			
			this.fontName = fontName;
			
			loader = new Loader();
			loader.load(new URLRequest(swfUrl));
			if (ShicConfig.debug && debug) {
				trace("FontLoader loads : "+swfUrl);
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);//
		}
		[Event(name="onDownloadComplete", type="cc.shic.events.CustomEvent")]
		private function onLoad(e:Event):void 
		{		
			var domain:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
			var font:Class = domain.getDefinition(fontName) as Class;
			Font.registerFont(font);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);//
			loader = null;
			domain = null;
			fontName = null;
			dispatchEvent(new CustomEvent(CustomEvent.ON_DOWNLOAD_COMPLETE));
		}
		
	}

}