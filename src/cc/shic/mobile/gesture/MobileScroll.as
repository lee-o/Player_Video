package cc.shic.mobile.gesture 
{
	import cc.shic.display.SquareShape;
	import cc.shic.Utils;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.events.TouchEvent;
	import flash.utils.getTimer;
	/**
	 * 
	 * @author david
	 */
	public class MobileScroll 
	{
		
		public var display:InteractiveObject;
		private var touchMoveID:int = 0;
		private var initYtouch:Number;
		private var initPosY:Number;
		private var endTime:Number;
		private var initTime:Number;
		/**
		 * hauteur sur laquelle se baser
		 */
		public var height:Number = 300;
		/**
		 * la barre de scroll
		 */
		public var scrollDisplay:Shape = new Shape();
		public var scrollBarPadding:Number = 10;
		/**
		 * Faire passer l'interactive object et définir height sur la hauteur scrollable. scrollDisplay permet d'obtenir une representation graphique du scroll qui s'affiche lors des actions utilisateur.
		 * @param	display
		 * @param	height
		 */
		public function MobileScroll(display:InteractiveObject,height:Number) 
		{
			this.display = display;
			this.height = height;
			this.scrollDisplay.graphics.beginFill(0x808080);
			this.scrollDisplay.graphics.drawRect(0, 0, 1, 100);
			this.scrollDisplay.blendMode = BlendMode.INVERT;
			display.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		}
		private function onTouchBegin(event:TouchEvent):void{ 
			if(touchMoveID != 0) { 
				//trace("already moving. ignoring new touch");     
				return; 
			} 
			TweenLite.killTweensOf(display);
			touchMoveID = event.touchPointID; 
			initYtouch = event.stageY;
			initPosY = display.y;
			initTime = getTimer();
			
			//trace("touch begin" + event.touchPointID); 
			Utils.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove); 
			Utils.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd); 
		} 
		private function onTouchMove(event:TouchEvent):void {
			//trace("touchmove");
			if(event.touchPointID != touchMoveID) { 
				//trace("ignoring unrelated touch"); 
				return; 
			} 
			var diff:Number = event.stageY - initYtouch;
			display.y = diff + initPosY;
			
			TweenMax.to(scrollDisplay, 0, { autoAlpha:1 } );
			updateScrollBar();
			
			
		} 
		

		private function onTouchEnd(event:TouchEvent):void { 
			if(event.touchPointID != touchMoveID) { 
				//trace("ignoring unrelated touch end"); 
				return; 
			} 
			touchMoveID = 0; 
			Utils.stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove); 
			Utils.stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd); 
			//TweenMax.to(scrollDisplay, 3, { autoAlpha:0 } );
			//trace("touch end" + event.touchPointID);
			endTime = getTimer();
			scrollLimits();
		}
		/**
		 * met à jour la hauteur et la position de la scroll bar
		 */
		private function updateScrollBar():void 
		{
			scrollDisplay.height = int(Utils.rapport(display.height, height, height, height*2,height/2));
			if (scrollDisplay.height < 20) {
				scrollDisplay.height = 20;
			}
			scrollDisplay.y = int(Utils.rapport(display.y, 0, scrollBarPadding, height - display.height, height - scrollDisplay.height - scrollBarPadding));
			
		}
		public function scrollLimits():void 
		{

			var finalPos:Number = display.y;
			var time:Number = endTime-initTime;
			var dif:Number = initPosY - display.y;
			var duration:Number = 0.75;
			if (display.height<height) {
				finalPos = 0;
			}else {
				if (time<500) {
					finalPos -= dif * Utils.rapport(time, 0, 2, 500, 0.5);
				}
				if (finalPos>0) {
					finalPos = 0;
				}else if (finalPos+display.height<height) {
					finalPos = height - display.height;
				}
			}
			finalPos = int(finalPos);
			TweenLite.to(display, duration, {
				y:finalPos,
				onUpdate:updateScrollBar
			} );
		}
		
	}

}