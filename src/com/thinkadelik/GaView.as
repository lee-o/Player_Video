package com.thinkadelik 
{
	import cc.shic.events.CustomEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	[Event(name = "onLoaded", type = "cc.shic.events.CustomEvent")]
	/**
	 * ...
	 * @author lee-o
	 */
	public class GaView extends EventDispatcher
	{
		public var loaderReturn:String;
		public var p:String;
		
		public function GaView() 
		{
			
		}
		
		public function sendData(_p:String = null):void
		{
			p = _p;			
			//
			var loader : URLLoader = new URLLoader();
			var urlreq:URLRequest = new URLRequest("http://www.google-analytics.com/collect");
			var urlvars: URLVariables = new URLVariables;
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			urlreq.method = URLRequestMethod.POST;
						
			urlvars.v = "1"             // Version.
			urlvars.tid = "UA-46339156-1"  // Tracking ID / Web property / Property ID.
			urlvars.cid = Greetings2014App.uid;        // Anonymous Client ID.

			urlvars.t="appview"     // Appview hit type.
			urlvars.an="My Nestlé Waters Snow Globe"    // App name.
			urlvars.av="1.0"      // App version.

			urlvars.cd = p;
			
			urlreq.data = urlvars;
			loader.addEventListener(Event.COMPLETE, loadData);
			loader.load(urlreq);
		}

		public function loadData(e:Event): void
		{
			var loader2: URLLoader = URLLoader(e.target);
			loader2.removeEventListener(Event.COMPLETE, loadData);
			//loaderReturn = p + ":" + e.target.data;
			//loaderReturn = "yo";
			dispatchEvent(new CustomEvent(CustomEvent.ON_LOADED));
		}
		
	}

}