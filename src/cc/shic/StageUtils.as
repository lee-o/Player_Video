package cc.shic 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class StageUtils
	{
		
		public function StageUtils() 
		{
			
		}
		/**
		 * allignement haut gauche, scale normal.
		 */
		public static function TopLeftNoScale():void {
			if (!Utils.stage) {
				trace("Il faut déclarer cc.Utils.Stage");
			}
			Utils.stage.scaleMode = StageScaleMode.NO_SCALE;
			Utils.stage.align = StageAlign.TOP_LEFT;
		}
		/**
		 * tente de mettre l'application en fullscreen
		 * @param	e
		 */
		public static function setFullScreen(e:MouseEvent=null):void {
			if (!Utils.stage) {
				trace("Il faut déclarer cc.Utils.Stage");
			}
			Utils.stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		/**
		 * sort du mode full screen
		 * @param	e
		 */
		public static function setFullScreenOut(e:MouseEvent=null):void {
			if (!Utils.stage) {
				trace("Il faut déclarer cc.Utils.Stage");
			}
			Utils.stage.displayState = StageDisplayState.NORMAL;
		}
	}

}