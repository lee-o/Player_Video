package cc.shic.display.text
{
	import com.arabicode.text.Flaraby.FlarabyAS3Flex;
	import com.arabicode.text.Flaraby.ExtraWidthEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	
	/**
	 * Cette classe nécessite le composant FlarabyAS3Flex.swc. Le but de cette classe est de simplifier l'utilisation du composant au moyen de la méthode setText qui a pour rôle de simplement appliquer le texte donné en paramètre au champ de texte.
	 * @author 
	 */
	
	 
	
	public class InternationalTextField extends FlarabyAS3Flex
	{
		/**
		 * le vrai texte avant que les inversions de caractères ne soient faites
		 */
		public var realText:String;
		
		public function InternationalTextField() 
		{	
			//this.condenseWhite = true;
			this.extraCharWidth = 1;
			this.autoSize = TextFieldAutoSize.LEFT;
		}
		public function hasArabic(string:String):Boolean {
			for (var i:int = 0; i < string.length; i++ ) {
				if (isArabic(string.substr(i, 1))) {
					return true;
				}
			}
			return false;
		}
		/**
		 * Applique le texte donné au champ texte
		 * @param	text
		 */
		public function setText(text:String, width:Number, tf:TextFormat, multiline:Boolean, embedFonts:Boolean):void {
			//this.html = true;
			var align:String = tf.align;
			var isArabic:Boolean = false;
			var t:String;
			if (embedFonts) {
				this.embedFonts = true;
			}
			if (hasArabic(text)) {
				isArabic = true;
				//this.dir = "RTL";
			}else {
				//this.dir = "LTR";
			}
			realText = text;
			
			
			if (multiline) {
				this.autoSize = TextFieldAutoSize.LEFT;
				this.multiline = true;
				//this.wordWrap = true;
				this.width = width;
			}
			if(isArabic){
				t= this.convertArabicString(text, width, tf);
			}else {
				t = text;
			}
			this.text = t;
			//recupere le align du textformat qui saute avec flaraby
			tf.align = align;
			setTextFormat(tf);
			

			
			/* 
			 * exemple qui marche en cas de bug
			 * 
			descriptionField.width = Globals.gridSystem.getWidthByCols(4);
			descriptionField.multiline = true;
			descriptionField.embedFonts = true;
			var tf:TextFormat = new TextFormat();
			tf.rightMargin = 0;
			tf.leftMargin = 0;
			tf.size = 12;
			tf.color = 0xffffff;
			tf.font = "Tahoma";
			tf.align = "right";
			var t:String=descriptionField.convertArabicString(value, Globals.gridSystem.getWidthByCols(4),tf);
			descriptionField.text = descriptionField.convertArabicString(value, Globals.gridSystem.getWidthByCols(4),tf);
			tf.align = "right";
			descriptionField.setTextFormat(tf);
			*/
			
			
		}
		/**
		 * il est fortement conseillé d'appeller cette méthode après avoir modifié les dimensions d'un champ texte sans quoi les retours à la ligne ne fonctionneront pas correctement.
		 */
		public function update(e:ExtraWidthEvent = null):void {
			if (!realText) {
				realText = text;
			}
			setText(realText,width,this.getTextFormat(),multiline,embedFonts);	
		}
		
		/**
		 * le formatage appliqué au champ texte.<br/> 
		 * Il est fortement conseillé de n'appliquer cette pripirété qu'après avoir spécifié une valeur de texte pour le champ
		 */
		/*public function get textFormat():TextFormat { return _textFormat; }		
		public function set textFormat(value:TextFormat):void 
		{
			_textFormat = value;
			this.setTextFormat(_textFormat);
			update();
		}*/
	}

}