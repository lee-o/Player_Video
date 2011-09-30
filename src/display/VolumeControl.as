package display 
{
	//import cc.shic.display.EasyLoader;
	import cc.shic.display.SquareShape;
	import cc.shic.events.CustomEvent;
	import cc.shic.flashCookie.FlashCookie;
	import cc.shic.Utils;
	import com.greensock.TweenMax;
	import config.Config;
	import config.Css;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author david
	 */
	[Event(name = "onLoaded", type = "cc.shic.events.CustomEvent")]
	[Event(name = "onChange", type = "cc.shic.events.CustomEvent")]
	
	public class VolumeControl extends Sprite
	{
		[Embed(source="/assets/soundControl.png")]
		public var SoundControlPicture:Class;
		
		private var masque:SquareShape;
		//public var bg:EasyLoader;
		public var bg:Bitmap;
		//public var progress:EasyLoader;
		public var progress:Bitmap;
		private var _volume:Number=0.5;
		
		public function VolumeControl() 
		{
			//var graphic:String = Utils.flashVarsGet("soundControl", Config.racine + "img/videoPlayer/soundControl.png");
			//bg = new EasyLoader(graphic);
			bg = new SoundControlPicture();
			//progress = new EasyLoader(graphic);
			progress = new SoundControlPicture();
			
			TweenMax.to(progress, 0, { tint:Css.volumeProgressColor } );
			TweenMax.to(bg, 0, { tint:Css.volumeBackgroundColor } );
			
			addChild(bg);
			addChild(progress);
			//bg.addEventListener(Event.COMPLETE, onLoaded);
			onLoaded();
			addEventListener(MouseEvent.MOUSE_DOWN, drag);
			this.buttonMode = true;
			
		}
		
		private function drag(e:MouseEvent):void 
		{
			
			Utils.stage.addEventListener(MouseEvent.MOUSE_UP, stopdrag);
			Utils.stage.addEventListener(MouseEvent.MOUSE_MOVE, loopDrag);
		}
		
		private function loopDrag(e:*=null):void 
		{
			volume = Utils.rapport(mouseX, bg.width, 1, 0, 0);
			
		}
		
		private function stopdrag(e:MouseEvent):void 
		{
			Utils.stage.removeEventListener(MouseEvent.MOUSE_MOVE, loopDrag);
			Utils.stage.removeEventListener(MouseEvent.MOUSE_UP, stopdrag);
			loopDrag();
		}
		
		private function onLoaded(e:Event = null):void 
		{
			masque = new SquareShape(100, 100, 0x00ff00);
			addChild(masque);
			progress.mask = masque;
			trace("---------vol------"+FlashCookie.getValue("volume"));
			volume = FlashCookie.getValue("volume");
			dispatchEvent(new CustomEvent(CustomEvent.ON_LOADED));
		}
		
		
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void 
		{
			if (!value && value!==0) {
				value = 0.5;
			}
			
			if (value > 1) {
				value = 1;
			}
			if (value < 0) {
				value = 0;
			}
			

			_volume = value;
			FlashCookie.setValue("volume", value);
			masque.height = progress.height;
			masque.width = Utils.rapport(volume, 1, bg.width, 0, 0);
			dispatchEvent(new CustomEvent(CustomEvent.ON_CHANGE, volume));
		}
		
		
	}

}