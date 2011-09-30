package display 
{
	//import cc.shic.display.EasyLoader;
	import cc.shic.display.Square;
	import cc.shic.StageUtils;
	import cc.shic.Utils;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import config.Config;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author david
	 */
	public class FullScreenButton extends Sprite 
	{
		[Embed(source="/assets/fullScreenIn.png")]
		public var FsInPicture:Class;
		[Embed(source="/assets/fullScreenOut.png")]
		public var FsOutPicture:Class;
		
		//public var fsOut:EasyLoader;
		//public var fsIn:EasyLoader;
		public var fsOut:Bitmap;
		public var fsIn:Bitmap;
		
		public function FullScreenButton() 
		{
			
			//fsOut = new EasyLoader(Utils.flashVarsGet("fullScreenOut",Config.racine + "img/videoPlayer/fullScreenOut.png"));
			//fsIn = new EasyLoader(Utils.flashVarsGet("fullScreenIn", Config.racine + "img/videoPlayer/fullScreenIn.png"));
			fsOut = new FsOutPicture();
			fsIn = new FsInPicture();

			fsIn.alpha = 0;
			addChild(fsOut);
			addChild(fsIn);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, over);
			this.addEventListener(MouseEvent.MOUSE_OUT, out);
			this.addEventListener(MouseEvent.CLICK, toggle);
			
			out();
			
		}
		
		private function toggle(e:MouseEvent):void 
		{
			if (Utils.stage.displayState == StageDisplayState.FULL_SCREEN) {
				StageUtils.setFullScreenOut();
				out();
			}else {
				StageUtils.setFullScreen();
			}
		}
		
		private function out(e:MouseEvent=null):void 
		{
			TweenLite.to(fsIn, 0.5, { alpha:0});
		}
		
		private function over(e:MouseEvent=null):void 
		{
			TweenLite.to(fsIn, 0.5, { alpha:1});
		}
		
	}

}