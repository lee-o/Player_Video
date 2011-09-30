package display 
{
	//import cc.shic.display.EasyLoader;
	import cc.shic.display.SquareShape;
	import cc.shic.display.text.TexfieldMonoline;
	import cc.shic.events.CustomEvent;
	import cc.shic.Utils;
	import config.Config;
	import config.Css;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author david
	 */
	[Event(name = "onChange", type = "cc.shic.events.CustomEvent")]
	
	public class HdToggle extends Sprite
	{
		private var hdField:TexfieldMonoline;
		private var hdOn:String;
		private var hdOff:String;
		private var background:SquareShape = new SquareShape(10, 10,0x000000,0);
		//Assets embarqués
		/*[Embed(source="/assets/HdOn.png")]
		public var HdOnPicture:Class;
		[Embed(source="/assets/HdOff.png")]
		public var HdOutPicture:Class;*/
		//
		private var _isOn:Boolean = true;
		//Chargement externe
		//private var btisOn:EasyLoader;
		//private var btisOff:EasyLoader;
		//Assets embarqués
		//private var btisOn:Bitmap;
		//private var btisOff:Bitmap;
		
		public function HdToggle() 
		{
			hdOn = Utils.flashVarsGet("HdOn", "Haute définition");
			hdOff = Utils.flashVarsGet("HdOff", "Basse définition");
			//
			hdField = new TexfieldMonoline();
			Css.textFormatMenu.applyTo(hdField);
			hdField.text = hdOn;
			
			//Chargement externe
			//btisOn = new EasyLoader(Utils.flashVarsGet("fullScreenOut", Config.racine + "img/videoPlayer/HdOn.png"));
			//btisOff = new EasyLoader(Utils.flashVarsGet("fullScreenIn", Config.racine + "img/videoPlayer/HdOff.png"));
			//Assets embarqués
			//btisOn = new HdOnPicture();
			//btisOff = new HdOutPicture();
			
			//addChild(btisOff);
			//addChild(btisOn);
			addChild(background);
			addChild(hdField);
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, toggle);
			isOn = _isOn;
			
		}
		
		private function toggle(e:MouseEvent):void 
		{
			isOn = !isOn;
		}
		
		public function get isOn():Boolean { return _isOn; }
		public function set isOn(value:Boolean):void 
		{
			_isOn = value;
			//btisOn.visible = isOn;
			//btisOff.visible = !isOn;
			_isOn == true ? hdField.text = hdOn : hdField.text = hdOff;
			background.width = hdField.width;
			background.height = hdField.height;
			dispatchEvent(new CustomEvent(CustomEvent.ON_CHANGE));
			
		}
		
	}

}