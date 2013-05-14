package cc.shic.display.map 
{
	import cc.shic.display.EasyLoader;
	import cc.shic.display.SpriteMore;
	
	/**
	 * ...
	 * @author david
	 */
	public class GoogleMapImage extends SpriteMore 
	{
		public var loader:EasyLoader;
		
		public var lat:Number=0;
		public var lng:Number=0;
		public var zoom:Number=12;
		private var _url:String;
		
		public function GoogleMapImage(lat:Number,lng:Number,zoom:Number,width:Number,height:Number) 
		{
			this.lat = lat;
			this.lng = lng;
			this.zoom = zoom;
			this._width = width;
			this._height = height;
			loader = new EasyLoader(url);
			addChild(loader);
			this.graphics.lineStyle(1, 0xff0000),
			this.graphics.lineTo(_width, _height);
		}
		public function refresh():void {
			if (loader) {
				loader.destroy();
				removeChild(loader);
				loader = null;
			}
			loader = new EasyLoader(url);
			addChild(loader);
		}
		/**
		 * Url de l'image google map chargée
		 */
		public function get url():String 
		{
			_url = "http://maps.googleapis.com/maps/api/staticmap?center=";
			_url += escape(lat + "," + lng) + "&size=" + _width + "x" + _height + "&sensor=false&";
			_url += "zoom=" + zoom;
			_url += "&style=" + escape("feature:all|element:geometry|saturation:-80");
			//_url = "http://maps.googleapis.com/maps/api/staticmap?center=48.86639145,2.3442437166666665&size=100x100&sensor=true&zoom=14&&style=feature:all|element:geometry|saturation:-80&";
			return _url;
		}
		
	}

}