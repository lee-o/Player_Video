package cc.shic.mobile.geo 
{
	import cc.shic.Utils;
	import flash.events.GeolocationEvent;
	import flash.events.StatusEvent;
	import flash.sensors.Geolocation;
	/**
	 * ...
	 * @author david
	 */
	public class GeoPosition 
	{
		
		public static var current:GeoPosition;
		private var geo:Geolocation = new Geolocation();
		public static var latitude:Number = 0;
		public static var longitude:Number = 0;
		
		public function GeoPosition() 
		{
			GeoPosition.current = this;
			//géoloc
			if (Geolocation.isSupported){
				Utils.traceDebug("YES! geolocation support.");
				geo = new Geolocation();
				geo.setRequestedUpdateInterval(10*1000);
				Utils.traceDebug(  "USER ALLOW geolocation support activated = " + !geo.muted);
				geo.addEventListener(StatusEvent.STATUS, onGeo);
				geo.addEventListener(GeolocationEvent.UPDATE, onGeo);
			}else{
				Utils.traceDebug(  "No geolocation support.");
			}
			
			
		}
		/**
		 * Quand on reçoit une info de géolocalisation
		 * @param	e
		 */
		private function onGeo(e:GeolocationEvent):void 
		{
			
			Utils.traceDebug("lat/lng= " + e.latitude + " / " + e.longitude);
			GeoPosition.latitude = e.latitude;
			GeoPosition.longitude = e.longitude;
			trace("geo="+latitude+"/"+longitude);
		}
		
	}

}