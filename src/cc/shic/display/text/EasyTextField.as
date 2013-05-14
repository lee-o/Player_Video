package cc.shic.display.text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class EasyTextField extends TextField
	{
		private var _textFormat:TextFormat;
		private var _text:String;
		
		public function EasyTextField() 
		{
			
		}
		
		public function get textFormat():TextFormat { 
			if(_textFormat){
				return _textFormat;
			}else {
				return this.getTextFormat();
			}
		}
		public function set textFormat(value:TextFormat):void 
		{
			_textFormat = value;
			if(_textFormat){
				super.setTextFormat(_textFormat);
			}
		}
		
		public override function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1) :void {
			textFormat = format;
		}
		
		public override function get text():String { return super.text; }
		public override function set text(value:String):void 
		{
			_text = value;
			if (!_textFormat) {
				trace("no text format");
				_textFormat = this.getTextFormat();
			}
			super.text = _text;
			textFormat = textFormat;
		}
		
		
	}

}