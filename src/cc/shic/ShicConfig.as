package cc.shic 
{
	/**
	 * ...
	 * @author david@shic.fr
	 */
	public class ShicConfig
	{
		private static var _debug:Boolean = false;
		
		public function ShicConfig() 
		{
			
		}
		
		static public function get debug():Boolean { return _debug; }
		
		static public function set debug(value:Boolean):void 
		{
			_debug = value;
			if (_debug) {
				trace("----cc.shic----");
				trace("debug mode will trace actions");
				trace("----------------");
			}
		}
		
	}

}