package com.shic.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class BitmapSerie extends Sprite
	{
		private var bitmapDataList:Vector.<BitmapData>;
		private var sens:int = 1;
		private var img:int = 0;
		
		public function BitmapSerie(bitmapDataList:Vector.<BitmapData>,smoothing:Boolean=false) 
		{
			this.bitmapDataList = bitmapDataList;
			
			var bmp:Bitmap;
			for (var i:uint = 0; i < bitmapDataList.length; i++) {
				bmp = new Bitmap(bitmapDataList[i],"auto",smoothing);
				bmp.name = "im" + i;
				addChild(bmp);
			}
			addEventListener(Event.ENTER_FRAME, replayLoop);
			
		}
		
		private function replayLoop(e:Event):void 
		{
			img += sens;
			if (img>numChildren-1) {
				sens = -sens;
				img -= 1;
			}
			if (img<0) {
				sens = -sens;
				img += 1;
			}
			
			addChild(this.getChildByName("im" + img));
		}
		
	}

}