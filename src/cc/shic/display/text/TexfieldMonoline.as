package cc.shic.display.text 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class TexfieldMonoline extends EasyTextField
	{
		
		public function TexfieldMonoline() 
		{
			this.autoSize = TextFieldAutoSize.LEFT;
			this.selectable = false;
			this.wordWrap = false;
			this.multiline = false;
		}
		
	}

}