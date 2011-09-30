package  config
{
	import cc.shic.display.text.TextStyleFormat;
	import cc.shic.Utils;
	import com.Piaget.LangCode;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author david
	 */
	public class Css 
	{
		private static var 	_progressColor:uint;
		private static var  _progressLoadingColor:uint;
		private static var  _progressBgColor:uint;
		private static var  _volumeProgressColor:uint;
		private static var  _volumeBackgroundColor:uint;
		private static var  _menuHeight:int;
		private static var  _progressHeight:int;
		
		private static var _textFormatSubtitles:TextStyleFormat = new TextStyleFormat(null);
		private static var _textFormatMenu:TextStyleFormat = new TextStyleFormat(null);
		private static var _textFormatTitle:TextStyleFormat = new TextStyleFormat(null);
		
		public static var subtitlesShadow:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 1, 2, 2, 5, 3);
		public static var titleShadow:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 0.6, 2, 2, 0.6, 3);
		
		static public function get textFormatSubtitles():TextStyleFormat 
		{
			_textFormatSubtitles.font = Utils.flashVarsGet("srtFont", "_sans");
			_textFormatSubtitles.color = Number("0x"+Utils.flashVarsGet("srtFontColor", "ffffff"));
			_textFormatSubtitles.embedFonts = false;
			_textFormatSubtitles.size = Number(Utils.flashVarsGet("srtFontSize", "20"));
			_textFormatSubtitles.align = TextFormatAlign.CENTER;
			return _textFormatSubtitles;
		}
		
		static public function get textFormatMenu():TextStyleFormat 
		{
			_textFormatMenu.font = Utils.flashVarsGet("timerFont", "_sans");
			_textFormatMenu.color = Number("0x"+Utils.flashVarsGet("timerFontColor", "ffffff"));
			_textFormatMenu.embedFonts = false;
			_textFormatMenu.size = Number(Utils.flashVarsGet("timerFontSize", "12"));
			return _textFormatMenu;
		}
		
		static public function get textFormatTitle():TextStyleFormat 
		{
			switch(LangCode.current)
			{
				case LangCode.FR:
				case LangCode.EN:
				case LangCode.DE:
				case LangCode.ES:
				case LangCode.IT:
					_textFormatTitle.font = "Futura Std Condensed";
					_textFormatTitle.embedFonts = false;
				break;
				default:
					_textFormatTitle.font = "_sans";
					_textFormatTitle.embedFonts = false;
			}
			
			_textFormatTitle.color = 0xffffff;
			_textFormatTitle.size = 24;
			_textFormatTitle.align = TextFormatAlign.LEFT;
			return _textFormatTitle;
		}
		
		static public function get textFormatBaseline():TextStyleFormat 
		{
			_textFormatTitle.font = "_sans";
			_textFormatTitle.embedFonts = false;
			_textFormatTitle.color = 0xffffff;
			_textFormatTitle.size = 12;
			_textFormatTitle.align = TextFormatAlign.LEFT;
			return _textFormatTitle;
		}
		
		static public function get progressHeight():int { return Number(Utils.flashVarsGet("progressHeight", "3")); }		
		static public function get menuHeight():int { return Number(Utils.flashVarsGet("menuHeight", "50")); }
		
		static public function get volumeBackgroundColor():uint { return Number("0x"+Utils.flashVarsGet("volumeBackgroundColor", "999999")); }
		static public function get volumeProgressColor():uint { return Number("0x"+Utils.flashVarsGet("volumeProgressColor", "ffffff")); }
		static public function get progressColor():uint { return Number("0x"+Utils.flashVarsGet("progressColor", "ffffff")); }
		static public function get progressLoadingColor():uint { return Number("0x"+Utils.flashVarsGet("progressLoadingColor", "ffffff")); }
		static public function get progressLoadingAlpha():Number { return Number(Utils.flashVarsGet("progressLoadingAlpha", "0.5")); }
		static public function get progressBgColor():uint { return Number("0x"+Utils.flashVarsGet("progressBgColor", "333333")); }
		static public function get menuBgColor():uint { return Number("0x"+Utils.flashVarsGet("menuBgColor", "000000")); }
		static public function get menuBgAlpha():Number { return Number(Utils.flashVarsGet("menuBgAlpha", "0.7")); }
	}

}