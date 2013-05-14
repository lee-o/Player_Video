package cc.shic.display.text 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class TexfieldMultiline extends EasyTextField
	{
		
		public function TexfieldMultiline() 
		{
			this.autoSize = TextFieldAutoSize.LEFT;
			this.selectable = false;
			this.wordWrap = true;
			this.multiline = true;
		}
		
	}

}