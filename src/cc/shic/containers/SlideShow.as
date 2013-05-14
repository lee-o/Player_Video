package cc.shic.containers 
{
	import cc.shic.Utils;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class SlideShow extends Sprite
	{
		private var picturesURL:Array;
		private var scaleMode:String;
		private var align:String;
		private var pauseDuration:Number;
		private var transitionDuration:Number;
		private var bgColor:uint
		private var transparent:Boolean;
		private var roundedRadius:Number;
		private var smoothing:Boolean;
		
		private var background:Shape;
		private var maskObject:Shape;
		private var _width:Number=0;
		private var _height:Number=0;
		private var imagesContainer:Sprite;
		private var resizeConfig:ResizerConfig;
		private var currentImage:AutoResizeContainer;
		private var oldImage:AutoResizeContainer;
		private var imageCount:int=-1;

		/**
		 * 
		 * @param	picturesURL	this array contains pictures URL
		 * @param	width	initial width
		 * @param	height iitial height
		 * @param	scaleMode	@see StageScaleMode
		 * @param	align @see StageAlign
		 * @param	pauseDuration time (in seconds) between two 
		 * @param	transitionDuration
		 * @param	bgColor
		 * @param	transparent
		 * @param	roundedRadius
		 */
		public function SlideShow(picturesURL:Array,width:Number,height:Number,scaleMode:String=StageScaleMode.SHOW_ALL,align:String=null,pauseDuration:Number=5,transitionDuration:Number=0.5,bgColor:uint=0x000000,transparent:Boolean=true,roundedRadius:Number=0,smoothing:Boolean=true) 
		{
			this.picturesURL = picturesURL;
			this.scaleMode = scaleMode;
			this.align = align;
			this.pauseDuration = pauseDuration;
			this.transitionDuration = transitionDuration;
			this.bgColor = bgColor;
			this.transparent = transparent;
			this.roundedRadius = roundedRadius;
			this._width = width;
			this._height = height;
			this.smoothing = smoothing;
			
			resizeConfig = new ResizerConfig();
			resizeConfig.align = align;
			resizeConfig.backgroundColor = bgColor;
			resizeConfig.height = _height;
			resizeConfig.scaleMode = scaleMode;
			resizeConfig.transparent = true;
			resizeConfig.width = _width;
			
			background = new Shape();
			maskObject = new Shape();
			imagesContainer = new Sprite();
			
			addChild(background);
			addChild(maskObject);
			addChild(imagesContainer);
			this.mask = maskObject;
			

			resize();
			
			
			if (stage) {
				init();
			}else {
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			nextImage();
		}
		
		/**
		 * load and play the next picture in the list
		 */
		private function nextImage():void {
			imageCount++;
			if (imageCount > picturesURL.length - 1) {
				imageCount = 0;
			}
			oldImage = currentImage;
			currentImage = new AutoResizeContainer(null, resizeConfig, picturesURL[imageCount]);
			currentImage.alpha = 0;
			currentImage.addEventListener(Event.COMPLETE, startTimer);
			imagesContainer.addChild(currentImage);
		}
		/**
		 * called after loading an image, start the pauseDuration timer before showing the next image
		 * @param	e
		 */
		private function startTimer(e:Event=null):void 
		{
			if (smoothing) {
				Utils.smoothRecursive(currentImage);
			}
			TweenLite.to(currentImage, transitionDuration, { alpha:1,onComplete:onImageReveal });
			

		}
		/**
		 * when an image is totaly loaded
		 */
		private function onImageReveal():void {
			TweenLite.delayedCall(pauseDuration, nextImage);
			if (oldImage) {
				TweenLite.to(oldImage, transitionDuration, { alpha:0, 
				onComplete:function(img:DisplayObject):void {
					if (img && imagesContainer.contains(img)) {
						imagesContainer.removeChild(img);
						img = null;
					}
				},onCompleteParams:[oldImage]
				
				});
			}
		}

		/**
		 * draw mask, called when resizing
		 */
		private function drawMask():void
		{
			maskObject.graphics.clear();
			maskObject.graphics.beginFill(0xff0000, 1);
			maskObject.graphics.drawRoundRect(0, 0, _width, _height, roundedRadius, roundedRadius);
		}
		/**
		 * draw background, called when resizing
		 */
		private function drawBackground():void
		{
			background.graphics.clear();
			background.graphics.beginFill(bgColor, transparent?0:1);
			background.graphics.drawRect(0, 0, _width, _height);
		}
		/**
		 * resie the object, called when whidth or height change
		 */
		private function resize():void {
			drawBackground();
			drawMask();
			if(currentImage){
				currentImage.width = width;
				currentImage.height = height;
			}
			if(oldImage){
				oldImage.width = width;
				oldImage.height = height;
			}
		}
		
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void 
		{
			_width = value;
			resize();
		}
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void 
		{
			_height = value;
			resize();
		}
		

		
	}

}