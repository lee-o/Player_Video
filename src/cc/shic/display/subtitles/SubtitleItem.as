package cc.shic.display.subtitles 
{
	import cc.shic.Utils;
	import cc.shic.UtilsTime;
	/**
	 * ...
	 * @author david
	 */
	public class SubtitleItem 
	{
		public var text:String;
		public var type:String;
		public var start:int;
		public var stop:int;
		private var _xml:XML;
		
		public function SubtitleItem(xml:XML=null) 
		{
			this.xml = xml;
		}
		/**
		 * Une portion du xml représentant un sous titre
		 * @example 
		 * <subtitle start="00:00:07,507" stop="00:00:10,977">
		 * 			<text>
		 * 				<![CDATA[On a enregistré à Providence, dans l'état de Rhode Island, c'est un peu notre ville natale.]]>
		 * 			</text>
		 * </subtitle>
		 *  
		 */
		public function get xml():XML {	return _xml;}
		public function set xml(value:XML):void 
		{
			if(value){
				_xml = value;
				start = UtilsTime.timeCodeToMs(xml.@start);
				stop = UtilsTime.timeCodeToMs(xml.@stop);
				text = xml.text;
				type = xml.name();
			}
			
		}

		
		
	}

}