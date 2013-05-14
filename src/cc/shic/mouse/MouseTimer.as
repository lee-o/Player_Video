package cc.shic.mouse 
{
	import cc.shic.events.CustomEvent;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Objet qui permet d'écouter les mouvement ou endormissements de souris sur un displayObject.
	 * @author david
	 */
	[Event(name="onMoving", type="cc.shic.events.CustomEvent")]
	[Event(name="onSleeping", type="cc.shic.events.CustomEvent")]
	public class MouseTimer extends EventDispatcher 
	{
		private var timer:Timer;
		public var sleeping:Boolean;
		
		
		public function MouseTimer(time:Number,targetObject:InteractiveObject) 
		{
			timer = new Timer(time);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onUserInactive);
			targetObject.addEventListener(MouseEvent.MOUSE_MOVE, onUserActive);
		}
		
		private function onUserActive(e:MouseEvent):void 
		{
			timer.reset();
			timer.start();
			if(sleeping==true){
				dispatchEvent(new CustomEvent(CustomEvent.ON_MOVING));
			}
			sleeping = false;
		}
		
		private function onUserInactive(e:TimerEvent):void 
		{
			if(sleeping==false){
				dispatchEvent(new CustomEvent(CustomEvent.ON_SLEEPING));
			}
			sleeping = true;
		}
		
		
	}

}