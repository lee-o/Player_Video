package cc.shic.display 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class FileRefImageLoader extends Loader
	{
		
		public var file:FileReference;
		
		public function FileRefImageLoader(file:FileReference) 
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
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}