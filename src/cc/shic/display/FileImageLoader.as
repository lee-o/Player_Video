package cc.shic.display 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class FileImageLoader extends Loader
	{
		
		public var file:File;
		
		public function FileImageLoader(file:File) 
		{
			this.file = file;
			loadImage()
		}
		
		private function loadImage():void{
			file.load();
			file.addEventListener(Event.COMPLETE, onFileLoaded);
		}
		
		private function onFileLoaded(e:Event):void 
		{
			this.loadBytes(file.data);
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileLoadedTrue);
		}
		
		[Event(name="complete", type="flash.events.Event")]
		private function onFileLoadedTrue(e:Event):void 
		{
			file.removeEventListener(Event.COMPLETE, onFileLoaded);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}