package cc.shic.display.text 
{
	import cc.shic.Utils;
	import com.greensock.data.DropShadowFilterVars;
	import com.greensock.data.FilterVars;
	import com.greensock.data.GlowFilterVars;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class TextStyleFormat
	{
		/**
		 * Le nom du text style
		 */
		public var name:String;
		public var textFormat:TextFormat;
		public var xml:XML;
		
		private var _italic:Boolean = false;
		private var _bold:Boolean = false;
		private var _underline:Boolean = false;
		private var _bullet:Boolean = false;
		private var _kerning:Boolean = false;
		private var _font:String;
		private var _size:Number;
		private var _color:uint;
		private var _letterSpacing:Number;
		private var _leading:Number;
		private var _align:String;
		private var _leftMargin:Number;
		private var _rightMargin:Number;
		private var _tabStops:Array;
		private var _indent:Number;
		private var _blockIndent:Number;
		
		public var embedFonts:Boolean;
		public var antiAliasType:String;
		public var gridFitType:String;
		public var sharpness:Number;
		public var thickness:Number;
		public var background:Boolean;
		public var backgroundColor:uint;
		public var border:Boolean;
		public var borderColor:uint;
		public var selectable:Boolean;
		
		/**
		 * Hauteur partant du haut du champ texte jusqu'à la ligne de base du champ
		 */
		public var baseLine:Number = 0;
		
		private var filters:TweenLiteVars = new TweenLiteVars();
		
		public function TextStyleFormat(xml:XML=null) 
		{
			textFormat = new TextFormat();
			if (xml) {
				

				this.xml = xml;
				name = xml.name();
				
				
				var obj:FilterVars;
				var glowFilter:GlowFilterVars;
				var dropShadowFilter:DropShadowFilterVars;
				
				var nodeName:String;
				for (var i:int=0; i<xml.children().length(); i++) {
					
					nodeName = xml.children()[i].name();
					//trace(nodeName);
					switch (nodeName) {
						case "italic" :
							italic = Utils.getBool(xml[nodeName]);
							
							break;
							
						case "bold" :
							bold=Utils.getBool(xml[nodeName]);
							break;

						case "underline" :
							underline=Utils.getBool(xml[nodeName]);
							break;

						case "bullet" :
							bullet=Utils.getBool(xml[nodeName]);
							break;

						case "kerning" :
							kerning=Utils.getBool(xml[nodeName]);
							break;

						case "font" :
							font=unescape(xml[nodeName]);
							break;

						case "size" :
							size=Number(xml[nodeName]);
							break;

						case "color" :
							color = Number(xml[nodeName]);
							break;

						case "letterSpacing" :
							letterSpacing=Number(xml[nodeName]);
							break;


						case "leading" :
							leading=Number(xml[nodeName]);
							break;

						case "align" :
							align=String(xml[nodeName]);
							break;

						case "leftMargin" :
							leftMargin=Number(xml[nodeName]);
							break;

						case "rightMargin" :
							rightMargin=Number(xml[nodeName]);
							break;

						case "tabStops" :
							tabStops=String(xml[nodeName]).split(",");
							break;

						case "indent" :
							textFormat.indent=Number(xml[nodeName]);
							break;

						case "blockIndent" :
							blockIndent=Number(xml[nodeName]);
							break;

						case "embedFonts" :
							embedFonts=Utils.getBool(xml[nodeName]);					
							break;
							
						case "antiAliasType":
							antiAliasType=String(xml[nodeName]);
							break;
							
						case "gridFitType":
							gridFitType=String(xml[nodeName]);
							break;
							
						case "sharpness":
							sharpness=Number(xml[nodeName]);
							break;
						
						case "thickness":
							thickness=Number(xml[nodeName]);
							break;
							
						case "border" :
							border=Utils.getBool(xml[nodeName]);
							break;

						case "background" :
							background=Utils.getBool(xml[nodeName]);
							break;

						case "borderColor" :
							borderColor=Number(xml[nodeName]);
							break;

						case "backgroundColor" :
							backgroundColor=Number(xml[nodeName]);
							break;
						
						case "selectable" :
							selectable=Utils.getBool(xml[nodeName]);
							break;
							
						case "baseLine" :
							baseLine=Number(xml[nodeName]);
							break;
							
						case "GlowFilter" :
								glowFilter = new GlowFilterVars();
								glowFilter.color = Number(xml.children()[i].color);
								glowFilter.alpha = Number(xml.children()[i].alpha);
								glowFilter.blurX = Number(xml.children()[i].blurX);
								glowFilter.blurY = Number(xml.children()[i].blurY);
								glowFilter.strength = Number(xml.children()[i].strength);
								glowFilter.quality = uint(xml.children()[i].quality);
								filters.glowFilter = glowFilter;
								break;
								
						case "DropShadowFilter" :
								dropShadowFilter = new DropShadowFilterVars();
								dropShadowFilter.color = Number(xml.children()[i].color);
								dropShadowFilter.alpha = Number(xml.children()[i].alpha);
								dropShadowFilter.blurX = Number(xml.children()[i].blurX);
								dropShadowFilter.blurY = Number(xml.children()[i].blurY);
								dropShadowFilter.strength = Number(xml.children()[i].strength);
								dropShadowFilter.quality = uint(xml.children()[i].quality);
								dropShadowFilter.distance = Number(xml.children()[i].distance);
								dropShadowFilter.angle=Number(xml.children()[i].angle);
								filters.dropShadowFilter = dropShadowFilter;
								break;
							

							
							
						default:
						break;
					}
				}
			}
		
		}
		
		public function clone():TextStyleFormat {
			var r:TextStyleFormat = new TextStyleFormat();
			r.align = align;
			r.blockIndent = blockIndent;
			r.bold = bold;
			r.antiAliasType = antiAliasType;
			r.background = background;
			r.backgroundColor = backgroundColor;
			r.border = border;
			r.borderColor = borderColor;
			r.bullet = bullet;
			r.color = color;
			r.embedFonts = embedFonts;
			r.filters = filters;
			r.font = font;
			r.gridFitType = gridFitType;
			r.indent = indent;
			r.italic = italic;
			r.kerning = kerning;
			r.leading = leading;
			r.leftMargin = leftMargin;
			r.letterSpacing = letterSpacing;
			r.name = name+"_cloned_at_"+String(new Date().time);
			r.rightMargin = rightMargin;
			r.selectable = selectable;
			r.sharpness = sharpness;
			r.thickness = thickness;
			r.size = size;
			r.tabStops = tabStops;
			r.underline = underline;
			return r;
		}
		
		
		/**
		 * applique les propriété au champ texte défini par txt
		 * @param	txt
		 */
		public function applyTo(txt:TextField):void {
			TweenLite.to(txt, 0, filters);
			
			txt.embedFonts = embedFonts;
			if(antiAliasType){
				txt.antiAliasType = antiAliasType;
			}
			if(gridFitType){
				txt.gridFitType = gridFitType;
			}
			if(sharpness){
				txt.sharpness = sharpness;
			}
			if (thickness) {
				txt.thickness = thickness;
			}
			if(border){
				txt.border = border;
			}
			if(background){
			txt.background = background;
			}
			if(borderColor){
			txt.borderColor = borderColor;
			}
			if(backgroundColor){
			txt.backgroundColor = backgroundColor;
			}
			if (selectable) {
				txt.selectable = selectable;
			}else {
				txt.selectable = false;
			}
			txt.setTextFormat(textFormat);
		}
		
		public function get italic():Boolean { return _italic; }
		public function set italic(value:Boolean):void 
		{
			_italic = value;
			textFormat.italic = _italic;
		}
		
		public function get bold():Boolean { return _bold; }
		public function set bold(value:Boolean):void 
		{
			_bold = value;
			textFormat.bold = _bold;
		}
		
		public function get underline():Boolean { return _underline; }
		public function set underline(value:Boolean):void 
		{
			_underline = value;
			textFormat.underline = underline;
		}
		
		public function get bullet():Boolean { return _bullet; }
		public function set bullet(value:Boolean):void 
		{
			_bullet = value;
			textFormat.bullet = _bullet;
		}
		
		public function get kerning():Boolean { return _kerning; }
		public function set kerning(value:Boolean):void 
		{
			_kerning = value;
			textFormat.kerning = _kerning;
		}
		
		public function get font():String { return _font; }
		public function set font(value:String):void 
		{
			_font = value;
			textFormat.font = _font;
		}
		
		public function get size():Number { return _size; }
		public function set size(value:Number):void 
		{
			_size = value;
			textFormat.size = _size;
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void 
		{
			_color = value;
			textFormat.color = _color;
		}
		
		public function get letterSpacing():Number { return _letterSpacing; }
		public function set letterSpacing(value:Number):void 
		{
			_letterSpacing = value;
			textFormat.letterSpacing=_letterSpacing;
		}
		
		public function get leading():Number { return _leading; }
		public function set leading(value:Number):void 
		{
			_leading = value;
			textFormat.leading = _leading;
		}
		
		public function get align():String { return _align; }
		public function set align(value:String):void 
		{
			_align = value;
			textFormat.align = _align;
		}
		
		public function get leftMargin():Number { return _leftMargin; }
		public function set leftMargin(value:Number):void 
		{
			_leftMargin = value;
			textFormat.leftMargin = _leftMargin;
		}
		
		public function get rightMargin():Number { return _rightMargin; }
		public function set rightMargin(value:Number):void 
		{
			_rightMargin = value;
			textFormat.rightMargin = _rightMargin;
		}
		
		public function get tabStops():Array { return _tabStops; }
		public function set tabStops(value:Array):void 
		{
			_tabStops = value;
			textFormat.tabStops = _tabStops;
		}
		
		public function get indent():Number { return _indent; }
		public function set indent(value:Number):void 
		{
			_indent = value;
			textFormat.indent = _indent;
		}
		
		public function get blockIndent():Number { return _blockIndent; }
		public function set blockIndent(value:Number):void 
		{
			_blockIndent = value;
			textFormat.blockIndent = blockIndent;
		}
	}

}