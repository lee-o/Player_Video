package cc.shic.containers 
{
	import cc.shic.display.EasyLoader;
	import cc.shic.ShicConfig;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class AutoResizeContainer extends Sprite
	{
		private var _content:DisplayObject;
		private var _resizeConfig:ResizerConfig
		private var _sourceUrl:String;
		private var _height:Number;
		private var _width:Number;
		private var imageLoader:EasyLoader;
		public static var debug:Boolean;
		public var loaded:Boolean = false;
		
		public function AutoResizeContainer(content:DisplayObject=null,resizeConfig:ResizerConfig=null,sourceUrl:String=null) 
		{
			if (sourceUrl) {
				this.sourceUrl = sourceUrl;
			}else{
				if (content) {
					this.content = content;
				}
			}
			if (resizeConfig) {
				this.resizeConfig = resizeConfig;
			}else {
				this.resizeConfig = new ResizerConfig();
			}
		}
		
		/**
		 * The display object you want to resize. Setting this property automaticaly delete the previous one.
		 */
		public function get content():DisplayObject { return _content; }
		public function set content(value:DisplayObject):void 
		{
			if (_content) {
				if (this.contains(_content)) {
					_content.parent.removeChild(_content);
				}
			}
			_content = value;
			this.addChild(_content);
			resize();
		}
		
		public function get resizeConfig():ResizerConfig { return _resizeConfig; }
		public function set resizeConfig(value:ResizerConfig):void 
		{
			_resizeConfig = value;
			resize();
		}
		public function get scaleMode():String { return _resizeConfig.scaleMode; }
		
		public function set scaleMode(value:String):void 
		{
			_resizeConfig.scaleMode = value;
			resizeConfig = _resizeConfig;
		}
		
		public function destroy():void {
			if (imageLoader) {
				imageLoader.removeEventListener(Event.COMPLETE, onImageLoaded);
				imageLoader.destroy();
			}
			if(_content){
			if (_content.parent && this.contains(_content)) {
				removeChild(_content);
			}
			}
			_content = null;
		}
		
		/**
		 * An image source url to load, setting this property, replace the content property by the resulted image 
		 */
		public function get sourceUrl():String { return _sourceUrl; }
		/**
		 * Evènement distribué quand l'image définie par la propriété sourceUrl est chargée.
		 */
		[Event(name="complete", type="flash.events.Event")]
		public function set sourceUrl(value:String):void 
		{
			_sourceUrl = value;
			if(ShicConfig.debug && AutoResizeContainer.debug){
				trace("cc.shic.containers.AutoResizeContainer loads : "+_sourceUrl);
			}
			imageLoader = new EasyLoader(_sourceUrl);
			imageLoader.addEventListener(Event.COMPLETE, onImageLoaded);
		}
		
		public override function get height():Number { 
			return this.scrollRect.height
		}
		public override function get width():Number { 
			return this.scrollRect.width;
		}
		public override function set height(value:Number):void 
		{
			_height = value;
			resizeConfig.height = _height;
			resize();
		}
		public override function set width(value:Number):void 
		{
			_width = value;
			resizeConfig.width = _width;
			resize();
		}
		

		
		
		
		private function onImageLoaded(e:Event):void 
		{
			imageLoader.removeEventListener(Event.COMPLETE, onImageLoaded);
			if (imageLoader) {
				this.content = imageLoader;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			loaded = true;
		}
		
		
		private function resize():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, _resizeConfig.width, _resizeConfig.height);
			//set width & height
			this.scrollRect = new Rectangle(0, 0, Math.ceil(_resizeConfig.width), Math.ceil(_resizeConfig.height));
			
			if(_content){
			_content.scaleX = content.scaleY = 1;
			}
			
			
			//set background
			if ( this.resizeConfig) {
				if (_resizeConfig.transparent) {
					this.opaqueBackground = null;
				}else {
					this.opaqueBackground = _resizeConfig.backgroundColor;
				}	
			}
			if(_content){
				if (_resizeConfig.scaleMode == StageScaleMode.SHOW_ALL) {
					_content.width = _resizeConfig.width;
					if (_content.scaleX>2) {
						_content.scaleX = 2;
					}
					_content.scaleY = _content.scaleX;
					if (_content.width>_resizeConfig.width) {
						_content.width = _resizeConfig.width;
						_content.scaleY = _content.scaleX;
					}
					if (_content.height>_resizeConfig.height) {
						_content.height = _resizeConfig.height;
						_content.scaleX = content.scaleY;
					}
					setPosition();
				}
				if (_resizeConfig.scaleMode == StageScaleMode.NO_BORDER) {
					content.width = _resizeConfig.width;
					_content.scaleY = _content.scaleX;
					if (_content.width<_resizeConfig.width) {
						_content.width = _resizeConfig.width;
						_content.scaleY = _content.scaleX;
					}
					if (_content.height<_resizeConfig.height) {
						_content.height = _resizeConfig.height;
						_content.scaleX = content.scaleY;
					}
					setPosition();
				}
				if (_resizeConfig.scaleMode == StageScaleMode.NO_SCALE) {
					_content.scaleY = _content.scaleX=1;
					setPosition();
				}
				if (_resizeConfig.scaleMode == StageScaleMode.EXACT_FIT) {
					_content.width = _resizeConfig.width;
					_content.height = _resizeConfig.height;
					setPosition();
				}
			}
			
		}
		
		private function setPosition():void
		{
			if(_resizeConfig.align==StageAlign.BOTTOM){
				_content.x = _resizeConfig.width / 2 - _content.width / 2;
				_content.y = _resizeConfig.height- _content.height;
			}else if(_resizeConfig.align==StageAlign.BOTTOM_LEFT){
				_content.x = 0;
				_content.y = _resizeConfig.height- _content.height;
			}else if(_resizeConfig.align==StageAlign.BOTTOM_RIGHT){
				_content.x = _resizeConfig.width- _content.width;
				_content.y = _resizeConfig.height- _content.height;
			}else if(_resizeConfig.align==StageAlign.LEFT){
				_content.x = 0;
				_content.y = _resizeConfig.height / 2 - _content.height / 2;
			}else if(_resizeConfig.align==StageAlign.RIGHT){
				_content.x = _content.x = _resizeConfig.width- _content.width;
				_content.y = _resizeConfig.height / 2 - _content.height / 2;
			}else if(_resizeConfig.align==StageAlign.TOP){
				_content.x = _resizeConfig.width / 2 - _content.width / 2;
				_content.y = 0;
			}else if(_resizeConfig.align==StageAlign.TOP_LEFT){
				_content.x = 0;
				_content.y = 0;
			}else if(_resizeConfig.align==StageAlign.TOP_RIGHT){
				_content.x = _resizeConfig.width - _content.width ;
				_content.y = 0;
			}else {
				if(_resizeConfig.align==""){
					_content.x = _resizeConfig.width / 2 - _content.width / 2;
					_content.y = _resizeConfig.height / 2 - _content.height / 2;
				}else{
					trace("sorry but " + _resizeConfig.align + " is not a valid property in cc.shic.containers.ResizerConfig.align property, middle align is provided by default");
				}
			}
		}
		
		
		
	}
	


}