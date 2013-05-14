package cc.shic.containers 
{
	import cc.shic.bitmaps.Tiles;
	import cc.shic.display.Square;
	import cc.shic.mouse.cursor.ps.Drag;
	import cc.shic.mouse.cursor.ps.DragHold;
	import cc.shic.mouse.MouseCursor;
	import cc.shic.Utils;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Un objet ScrollingContainer est un container avancé qui permet à l'utilisateur de déplacer et zoomer sur une image (définie par la propriété content).
	 * @author david@shic.fr
	 */
	public class ScrollingContainer extends Sprite
	{
		/**
		 * permet de controler si l'objet peut être déplacé à l'aide de la souris ou non
		 */
		public var dragEnabled:Boolean = true;
		
		private var background:Shape=new Shape();
		private var _backgroundColor:uint;
		private var _backgroundBitmapData:BitmapData;
		
		
		private var _width:Number=320;
		private var _height:Number=320;
		
		private var _content:DisplayObject;
		public var imageContainer:Sprite = new Sprite;
		
		private var _verticalAlign:String="center";
		private var _horizontalAlign:String = "center";
		private var _zoom:Number;
		
		private var cursorDrag:Drag = new Drag();
		private var cursorDragHold:DragHold= new DragHold();
		
		private var centerPoint:Square = new Square(2, 2, 1, 0xff0000);
		/**
		 * peut être égal à color ou bitmapData
		 * @see backgroundColor
		 * @see backgroundBitmapData
		 */
		private var fillType:String = "bitmapData";
		/**
		 * taille maximum de l'image exprimée en pixels, cette valeur limite la propriété zoom
		 */
		private var imageSizeLimit:Number=10000;
		private var dragging:Boolean;
		
		
		
		public function ScrollingContainer() 
		{
			this.opaqueBackground = 0xC0C0C0;
			
			width = _width;
			height = _height;
			
			addChildAt(background,0);
			backgroundBitmapData = new Tiles();
			addChild(imageContainer);
			addChild(centerPoint);
			imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			Utils.stage.addEventListener(MouseEvent.MOUSE_WHEEL, imageContainerMouseWheelZoom);
			TweenPlugin.activate([TransformAroundPointPlugin]);
			
			addEventListener(MouseEvent.MOUSE_OVER, setMouseCursor);
			addEventListener(MouseEvent.MOUSE_OUT, setMouseCursor);
			addEventListener(MouseEvent.MOUSE_MOVE, setMouseCursor);
			addEventListener(MouseEvent.MOUSE_UP, setMouseCursor);
			
		}
		
		private function setMouseCursor():void {
			if(dragEnabled){
			if (dragging) {
				MouseCursor.cursor = cursorDragHold;
			}else {
				if (imageContainer.hitTestPoint(Utils.stage.mouseX, Utils.stage.mouseY, true)) {
					if(!MouseCursor.mouseIsDown){
						MouseCursor.cursor = cursorDrag;
					}
					
				}else {
					MouseCursor.cursor = null;
				}
			}
			}
		}
		
		private function drag(e:MouseEvent):void 
		{
			imageContainer.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			addEventListener(Event.ENTER_FRAME, whileDraggin);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			
			imageContainer.startDrag();
			MouseCursor.cursor = cursorDragHold;
			dragging = true;
		}
		
		private function whileDraggin(e:Event):void 
		{	
			positionne();
		}
		
		private function dragStop(e:MouseEvent):void 
		{
			dragging = false;
			setMouseCursor();
			removeEventListener(Event.ENTER_FRAME, whileDraggin);
			imageContainer.stopDrag();
			positionne();
		}
		
		/**
		 * ajuste l'image aux dimensions du conteneur de manière à ce que l'ensemble de l'image soit visible.
		 */
		public function fit():void {
			if(imageContainer.width>_width || imageContainer.height>_height){
				imageContainer.width = _width;
				imageContainer.scaleY = imageContainer.scaleX;
				
				if (imageContainer.height > _height) {
					imageContainer.height = _height;
					imageContainer.scaleX = imageContainer.scaleY;
				}
			}else {
				zoom = 1;
			}
			dispatchEvent(new ScrollingContainerEvent(ScrollingContainerEvent.ON_ZOOM));
			positionne(true);
			
		}
		
		/**
		 * couleur de fond de l'objet. Cette propriété annule la propriété backgroundBitmapData
		 * @see backgroundBitmapData
		 */
		public function get backgroundColor():uint 	{ return _backgroundColor; }
		public function set backgroundColor(value:uint):void 
		{
			fillType = "color";
			_backgroundColor = value;
			updateBackground();
		}
		
		/**
		 * bitmapData de fond de l'objet. Cette propriété annule la propriété backgroundColor
		 * @see backgroundColor
		 */
		public function get backgroundBitmapData():BitmapData { return _backgroundBitmapData; }
		public function set backgroundBitmapData(value:BitmapData):void 
		{
			fillType = "bitmapData";
			_backgroundBitmapData = value;
			updateBackground();
		}
		
		/**
		 * objet contenu
		 */
		public function get content():DisplayObject { return _content; }
		public function set content(value:DisplayObject):void 
		{
			//nettoie l'objet
			while (imageContainer.numChildren > 0) {
				imageContainer.removeChildAt(0);
			}
			_content = value;
			imageContainer.addChildAt(_content, 0);
			trace("addChild img " + _content + " " + _content.width);
			updateBackground();
			
			
		}
		/**
		 * met à jour le fond, donc sa taille, sa position, son remplissage
		 * @param	e
		 */
		public function updateBackground():void {
			background.x = imageContainer.x;
			background.y = imageContainer.y;
			//background.scrollRect = new Rectangle(0, 0, imageContainer.width, imageContainer.height);
			background.graphics.clear();
			if (fillType == "color") {
				background.graphics.beginFill(_backgroundColor);
			}else {
				background.graphics.beginBitmapFill(_backgroundBitmapData);
			}
			background.graphics.drawRect(0, 0, imageContainer.width, imageContainer.height);
			addChildAt(background, 0);
		}
		
		
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void 
		{
			_width = value;
			this.scaleY = 1;
			this.scaleX = 1;
			this.scrollRect = new Rectangle(0, 0, _width, _height);
			centerPoint.x = _width / 2;
		}
		
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void 
		{
			_height = value;
			this.scaleY = 1;
			this.scaleX = 1;
			this.scrollRect = new Rectangle(0, 0, _width, _height);
			centerPoint.y = _height / 2;
		}
		/**
		 * invoqué quand l'utilisateur zoome sur l'image à l'aide de la molette de la souris
		 * @param	e
		 */
		private function imageContainerMouseWheelZoom(e:MouseEvent):void 
		{
			if(this.hitTestPoint(Utils.stage.mouseX,Utils.stage.mouseY,false)){
				//déplace le point central
				centerPoint.x = mouseX;
				centerPoint.y = mouseY;
				//zoome
				zoom += e.delta / 100;
				//replace le point central
				centerPoint.x = _width / 2;
				centerPoint.y = _height / 2;
			}
			
		}
		/**
		 * définit et renvoie les valeurs scaleX et scaleY de l'objet content. L'objet content théoriquement respecte son homotétie originale.
		 */
		public function get zoom():Number { return  imageContainer.scaleY; }
		public function set zoom(value:Number):void 
		{
			
			
			if (value < 0) {
				value = 0;
			}
			_zoom = value;
			
			var save:Number = imageContainer.scaleX ;
			
			imageContainer.scaleX = imageContainer.scaleY = _zoom;
			//teste si on ne va pas obtenir des valeurs trop importantes
			if (imageContainer.width > imageSizeLimit || imageContainer.height > imageSizeLimit) {
				imageContainer.scaleX = imageContainer.scaleY = save;
				_zoom = save;
				dispatchEvent(new ScrollingContainerEvent(ScrollingContainerEvent.ON_ZOOM));
				return;
			}
			
			imageContainer.scaleX = imageContainer.scaleY = save;
			
			var pt:Point = centerPoint.getBounds(this).topLeft;
			TweenLite.to(imageContainer, 0, {
					transformAroundPoint:{point:pt,scaleY:_zoom,scaleX:_zoom},
					onComplete:positionne,
					ease:Linear.easeNone
			});

			dispatchEvent(new ScrollingContainerEvent(ScrollingContainerEvent.ON_ZOOM));
			
		}
		/**
		 * positionne correctement content en fonction des paramètres définis par verticalAlign et horizontalAlign.
		 */
		public function positionne(forcePosition:Boolean=false):void
		{
			if (imageContainer.y > 0) {
				imageContainer.y = 0;
			}
			if (imageContainer.x > 0) {
				imageContainer.x = 0;
			}
			if (imageContainer.y<_height-imageContainer.height) {
				imageContainer.y=_height-imageContainer.height
			}
			if (imageContainer.x<_width-imageContainer.width) {
				imageContainer.x=_width-imageContainer.width
			}
			if (imageContainer.width < _width || forcePosition) {
				if (horizontalAlign == "left") {	
						imageContainer.x = 0;
				}
				if (horizontalAlign == "right") {
						imageContainer.x = _width - imageContainer.width;
				}
				if (horizontalAlign == "center") {
						imageContainer.x = _width / 2 - imageContainer.width / 2;
				}
			}
			
			if (imageContainer.height < _height || forcePosition) {
				if (verticalAlign == "top") {
						imageContainer.y = 0;
				}
				if (verticalAlign == "bottom") {	
						imageContainer.y = _height - imageContainer.height;	
				}
				if (verticalAlign == "center") {
						imageContainer.y = _height / 2 - imageContainer.height / 2;
				}
			}
			updateBackground();
			
		}
		
		/**
		 * définit le mode d'alignement horizontal, les valeurs possibles sont left, center et right
		 */
		public function get horizontalAlign():String { return _verticalAlign; }
		public function set horizontalAlign(value:String):void 
		{
			_horizontalAlign = value;
			positionne();
		}
		/**
		 * définit le mode d'alignement vertical, les valeurs possibles sont top, center et bottom
		 */
		public function get verticalAlign():String { return _verticalAlign; }
		public function set verticalAlign(value:String):void 
		{
			_verticalAlign = value;
			positionne();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * invoqué quand l'image change de taille
		 */
		[Event(name = "onZoom", type = "cc.shic.containers.ScrollingContainerEvent")]
		
	}

}