package cc.shic.xml 
{
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	
	/**
	 * ...
	 * @author shic
	 */
	public class EasyXmlEvent extends Event 
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		/**
		 * Les données chargées sous forme de xml
		 */
		private var _xml:XML;
		public var error:*;
		/**
		 * Les données chargées sous forme de texte
		 */
		private var _data:String;
		
		public function EasyXmlEvent(type:String, p_xml:XML,error:*=null,p_data:String=null) 
		{ 
			_xml = p_xml;
			error = error;
			_data = p_data;
			super(type);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EasyXmlEvent(type,_xml,error,_data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EasyXmlEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get xml():XML { return _xml; }
		public function get data():String {	return _data;}
		
		
	}
	
}