package cc.shic.ui
{
	import cc.shic.display.text.TexfieldMultiline;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class Alert extends Sprite
	{
		private var text:TextField;
		private var padding:Number = 32;
		
		public function Alert(message:String,width:Number,height:Number) 
		{
			text = new TexfieldMultiline();
			text.textColor = 0x333333;
			text.height = 20;
			text.selectable = false;
			text.mouseEnabled = false;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			var tf:TextFormat = new TextFormat();
			tf.font = "_sans";
			
			text.htmlText = message;
			addChild(text);
			text.setTextFormat(tf);
			
			text.x = width / 2 - text.width / 2;
			text.y = height / 2 - text.height / 2;
			
			var g:Graphics = this.graphics;
			g.beginFill(0xffffff, 0.5);
			g.drawRect(0, 0, width, height);
			g.beginFill(0xeeeeee, 0.9);
			g.lineStyle(1, 0x333333, 0.9);
			g.drawRect(text.getBounds(this).left - padding, text.getBounds(this).top-padding, text.width + padding * 2, text.height + padding * 2);
			this.addEventListener(MouseEvent.CLICK, destroy);
			
		}
		
		private function destroy(e:MouseEvent=null):void 
		{
			if (this.parent && this.parent.contains(this)) {
				this.parent.removeChild(this);
				this.graphics.clear();
				removeChild(text);
				text = null;
			}
		}
		
		
	}

}