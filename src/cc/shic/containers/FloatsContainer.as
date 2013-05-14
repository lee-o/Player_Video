package cc.shic.containers 
{
	import cc.shic.display.SpriteMore;
	import cc.shic.display.Square;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author david
	 */
	public class FloatsContainer extends SpriteMore 
	{
		public static const MODE_VERTICAL:String = "modeVertical";
		public static const MODE_HORIZONTAL:String = "modeHorizontal";
		
		public var mode:String = MODE_HORIZONTAL;
		
		public var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		public var container:Sprite = new Sprite();
		public var paddingX:Number = 0;
		public var paddingY:Number = 0;
		public var align:String = "center";
		private var _background:DisplayObject;
		
		private var _numChildren:int;

		
		public function FloatsContainer() 
		{
			background = new Square(10, 10, 0x00ffff, 1);
			background.alpha = 0;
			super.addChild(background);
			super.addChild(container);
		}
		public override function addChild(d:DisplayObject):DisplayObject {
			return addItem(d);
		}		
		public override function removeChild(d:DisplayObject):DisplayObject {
			return removeItem(d);
		}
		public function addItem(item:DisplayObject):DisplayObject {
		 var val:DisplayObject = container.addChild(item);
		 items.push(item);
		 resize();
		 return val;
		}		
		public function removeItem(item:DisplayObject):DisplayObject {
		 var val:DisplayObject = container.removeChild(item);
		 for (var i:int = 0; i < items.length; i++ ) {
			 if (items[i] == item) {
				 items.splice(i, 1);
			 }
		 }
		 resize();
		 return val;
		}
		public override function resize():void {
			container.x = 0;
			container.y = 0;
			background.width = background.height = 0;
			for (var i:int = 0; i < items.length; i++ ) {		
				if (i==0) {
					items[i].x = paddingX;
					items[i].y = paddingY;
				}else {
					items[i].x = items[i-1].x+items[i-1].width+paddingX;
					items[i].y = items[i - 1].y;
					if (items[i].x+items[i].width>this._width-paddingX) {
						items[i].y = items[i - 1].y + paddingY + items[i - 1].height;
						items[i].x = paddingX;
					}
				}
				
			}
			if (align == "center") {
				if(mode==FloatsContainer.MODE_HORIZONTAL){
					container.x = Math.floor(_width / 2 - container.width / 2 - paddingX);
				}else {
					container.y = Math.floor(_height / 2 - container.height / 2 - paddingY);
				}
			}
			background.x = background.y = 0;
			if (mode==FloatsContainer.MODE_HORIZONTAL) {
				background.width = _width;
				background.height = container.height + paddingY * 2;
				_height = background.height;
			}else {
				background.height = _height;
				background.width = container.width + paddingX * 2;
				_width = background.width;
			}
		}
		public override function getChildAt(level:int):DisplayObject {
			return container.getChildAt(level);
		}
		
		public function get background():DisplayObject {return _background;}
		
		public function set background(value:DisplayObject):void 
		{
			if (_background) {
				super.removeChild(_background);
			}
			_background = value;
			super.addChildAt(_background, 0);
			resize();

		}
		
		public override function get numChildren():int 
		{
			return container.numChildren;
		}
		

		

		
	}

}