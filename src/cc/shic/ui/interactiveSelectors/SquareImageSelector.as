package cc.shic.ui.interactiveSelectors 
{
	import cc.shic.display.Square;
	import cc.shic.mouse.cursor.ps.ArrowMoveSelection;
	import cc.shic.mouse.cursor.ps.ResizeHorizontal;
	import cc.shic.mouse.cursor.ps.ResizeObliqueTlBr;
	import cc.shic.mouse.cursor.ps.ResizeObliqueTrBl;
	import cc.shic.mouse.cursor.ps.ResizeVertical;
	import cc.shic.mouse.MouseCursor;
	import cc.shic.Utils;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class SquareImageSelector extends Sprite
	{
		
		
		/**
		 * tirette top left
		 */
		public var tl:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette top center
		 */
		public var tc:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette top right
		 */
		public var tr:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette center left
		 */
		public var cl:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette center right
		 */
		public var cr:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette bottom left
		 */
		public var bl:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette bottom center
		 */
		public var bc:Square = new Square(6, 6, 0xffffff);
		/**
		 * tirette bottom right
		 */
		public var br:Square = new Square(6, 6, 0xffffff);
		
		public var centerDrag:Sprite = new Sprite();
		
		//curseurs de souris
		private var resizeObliqueTlBr:Sprite=new ResizeObliqueTlBr();
		private var resizeObliqueTrBl:Sprite=new ResizeObliqueTrBl();
		private var resizeVertical:Sprite=new ResizeVertical();
		private var resizeHorizontal:Sprite=new ResizeHorizontal();
		private var arrowMoveSelection:Sprite=new ArrowMoveSelection();
		
		
		/**
		 * objet posé sur stage qui contient les tirettes
		 */
		private var stageContainer:Sprite = new Sprite();	
		
		/**
		 * objet de masque pour les objet interactifs, cet objet a pour but que les tirettes qui sortent de la dimension originale de l'objet ne soient pas visibles. Les dimensions de cet objet doivent donc être relatives à stage
		 */
		public var maskStageContainer:Square = new Square(100, 100, 0x00ff00,0.5);
		
		/**
		 * rectangle qui dessine la selection
		 */
		private var outline:Sprite = new Sprite();
		
		/**
		 * tirette couramment draggée par l'utilisateur
		 */
		public var dragging:Sprite;
		
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * rectangle dans les coordonnées locales qui représente la selection
		 */
		public var rect:Rectangle = new Rectangle(40, 40, 100, 100);
		private var outputWidth:Number;
		private var outputHeight:Number;
		private var hasRatio:Boolean = false;
		private var saveRect:Rectangle;
		private var lastDrag:Sprite;
		
		public function SquareImageSelector(w:Number,h:Number) 
		{
			_width = w;
			_height = h;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			//les éléments interactifs en réalité sont sur stage afin de conserver scleX et scaleY à 1 
			stage.addChild(stageContainer);
			
			stageContainer.addChild(tl);
			stageContainer.addChild(tc);
			stageContainer.addChild(tr);
			stageContainer.addChild(cl);
			stageContainer.addChild(cr);
			stageContainer.addChild(bl);
			stageContainer.addChild(bc);
			stageContainer.addChild(br);
			stageContainer.addChildAt(centerDrag, 0);
			
			
			//initiatlise les boutons
			var inside:Square;
			var bt:Sprite;
			for (var i:uint; i < stageContainer.numChildren; i++) {
				bt = stageContainer.getChildAt(i) as Sprite;
				//Utils.setAsBouton(bt);
				bt.mouseChildren = false;
				bt.addEventListener(MouseEvent.MOUSE_DOWN, drag);
				Utils.stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
				inside = new Square(4, 4, 0x000000);
				bt.addChild(inside);
				inside.x = inside.y = 1;
				inside.name = "inside";
				bt.addEventListener(MouseEvent.ROLL_OVER, setMouseCursor);
				Utils.stage.addEventListener(MouseEvent.MOUSE_UP, setMouseCursor);
				bt.addEventListener(MouseEvent.ROLL_OUT,setMouseCursor);
			}
			
			//inititlise les appels de clavier
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			//center
			centerDrag.alpha = 0;
			lastDrag = centerDrag;
			//stageContainer.addChildAt(centerDrag, 0);
			//centerDrag.addEventListener(MouseEvent.MOUSE_DOWN, drag);
			
			//masque général
			stageContainer.addChildAt(maskStageContainer, 0);
			maskStageContainer.width = stage.stageWidth;
			maskStageContainer.height = stage.stageHeight;
			stageContainer.mask = maskStageContainer;
			
			//countour
			stageContainer.addChildAt(outline, 0);
			outline.mouseEnabled = false;
			outline.mouseChildren = false;
			outline.blendMode = BlendMode.INVERT;
			setSize();
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}
		/**
		 * écouteur de touches
		 * @param	e
		 */
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if(lastDrag){ //gere les déplacement du dernier élément selectionné à l'aide des fleches de clavier
				switch (e.keyCode) {
					
					case Keyboard.UP:
					dragging = lastDrag;
					lastDrag.y -= 1;
					break;
					
					case Keyboard.DOWN:
					lastDrag.y += 1;
					dragging = lastDrag;
					break;
					
					case Keyboard.RIGHT:
					lastDrag.x += 1;
					dragging = lastDrag;
					if (lastDrag == tl   || lastDrag==br) {
						lastDrag.y += 1;
					}else if (lastDrag==tr || lastDrag == bl ) {
						lastDrag.y -= 1;
					}
					break;
					
					case Keyboard.LEFT:
					lastDrag.x -= 1;
					dragging = lastDrag;
					if (lastDrag == tl  || lastDrag==br) {
						lastDrag.y -= 1;
					}else if ( lastDrag==tr|| lastDrag == bl) {
						lastDrag.y += 1;
					}
					break;
					
					default:
					break;
				}
				setRect();
				dragging = null;
			}
			
		}
		/**
		 * définit le bon curseur de souris en fonction de l'état et de la position de la souris
		 * @param	e
		 */
		private function setMouseCursor():void {
			//un bouton dans l'itération
			var bt:Sprite;
			//le bouton trouvé comme étant séléctionné
			var btOver:Sprite;
			for (var i:uint; i < stageContainer.numChildren; i++) {
				bt = stageContainer.getChildAt(i) as Sprite;
				if (bt.hitTestPoint(Utils.stage.mouseX, Utils.stage.mouseY,true)) {
					btOver = bt;
				}
			}
			
			if (dragging) {
				btOver = dragging;
			}
			

			
			switch(btOver) {
				
				
				case tl:
				case br:
				MouseCursor.cursor = resizeObliqueTlBr;
				break;
				
				case tr:
				case bl:
				MouseCursor.cursor = resizeObliqueTrBl;
				break;
				
				case tc:
				case bc:
				MouseCursor.cursor = resizeVertical;
				break;
				
				case cl:
				case cr:
				MouseCursor.cursor = resizeHorizontal;
				break;
				
				case centerDrag:
				MouseCursor.cursor = arrowMoveSelection;
				break;
				
				default:
				MouseCursor.cursor = null;
			}
		}
		
		/**
		 * détruit l'objet et ses écouteurs
		 * @param	e
		 */
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(Event.ENTER_FRAME, update);
			stage.removeChild(stageContainer);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		/**
		 * drag sur un des éléments de resize
		 * @param	e
		 */
		private function dragStop(e:MouseEvent):void 
		{
			for (var i:uint; i < stageContainer.numChildren; i++) {
				var obj:Sprite = stageContainer.getChildAt(i) as Sprite;
				obj.stopDrag();
			}
			dragging = null;
		}
		/**
		 * drag sur un des 8 points
		 * @param	e
		 */
		private function drag(e:MouseEvent):void 
		{
			var obj:Sprite = e.target as Sprite;
			obj.startDrag();
			dragging = obj;
			lastDrag = dragging;
			hightligthLastDrag();
		}
		
		private function hightligthLastDrag():void
		{
			for (var i:uint; i < stageContainer.numChildren; i++) {
				var obj:Sprite = stageContainer.getChildAt(i) as Sprite;
				if (obj.getChildByName("inside")) {
					obj.getChildByName("inside").alpha = 1;
				}
			}
			if (lastDrag && lastDrag.getChildByName("inside")) {
				lastDrag.getChildByName("inside").alpha = 0.5;
			}
		}
		/**
		 * met à jour graphiquement l'objet
		 */
		public function update():void {
			
			if (dragging) {
				setRect();
			}else{
			}
			
			setPoints();
			
			//dessin de la zone noire
			if(dragging==null){
				var g:Graphics = this.graphics;
				g.clear();
				g.beginFill(0x000000, 0.75);
				g.drawRect(0,0,_width, _height);
				//fait un trou dans le dessin
				g.drawRect(rect.left, rect.top, rect.width, rect.height);
			}
			//dessin du contour
			g = outline.graphics;
			g.clear();
			g.lineStyle(1, 0x0000ff, 1);
			g.drawRect(tl.x+3, tl.y+3, (br.x-tl.x) , (br.y-tl.y) );
			
			
		}
		/**
		 * positionne les points en fonction du rectangle
		 */
		private function setPoints():void
		{
			
			tl.x = cl.x = bl.x = centerDrag.x = Math.floor(this.localToGlobal(rect.topLeft).x-3);
			tl.y = tc.y = tr.y = centerDrag.y = Math.floor(this.localToGlobal(rect.topLeft).y-3);
			br.x = cr.x = tr.x = Math.floor(this.localToGlobal(rect.bottomRight).x-3);
			br.y = bc.y = bl.y = Math.floor(this.localToGlobal(rect.bottomRight).y-3);
			
			cl.y = cr.y = Math.floor(this.localToGlobal(new Point(9999,rect.top + rect.height / 2)).y-3);
			tc.x = bc.x = Math.floor(this.localToGlobal(new Point(rect.left + rect.width / 2, 9999)).x - 3);
			
			centerDrag.x += 3;
			centerDrag.y += 3;
			
			centerDrag.graphics.clear();
			centerDrag.graphics.beginFill(0xff0000, 0);
			centerDrag.graphics.drawRect(0, 0, tr.x - tl.x, br.y - tl.y);
			
			
		}
		/**
		 * définit le rectangle en fonction de l'objet draggé en cours
		 */
		private function setRect():void {
			
			saveRect = rect.clone();
			if (dragging==centerDrag) {
				rect.y = this.globalToLocal(new Point(centerDrag.x,centerDrag.y)).y;
				rect.x = this.globalToLocal(new Point(centerDrag.x,centerDrag.y)).x;
			}
			if (dragging==tl) {
				rect.top = this.globalToLocal(new Point(tl.x+3,tl.y+3)).y;
				rect.left = this.globalToLocal(new Point(tl.x+3,tl.y+3)).x;
			}
			if (dragging==tr) {
				//rect.top = tr.y+3;
				//rect.right = tr.x + 3;
				rect.top = this.globalToLocal(new Point(tr.x+3,tr.y+3)).y;
				rect.right = this.globalToLocal(new Point(tr.x+3,tr.y+3)).x;
			}
			if (dragging==bl) {
				//rect.bottom = bl.y+3;
				//rect.left = bl.x + 3
				rect.bottom = this.globalToLocal(new Point(bl.x+3,bl.y+3)).y;
				rect.left = this.globalToLocal(new Point(bl.x+3,bl.y+3)).x;
			}
			if (dragging==br) {
				//rect.bottom = br.y+3;
				//rect.right = br.x+3;
				rect.bottom = this.globalToLocal(new Point(br.x+3,br.y+3)).y;
				rect.right = this.globalToLocal(new Point(br.x+3,br.y+3)).x;
			}
			
			if (dragging==tc) {
				//rect.top = tc.y + 3;
				rect.top = this.globalToLocal(new Point(tc.x+3,tc.y+3)).y;
			}
			if (dragging==bc) {
				//rect.bottom = bc.y + 3
				rect.bottom = this.globalToLocal(new Point(bc.x+3,bc.y+3)).y;
			}
			if (dragging==cl) {
				//rect.left = cl.x + 3;
				rect.left = this.globalToLocal(new Point(cl.x+3,cl.y+3)).x;
			}
			if (dragging==cr) {
				//rect.right = cr.x + 3;
				rect.right = this.globalToLocal(new Point(cr.x+3,cr.y+3)).x;
			}
			checkRatio();
		}

		
		/**
		 * 
		 * @param	width
		 * @param	height
		 * @see unsetRatio
		 */
		public function setRatio(width:Number, height:Number):void {
			trace("setRatio(",width,height,")");
			outputWidth = width;
			outputHeight = height;
			if (width <= 0 || height <= 0) {
				unsetRatio();
				return;
			}
			hasRatio = true;
			checkRatio();
		}
		/**
		 * supprime la contrainte de ratio
		 * @see setRatio
		 */
		public function unsetRatio():void {
			hasRatio = false;
		}
		
		/**
		 * vérifie s'il ne faut pas donner un ratio au rectangle et lui applique s'il le faut
		 */
		private function checkRatio():void
		{
			if (hasRatio) {
				
				if (!saveRect) {
					saveRect = rect.clone();
				}
				
				if (rect.width / rect.height != outputWidth / outputHeight) {
					if (dragging == cl || dragging == cr) {
						rect.height = rect.width * (outputHeight / outputWidth);	
					}else {
						rect.width = rect.height * (outputWidth / outputHeight);
					}
				}
				if (dragging == null) {
					rect.x = saveRect.x - (rect.width - saveRect.width) / 2;
					rect.y = saveRect.y - (rect.height - saveRect.height) / 2;
				}
				if (dragging == bc || dragging == tc) {
					rect.x = saveRect.x - (rect.width - saveRect.width) / 2;
				}
				if (dragging == cl || dragging == cr) {
					rect.y = saveRect.y - (rect.height - saveRect.height) / 2;
				}
				
				if (dragging == tl) {
					rect.y = saveRect.bottom - rect.height;
					rect.x = saveRect.right-rect.width;
				}
				if (dragging == tr) {
					rect.y = saveRect.bottom - rect.height;
				}
				if (dragging == bl) {
					rect.x = saveRect.right-rect.width;
				}
			}
		}
		
		
		/**
		 * Retourne un bitmapData du DisplayObject passé en paramètre, découpé selon le rectangle de selection défini.
		 * @param	displayObject objet source à dessiner.
		 * @param	tranparent valeur de transparence appliquée au BitmapData retourné.
		 * @param	color couleur de fond appliquée au BitmapData retourné.
		 * @return	un BitmapData découpé selon le rectangle défini et dont les dimensions dépendront des valeurs outputWidth et outputHeight.
		 */
		public function getSelectionBitmap(displayObject:DisplayObject,transparent:Boolean=false,color:uint=0xffffff):BitmapData
		{
			if (displayObject) {
				
				//inverse le rectangle si on a des valeurs négatives
				var rect:Rectangle = this.rect.clone();
				if (rect.width < 0) {
					rect.width = -rect.width;
					rect.x -= rect.width;
				}
				if (rect.height < 0) {
					rect.height = -rect.height;
					rect.y -= rect.height;
				}
				
				var w:Number;
				var h:Number;
				if (outputWidth>0 && outputHeight>0) { // un ratio fixe est défini
					w = outputWidth;
					h = outputHeight;
				}else {
					if (outputWidth > 0) { // une largeur de sortie est définie
						w = outputWidth;
						h = (outputWidth/rect.width)*rect.height
					}else if(outputHeight>0){ //une hauteur de sortie est définie
						h = outputHeight;
						w=(outputHeight/rect.height)*rect.width
					}else { // la taille du rectangle correspondra aux dimensions de sortie
						h = rect.height
						w = rect.width;
					}
				}
				if (w <= 0 || h <= 0) {
					return null;
				}
				var resultBmpd:BitmapData = new BitmapData(w, h,transparent,color)
				var matr:Matrix = new Matrix();
				matr.tx -= rect.left;
				matr.ty -= rect.top;
				matr.scale(w/ rect.width,h/rect.height);
				
				resultBmpd.draw(displayObject, matr);
				return resultBmpd;
			}else {
				//Utils.alert("Please crop the image before save.");
				return null;
			}
		}
		
		
		public override function get height():Number { return _height; }
		public override function set height(value:Number):void 
		{
			_height = value;
			setSize();
		}
		
		public override function get width():Number { return _width; }
		public override function set width(value:Number):void 
		{
			_width = value;
			setSize();
		}
		/**
		 * fonction qui va de paire avec les setter width et height
		 */
		private function setSize():void
		{
			this.scaleX = this.scaleY = 1;
			this.scrollRect = new Rectangle(0, 0, _width, _height);
		}
		
		
	}

}