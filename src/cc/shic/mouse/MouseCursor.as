package cc.shic.mouse 
{
	import cc.shic.Utils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class MouseCursor extends Sprite
	{
		public static var instance:MouseCursor = new MouseCursor();
		private static var _cursor:Sprite=new Sprite();
		private static var _mouseIsDown:Boolean;
		public  function MouseCursor() 
		{
			instance = this;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			Utils.stage.addChild(instance);
			Utils.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			Utils.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave);
			Utils.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			Utils.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			_mouseIsDown=true;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_mouseIsDown=false;
		}
		
		private function mouseLeave(e:Event):void 
		{
			//Mouse.show();
			instance.visible = false;
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			//Utils.stage.addChild(instance);
			if(_cursor){
				Mouse.hide();
				if (stage.getChildIndex(instance) != Utils.stage.numChildren - 1) {
					stage.addChild(instance);
				}
			}else {
				Mouse.show();
			}
			instance.x = e.stageX;
			instance.y = e.stageY;
			instance.visible = true;
		}
		
		public static function get cursor():Sprite { return _cursor; }
		public static function set cursor(value:Sprite):void 
		{
			
			//efface ancien curseur
			if (_cursor && instance.contains(_cursor)) {
				instance.removeChild(_cursor);
			}
			
			_cursor = value;
			
			if (_cursor == null) {
				Mouse.show();
				return;
			}
			
			_cursor.mouseEnabled = false;
			_cursor.mouseChildren = false;
			instance.addChild(_cursor);
			
			
		}
		/**
		 * retourne true si le bouton de la souris est enfoncé
		 */
		public static function get mouseIsDown():Boolean { return _mouseIsDown; }
		
	}

}